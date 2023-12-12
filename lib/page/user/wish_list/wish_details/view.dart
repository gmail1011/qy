import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/comment_model.dart';
import 'package:flutter_app/model/reply_model.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/load_more_footer.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/like_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/route_manager.dart' as Gets;

import 'action.dart';
import 'state.dart';

///愿望工单-问题详情UI
Widget buildView(
    WishDetailsState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar("问题详情"),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: EasyRefresh.custom(
              footer: LoadMoreFooter(hasNext: false, isComment: true),
              onLoad: () async =>
                  dispatch(WishDetailsActionCreator.getCommentList()),
              controller: state.refreshController,
              slivers: <Widget>[
                SliverToBoxAdapter(child: _createQuestionHeader(state)),
                _buildQuestionImagesUI(state),
                SliverToBoxAdapter(child: _createQuestionHeader2(state)),
                _buildQuestionDiscussUI(state, dispatch),
              ],
            ),
          ),
          _footerComment(state, dispatch, viewService.context),
        ],
      ),
    ),
  );
}

///展示评论列表UI
Widget _buildQuestionDiscussUI(WishDetailsState state, Dispatch dispatch) {
  return state.isErrorNet
      ? SliverToBoxAdapter(child: _buildRequestUI(1))
      : state.isDataReq
          ? SliverToBoxAdapter(child: _buildRequestUI(0))
          : (state.commentList?.length ?? 0) == 0
              ? SliverToBoxAdapter(child: _buildRequestUI(2))
              : SliverPadding(
                  padding: EdgeInsets.only(
                      top: Dimens.pt16, left: Dimens.pt25, right: Dimens.pt25),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return _buildCommentItemUI(state, dispatch, context,
                            state.commentList[index], index);
                      },
                      childCount: state.commentList?.length ?? 0,
                    ),
                  ),
                );
}

///创建问题图片UI
Widget _buildQuestionImagesUI(WishDetailsState state) {
  return state.isDataReq
      ? SliverToBoxAdapter()
      : (state.wishListItem?.images?.length ?? 0) > 0
          ? SliverToBoxAdapter(
              child: Container(
                color: AppColors.userMakeBgColor,
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: GridView.builder(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: Dimens.pt6,
                        mainAxisSpacing: Dimens.pt6,
                        childAspectRatio: 128 / 128),
                    itemCount: state.wishListItem?.images?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      List<String> picList = [];
                      state.wishListItem?.images
                          ?.map((e) => picList.add(e))
                          ?.toList();
                      return _buildWishImageItem(context, picList, index);
                    }),
              ),
            )
          : SliverToBoxAdapter();
}

///创建宽高UI
Widget _buildRequestUI(int requestType) {
  var requestUI;
  if (requestType == 0) {
    requestUI = LoadingWidget();
  } else if (requestType == 1) {
    requestUI = CErrorWidget(Lang.REQUEST_FAILED);
  } else if (requestType == 2) {
    requestUI = CErrorWidget(Lang.EMPTY_DATA);
  }
  return Container(
    alignment: Alignment.center,
    width: screen.screenWidth,
    height: screen.screenWidth,
    child: requestUI,
  );
}

///问题描述信息header1
Widget _createQuestionHeader(WishDetailsState state) {
  return state.isDataReq
      ? Container()
      : Container(
          margin: const EdgeInsets.only(top: 16),
          padding:
              const EdgeInsets.only(top: 11, left: 25, right: 25, bottom: 11),
          decoration: BoxDecoration(color: AppColors.userMakeBgColor),
          child: Text(
            state.wishListItem?.question ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimens.pt16,
              height: 1.5,
            ),
          ),
        );
}

