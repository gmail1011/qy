import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/comment_model.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/reply_model.dart';
import 'package:flutter_app/page/comment/comment_list_page.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_result_page.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/like_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:get/route_manager.dart' as Gets;

import 'action.dart';
import 'state.dart';

Widget buildView(
    FilmVideoCommentState state, Dispatch dispatch, ViewService viewService) {
  return Column(
    children: [
      // _header(state, viewService, state.quickSearch),
      SizedBox(height: 8),
      Expanded(child: CommentListPage(state.videoId, hasHeader: false, footerComment :true,needReplay: false,isVideoDetail: true,)),
      // Expanded(child: BaseRequestView(
      //       retryOnTap: () =>
      //           dispatch(FilmVideoCommentActionCreator.refreshCommentList()),
      //       controller: state.baseRequestController,
      //       child: pullYsRefresh(
      //         refreshController: state.refreshController,
      //         onRefresh: () =>
      //             dispatch(FilmVideoCommentActionCreator.refreshCommentList()),
      //         onLoading: () =>
      //             dispatch(FilmVideoCommentActionCreator.loadMoreCommentList()),
      //         child: CustomScrollView(
      //           slivers: [
      //             SliverToBoxAdapter(child: SizedBox(height: 16)),
      //             SliverList(
      //               delegate: SliverChildBuilderDelegate(
      //                 (BuildContext context, int index) {
      //                   return _getCommentItem(state, dispatch, context,
      //                       state.commentList[index], index, viewService);
      //                 },
      //                 childCount: state.commentList?.length ?? 0,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     )),
      //_footerComment(state, dispatch, viewService.context),
    ],
  );
}

