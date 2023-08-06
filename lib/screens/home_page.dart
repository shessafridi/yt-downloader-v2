import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader_v2/screens/no_video_selected_page.dart';
import 'package:yt_downloader_v2/screens/video_select_page.dart';

import 'download_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Video? selectedVideo;
  Future<StreamManifest?>? getManifest;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('YouTube Downloader'),
              actions: [
                IconButton(
                    onPressed: () async {
                      // final video = await showSearch(
                      //     context: context, delegate: VideoSearch());
                      // if (video == null) return;
                      // setState(() {
                      //   selectedVideo = video;
                      //   getManifest = getVideoStreamManifest(video);
                      //   DefaultTabController.of(context)?.animateTo(0);
                      // });
                    },
                    icon: const Icon(Icons.search_rounded))
              ],
            ),
            bottomNavigationBar: const TabBar(
              indicatorColor: Colors.transparent,
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  text: "Home",
                ),
                Tab(
                  icon: Icon(Icons.download_for_offline_outlined),
                  text: "Downloads",
                ),
              ],
            ),
            body: TabBarView(
              children: [
                if (selectedVideo == null)
                  const NoVideoSelectedPage()
                else
                  VideoSelectedPage(
                      onDissmissed: (direction) {
                        setState(() {
                          selectedVideo = null;
                          getManifest = null;
                        });
                      },
                      getManifest: getManifest,
                      selectedVideo: selectedVideo),
                const DownloadPage()
              ],
            )));
  }
}
