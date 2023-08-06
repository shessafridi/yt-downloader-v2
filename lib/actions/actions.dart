import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader_v2/models/download_state.dart';

// For Middleware
class AddToDownloadListAction {
  Video video;
  MuxedStreamInfo? muxedStreamInfo;
  AudioOnlyStreamInfo? audioStreamInfo;
  VideoOnlyStreamInfo? videoStreamInfo;

  AddToDownloadListAction(this.video);
}

class StartDownloadAction {
  String id;

  StartDownloadAction(this.id);
}

// For Reducer
class AddDownloadStateAction {
  DownloadState downloadState;

  AddDownloadStateAction(this.downloadState);
}

class UpdateDownloadStateAction {
  DownloadState downloadState;

  UpdateDownloadStateAction(this.downloadState);
}
