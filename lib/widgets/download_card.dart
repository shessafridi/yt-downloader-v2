import 'package:flutter/material.dart';
import 'package:yt_downloader_v2/models/download_state.dart';

class DownloadCard extends StatelessWidget {
  const DownloadCard({Key? key, required this.downloadState}) : super(key: key);

  final DownloadState downloadState;

  Widget _buildTrailing() {
    if (downloadState.status == DownloadStatus.notStarted) {
      return IconButton(onPressed: () {}, icon: const Icon(Icons.download));
    }
    if (downloadState.status == DownloadStatus.active ||
        downloadState.status == DownloadStatus.processing) {
      return CircularProgressIndicator(
        value: downloadState.status == DownloadStatus.processing
            ? null
            : (getProgress() / 100),
      );
    }
    return IconButton(onPressed: () {}, icon: const Icon(Icons.download_done));
  }

  Widget _buildLeading() {
    if (downloadState.type == DownloadType.audioOnly) {
      return const Icon(Icons.music_note_outlined);
    } else {
      return const Icon(Icons.movie_creation_outlined);
    }
  }

  num getProgress() {
    num finalCount = 0;
    if (downloadState.type == DownloadType.seperateAVThenMux) {
      finalCount = ((downloadState.progressAudio ?? 0) / 2) +
          ((downloadState.progressVideo ?? 0) / 2);
    }

    if (downloadState.type == DownloadType.muxed) {
      finalCount = downloadState.progressMuxed ?? 0;
    }
    if (downloadState.type == DownloadType.audioOnly) {
      finalCount = downloadState.progressAudio ?? 0;
    }
    if (downloadState.type == DownloadType.videoOnly) {
      finalCount = downloadState.progressVideo ?? 0;
    }

    return finalCount;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(downloadState.video.title),
      subtitle: Text(
        '${getProgress().toStringAsFixed(1)}%',
        style: const TextStyle(color: Colors.white70),
      ),
      leading: _buildLeading(),
      trailing: _buildTrailing(),
    );
  }
}
