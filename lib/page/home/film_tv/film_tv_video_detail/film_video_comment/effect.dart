import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/comment_model.dart';
import 'package:flutter_app/model/reply_model.dart';
import 'package:flutter_app/model/res/comment_list_res.dart';
import 'package:flutter_app/model/res/reply_list_res.dart';
import 'package:flutter_app/page/alert/vip_rank_alert.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'action.dart';
import 'state.dart';

Effect<FilmVideoCommentState> buildEffect() {
  return combineEffects(<Object, Effect<FilmVideoCommentState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    FilmVideoCommentAction.refreshCommentList: _initState,
    FilmVideoCommentAction.loadMoreCommentList: _loadMoreCommentList,
    FilmVideoCommentAction.getRelayList: _getReplyList,
    FilmVideoCommentAction.sendComment: _sendComment,
    FilmVideoCommentAction.sendReply: _sendReply,
  });
}

void _initState(Action action, Context<FilmVideoCommentState> ctx) {
  ctx.state.pageIndex = 1;
  //_loadCommentData(ctx);
}

///获取评论列表
void _loadCommentData(Context<FilmVideoCommentState> ctx) async {
  String objID = ctx.state.videoId;
  String curTime = DateTimeUtil.format2utc(DateTime.now());
  try {
    CommentListRes commentListRes = await netManager.client.getCommentList(
        objID, curTime, ctx.state.pageIndex, ctx.state.pageSize);

    ctx.state.commentHasNext = commentListRes?.hasNext ?? false;
    if (ctx.state.pageIndex == 1) {
      ctx.state.commentList?.clear();
    }

    ///重装评论数据
    if ((commentListRes.list ?? []).isNotEmpty) {
      for (CommentModel commentModel in commentListRes.list) {
        if ((commentModel?.info?.length ?? 0) > 0 ?? false) {
          commentModel.haveMoreData = true;
          commentModel.commCount = commentModel?.info?.length ?? 0;
        }
        commentModel.replyPageIndex = 1;
        ctx.state.commentList?.add(commentModel);
      }
      ctx.state.baseRequestController?.requestSuccess();
      if (ctx.state.pageIndex == 1) {
        ctx.state.refreshController?.refreshCompleted(resetFooterState: true);
      } else {
        ctx.state.refreshController?.loadComplete();
      }
    } else {
      if (ctx.state.commentList?.isEmpty ?? false) {
        ctx.state.baseRequestController?.requestDataEmpty();
      } else {
        ctx.state.refreshController?.loadNoData();
      }
    }
  } catch (e) {
    if (ctx.state.commentList?.isEmpty ?? false) {
      ctx.state.baseRequestController?.requestFail();
    } else {
      ctx.state.refreshController?.loadFailed();
    }
  }
  ctx.dispatch(FilmVideoCommentActionCreator.updateUI());
}

///获取评论列表
void _loadMoreCommentList(
    Action action, Context<FilmVideoCommentState> ctx) async {
  if (ctx.state.pageIndex * ctx.state.pageSize <=
      ctx.state.commentList?.length) {
    ctx.state.pageIndex = ctx.state.pageIndex + 1;
    _loadCommentData(ctx);
  } else {
    ctx.state.refreshController?.loadNoData();
  }
}

///获取回复列表
void _getReplyList(Action action, Context<FilmVideoCommentState> ctx) async {
  int parentIndex = action.payload as int;
  if (parentIndex < 0 || parentIndex >= ctx.state.commentList.length) return;
  if (!ctx.state.commentList[parentIndex].haveMoreData) {
    ctx.state.refreshController?.loadNoData();
    return;
  }
  if ((ctx.state.commentList[parentIndex].info?.length ?? 0) > 1) {
    ctx.dispatch(FilmVideoCommentActionCreator.updateUI());
    return;
  }

  var infoList = ctx.state.commentList[parentIndex].info;
  String objID = ctx.state.videoId;
  String cmtId = ctx.state.commentList[parentIndex].id;
  String curTime = DateTimeUtil.format2utc(DateTime.now());
  int pageNumber = ctx.state.commentList[parentIndex].replyPageIndex;
  int pageSize = ctx.state.commentList[parentIndex].commCount ?? 10; //设置回复条数
  String fstID;
  if (infoList.isNotEmpty) {
    fstID = infoList[0].id ?? "";
  }
  try {
    ReplyListRes replyListRes = await netManager.client
        .getReplyList(objID, cmtId, curTime, pageNumber, pageSize, fstID);
    ++ctx.state.commentList[parentIndex].replyPageIndex;
    ctx.state.commentList[parentIndex].info.addAll(replyListRes.list);
  } catch (e) {
    l.e("_getReplyList", "$e");
  }
  ctx.dispatch(FilmVideoCommentActionCreator.updateUI());
}

///发布评论
void _sendComment(Action action, Context<FilmVideoCommentState> ctx) {
  Map map = action.payload as Map;
  String content = map["content"];
  int parentIndex = map["parentIndex"];
  _sendFilmComment(ctx, content, parentIndex: parentIndex);
}

///回复评论
void _sendReply(Action action, Context<FilmVideoCommentState> ctx) {
  Map map = action.payload as Map;
  String content = map["content"];
  int parentIndex = map["parentIndex"];
  int childIndex = map["childIndex"];
  _sendFilmComment(ctx, content,
      parentIndex: parentIndex, childIndex: childIndex);
}

///发表评论
_sendFilmComment(Context<FilmVideoCommentState> ctx, String content,
    {int parentIndex = -1, int childIndex = -1}) async {
  if (!GlobalStore.isVIP()) {
    ctx.state.focusNode.unfocus();
    Future.delayed(Duration(milliseconds: 500), (){
      VipRankAlert.show(
        ctx.context,
        type: VipAlertType.vip,
      );
    });
    return;
  }
  if (GlobalStore.store?.getState()?.meInfo?.hasBanned ?? false) {
    showToast(msg: Lang.COMMENT_FORBID);
    return;
  }

  String objID = ctx.state.videoId;
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
          .sendReply(objID, level, content, cid, rid, toUserID);
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
      CommentModel commentModel =
          await netManager.client.sendComment(objID, level, content);

      ///如果评论列表为空，则重新请求列表数据
      if ((ctx.state.commentList ?? []).isEmpty) {
        ctx.state.pageIndex = 1;
        _loadCommentData(ctx);
      } else {
        ctx.state.commentList.insert(0, commentModel);
      }
    }

    ctx.dispatch(FilmVideoCommentActionCreator.updateUI());
  } catch (e) {
    showToast(msg: "${e.toString()}");
    l.d('sendReply/sendComment =', e.toString());
  }
}

void _dispose(Action action, Context<FilmVideoCommentState> ctx) {
  ctx.state.refreshController?.dispose();
  ctx.state.contentController?.dispose();
}
