import 'package:fish_redux/fish_redux.dart';

enum PayForAction {
  refresh,
  expand, //展开
  conventional, //常规充值
  payFor, //代充
  isPaying,
  glodBuyVip
}

class PayForActionCreator {
  static Action onConventional(int index) {
    return Action(PayForAction.conventional, payload: index);
  }

  static Action glodBuyVip() {
    return Action(PayForAction.glodBuyVip);
  }

  static Action payLoading(bool isPaying) {
    return Action(PayForAction.isPaying, payload: isPaying);
  }
}
