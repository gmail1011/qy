import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/message/message_type_model.dart';

enum MsgAction {
  setUrlAction,
  onLoadMessageTypeAction,
  loadMessageTypeAction,
  getAdsOkay,
}

class MsgActionCreator {
  static Action onAction(String url) {
    return Action(MsgAction.setUrlAction, payload: url);
  }

  static Action getAdsOkay(AdsInfoBean adsBean) {
    return Action(MsgAction.getAdsOkay, payload: adsBean);
  }

  static Action loadMessageType() {
    return Action(MsgAction.loadMessageTypeAction);
  }

  static Action onLoadMessageType(MessageTypeModel messageTypeModel) {
    return Action(MsgAction.onLoadMessageTypeAction, payload: messageTypeModel);
  }
}
