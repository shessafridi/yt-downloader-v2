import 'package:redux/redux.dart';
import 'package:yt_downloader_v2/actions/actions.dart';
import 'package:yt_downloader_v2/models/app_state.dart';
import 'package:yt_downloader_v2/models/download_state.dart';

void downloadCreatorMiddleware(
    Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is AddToDownloadListAction) {
    // Call the `fromAddAction` method to generate the download state
    DownloadState.fromAddAction(action).then((downloadState) =>
        store.dispatch(AddDownloadStateAction(downloadState)));
  }

  // Continue the action to the next middleware or reducer
  next(action);
}
