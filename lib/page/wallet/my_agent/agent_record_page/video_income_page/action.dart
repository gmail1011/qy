import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/video_income_model.dart';

enum VideoIncomeAction {
  loadData,
  loadMoreData,
  setLoadData,
  setLoadMoreData,
}

class VideoIncomeActionCreator {
  static Action loadData() {
    return const Action(VideoIncomeAction.loadData);
  }

  static Action loadMoreData() {
    return const Action(VideoIncomeAction.loadMoreData);
  }

  static Action setLoadData(VideoIncomeModel model) {
    return Action(VideoIncomeAction.setLoadData, payload: model);
  }

  static Action setLoadMoreData(List<VideoIncome> list) {
    return Action(VideoIncomeAction.setLoadMoreData, payload: list);
  }
}
