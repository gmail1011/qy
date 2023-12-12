import 'package:fish_redux/fish_redux.dart';

enum IndexAction {
  changeIndex,
  onChangeIndex,
  onChangeToUserCenter,
  onChangeToRecommend,
  onSearch,
}

class IndexActionCreator {
  ///改变index
  static Action changeIndex(int index) {
    return Action(IndexAction.changeIndex, payload: index);
  }

  static Action onChangeIndex(int index) {
    return Action(IndexAction.onChangeIndex, payload: index);
  }

  ///切换到用户中心界面去
  static Action onChangeToUserCenter() {
    return Action(IndexAction.onChangeToUserCenter);
  }

  ///切换到推荐界面去
  static Action goToRecommend() {
    return Action(IndexAction.onChangeToRecommend);
  }

  ///进入到搜索界面
  static Action onSearch() {
    return Action(
      IndexAction.onSearch,
    );
  }
}
