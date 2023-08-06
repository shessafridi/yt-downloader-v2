import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader_v2/models/download_state.dart';

class AddToDownloadList {
  Video video;
  MuxedStreamInfo? muxedStreamInfo;
  AudioOnlyStreamInfo? audioStreamInfo;
  VideoOnlyStreamInfo? videoStreamInfo;

  AddToDownloadList(this.video);
}

class AddDownloadState {
  DownloadState downloadState;

  AddDownloadState(this.downloadState);
}

class UpdateDownloadProgress {
  String id;
  num progress;

  UpdateDownloadProgress(this.id, this.progress);
}
