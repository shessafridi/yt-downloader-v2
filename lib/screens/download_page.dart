import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:yt_downloader_v2/models/app_state.dart';
import 'package:yt_downloader_v2/models/download_state.dart';
import 'package:yt_downloader_v2/widgets/download_card.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<DownloadState>>(
        converter: (store) => store.state.downloadList,
        builder: (context, list) {
          if (list.isEmpty) {
            return const Center(
              child: Text("Your downloads will appear here."),
            );
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              return DownloadCard(
                downloadState: list[index],
              );
            },
          );
        });
    // if (downloadList.state.isEmpty) {

    // }

    // return ListView.builder(
    //   itemCount: downloadList.state.length,
    //   itemBuilder: (context, index) {
    //     final downloadState =
    //         ChangeNotifierProvider((ref) => downloadList.state[index]);
    //     return DownloadCard(
    //       downloadState: downloadState,
    //     );
    //   },
    // );
  }
}
