import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/weibo_page/message/message_list_entity.dart';
import 'package:flutter_base/flutter_base.dart';

import 'message_action.dart';
import 'message_state.dart';

Effect<MessageState> buildEffect() {
  return combineEffects(<Object, Effect<MessageState>>{
    Lifecycle.initState: _onInitData,
    Lifecycle.dispose: _dispose,
    MessageAction.onLoadMore: _onLoadMore,
    MessageAction.delMsgSession: _delMsgSession,
  });
}

void _onInitData(Action action, Context<MessageState> ctx) async {
  List<AdsInfoBean> list = await getAdsByType(AdsType.message);
  ctx.dispatch(MessageActionCreator.getAdList(list));

  _onLoadMore(action, ctx);
}

void _onLoadMore(Action action, Context<MessageState> ctx) async {
  int pageNumber;
  if (action.payload != null) {
    pageNumber = action.payload;
  } else {
    pageNumber = ctx.state.pageNumber;
  }
  try {
    dynamic commonPostRes =
        await netManager.client.getMessageList(pageNumber, ctx.state.pageSize);
    MessageListData messageListData = MessageListData().fromJson(commonPostRes);
    if (pageNumber > 1) {
      ctx.state.messageListData.xList.addAll(messageListData.xList);
      ctx.dispatch(MessageActionCreator.getData(ctx.state.messageListData));
      ctx.state.refreshController.refreshCompleted();
    } else {
      ctx.dispatch(MessageActionCreator.getData(messageListData));
      ctx.state.refreshController.refreshCompleted();
    }
    if (messageListData.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
  } catch (e) {
    if (pageNumber > 1) {
      ctx.state.refreshController.loadFailed();
    } else {
      ctx.state.refreshController.refreshFailed();
    }
  }
}

///删除消息
void _delMsgSession(Action action, Context<MessageState> ctx) async {
  try {
    Map map = action.payload as Map;
    String sessionId = map["sessionId"];
    int realIndex = map["realIndex"];
    await netManager.client.delMsgSession(sessionId);
    ctx.dispatch(MessageActionCreator.removeMsgByRealIndex(realIndex));

  } catch (e) {
    showToast(msg: "删除失败");
  }
}

void _dispose(Action action, Context<MessageState> ctx) {
  ctx.state.refreshController?.dispose();
}
