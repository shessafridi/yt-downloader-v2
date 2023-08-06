import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class AddToDownloadList {
  Video video;
  MuxedStreamInfo? muxedStreamInfo;
  AudioOnlyStreamInfo? audioStreamInfo;
  VideoOnlyStreamInfo? videoStreamInfo;

  AddToDownloadList(this.video);
}

class UpdateDownloadProgress {
  String id;
  num progress;

  UpdateDownloadProgress(this.id, this.progress);
}
