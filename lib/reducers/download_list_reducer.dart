import 'package:yt_downloader_v2/actions/actions.dart';
import 'package:yt_downloader_v2/models/download_state.dart';

List<DownloadState> downloadListReducer(List<DownloadState> state, action) {
  if (action is AddDownloadStateAction) {
    return [...state, action.downloadState];
  }
  if (action is UpdateDownloadStateAction) {
    return state
        .map((e) => e.id == action.downloadState.id ? action.downloadState : e)
        .toList();
  }
  return state;
}
