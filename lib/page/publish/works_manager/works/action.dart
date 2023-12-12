import 'package:fish_redux/fish_redux.dart';

enum WorksListAction {
  updateUI,
  refreshData,
  loadMoreData,
  delVideo,
}

class WorksListActionCreator {
  static Action updateUI() {
    return const Action(WorksListAction.updateUI);
  }

  static Action refreshData() {
    return const Action(WorksListAction.refreshData);
  }

  static Action loadMoreData() {
    return const Action(WorksListAction.loadMoreData);
  }

  static Action deleteVideoById(String videoId) {
    return Action(WorksListAction.delVideo, payload: videoId);
  }
}