///问题描述信息header2
Widget _createQuestionHeader2(WishDetailsState state) {
  return state.isDataReq
      ? Container()
      : Container(
          padding:
              const EdgeInsets.only(top: 11, left: 25, right: 25, bottom: 11),
          decoration: BoxDecoration(color: AppColors.userMakeBgColor),
          child: Row(
            children: [
              svgAssets(AssetsSvg.ICON_WISH_LIST02,
                  width: Dimens.pt13, height: Dimens.pt13),
              const SizedBox(width: 5),
              Text(
                formatTimeForQuestion(state.wishListItem?.createdAt ?? ""),
                maxLines: 1,
                style: TextStyle(
                    fontSize: Dimens.pt12,
                    color: Colors.white.withOpacity(0.5)),
              ),
              const SizedBox(width: 22),
              svgAssets(AssetsSvg.ICON_WISH_LIST03,
                  width: Dimens.pt13, height: Dimens.pt13),
              const SizedBox(width: 5),
              Text(
                "${state.wishListItem?.lookCount ?? 0}",
                maxLines: 1,
                style: TextStyle(
                  fontSize: Dimens.pt12,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ), //
        );
}

///图片列表UI
Widget _buildWishImageItem(
    BuildContext context, List<dynamic> imageList, int index) {
  String imageUrl = imageList[index];
  return GestureDetector(
    onTap: () =>
        showPictureSwipe(context, imageList, index, imageTyp: ImageTyp.NET),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: CustomNetworkImage(
        imageUrl: imageUrl,
        width: 128,
        height: 128,
        type: ImgType.avatar,
        fit: BoxFit.fitWidth,
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

///获取评论列表的item
Widget _buildCommentItemUI(WishDetailsState state, Dispatch dispatch,
    BuildContext context, CommentModel commentModel, int index) {
  bool isVip = _isVipByVipExpireDate(commentModel.vipExpireDate) ?? false;
  //外部点击事件
  return Padding(
    padding: EdgeInsets.only(top: Dimens.pt10, bottom: Dimens.pt5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              ///点击头像，进入用户中心
              onTap: () {
                if (commentModel.userID == null) {
                  return;
                }
                Map<String, dynamic> arguments = {
                  'uid': commentModel?.userID ?? 0,
                  'uniqueId': DateTime.now().toIso8601String(),
                };
                Gets.Get.to(() => BloggerPage(arguments), opaque: false);
              },
              child: HeaderWidget(
                headPath: commentModel.userPortrait ?? '',
                headHeight: Dimens.pt40,
                headWidth: Dimens.pt40,
                level: (commentModel.superUser ??false) ? 1 : 0,
                positionedSize: 0,
              ),
            ),
            Padding(padding: EdgeInsets.only(left: Dimens.pt10)),
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
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              _getUserName(commentModel.userName),
                              softWrap: true,
                              maxLines: 1,
                              style: TextStyle(
                                  color: (isVip && commentModel.vipLevel > 0)
                                      ? Color.fromRGBO(246, 197, 89, 1)
                                      : Colors.white,
                                  fontSize: Dimens.pt14,
                                  fontWeight: FontWeight.w300),
                            ),
                            buildHonorLevelUI(
                                hasKingIcon:
                                    isVip && (commentModel.vipLevel ?? 0) > 0,
                                honorLevelList: commentModel?.awardsExpire),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: Dimens.pt5)),
                      Visibility(
                        visible: commentModel?.isAdoption ?? false,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff333333),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 2, bottom: 2),
                          child: Text(
                            "已采纳",
                            style: TextStyle(
                              fontSize: Dimens.pt13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _commentStr(state, index),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimens.pt15,
                    ),
                    maxLines: 3,
                  ),

                  //time

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          DateTimeUtil.utc2iso2(commentModel?.createdAt ?? ""),
                          style: TextStyle(
                              fontSize: Dimens.pt12,
                              color: AppColors.recommentSubTextColor),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showInput(state, dispatch, context,
                              parentIndex: index);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image:
                                  AssetImage(AssetsImages.IC_QUESTION_REPLAY),
                              width: Dimens.pt16,
                              height: Dimens.pt16,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: Dimens.pt5),
                            ),
                            Text("回复",
                                style: TextStyle(
                                    color: AppColors.recommentSubTextColor,
                                    fontSize: Dimens.pt10))
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Visibility(
                        visible: !state.hideAdoptionButton,
                        child: GestureDetector(
                          onTap: () {
                            dispatch(WishDetailsActionCreator.adoption(
                                commentModel?.id));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image(
                                image:
                                    AssetImage(AssetsImages.ICON_QUESTION_GET),
                                width: Dimens.pt16,
                                height: Dimens.pt16,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: Dimens.pt5),
                              ),
                              Text("采纳",
                                  style: TextStyle(
                                      color: AppColors.recommentSubTextColor,
                                      fontSize: Dimens.pt10))
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !state.hideAdoptionButton,
                        child: const SizedBox(width: 15),
                      ),
                      CustomLikeWidget(
                        scrollDirection: Axis.horizontal,
                        isLike: commentModel?.isLike ?? false,
                        width: Dimens.pt15,
                        height: Dimens.pt15,
                        likeCountColor: AppColors.recommentSubTextColor,
                        likeIconPath: AssetsImages.IC_QUESTION_LIKE,
                        unlikeIconPath: AssetsImages.IC_QUESTION_UNLIKE,
                        padding: EdgeInsets.all(Dimens.pt5),
                        likeCount: commentModel?.likeCount ?? 0,
                        callback: (isLike) {
                          Map<String, dynamic> map = {};
                          map["index"] = index;
                          map["objID"] = commentModel.id;
                          if (commentModel?.isLike ?? false) {
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
            commentModel?.isRequestReply = !commentModel.isRequestReply;
            dispatch(WishDetailsActionCreator.updateUI());
          },
          child: Offstage(
            offstage: commentModel.haveMoreData ? false : true,
            child: Container(
              padding: EdgeInsets.only(
                  left: Dimens.pt46, top: Dimens.pt5, bottom: Dimens.pt5),
              child: Row(
                children: <Widget>[
                  Text(
                    (commentModel?.commCount ?? 0) > 99
                        ? ' ${Lang.COMMENT_SHOW_MORE_REPLY}' //展開更多回復
                        : " ${commentModel.isRequestReply ? "关闭" : "展开"} ${commentModel?.commCount} 条回复",
                    style: TextStyle(
                        color: AppColors.recommentSubTextColor,
                        fontSize: Dimens.pt11),
                  ),
                ],
              ),
            ),
          ),
        ),
        Offstage(
          offstage: !commentModel.isRequestReply ?? true,
          child: Padding(
            padding: EdgeInsets.only(left: Dimens.pt40, top: Dimens.pt8),
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                itemCount: state.commentList[index].info.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int childIndex) {
                  return _buildReplyItemUI(
                      state,
                      dispatch,
                      context,
                      state.commentList[index].info[childIndex],
                      index,
                      childIndex);
                },
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

///显示评论状态
String _commentStr(WishDetailsState state, int index) {
  CommentModel commentModel = state.commentList[index];
  if (commentModel?.isDelete ?? false) {
    return Lang.COMMENT_STATUS_DELETE;
  }
  if (commentModel?.status == 3) {
    return Lang.COMMENT_STATUS_SHIELD;
  } else if (commentModel?.status == 2) {
    return Lang.COMMENT_STATUS_CHECK;
  } else {
    return commentModel?.content ?? "";
  }
}

///获取用户名称
String _getUserName(String userName) {
  if ((userName ?? "").isNotEmpty) {
    if (userName.length > 9) {
      userName = userName.substring(0, 9);
    }
  }
  return userName ?? "";
}

///回复评论的ITEM
Widget _buildReplyItemUI(
    WishDetailsState state,
    Dispatch dispatch,
    BuildContext context,
    ReplyModel replyModel,
    int parentIndex,
    int childIndex) {
  bool isVip = _isVipByVipExpireDate(replyModel.vipExpireDate) ?? false;

  return Padding(
    padding: EdgeInsets.only(top: Dimens.pt8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (replyModel?.userID == null) {
              return;
            }
            Map<String, dynamic> arguments = {
              'uid': replyModel?.userID ?? 0,
              'uniqueId': DateTime.now().toIso8601String(),
            };
            Gets.Get.to(() => BloggerPage(arguments), opaque: false);
          },
          child: HeaderWidget(
            headPath: replyModel?.userPortrait ?? '',
            headHeight: Dimens.pt32,
            headWidth: Dimens.pt32,
            level: (replyModel.superUser ?? false) ? 1 : 0,
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
                        color: (isVip && replyModel.vipLevel > 0)
                            ? Color.fromRGBO(246, 197, 89, 1)
                            : Colors.white,
                        fontSize: Dimens.pt14,
                        fontWeight: FontWeight.w300),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: Dimens.pt5),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              _getContentView(replyModel),

              //显示回复按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      DateTimeUtil.utc2iso2(replyModel?.createdAt ?? ""),
                      style: TextStyle(
                          fontSize: Dimens.pt12,
                          color: AppColors.recommentSubTextColor),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ///点击评论进行回复
                      _showInput(state, dispatch, context,
                          parentIndex: parentIndex, childIndex: childIndex);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage(AssetsImages.IC_QUESTION_REPLAY),
                          width: Dimens.pt16,
                          height: Dimens.pt16,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Dimens.pt5),
                        ),
                        Text("回复",
                            style: TextStyle(
                                color: AppColors.recommentSubTextColor,
                                fontSize: Dimens.pt10))
                      ],
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
      )
    ]));
  }
}

