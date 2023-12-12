import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_base/utils/log.dart';

import 'message_action.dart';
import 'message_state.dart';

Reducer<MessageState> buildReducer() {
  return asReducer(
    <Object, Reducer<MessageState>>{
      MessageAction.getAdList: _getAdList,
      MessageAction.getData: getData,
      MessageAction.onLoadMore: onLoadMore,
      MessageAction.removeMsgByRealIndex: _removeMsgByRealIndex,
    },
  );
}

MessageState _getAdList(MessageState state, Action action) {
  final MessageState newState = state.clone();
  newState.adsList = action.payload as List<AdsInfoBean> ?? [];
  return newState;
}

MessageState getData(MessageState state, Action action) {
  final MessageState newState = state.clone();
  newState.messageListData = action.payload;
  return newState;
}

MessageState onLoadMore(MessageState state, Action action) {
  final MessageState newState = state.clone();
  newState.pageNumber = action.payload;
  return newState;
}

MessageState _removeMsgByRealIndex(MessageState state, Action action) {
  final MessageState newState = state.clone();

  try {
    int realIndex = action.payload as int;
    int totalCount = newState.messageListData?.xList?.length ?? 0;
    l.d("totalCount", "$totalCount");
    l.d("realIndex", "$realIndex");
    if (totalCount != 0 && realIndex < totalCount) {
      newState.messageListData?.xList?.removeAt(realIndex);
    }
  } catch (e) {
    l.d("_removeMsgByRealIndex", "$e");
  }
  return newState;
}
