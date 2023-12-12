import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/comment/comment_list_page.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/page/video/widget/love_button/love_button.dart';
import 'package:flutter_app/page/video/widget/love_button/model.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidgetForHjll.dart';
import 'package:flutter_app/weibo_page/widget/word_rich_text.dart';
import 'package:flutter_app/widget/chewie/chewie_player.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:like_button/like_button.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'community_detail_action.dart';
import 'community_detail_page.dart';
import 'community_detail_state.dart';

Widget buildView(CommunityDetailState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 50),
          color: AppColors.primaryColor,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  safePopPage();
                },
                child: Image.asset(
                  "assets/weibo/back_arrow.png",
                  width: 24,
                  height: 24,
                ),
              ),
              SizedBox(width: 8),
              GestureDetector(
                child: (state.videoModel == null)
                    ? SizedBox()
                    : UnconstrainedBox(
                        child: SizedBox(
                          width: 32.w,
                          height: 32.w,
                          child: ClipOval(
                            child: CustomNetworkImage(
                              fit: BoxFit.cover,
                              height: 32.w,
                              width: 32.w,
                              imageUrl: state.videoModel?.publisher?.portrait ?? "",
                            ),
                          ),
                        ),
                      ),
                onTap: () {
                  Map<String, dynamic> arguments = {
                    'uid': state.videoModel.publisher.uid,
                    'uniqueId': DateTime.now().toIso8601String(),
                  };
                  Gets.Get.to(() => BloggerPage(arguments));
                },
              ),
              SizedBox(width: 10),
              Text(
                "${state.videoModel?.publisher?.name ?? ""}",
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              (state.videoModel == null ||
                      state.videoModel?.publisher == null ||
                      state.videoModel.publisher?.upTag == null ||
                      state.videoModel.publisher?.upTag == "")
                  ? SizedBox()
                  : Image.asset("assets/weibo/ic_uptag.png", width: 20, height: 20),
              Expanded(child: SizedBox()),
              Visibility(
                  visible: true,
                  child: GestureDetector(
                    child: (state.videoModel?.publisher?.hasFollowed ?? false)
                        ? // Rectangle 2784
                        Container(
                            width: 64,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color(0xffffffff).withOpacity(0.1),
                            ),
                            child: Text(
                              "已关注",
                              style: TextStyle(color: Color(0xffd3d3d3), fontSize: 15.w),
                            ),
                          )
                        : Container(
                            width: 63,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.primaryTextColor),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "+",
                                  style: TextStyle(color: AppColors.primaryTextColor, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Text(
                                  "关注",
                                  style: TextStyle(color: AppColors.primaryTextColor, fontSize: 12),
                                ),
                              ],
                            )),
                    onTap: () async {
                      // 自己不能关注自己
                      if (GlobalStore.isMe(state.videoModel.publisher.uid)) {
                        showToast(msg: Lang.GLOBAL_TIP_TXT1);
                        return;
                      }
                      bool isFollow = !state.videoModel.publisher.hasFollowed;

                      state.videoModel.publisher.hasFollowed = isFollow;

                      int followUID = state.videoModel.publisher.uid;
                      try {
                        await netManager.client.getFollow(followUID, isFollow);
                        dispatch(CommunityDetailActionCreator.updateUI());
                      } catch (e) {
                        //l.d('getFollow', e.toString());
                        showToast(msg: Lang.FOLLOW_ERROR, gravity: ToastGravity.CENTER);
                      }
                    },
                  )),
              SizedBox(width: 10),
            ],
          ),
        ),
        Expanded(
          child: state.videoModel == null
              ? LoadingWidget()
              : Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 50),
                      color: Color(0xff151515),
                      child: pullYsRefresh(
                        enablePullDown: false,
                        enablePullUp: true,
                        onRefresh: () {},
                        onLoading: () {
                          bus.emit(EventBusUtils.refreshComeent);
                        },
                        refreshController: state.controller,
                        // child: _getNewScrollView(dispatch),
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 0.w,
                                      top: 6.w,
                                      right: 0.w,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        WordImageWidgetForHjll(
                                          videoModel: state.videoModel,
                                          index: 0,
                                          isHideBottom: true,
                                          hideTopUserInfo: true,
                                          isDetail: true,
                                          randomTag: state.randomTag,
                                          linearGradient: state.linearGradient,
                                          isHaiJiaoLLDetail: true,
                                          bgColor: AppColors.primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 14),
                                      LikeButton(
                                        size: 18,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        likeCountPadding: EdgeInsets.only(left: 6.w),
                                        isLiked: state.videoModel.vidStatus.hasLiked ?? false,
                                        likeCountAnimationType: LikeCountAnimationType.none,
                                        circleColor:
                                            CircleColor(start: Color.fromRGBO(245, 75, 100, 1), end: Color.fromRGBO(245, 75, 100, 1)),
                                        bubblesColor: BubblesColor(
                                          dotPrimaryColor: Color.fromRGBO(245, 75, 100, 1),
                                          dotSecondaryColor: Color.fromRGBO(245, 75, 100, 1),
                                        ),
                                        likeBuilder: (bool isLiked) {
                                          return Image.asset(
                                            isLiked ? "assets/images/thumb_liked.png" : "assets/images/thumb_like_border.png",
                                            width: 25.w,
                                            height: 25.w,
                                          );
                                        },
                                        likeCount: state.videoModel.likeCount ?? 0,
                                        countBuilder: (int count, bool isLiked, String text) {
                                          var color = isLiked ? Color.fromRGBO(245, 75, 100, 1) : Colors.white.withOpacity(0.6);

                                          Widget result;
                                          if (count == 0) {
                                            result = Text(
                                              "点赞",
                                              style: TextStyle(color: color, fontSize: 12),
                                            );
                                          } else
                                            result = Text(
                                              getShowFansCountStr(count),
                                              //count.toString(),
                                              style: TextStyle(color: color, fontSize: 12),
                                            );
                                          return result;
                                        },
                                        onTap: (isLiked) async {
                                          // String type = 'video'; //img
                                          // if (state.videoModel.newsType == "SP") {
                                          //   type = 'video';
                                          // } else if (state.videoModel.newsType ==
                                          //     "COVER") {
                                          //   type = 'img';
                                          // }
                                          String type = 'image';
                                          String objID = state.videoModel.id;
                                          bool hasLiked = !state.videoModel.vidStatus.hasLiked;
                                          try {
                                            if (hasLiked) {
                                              await netManager.client.sendLike(objID, type);
                                            } else {
                                              await netManager.client.cancelLike(objID, type);
                                            }
                                            if (!hasLiked) {
                                              state.videoModel.likeCount -= 1;
                                            } else {
                                              state.videoModel.likeCount += 1;
                                            }
                                            state.videoModel.vidStatus.hasLiked = hasLiked;
                                          } catch (e) {
                                            l.d('changeTagStatus', e.toString());
                                            //showToast(msg: e.toString());
                                          }
                                          dispatch(CommunityDetailActionCreator.updateUI());
                                          return !isLiked;
                                        },
                                      ),
                                      SizedBox(
                                        width: 36,
                                      ),
                                      _buildCollectItem(state.videoModel, dispatch),
                                      SizedBox(
                                        width: 36,
                                      ),

                                      ///赚钱
                                      _createFunctionItemUI("assets/weibo/video_share.png", "分享", onTap: () {
                                        showShareVideoDialog(viewService.context, () async {
                                          await Future.delayed(Duration(milliseconds: 500));
                                        },
                                            videoModel: state.videoModel,
                                            isLongVideo: (state.videoModel.playTime ?? 0) > 300,
                                            isFvVideo: true);
                                      }),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    height: 1,
                                    color: Colors.white.withOpacity(0.1),
                                    margin: EdgeInsets.symmetric(horizontal: 14),
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    child: Text(
                                      "评论（${state.videoModel.commentCount}）",
                                      style: TextStyle(color: Color(0xffe7e7e7), fontSize: 16),
                                    ),
                                    margin: EdgeInsets.only(left: 10, right: 10),
                                  ),
                                ],
                              ),
                            ),
                            CommentListPage(
                              state.videoModel.id,
                              isSliver: true,
                              key: state.commentKey,
                              footerComment: false,
                              needReplay: true,

                              dataFinishCallback: (hasNext) {
                                if (hasNext) {
                                  state.controller.loadComplete();
                                } else {
                                  state.controller.loadNoData();
                                }
                              },
                              commentResult: (Map<String, dynamic> map) {
                                int bigCount = 0;
                                int count = 0;
                                int openOrClose = 0;
                                if (map.containsKey("bigCount")) {
                                  bigCount = map['bigCount'];
                                }
                                if (map.containsKey("count")) {
                                  count = map['count'];
                                }
                                if (map.containsKey("openOrClose")) {
                                  openOrClose = map['openOrClose'];
                                }
                                if (bigCount > 0) {
                                  state.commentCellCount = bigCount;
                                }
                                if (count > 0) {
                                  //1打开二级 2关闭
                                  if (openOrClose == 1) {
                                    state.commentCellCount += count;
                                  } else {
                                    state.commentCellCount -= (count - 1);
                                  }
                                }
                                if (map.containsKey("addComment")) {
                                  state.videoModel.commentCount += 1;
                                }
                                dispatch(CommunityDetailActionCreator.updateUI());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: Color(0xff151515),
                        padding: EdgeInsets.only(top: 8),
                        child: CommentListState.footerComment(callback: () {
                          state.commentKey?.currentState?.showInput();
                        }),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    ),
  );
}

