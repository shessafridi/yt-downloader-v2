import 'dart:io';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:uuid/uuid.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader_v2/actions/actions.dart';
import 'package:path/path.dart' as path;

enum DownloadStatus { notStarted, active, processing, errored }

enum DownloadType { videoOnly, audioOnly, muxed, seperateAVThenMux }

Future<Directory?> getDownloadDirectory() async {
  if (Platform.isAndroid) {
    // var dirs = await path_provider.getExternalStorageDirectory();
    return Future.value(Directory("/storage/emulated/0/Download"));
  }
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return await path_provider.getDownloadsDirectory();
  }
  throw UnsupportedError("No supported");
}

class DownloadState {
  String id;
  Video video;
  DownloadType type;

  MuxedStreamInfo? muxedStreamInfo;
  AudioOnlyStreamInfo? audioStreamInfo;
  VideoOnlyStreamInfo? videoStreamInfo;

  num? progressMuxed;
  num? progressAudio;
  num? progressVideo;

  String savePath;
  DownloadStatus status;

  DownloadState({
    required this.id,
    required this.type,
    required this.video,
    required this.savePath,
    required this.status,
  });

  static Future<DownloadState> fromAddAction(AddToDownloadList action) async {
    final downloadState = DownloadState(
        id: const Uuid().v4(),
        type: DownloadType.audioOnly,
        video: action.video,
        savePath: '',
        status: DownloadStatus.notStarted);

    if (action.audioStreamInfo != null && action.videoStreamInfo != null) {
      downloadState.audioStreamInfo = action.audioStreamInfo;
      downloadState.videoStreamInfo = action.videoStreamInfo;
      downloadState.type = DownloadType.seperateAVThenMux;
    } else if (action.muxedStreamInfo != null) {
      downloadState.muxedStreamInfo = action.muxedStreamInfo;
      downloadState.type = DownloadType.muxed;
    } else if (action.audioStreamInfo != null) {
      downloadState.audioStreamInfo = action.audioStreamInfo;
      downloadState.type = DownloadType.audioOnly;
    } else if (action.videoStreamInfo != null) {
      downloadState.videoStreamInfo = action.videoStreamInfo;
      downloadState.type = DownloadType.videoOnly;
    } else {
      throw Exception("Unable to generate a download state");
    }

    String sanitizedTitle =
        action.video.title.replaceAll(RegExp(r'[^\w\s]+'), '');
    String downloadsDir = (await getDownloadDirectory())?.path ?? '';

    downloadState.savePath = path.join(downloadsDir, sanitizedTitle);

    return downloadState;
  }
}
