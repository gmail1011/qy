import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/nove_details_model.dart';
import 'package:flutter_app/page/home/discovery_tab_page/passion_novel_page/novel_player_page/state.dart';

enum NovelPlayerAction {
  action,
  showAppBar,
  saveCurrentText,
  changeTipArrow,
  saveData,
  onCollect,
  onLoadData,
  changeColor,
}

class NovelPlayerActionCreator {
  static Action onLoadData() {
    return const Action(NovelPlayerAction.onLoadData);
  }

  static Action onCollect() {
    return const Action(NovelPlayerAction.onCollect);
  }

  static Action changeColor(ColorsModel color) {
    return Action(NovelPlayerAction.changeColor, payload: color);
  }

  static Action showAppBar(bool isShow) {
    return Action(NovelPlayerAction.showAppBar, payload: isShow);
  }

  static Action saveCurrentText(List<String> data) {
    return Action(NovelPlayerAction.saveCurrentText, payload: data);
  }

  static Action saveData(NoveDetails data) {
    return Action(NovelPlayerAction.saveData, payload: data);
  }

  static Action changeTipArrow(bool data) {
    return Action(NovelPlayerAction.changeTipArrow, payload: data);
  }
}
