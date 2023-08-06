import 'package:youtube_explode_dart/youtube_explode_dart.dart';

var httpClient = YoutubeHttpClient();
var yt = YoutubeExplode(httpClient);
var ytSearchClient = SearchClient(httpClient);

Future<List<String>> getSearchSuggestions(String query) async {
  return yt.search.getQuerySuggestions(query);
}

Future<VideoSearchList> searchVideo(String query) async {
  return ytSearchClient.search(query);
}

Future<Video> getVideoInfo(String url) async {
  return yt.videos.get(url);
}

Future<StreamManifest?> getVideoStreamManifest(Video video) async {
  return yt.videos.streamsClient.getManifest(video.id.value);
}
