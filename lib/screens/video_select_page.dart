import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../widgets/youtube_card.dart';

class VideoSelectedPage extends StatelessWidget {
  const VideoSelectedPage({
    Key? key,
    required this.onDissmissed,
    required this.getManifest,
    required this.selectedVideo,
  }) : super(key: key);

  final Future<StreamManifest?>? getManifest;
  final Video? selectedVideo;
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      YouTubeCard(selectedVideo!),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          child: const Text("Download"),
                          onPressed: () =>
                              _handleDownloadPressed(context, manifest),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
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
