import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloadSelectDialog extends StatelessWidget {
  const DownloadSelectDialog({
    Key? key,
    required this.manifest,
    required this.videoName,
  }) : super(key: key);

  final StreamManifest manifest;
  final String videoName;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: SingleChildScrollView(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          const ListTile(
            title: Text("Video Streams"),
          ),
          for (var videoStream in manifest.muxed.sortByVideoQuality())
            if (videoStream.container.name == "mp4")
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(videoStream);
                },
                child: ListTile(
                    leading: const Icon(Icons.movie_creation_outlined),
                    title: Text(
                        "${videoStream.size.totalMegaBytes.toStringAsFixed(1)}MB ${videoStream.qualityLabel}"),
                    subtitle: Text(
                      "${videoStream.videoResolution} | MP4",
                      style: const TextStyle(color: Colors.white70),
                    )),
              ),
          const Divider(),
          const ListTile(
            title: Text("Audio Streams"),
          ),
          for (var audioStream in manifest.audioOnly.sortByBitrate())
            InkWell(
              onTap: () {
                Navigator.of(context).pop(audioStream);
              },
              child: ListTile(
                leading: const Icon(Icons.music_note_outlined),
                title: Text(
                    "${audioStream.size.totalMegaBytes.toStringAsFixed(1)}MB"),
                subtitle: Text(
                  "${audioStream.bitrate} | MP3",
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ),
          const Divider(),
          const ListTile(
            title: Text("Higher resolution videos"),
          ),
          for (var videoStream in manifest.videoOnly.sortByVideoQuality())
            if (videoStream.container.name == "mp4")
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(videoStream);
                },
                child: ListTile(
                    leading: const Icon(Icons.movie_creation_outlined),
                    title: Text(
                        "${videoStream.size.totalMegaBytes.toStringAsFixed(1)}MB ${videoStream.qualityLabel}"),
                    subtitle: Text(
                      "${videoStream.videoResolution} | MP4",
                      style: const TextStyle(color: Colors.white70),
                    )),
              ),
        ],
      ),
    ));
  }
}
