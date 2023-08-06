import 'package:yt_downloader_v2/actions/actions.dart';
import 'package:yt_downloader_v2/models/download_state.dart';

List<DownloadState> downloadListReducer(List<DownloadState> state, action) {
  if (action is AddToDownloadList) {
    print(action);
  }
  return state;
}