///取消点赞
_cancelLike(WishDetailsState state, int parentIndex,
    {int childIndex = -1}) async {
  String objID = childIndex == -1
      ? state.commentList[parentIndex].id
      : state.commentList[parentIndex].info[childIndex].id;
  String type = 'comment';

  try {
    await netManager.client.cancelLike(objID, type);
  } catch (e) {
    // l.d('cancelLike=', e.toString());
  }
}

///点赞
_sendLike(WishDetailsState state, int parentIndex,
    {int childIndex = -1}) async {
  String objID = childIndex == -1
      ? state.commentList[parentIndex].id
      : state.commentList[parentIndex].info[childIndex].id;
  String type = 'comment';
  try {
    await netManager.client.sendLike(objID, type);
  } catch (e) {}
}

///输入框弹出
_showInput(WishDetailsState state, Dispatch dispatch, BuildContext context,
    {int parentIndex = -1, int childIndex = -1}) {
  var hint = Lang.COMMENT_INPUT_TIP;
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

        return Container(
          height: height,
          child: Scaffold(
            body: Container(
              height: Dimens.pt80,
              width: double.infinity,
              padding: EdgeInsets.only(left: Dimens.pt10, right: Dimens.pt10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TextField(
                      style:
                          TextStyle(fontSize: Dimens.pt15, color: Colors.white),
                      autofocus: true,
                      cursorColor: Colors.white.withOpacity(0.6),
                      maxLines: 8,
                      maxLength: 120,
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
                    ),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 28, right: 16, bottom: 32),
                      child: Image(
                        image: AssetImage(AssetsImages.IC_SEND_COMMENT),
                        width: Dimens.pt21,
                        height: Dimens.pt21,
                      ),
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
                        dispatch(WishDetailsActionCreator.sendWishReply(
                            content, parentIndex, childIndex));
                      } else {
                        if (parentIndex != -1) {
                          ///评论item
                          dispatch(WishDetailsActionCreator.sendWishComment(
                              content, parentIndex));
                        } else {
                          ///自己发布评论
                          dispatch(WishDetailsActionCreator.sendWishComment(
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
    WishDetailsState state, Dispatch dispatch, BuildContext context) {
  return GestureDetector(
    onTap: () {
      _showInput(state, dispatch, context);
    },
    child: state.isDataReq
        ? Container()
        : Container(
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
                  flex: 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(left: 16, right: 16),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Color(0xff2c2c2c),
                            borderRadius: BorderRadius.circular(17),
                          ),
                          height: Dimens.pt34,
                          padding: EdgeInsets.only(left: Dimens.pt20),
                          child: Text(
                            Lang.COMMENT_INPUT_TIP,
                            style: TextStyle(
                                color: Colors.white, fontSize: Dimens.pt15),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: Dimens.pt10),
                        child: Image(
                          image: AssetImage(AssetsImages.IC_SEND_COMMENT),
                          width: Dimens.pt21,
                          height: Dimens.pt21,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
  );
}
