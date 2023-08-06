import 'package:flutter/material.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Your downloads will appear here."),
    );
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
