import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum PayForGameAction {
  refresh,
  expand, //展开
  conventional, //常规充值
  payFor, //代充
  isPaying,
  glodBuyVip,
  updatePayRadioType,
}

// class PayForGameActionCreator {
//   static Action onAction() {
//     return const Action(PayForGameAction.action);
//   }
// }

class PayForGameActionCreator {
  static Action onConventional(int index) {
    return Action(PayForGameAction.conventional, payload: index);
  }

  static Action glodBuyVip() {
    return Action(PayForGameAction.glodBuyVip);
  }

  static Action payLoading(bool isPaying) {
    return Action(PayForGameAction.isPaying, payload: isPaying);
  }

  static Action updatePayRadioType(int payRadioType) {
    return Action(PayForGameAction.updatePayRadioType, payload: payRadioType);
  }
}
