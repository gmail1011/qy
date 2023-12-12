import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/comment_model.dart';
import 'package:flutter_app/model/reply_model.dart';
import 'package:flutter_app/model/res/comment_list_res.dart';
import 'package:flutter_app/model/user/wish_list_entity.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';

import 'action.dart';
import 'state.dart';

Effect<WishDetailsState> buildEffect() {
  return combineEffects(<Object, Effect<WishDetailsState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _disponse,
    WishDetailsAction.getCommentList: _getCommentList,
    WishDetailsAction.adoption: _adoption,
    WishDetailsAction.sendWishComment: _sendComment,
    WishDetailsAction.sendWishReply: _sendReply,
  });
}

void _initState(Action action, Context<WishDetailsState> ctx) async {
  ctx.state.isDataReq = true;
  ctx.state.isErrorNet = false;

  l.d("请求心愿工单", "");
  _wishDetailsReq(action, ctx);
}

///请求心愿工单详情
Future _wishDetailsReq(Action action, Context<WishDetailsState> ctx) async {
  try {
    String objID = ctx.state.wishId ?? "";
    if (objID.isEmpty) {
      l.d("_wishDetailsReq", "心愿ID为空");
      return Future.value(false);
    }
    var result = await netManager.client.wishDetailReq(objID);
    var wishInfo = WishListDataList().fromJson(result["info"]);
    l.d("wishInfo", "${wishInfo.id}");
    ctx.state.wishListItem = wishInfo;
    if (ctx.state.wishListItem?.isAdoption ?? false) {
      ctx.state.adoptionCmtId = ctx.state.wishListItem?.adoptionCmtId ?? "";
    }

    ///如果是我的心愿工单
    if ((ctx.state.isMyWish ?? false) &&
        (ctx.state.wishListItem?.isAdoption == false)) {
      //判断是否展示采纳按钮
      ctx.state.hideAdoptionButton = false;
    }

    ///请求评论列表
    _getCommentList(action, ctx);
    return Future.value(true);
  } catch (e) {
    l.d("_wishDetailsReq", "$e");
    ctx.state.isErrorNet = true;
    ctx.state.isDataReq = true;
    ctx.dispatch(WishDetailsActionCreator.updateUI());
  }
  return Future.value(false);
}

///获取评论列表
void _getCommentList(Action action, Context<WishDetailsState> ctx) async {
  try {
    if (!ctx.state.commentHasNext) {
      ctx.state.refreshController?.finishLoad(success: true, noMore: true);
      return;
    }
    ctx.state.pageIndex++;

    String objID = ctx.state.wishListItem?.id;
    try {
      CommentListRes commentListRes = await netManager.client
          .getDesireCmtList(objID, ctx.state.pageIndex, ctx.state.pageSize);

      ctx.state.refreshController?.finishLoad(success: true);
      ctx.state.commentHasNext = commentListRes?.hasNext ?? false;
      if (ctx.state.pageIndex == 1) {
        ctx.state.commentList?.clear();
      }

      if ((commentListRes?.list ?? []).isNotEmpty) {
        for (CommentModel commentModel in commentListRes?.list) {
          if ((commentModel?.info?.length ?? 0) > 0 ?? false) {
            commentModel.haveMoreData = true;
            commentModel.commCount = commentModel?.info?.length ?? 0;
          }
          commentModel.replyPageIndex = 1;
          commentModel.isAdoption =
              (ctx.state.adoptionCmtId == commentModel?.id);
          ctx.state.commentList?.add(commentModel);
        }
      } else {
        ctx.state.refreshController?.finishLoad(success: true, noMore: true);
      }
    } catch (e) {
      ctx.state.refreshController?.finishLoad(success: true);
    }
    ctx.state.isErrorNet = false;
  } catch (e) {
    l.d("_getCommentList-error:", "$e");
    if ((ctx.state.commentList ?? []).isNotEmpty) {
      ctx.state.refreshController.finishLoad(success: false, noMore: false);
    } else {
      ctx.state.isErrorNet = true;
    }
  }
  ctx.state.isDataReq = false;
  ctx.dispatch(WishDetailsActionCreator.updateUI());
}

///执行采纳评论
void _adoption(Action action, Context<WishDetailsState> ctx) async {
  try {
    String commentId = action.payload as String ?? "";
    String desireId = ctx.state.wishListItem?.id ?? "";

    var result = await netManager.client.adoption(commentId, desireId);
    l.d("_adoption:", "$result");

    ctx.state.commentList?.forEach((element) {
      if (commentId == element.id) {
        element.isAdoption = true;
      }
    });
    ctx.state.hideAdoptionButton = true;
    ctx.dispatch(WishDetailsActionCreator.updateUI());
    showToast(msg: "采纳成功~");
  } catch (e) {
    l.d("_adoption-error:", "$e");
    showToast(msg: "采纳失败~");
  }
}

///发布评论
void _sendComment(Action action, Context<WishDetailsState> ctx) {
  Map map = action.payload as Map;
  String content = map["content"];
  int parentIndex = map["parentIndex"];
  _sendWishComment(ctx, content, parentIndex: parentIndex);
}

///回复评论
void _sendReply(Action action, Context<WishDetailsState> ctx) {
  Map map = action.payload as Map;
  String content = map["content"];
  int parentIndex = map["parentIndex"];
  int childIndex = map["childIndex"];
  _sendWishComment(ctx, content,
      parentIndex: parentIndex, childIndex: childIndex);
}

///发表评论
_sendWishComment(Context<WishDetailsState> ctx, String content,
    {int parentIndex = -1, int childIndex = -1}) async {
  String objID = ctx.state.wishListItem?.id;
  int level = 1;
  String cid, rid;
  int toUserID;
  if (childIndex != -1) {
    cid = ctx.state.commentList[parentIndex].id;
    rid = ctx.state.commentList[parentIndex].info[childIndex].id;
    toUserID = ctx.state.commentList[parentIndex].info[childIndex].userID;
    level = 2;
  } else {
    if (parentIndex != -1) {
      cid = ctx.state.commentList[parentIndex].id;
      toUserID = ctx.state.commentList[parentIndex].userID;
      level = 2;
    }
  }

  try {
    ///回复接口
    if (childIndex != -1 || parentIndex != -1) {
      ReplyModel replyModel = await netManager.client
          .sendWishReply(objID, level, content, cid, rid, "desire");

      if (ctx.state.commentList[parentIndex].info == null) {
        ctx.state.commentList[parentIndex].info = [];
      }
      ctx.state.commentList[parentIndex].info
          .insert(childIndex + 1, replyModel);
      int commCount = ctx.state.commentList[parentIndex].commCount ?? 0;
      ctx.state.commentList[parentIndex].commCount = commCount + 1;
      ctx.state.commentList[parentIndex].haveMoreData = true;
    } else {
      ///评论接口

      CommentModel commentModel = await netManager.client
          .sendWishComment(objID, level, content, cid, rid, "desire");
      ctx.state.commentList.insert(0, commentModel);
    }

    ctx.dispatch(WishDetailsActionCreator.updateUI());
  } catch (e) {
    showToast(msg: "${e.toString()}");
    l.d('sendReply/sendComment =', e.toString());
  }
}

void _disponse(Action action, Context<WishDetailsState> ctx) {
  ctx.state.refreshController?.dispose();
  ctx.state.contentController?.dispose();
}
