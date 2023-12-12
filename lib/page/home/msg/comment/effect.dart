import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/message/comment_reply_list.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'state.dart';

Effect<CommentState> buildEffect() {
  return combineEffects(<Object, Effect<CommentState>>{
    Lifecycle.initState: _initState,
  });
}

void _initState(Action action, Context<CommentState> ctx) {
  getCommentReply(ctx);
  Future.delayed(Duration(milliseconds: 200)).then((_) {
    //eaglePage(ctx.state.selfId(),
          //sourceId: ctx.state.eagleId(ctx.context));
  });
}

/// 获取
getCommentReply(Context<CommentState> ctx) async {
  Map<String, dynamic> map = Map();
  map['pageNumber'] = ctx.state.pageNumber;
  map['pageSize'] = ctx.state.pageSize;
  try {
    int pageNumber = ctx.state.pageNumber;
    int pageSize = ctx.state.pageSize;
    ReplyListModel replyListModel = await netManager.client.getCommentReplyList(pageNumber, pageSize);
    ctx.dispatch(CommentActionCreator.onLoadCommentReply(
        replyListModel.list, replyListModel.hasNext ?? false));
  } catch (e) {
    showToast(msg: e.toString());
  }

  // BaseResponse res =
  //     await HttpManager().get(Address.COMMENT_REPLY_LIST, params: map);
  // if (res.code == 200) {
  //   ///toList
  //   // PagedList list = PagedList.fromJson<CommentReplyModel>(res.data);
  //   PagedList list = PagedList.fromJson(res.data);
  //   ctx.dispatch(CommentActionCreator.onLoadCommentReply(
  //       CommentReplyModel.toList(list.list), list?.hasNext ?? false));
  // } else {
  //   showToast(msg: res.msg ?? '');
  // }
}
