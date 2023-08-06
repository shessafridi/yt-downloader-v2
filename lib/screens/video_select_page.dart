import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader_v2/actions/actions.dart';
import 'package:yt_downloader_v2/widgets/download_select_dialog.dart';

import '../models/app_state.dart';
import '../widgets/youtube_card.dart';

class VideoSelectedPage extends StatelessWidget {
  const VideoSelectedPage({
    Key? key,
    required this.onDissmissed,
    required this.getManifest,
    required this.selectedVideo,
  }) : super(key: key);

  final Future<StreamManifest?>? getManifest;
  final Video selectedVideo;
  final void Function(DismissDirection) onDissmissed;

  Future<void> _handleDownloadPressed(
      BuildContext context, StreamManifest manifest) async {
    // final list = context.read(downloadListStateProvider);

    // final tabCtrl = DefaultTabController.of(context);

    // final state = await showDialog<DownloadState>(
    //   context: context,
    //   builder: (context) => DownloadSelectDialog(
    //     manifest: manifest,
    //     videoName: selectedVideo?.title ?? 'Download',
    //   ),
    // );

    // if (state != null) {
    //   list.state.add(state);
    //   tabCtrl.animateTo(1);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getManifest,
      builder: (context, AsyncSnapshot<StreamManifest?> snapshot) {
        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.connectionState == ConnectionState.done) {
          var manifest = snapshot.data!;

          return SingleChildScrollView(
              child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Dismissible(
                key: ObjectKey(selectedVideo),
                onDismissed: onDissmissed,
                child: DownloadSelectCard(
                    manifest: manifest, selectedVideo: selectedVideo),
              ),
            ),
          ));
        }

        return const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text("Converting your video please wait.")
            ],
          ),
        );
      },
    );
  }
}

class DownloadSelectCard extends StatelessWidget {
  final Video selectedVideo;
  final StreamManifest manifest;

  const DownloadSelectCard(
      {super.key, required this.selectedVideo, required this.manifest});

  Future<void> _handleDownloadPressed(
      BuildContext context, Function(AddToDownloadList) dispatcher) async {
    final tabCtrl = DefaultTabController.of(context);

    final streamInfo = await showDialog<StreamInfo>(
      context: context,
      builder: (context) => DownloadSelectDialog(
        manifest: manifest,
        videoName: selectedVideo.title,
      ),
    );

    if (streamInfo == null) return;

    var action = AddToDownloadList(selectedVideo);

    if (streamInfo is MuxedStreamInfo) action.muxedStreamInfo = streamInfo;
    if (streamInfo is AudioOnlyStreamInfo) action.audioStreamInfo = streamInfo;
    if (streamInfo is VideoOnlyStreamInfo) {
      var audio = manifest.audioOnly.sortByBitrate().firstOrNull;
      if (audio == null) return;
      action.audioStreamInfo = audio;
      action.videoStreamInfo = streamInfo;
    }

    dispatcher(action);

    tabCtrl.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        YouTubeCard(selectedVideo),
        SizedBox(
          height: 50,
          child: StoreConnector<AppState, Function(AddToDownloadList)>(
            converter: (store) =>
                (AddToDownloadList action) => store.dispatch(action),
            builder: (context, dispatcher) => ElevatedButton(
                child: const Text("Download"),
                onPressed: () => _handleDownloadPressed(context, dispatcher)),
          ),
        )
      ],
    );
  }
}