///收藏UI
///
Widget _buildCollectItem(VideoModel viewModel, Dispatch dispatch) {
  if (viewModel == null) {
    return SizedBox();
  }
  bool isLove = (viewModel?.vidStatus?.hasCollected ?? false);
  var love1 = assetsImg("assets/weibo/collected.png", fit: BoxFit.cover, width: 20.w, height: 20.w);
  var love2 = assetsImg("assets/weibo/collect.png", fit: BoxFit.cover, width: 20.w, height: 20.w);
  var loveItem = Container(
      child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        child: LoveButton(
          loveController: LoveController(isLove),
          dotColor: DotColor(
            dotPrimaryColor: Color.fromARGB(1, 152, 219, 236),
            dotSecondaryColor: Color.fromARGB(1, 247, 188, 48),
            dotLastColor: Color.fromARGB(1, 221, 70, 136),
            dotThirdColor: Color.fromARGB(1, 205, 143, 246),
          ),
          imgWidth: 20.w,
          imgHeight: 20.w,
          cWidth: 30.w,
          cHeight: 30.w,
          imageTrue: love1,
          imageFalse: love2,
          duration: Duration(milliseconds: 800),
          enable: true,
          onIconCompleted: () {},
          onIconClicked: () {
            dispatch(CommunityDetailActionCreator.operateCollect());
          },
        ),
      ),
      Container(
        margin: EdgeInsets.only(left: 6),
        child: Center(
          child: Text(
            "收藏",
            style: TextStyle(
              color: Color.fromRGBO(167, 167, 167, 1),
              fontSize: 12.w,
            ),
          ),
        ),
      ),
    ],
  ));
  return loveItem;
}

///功能按钮UI
Widget _createFunctionItemUI(String imagePath, String title, {Function onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      alignment: Alignment.center,
      child: Row(
        children: [
          Image(
            image: AssetImage(imagePath),
            width: 20.w,
            height: 20.w,
          ),
          SizedBox(
            width: 6,
          ),
          Text(
            title,
            style: TextStyle(
              color: Color.fromRGBO(167, 167, 167, 1),
              fontSize: 12.w,
            ),
          ),
        ],
      ),
    ),
  );
}
