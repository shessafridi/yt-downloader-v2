import 'package:youtube_explode_dart/youtube_explode_dart.dart';

var yt = YoutubeExplode();

Future<List<String>> getSearchSuggestions(String query) async {
  return yt.search.getQuerySuggestions(query);
}

Future<VideoSearchList> searchVideo(String query) async {
  return yt.search.search(query);
}

Future<Video> getVideoInfo(String url) async {
  return yt.videos.get(url);
}

Future<StreamManifest?> getVideoStreamManifest(Video video) async {
  return yt.videos.streamsClient.getManifest(video.id.value);
}
