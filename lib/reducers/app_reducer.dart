import 'package:yt_downloader_v2/models/app_state.dart';
import 'package:yt_downloader_v2/reducers/download_list_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
      downloadList: downloadListReducer(state.downloadList, action));
}
