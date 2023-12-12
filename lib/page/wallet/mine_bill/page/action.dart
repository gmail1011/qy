import 'package:fish_redux/fish_redux.dart';

enum MineBillAction {onLoadData,onRefreshData,loadDataSuccess,loadDataFail }

class MineBillActionCreator {

  static Action onLoadData() {
    return const Action(MineBillAction.onLoadData);
  }

  static Action onRefreshData() {
    return const Action(MineBillAction.onRefreshData);
  }


  static Action loadDataFail() {
    return const Action(MineBillAction.loadDataFail);
  }


  static Action loadDataSuccess() {
    return Action(MineBillAction.loadDataSuccess);
  }
}
