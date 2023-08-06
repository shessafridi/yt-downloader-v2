import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:redux/redux.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader_v2/actions/actions.dart';
import 'package:yt_downloader_v2/models/app_state.dart';
import 'package:yt_downloader_v2/models/download_state.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;
import 'package:yt_downloader_v2/services/youtubedl_service.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestStoragePermissions() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) return true;
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.mediaLibrary,
  ].request();

  return statuses.entries.every((element) => element.value.isGranted);
}

class _DownloadRunner {
  final Store<AppState> store;
  DownloadState downloadState;
  final VoidCallback onComplete;
  final VoidCallback onError;

  StreamSubscription<List<int>>? muxSubscription;
  StreamSubscription<List<int>>? videoSubscription;
  StreamSubscription<List<int>>? audioSubscription;

  _DownloadRunner(
      {required this.store,
      required this.downloadState,
      required this.onComplete,
      required this.onError});

  StreamSubscription<List<int>> _download(
      {required StreamInfo streamInfo,
      required String path,
      required Function(num progress) onProgress,
      required Function onStart,
      required Function onComplete,
      required Function onError}) {
    var stream = yt.videos.streamsClient.get(streamInfo);
    var totalLength = streamInfo.size.totalBytes;
    var downloadedBytes = 0;

    onStart();

    // Open a file for writing.
    var file = File(path);
    var fileStream = file.openWrite();

    var streamCtrl = StreamController<List<int>>(onCancel: () async {
      await fileStream.flush();
      await fileStream.close();
      await file.delete();

      onError();
    });

    var subscription = streamCtrl.stream.listen((data) {
      fileStream.add(data);

      downloadedBytes += data.length;
      var progress = ((downloadedBytes / totalLength) * 100);

      onProgress(progress);
    });

    streamCtrl
        .addStream(stream)
        .then((_) => fileStream.flush())
        .then((_) => fileStream.close())
        .then((_) {
      if (Platform.isAndroid) {
        print("Refreshing $path");
        return MediaScanner.loadMedia(path: path)
            .catchError((err) => Future.value(null));
      }
      return Future.value(null);
    }).then((value) => onComplete());

    return subscription;
  }

  start() async {
    if (downloadState.type == DownloadType.muxed) {
      var muxFilePath =
          path.join(downloadState.savePath, '${downloadState.saveName}.mp4');

      muxSubscription = _download(
          streamInfo: downloadState.muxedStreamInfo!,
          path: muxFilePath,
          onProgress: (progress) {
            if ((progress - progress.toInt()).abs() < 0.02) {
              _updateDownloadState(
                  downloadState.copyWith(progressMuxed: progress));
            }
          },
          onComplete: () {
            _updateDownloadState(
                downloadState.copyWith(status: DownloadStatus.finished));
            onComplete();
          },
          onError: () {
            _updateDownloadState(
                downloadState.copyWith(status: DownloadStatus.errored));
            onError();
          },
          onStart: () {
            _updateDownloadState(
                downloadState.copyWith(status: DownloadStatus.active));
          });
    } else if (downloadState.type == DownloadType.audioOnly) {
      var audioFilePath =
          path.join(downloadState.savePath, '${downloadState.saveName}.mp3');

      audioSubscription = _download(
          streamInfo: downloadState.audioStreamInfo!,
          path: audioFilePath,
          onProgress: (progress) {
            if ((progress - progress.toInt()).abs() < 0.02) {
              _updateDownloadState(
                  downloadState.copyWith(progressAudio: progress));
            }
          },
          onComplete: () {
            _updateDownloadState(
                downloadState.copyWith(status: DownloadStatus.finished));
            onComplete();
          },
          onError: () {
            _updateDownloadState(
                downloadState.copyWith(status: DownloadStatus.errored));
            onError();
          },
          onStart: () {
            _updateDownloadState(
                downloadState.copyWith(status: DownloadStatus.active));
          });
    } else {
      store.dispatch(UpdateDownloadStateAction(
          downloadState.copyWith(status: DownloadStatus.errored)));
      onError();
    }
  }

  cancel() async {
    if (muxSubscription != null) {
      await muxSubscription!.cancel();
    }
    if (videoSubscription != null) {
      await videoSubscription!.cancel();
    }
    if (audioSubscription != null) {
      await audioSubscription!.cancel();
    }
  }

  _updateDownloadState(DownloadState newState) {
    downloadState = newState;
    store.dispatch(UpdateDownloadStateAction(downloadState));
  }
}

List<_DownloadRunner> _runners = [];

void downloadRunnerMiddleware(
    Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is StartDownloadAction) {
    var downloadState =
        store.state.downloadList.firstWhereOrNull((ds) => ds.id == action.id);

    if (downloadState != null) {
      _runDownload(store, downloadState);
    }
  }

  // Continue the action to the next middleware or reducer
  next(action);
}

Future<void> _runDownload(Store<AppState> store, DownloadState state) async {
  try {
    var hasPermission = await requestStoragePermissions();
    if (!hasPermission) throw Error();

    var runner = _DownloadRunner(
        downloadState: state,
        store: store,
        onComplete: () {
          _runners =
              _runners.where((r) => r.downloadState.id != state.id).toList();
        },
        onError: () {
          _runners =
              _runners.where((r) => r.downloadState.id != state.id).toList();
        });

    _runners.add(runner);

    runner.start();
  } catch (_) {}
}
