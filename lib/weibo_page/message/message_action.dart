import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';

import 'message_list_entity.dart';

enum MessageAction {
  getAdList,
  getData,
  onLoadMore,
  delMsgSession,
  removeMsgByRealIndex,
}

class MessageActionCreator {
  static Action getAdList(List<AdsInfoBean> adsList) {
    return Action(MessageAction.getAdList, payload: adsList);
  }

  static Action getData(MessageListData messageListData) {
    return Action(MessageAction.getData, payload: messageListData);
  }

  static Action onLoadMore(int pageNum) {
    return Action(MessageAction.onLoadMore, payload: pageNum);
  }

  static Action delMsgSession(String sessionId, int realIndex) {
    return Action(MessageAction.delMsgSession, payload: {
      "sessionId": sessionId,
      "realIndex": realIndex,
    });
  }

  static Action removeMsgByRealIndex(int realIndex) {
    return Action(MessageAction.removeMsgByRealIndex, payload: realIndex);
  }
}