Widget _header(FilmVideoCommentState state, ViewService viewService, QuickSearch quickSearch) {
  return Container(
    height: 30,
    alignment: Alignment.bottomLeft,
    padding: EdgeInsets.only(bottom: 4),
    child: Row(
      children: <Widget>[
        SizedBox(width: 12),
        if (quickSearch != null) ...[
          Text(
            "大家都在搜：",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          InkWell(
            onTap: () async{
              viewService.broadcast(
                  FilmVideoCommentActionCreator.stopVideoPlay(state.videoId));
              if(quickSearch.searchKeyword?.isNotEmpty == true){
                Navigator.of(viewService.context).push(MaterialPageRoute(
                  builder: (context) {
                    return SearchResultPage()
                        .buildPage({"keyword": quickSearch.searchKeyword});
                  },
                ));
                 // Gets.Get.to(() => SearchResultPage()
                 //    .buildPage({"keyword": quickSearch.searchKeyword}));
              }else if (quickSearch.videoID?.isNotEmpty == true) {
                Map<String, dynamic> maps = Map();
                maps["videoId"] = quickSearch.videoID;
                JRouter().go(FILM_TV_VIDEO_DETAIL_PAGE, arguments: maps);
              } else if (quickSearch.link?.isNotEmpty == true) {
                JRouter().handleAdsInfo(quickSearch.link, id: quickSearch.id);
              } else {

              }
            },
            child: Row(
              children: [
                Text(
                  quickSearch.title,
                  style:
                  TextStyle(color: Color(0xffe9a43d), fontSize: 16),
                ),
                SizedBox(width: 1),
                Image.asset(
                  "assets/weibo/images/comment_search.png",
                  width: 10,
                  height: 11,
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );
}

///获取评论列表的item
Widget _getCommentItem(
    FilmVideoCommentState state,
    Dispatch dispatch,
    BuildContext context,
    CommentModel commentModel,
    int index,
    ViewService viewService) {
  //判断是否VIP
  bool isVip = _isVipByVipExpireDate(commentModel.vipExpireDate) ?? false;
  return Padding(
    padding:
        EdgeInsets.fromLTRB(Dimens.pt10, Dimens.pt10, Dimens.pt10, Dimens.pt5),
    child: Stack(
      children: [
        if(commentModel?.isGodComment == true)
          Positioned(
            right: 8,
            child: Image.asset(
              "assets/weibo/images/comment_god.png",
              width: 56,
              height: 56,
            ),
          ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    if (commentModel.userID == null) {
                      return;
                    }
                    Map<String, dynamic> arguments = {
                      'uid': commentModel?.userID ?? 0,
                      'uniqueId': DateTime.now().toIso8601String(),
                    };

                    viewService.broadcast(
                        FilmVideoCommentActionCreator.stopVideoPlay(state.videoId));
                    var result = await Gets.Get.to(() => BloggerPage(arguments),
                        opaque: false);
                    l.e("_getCommentItem", "$result");
                    viewService.broadcast(
                        FilmVideoCommentActionCreator.notifyReStartPlayVideo(
                            state.videoId));
                  },
                  child: HeaderWidget(
                    headPath: commentModel?.userPortrait,
                    headHeight: Dimens.pt40,
                    headWidth: Dimens.pt40,
                    level: (commentModel.superUser ?? false) ? 1 : 0,
                    positionedSize: 0,
                    levelSize: Dimens.pt12,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimens.pt10),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "${commentModel.userName}",
                            style: TextStyle(
                                color: (isVip && commentModel.vipLevel > 0)
                                    ? Color.fromRGBO(246, 197, 89, 1)
                                    : Colors.white,
                                fontSize: Dimens.pt14,
                                fontWeight: FontWeight.w600),
                          ),
                          buildHonorLevelUI(
                              hasKingIcon:
                              isVip && (commentModel.vipLevel ?? 0) > 0,
                              honorLevelList: commentModel?.awardsExpire),
                        ],
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          _showInput(state, dispatch, context, parentIndex: index);
                        },
                        child: Text(
                          _commentStr(state, index),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimens.pt15,
                          ),
                        ),
                      ),

                      //time

                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  DateTimeUtil.utc2iso2(
                                      commentModel.createdAt ?? ""),
                                  style: TextStyle(
                                      fontSize: Dimens.pt12,
                                      color: AppColors.recommentSubTextColor),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    _showInput(state, dispatch, context,
                                        parentIndex: index);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(Dimens.pt5),
                                    child: Text("回复",
                                        style: TextStyle(
                                            color: AppColors.recommentSubTextColor,
                                            fontSize: Dimens.pt10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          CustomLikeWidget(
                            scrollDirection: Axis.horizontal,
                            isLike: commentModel.isLike,
                            width: Dimens.pt15,
                            height: Dimens.pt15,
                            likeCountColor: AppColors.recommentSubTextColor,
                            likeIconPath: AssetsImages.IC_QUESTION_LIKE,
                            unlikeIconPath: AssetsImages.IC_QUESTION_UNLIKE,
                            padding: EdgeInsets.all(Dimens.pt5),
                            likeCount: commentModel.likeCount,
                            callback: (isLike) {
                              Map<String, dynamic> map = {};
                              map["index"] = index;
                              map["objID"] = commentModel.id;
                              if (commentModel.isLike) {
                                _cancelLike(state, index);
                              } else {
                                _sendLike(state, index);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                ///获取更多回复
                if (!commentModel.isRequestReply) {
                  commentModel.isRequestReply = true;
                  dispatch(FilmVideoCommentActionCreator.getRelayList(index));
                } else {
                  commentModel.isRequestReply = false;
                  dispatch(FilmVideoCommentActionCreator.updateUI());
                }
              },
              child: Offstage(
                offstage: commentModel.haveMoreData ? false : true,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(left: Dimens.pt48, bottom: Dimens.pt5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        commentModel.commCount > 99
                            ? ' ${Lang.COMMENT_SHOW_MORE_REPLY}' //展開更多回復
                            : " ${commentModel.isRequestReply ? "关闭" : "展开"} ${commentModel.commCount} 条回复",
                        style: TextStyle(
                            color: AppColors.recommentSubTextColor,
                            fontSize: Dimens.pt11),
                      ),
                      Icon(
                          commentModel.isRequestReply
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: AppColors.recommentSubTextColor),
                    ],
                  ),
                ),
              ),
            ),

            ///_getReplyList
            Offstage(
              offstage: !commentModel.isRequestReply ?? true,
              child: Padding(
                padding: EdgeInsets.only(left: Dimens.pt40),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: state.commentList[index].info.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int childIndex) {
                      return _getReplyItem(
                          state,
                          dispatch,
                          context,
                          state.commentList[index].info[childIndex],
                          index,
                          childIndex,
                          viewService);
                    },
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}

///显示评论状态
String _commentStr(FilmVideoCommentState state, int index) {
  CommentModel commentModel = state.commentList[index];
  if (commentModel.isDelete) {
    return Lang.COMMENT_STATUS_DELETE;
  }
  if (commentModel.status == 3) {
    return Lang.COMMENT_STATUS_SHIELD;
  } else if (commentModel.status == 2) {
    return Lang.COMMENT_STATUS_CHECK;
  } else {
    return commentModel.content;
  }
}

///回复评论的ITEM
Widget _getReplyItem(
    FilmVideoCommentState state,
    Dispatch dispatch,
    BuildContext context,
    ReplyModel replyModel,
    int parentIndex,
    int childIndex,
    ViewService viewService) {
  //判断是否VIP
  bool isVip = _isVipByVipExpireDate(replyModel?.vipExpireDate) ?? false;

  return Padding(
    padding: EdgeInsets.only(top: Dimens.pt8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          ///点击头像，进入用���中心
          onTap: () async {
            if (replyModel.userID == null) {
              return;
            }
            Map<String, dynamic> arguments = {
              'uid': replyModel?.userID ?? 0,
              'uniqueId': DateTime.now().toIso8601String(),
            };
            viewService.broadcast(
                FilmVideoCommentActionCreator.stopVideoPlay(state.videoId));
            var result =
                await Gets.Get.to(() => BloggerPage(arguments), opaque: false);
            l.e("_getReplyItem", "$result");
            viewService.broadcast(
                FilmVideoCommentActionCreator.notifyReStartPlayVideo(
                    state.videoId));
          },
          child: HeaderWidget(
            headPath: replyModel?.userPortrait,
            headHeight: Dimens.pt32,
            headWidth: Dimens.pt32,
            level: ( replyModel.superUser ?? false)? 1 : 0,
            levelSize: Dimens.pt12,
            positionedSize: 0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: Dimens.pt10),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "${replyModel.userName}",
                    style: TextStyle(
                        color: isVip && replyModel.vipLevel > 0
                            ? Color.fromRGBO(246, 197, 89, 1)
                            : Colors.white,
                        fontSize: Dimens.pt14,
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Dimens.pt5),
                  ),
                  buildHonorLevelUI(
                      hasKingIcon: isVip && replyModel.vipLevel > 0,
                      honorLevelList: replyModel?.awardsExpire),
                ],
              ),
              const SizedBox(height: 6),
              _getContentView(replyModel),

              //显示回复按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      DateTimeUtil.utc2iso2(replyModel?.createdAt ?? ""),
                      style: TextStyle(
                          fontSize: Dimens.pt12,
                          color: AppColors.recommentSubTextColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      ///点击评论进行回复
                      _showInput(state, dispatch, context,
                          parentIndex: parentIndex, childIndex: childIndex);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(Dimens.pt8),
                      child: Text("回复",
                          style: TextStyle(
                              color: AppColors.recommentSubTextColor,
                              fontSize: Dimens.pt10)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  CustomLikeWidget(
                    scrollDirection: Axis.horizontal,
                    isLike: replyModel.isLike,
                    width: Dimens.pt15,
                    height: Dimens.pt15,
                    likeCountColor: AppColors.recommentSubTextColor,
                    likeIconPath: AssetsImages.IC_QUESTION_LIKE,
                    unlikeIconPath: AssetsImages.IC_QUESTION_UNLIKE,
                    padding: EdgeInsets.all(Dimens.pt5),
                    likeCount: replyModel.likeCount,
                    callback: (isLike) {
                      if (replyModel.isLike) {
                        _cancelLike(state, parentIndex, childIndex: childIndex);
                      } else {
                        _sendLike(state, parentIndex, childIndex: childIndex);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

///回复列表item
Widget _getContentView(ReplyModel replyModel) {
  bool answerOtherPeople = true;
  if (replyModel.toUserID == null || replyModel.toUserID == 0) {
    answerOtherPeople = false;
  }
  if (answerOtherPeople) {
    return Text.rich(TextSpan(children: [
      TextSpan(
        text: "回复",
        style: TextStyle(color: Colors.white, fontSize: Dimens.pt15),
      ),
      TextSpan(
        text: "${replyModel.toUserName}:",
        style: TextStyle(color: Colors.grey, fontSize: Dimens.pt15),
      ),
      TextSpan(
        text: "${replyModel.content}",
        style: TextStyle(color: Colors.white, fontSize: Dimens.pt15),
      ),
      TextSpan(
        text: "   ${showDateDesc(replyModel.createdAt)}",
        style: TextStyle(color: Colors.grey, fontSize: Dimens.pt13),
      ),
    ]));
  } else {
    return Text.rich(TextSpan(children: [
      TextSpan(
        text: "${replyModel.content}",
        style: TextStyle(color: Colors.white, fontSize: Dimens.pt15),
      ),
    ]));
  }
}

///取消点赞
_cancelLike(FilmVideoCommentState state, int parentIndex,
    {int childIndex = -1}) async {
  // Map<String, dynamic> param = {};
  // param["type"] = "comment";
  // if (childIndex == -1) {
  //   param["objID"] = commentList[parentIndex].id;
  // } else {
  //   param["objID"] = commentList[parentIndex].info[childIndex].id;
  // }
  String objID = childIndex == -1
      ? state.commentList[parentIndex].id
      : state.commentList[parentIndex].info[childIndex].id;
  String type = 'comment';

  // setState(() {
  //   if (childIndex == -1) {
  //     commentList[parentIndex].isLike = false;
  //     --commentList[parentIndex].likeCount;
  //     if (commentList[parentIndex].likeCount < 0) {
  //       commentList[parentIndex].likeCount = 0;
  //     }
  //   } else {
  //     commentList[parentIndex].info[childIndex].isLike = false;
  //     --commentList[parentIndex].info[childIndex].likeCount;
  //     if (commentList[parentIndex].info[childIndex].likeCount < 0) {
  //       commentList[parentIndex].info[childIndex].likeCount = 0;
  //     }
  //   }
  // });
  // try {
  //   await netManager.client.cancelLike(objID, type);
  // } catch (e) {
  //   // l.d('cancelLike=', e.toString());
  // }
  // cancelLike(param);
}

///点赞
_sendLike(FilmVideoCommentState state, int parentIndex,
    {int childIndex = -1}) async {
  // Map<String, dynamic> param = {};
  // param["type"] = "comment";
  // if (childIndex == -1) {
  //   param["objID"] = commentList[parentIndex].id;
  // } else {
  //   param["objID"] = commentList[parentIndex].info[childIndex].id;
  // }

  String objID = childIndex == -1
      ? state.commentList[parentIndex].id
      : state.commentList[parentIndex].info[childIndex].id;
  String type = 'comment';

  // setState(() {
  //   if (childIndex == -1) {
  //     commentList[parentIndex].isLike = true;
  //     ++commentList[parentIndex].likeCount;
  //   } else {
  //     commentList[parentIndex].info[childIndex].isLike = true;
  //     ++commentList[parentIndex].info[childIndex].likeCount;
  //   }
  // });
  try {
    await netManager.client.sendLike(objID, type);
  } catch (e) {
    // l.d('sendLike=', e.toString());
  }
  // sendLike(param);
}

///输入框弹出
_showInput(FilmVideoCommentState state, Dispatch dispatch, BuildContext context,
    {int parentIndex = -1, int childIndex = -1}) {
  l.e("parentIndex", "$parentIndex");
  l.e("childIndex", "$childIndex");

  var hint = "参与评论～"; //二级评论不需要提示语 南宫要求
  if (parentIndex != -1 && childIndex != -1) {
    hint = "回复: ${state.commentList[parentIndex].info[childIndex].userName}";
    state.textInputTip =
        "回复: ${state.commentList[parentIndex].info[childIndex].userName}";
  } else if (parentIndex != -1) {
    hint = "回复: ${state.commentList[parentIndex].userName}";
    state.textInputTip = "回复: ${state.commentList[parentIndex].userName}";
  } else {
    state.textInputTip = "";
  }

  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.pt10),
        topRight: Radius.circular(Dimens.pt10),
      )),
      isScrollControlled: true,
      builder: (BuildContext buildContext) {
        var height = MediaQuery.of(buildContext).viewInsets.bottom;
        if (height == 0) {
          height = Dimens.pt300;
        } else {
          height = height + Dimens.pt120;
        }
        return SizedBox(
          height: height,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
              height: Dimens.pt80,
              width: double.infinity,
              padding: EdgeInsets.only(left: Dimens.pt10, right: Dimens.pt10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TextField(
                      style:
                          TextStyle(fontSize: Dimens.pt15, color: Colors.white),
                      autofocus: true,
                      maxLength: 120,
                      cursorColor: Colors.white.withOpacity(0.6),
                      maxLines: 6,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(Dimens.pt10),
                        hintText: hint,
                        hintStyle: TextStyle(
                            fontSize: Dimens.pt15,
                            color: Colors.white.withOpacity(0.5)),
                        labelText: state.textInputTip,
                        counterStyle: TextStyle(
                          fontSize: Dimens.pt15,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      controller: state.contentController,
                      focusNode: state.focusNode,
                    ),
                  ),
                  GestureDetector(
                    child: Image(
                      image: AssetImage(AssetsImages.IC_SEND_COMMENT),
                      width: Dimens.pt21,
                      height: Dimens.pt21,
                    ),
                    onTap: () {
                      String content = state.contentController.text;
                      if (content.isEmpty) {
                        showToast(msg: Lang.NOT_NULL_TIP);
                        return;
                      }
                      if (content.length > 120) {
                        showToast(msg: Lang.COMMENT_BEYOND_CONTENT);
                        return;
                      }

                      if (childIndex != -1) {
                        ///回复item
                        dispatch(FilmVideoCommentActionCreator.sendReply(
                            content, parentIndex, childIndex));
                      } else {
                        if (parentIndex != -1) {
                          ///评论item
                          dispatch(FilmVideoCommentActionCreator.sendComment(
                              content, parentIndex));
                        } else {
                          ///自己发布评论
                          dispatch(FilmVideoCommentActionCreator.sendComment(
                              content, -1));
                        }
                      }
                      state.contentController.clear();
                      safePopPage();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

///底部评论widget
Widget _footerComment(
    FilmVideoCommentState state, Dispatch dispatch, BuildContext context) {
  return GestureDetector(
    onTap: () {
      _showInput(state, dispatch, context);
    },
    child: Container(
      height: Dimens.pt55,
      width: double.infinity,
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Divider(
            height: Dimens.pt1,
            indent: 0,
            color: Color(0xff1f1f1f),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: Color(0xff2c2c2c),
                borderRadius: BorderRadius.circular(18.5),
              ),
              height: Dimens.pt36,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 12),
                  Image.asset(
                    "assets/images/comment_msg.png",
                    width: 24,
                    height: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "参与评论～",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

///通过到期时间判断是否VIP
bool _isVipByVipExpireDate(String vipExpireDate) {
  ///VIP判断
  if (TextUtil.isNotEmpty(vipExpireDate) ?? false) {
    DateTime dateTime = DateTime.parse(vipExpireDate);
    return dateTime.isAfter((netManager.getFixedCurTime()));
  }
  return false;
}
