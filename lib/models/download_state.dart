import 'package:youtube_explode_dart/youtube_explode_dart.dart';

enum DownloadStatus { notStarted, active, processing, errored }

enum DownloadType { videoOnly, audioOnly, muxed, seperateAVThenMux }

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
}
