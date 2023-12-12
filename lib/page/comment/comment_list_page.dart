import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/res/reply_list_res.dart';
import 'package:flutter_app/page/alert/vip_rank_alert.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_result_page.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/weibo_page/widget/word_rich_text.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/custom_like_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../model/comment_model.dart';
import '../../model/reply_model.dart';
import '../../model/res/comment_list_res.dart';
import 'package:dio/dio.dart';

typedef CommentResult = Function(Map<String, dynamic> map);

///评论列表界面
class CommentListPage extends StatefulWidget {
  final bool hasHeader;
  final String videoID;
  final CommentResult commentResult;
  final bool canScroll;
  final bool isVideoDetail;
  final bool footerComment;
  final bool needReplay;
  final bool isSliver;
  final Function(bool hasNext) dataFinishCallback;

  CommentListPage(
    this.videoID, {
    Key key,
    this.commentResult,
    this.hasHeader = false,
    this.canScroll = true,
    this.footerComment = true,
    this.needReplay = false,
    this.isVideoDetail = false,
    this.dataFinishCallback,
    this.isSliver = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CommentListState();
  }
}

class CommentListState extends State<CommentListPage> {
  //评论列表
  List<CommentModel> commentList = [];

  //评论总条数
  bool commentHasNext = true;

  int totalNum;

  int _pageIndex = 0;

  int _pageSize = 10;

  bool _isFirstLoading = true;

  bool _isLoadError = false;

  int videoIndex;

  String dateTime;

  //EasyRefreshController _controller = EasyRefreshController();

  RefreshController _controller = RefreshController();

  ///输入控制
  TextEditingController contentController = TextEditingController();

  String textInputTip;

  bool isClear = false;

  var inputText = '';

  FocusNode _focusNode = new FocusNode();

  QuickSearch quickSearch;

  int bigCount = 0;

  @override
  void initState() {
    super.initState();
    dateTime = DateTimeUtil.format2utc(DateTime.now());
    quickSearch = Config.randomSearch();
    _getCommentList();
    inputText = contentController.text ?? '';

    bus.on(EventBusUtils.refreshComeent, (arg) {
      _getCommentList();
    });
    bus.on(EventBusUtils.showCommentInput, (arg) {
      showInput();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bus.off(EventBusUtils.refreshComeent);
    bus.off(EventBusUtils.refreshComeentFinish);
    bus.off(EventBusUtils.refreshComeentFinishNoData);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSliver) {
      return _buildContentSliver();
    } else {
      return _buildContent();
    }
  }

  Widget _buildContentSliver() {
    if (_isFirstLoading || _isLoadError || (commentList.isEmpty && ((widget.footerComment ?? false) == false))) {
      return SliverToBoxAdapter(
        child: Container(
          height: 240,
          child: _buildContent(),
        ),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.only(bottom: 32),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _getCommentItem(commentList[index], index);
            },
            childCount: commentList?.length ?? 0,
          ),
        ),
      );
    }
  }

  Widget _buildContent() {
    if (_isFirstLoading) {
      return _loading();
    }
    if (_isLoadError) {
      return _error();
    }
    if (commentList.isEmpty && ((widget.footerComment ?? false) == false)) {
      return _empty();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.hasHeader) _header(),
        if (widget.canScroll == true)
          Expanded(child: widget.isVideoDetail ? _videoDetailView() : _comunityDetailView())
        else
          widget.isVideoDetail ? _videoDetailView() : _comunityDetailView(),
        (widget.footerComment ?? false) ? footerComment(callback: showInput) : SizedBox(),
      ],
    );
  }

  Widget _videoDetailView() {
    return (commentList.isEmpty)
        ? _empty()
        : pullYsRefresh(
            enablePullDown: widget.canScroll ?? false,
            enablePullUp: true,
            onRefresh: () {
              _pageIndex = 0;
              _getCommentList();
            },
            onLoading: () {
              _getCommentList();
            },
            refreshController: _controller,
            child: widget.canScroll
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      return _getCommentItem(commentList[index], index);
                    },
                    itemCount: commentList.length,
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemBuilder: (BuildContext context, int index) {
                      return _getCommentItem(commentList[index], index);
                    },
                    itemCount: commentList.length,
                  ),
          );
  }

  Widget _comunityDetailView() {
    return widget.canScroll
        ? ListView.builder(
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              return _getCommentItem(commentList[index], index);
            },
            itemCount: commentList.length,
          )
        : ListView.builder(
            padding: EdgeInsets.only(bottom: 32),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return _getCommentItem(commentList[index], index);
            },
            itemCount: commentList.length,
          );
  }

  ///空数据
  Widget _error() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: Dimens.pt20),
        ),
        Align(
          alignment: Alignment.center,
          child: Text(
            Lang.SERVER_ERROR,
            style: TextStyle(color: Colors.white, fontSize: Dimens.pt12),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: Dimens.pt5),
        ),
        Text(
          Lang.SERVER_ERROR,
          style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
        ),
      ],
    );
  }

  ///空数据
  Widget _empty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.hasHeader) _header(),
        SizedBox(
          height: 150,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: Dimens.pt20),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  Lang.COMMENT_NO_DATA,
                  style: TextStyle(color: Colors.grey, fontSize: Dimens.pt12),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: Dimens.pt5),
              ),
              Text(
                "快去发表评论吧",
                style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
              ),
            ],
          ),
        ),
        // _footerComment(),
      ],
    );
  }

  ///加载中动画
  Widget _loading() {
    return Center(
      child: LoadingWidget(
        color: AppColors.weiboBackgroundColor,
      ),
    );
  }

  ///头部控件
  Widget _header() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 56,
          child: Row(
            children: <Widget>[
              SizedBox(width: 16),
              if (quickSearch != null) ...[
                Text(
                  "大家都在搜：",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                InkWell(
                  onTap: () {
                    if (quickSearch.searchKeyword?.isNotEmpty == true) {
                      autoPlayModel.pauseAll();
                      Gets.Get.to(() => SearchResultPage().buildPage({"keyword": quickSearch.searchKeyword}));
                    } else if (quickSearch.videoID?.isNotEmpty == true) {
                      autoPlayModel.pauseAll();
                      Map<String, dynamic> maps = Map();
                      maps["videoId"] = quickSearch.videoID;
                      JRouter().go(FILM_TV_VIDEO_DETAIL_PAGE, arguments: maps);
                    } else if (quickSearch.link?.isNotEmpty == true) {
                      JRouter().handleAdsInfo(quickSearch.link, id: quickSearch.id);
                    } else {}
                  },
                  child: Row(
                    children: [
                      Text(
                        quickSearch.title,
                        style: TextStyle(color: Color(0xffe9a43d), fontSize: 16),
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
              Spacer(),
              // InkWell(
              //   onTap: () {
              //     safePopPage();
              //   },
              //   child: Container(
              //     padding: EdgeInsets.fromLTRB(6, 5, 0, 6),
              //     child: Image.asset(
              //       "assets/weibo/images/comment_close.png",
              //       width: 24,
              //       height: 24,
              //     ),
              //   ),
              // ),
              SizedBox(width: 16),
            ],
          ),
        ),
        Container(
          color: Color(0xff2b2b2b),
          height: 1,
        ),
        SizedBox(height: 12),
        // if (commentList?.isNotEmpty == true)
        //   Text(
        //     "$totalNum条评论",
        //     style: TextStyle(
        //       color: Color(0xffbebebe),
        //       fontSize: 14,
        //     ),
        //   ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 16,
            ),
            Text(
              "评论",
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontSize: 18,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }

  ///底部评论widget
  static Widget footerComment({Function callback}) {
    return GestureDetector(
        onTap: () {
          callback?.call();
        },
        child: Container(
          padding: EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 11,
              ),
              Expanded(
                child: Container(
                  // height: Dimens.pt50,
                  width: double.infinity,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 40,
                    margin: EdgeInsets.only(left: Dimens.pt12, right: Dimens.pt12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color.fromRGBO(44, 44, 44, 1),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 12),
                        // Image.asset(
                        //   "assets/images/comment_msg.png",
                        //   width: 24,
                        //   height: 24,
                        // ),
                        SizedBox(width: 8),
                        Text(
                          "参与评论 得积分拿VIP",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10.w),
                child: Image.asset(
                  "assets/weibo/images/icon_send_comment.png",
                  width: 40.w,
                  height: 40.w,
                ),
              ),
            ],
          ),
        ));
  }

  ///输入框弹出
  showInput({int parentIndex = -1, int childIndex = -1}) {
    if (parentIndex != -1 && childIndex != -1) {
      textInputTip = "回复: ${commentList[parentIndex].info[childIndex].userName}";
    } else if (parentIndex != -1) {
      textInputTip = "回复: ${commentList[parentIndex].userName}";
    } else {
      textInputTip = "参与评论 得积分拿VIP";
    }

    showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.weiboJianPrimaryBackground,
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
            height = height + Dimens.pt80;
          }
          return Container(
            height: height + 18.w,
            child: Column(
              children: [
                SizedBox(
                  height: 18.w,
                ),
                Container(
                  height: 66.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          child: TextField(
                            onSubmitted: (values) {
                              String content = contentController.text;
                              if (content.isEmpty) {
                                showToast(msg: Lang.NOT_NULL_TIP);
                                return;
                              }
                              if (childIndex != -1) {
                                _sendComment(content, parentIndex: parentIndex, childIndex: childIndex);
                              } else {
                                if (parentIndex != -1) {
                                  _sendComment(content, parentIndex: parentIndex);
                                } else {
                                  _sendComment(content);
                                }
                              }
                              contentController.clear();
                              safePopPage();
                            },
                            controller: contentController,
                            keyboardType: TextInputType.text,
                            autofocus: true,
                            autocorrect: true,
                            onTap: () {},
                            textInputAction: TextInputAction.done,
                            cursorColor: Colors.white,
                            textAlign: TextAlign.left,
                            focusNode: _focusNode,
                            onChanged: (text) {},
                            maxLines: 1,
                            // maxLength: 120,
                            // buildCounter: (_,
                            //     {currentLength, maxLength, isFocused}) =>
                            //     Container(
                            //       height: 20.w,
                            //       alignment: Alignment.centerRight,
                            //       child: Text(
                            //         currentLength.toString() +
                            //             "/" +
                            //             maxLength.toString(),
                            //         style: TextStyle(
                            //             color: Colors.white, fontSize: 12.w),
                            //       ),
                            //     ),
                            style: TextStyle(color: Colors.white, fontSize: 16.w),
                            decoration: InputDecoration(
                              fillColor: Color.fromRGBO(44, 44, 44, 1),
                              hintText: textInputTip,
                              // "请输入你想说的",
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16.w),
                              contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              filled: true,
                              isCollapsed: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color.fromRGBO(44, 44, 44, 1)), borderRadius: BorderRadius.circular(26)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(44, 44, 44, 1)),
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 13.w,
                      ),
                      GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(right: 10.w),
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            "assets/weibo/images/icon_send_comment.png",
                            width: 40.w,
                            height: 40.w,
                          ),
                        ),
                        onTap: () {
                          String content = contentController.text;
                          if (content.isEmpty) {
                            showToast(msg: Lang.NOT_NULL_TIP);
                            return;
                          }
                          /*if (content.length > 120) {
                            showToast(msg: Lang.COMMENT_BEYOND_CONTENT);
                            return;
                          }*/
                          if (childIndex != -1) {
                            _sendComment(content, parentIndex: parentIndex, childIndex: childIndex);
                          } else {
                            if (parentIndex != -1) {
                              _sendComment(content, parentIndex: parentIndex);
                            } else {
                              _sendComment(content);
                            }
                          }
                          contentController.clear();
                          safePopPage();
                        },
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  ///获取评论列表的item
  Widget _getCommentItem(CommentModel commentModel, int index) {
    // int commentCount = commentModel.info.length;
    String time = showDateDesc(commentModel.createdAt);
    //外部点击事件
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.fromLTRB(Dimens.pt10, Dimens.pt5, Dimens.pt10, Dimens.pt5),
        child: Stack(
          children: [
            if (commentModel?.isGodComment == true)
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
                      ///点击头像，进入用户中心
                      onTap: () {
                        Map<String, dynamic> map = {
                          'uid': commentModel.userID,
                          'uniqueId': DateTime.now().toIso8601String(),
                        };

                        Gets.Get.to(() => BloggerPage(map), opaque: false);
                      },
                      child: HeaderWidget(
                        headPath: commentModel?.userPortrait ?? "",
                        level: (commentModel?.superUser ?? false) ? 1 : 0,
                        headWidth: 40.w,
                        headHeight: 40.w,
                        levelSize: 13.w,
                        positionedSize: 0,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(
                              height: 40.w,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${commentModel.userName}",
                                style: TextStyle(
                                    color: commentModel.vipLevel > 0 ? Color.fromRGBO(255, 255, 255, 1) : Color.fromRGBO(255, 255, 255, 1),
                                    fontSize: 16.nsp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            WordRichText(
                              title: _commentStr(index),
                              linkUrl: commentList[index].linkStr,
                              maxTextSize: 270,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16.nsp,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  time,
                                  style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12.nsp),
                                ),
                                if (widget.needReplay ?? false)
                                  Text(
                                    "       回复",
                                    style: TextStyle(color: Color.fromRGBO(124, 135, 159, 1), fontSize: 12.nsp),
                                  ),
                                Spacer(),
                                LikeWidget(
                                  isLike: commentModel.isLike,
                                  width: Dimens.pt20,
                                  height: Dimens.pt15,
                                  likeCountColor: Color(0xFFBBBCBB),
                                  likeIconPath: "assets/images/thumb_liked.png",
                                  // AssetsSvg.IC_COMMENT_LIKE,
                                  unlikeIconPath: "assets/images/thumb_like_border.png",
                                  // AssetsSvg.IC_COMMENT_UNLIKE,
                                  padding: EdgeInsets.all(Dimens.pt5),
                                  likeCount: commentModel.likeCount,
                                  scrollDirection: Axis.horizontal,
                                  callback: (isLike) {
                                    Map<String, dynamic> map = {};
                                    map["index"] = index;
                                    map["objID"] = commentModel.id;
                                    if (commentModel.isLike) {
                                      _cancelLike(index);
                                    } else {
                                      _sendLike(index);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (commentList[index]?.replyList?.isNotEmpty == true && (widget.needReplay ?? false))
                  Padding(
                    padding: EdgeInsets.only(left: Dimens.pt40, top: Dimens.pt5),
                    child: ListView.builder(
                      itemCount: commentList[index].replyList?.length ?? 0,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int childIndex) {
                        ReplyModel replyModel = commentList[index].info[childIndex];
                        return _getReplyItem(replyModel, index, childIndex);
                      },
                    ),
                  ),
                if (commentModel.hasMoreReply == true && (widget.needReplay ?? false))
                  InkWell(
                    onTap: () {
                      ///获取更多回复
                      if (commentModel.haveMoreData) {
                        _getReplyList(index);
                      } else {
                        commentModel.isShowReply = !commentModel.isShowReply;
                        if (commentModel.isShowReply) {
                          Map<String, dynamic> maps = Map();
                          maps['count'] = commentList[index].replyList.length;
                          maps['openOrClose'] = 2; //关闭二级
                          maps['bigCount'] = bigCount;
                          widget.commentResult(maps);
                        } else {
                          Map<String, dynamic> maps = Map();
                          maps['count'] = commentList[index].replyList.length;
                          maps['openOrClose'] = 1; //打开二级
                          maps['bigCount'] = bigCount;
                          widget.commentResult(maps);
                        }
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: Dimens.pt72, top: 8.w, bottom: Dimens.pt5, right: 4),
                      child: Row(
                        children: <Widget>[
                          if (commentModel.isShowReply)
                            Text(
                              commentModel.commCount > 99
                                  ? ' ${Lang.COMMENT_SHOW_MORE_REPLY}' //展開更多回復
                                  : " 展开 ${commentModel.realCommentCount} 条回复",
                              style: TextStyle(color: Color.fromRGBO(124, 135, 159, 1), fontSize: Dimens.pt11),
                            )
                          else
                            Text(
                              " 收起回复",
                              style: TextStyle(color: Color.fromRGBO(124, 135, 159, 1), fontSize: Dimens.pt11),
                            ),
                          SizedBox(width: 8.w),
                          if (commentModel.isRequestReply)
                            Theme(
                              data: ThemeData(
                                cupertinoOverrideTheme: CupertinoThemeData(
                                  brightness: Brightness.dark,
                                  primaryColor: Colors.white,
                                ),
                              ),
                              child: CupertinoActivityIndicator(
                                radius: 6,
                              ),
                            )
                          else
                            Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationX(commentModel.isShowReply ? 0 : pi),
                              child: Image.asset(
                                "assets/weibo/triangle.png",
                                width: 8.w,
                                height: 8.w,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        ///点击评论进行回复
        if (widget.needReplay ?? false) {
          showInput(parentIndex: index);
        }
      },
    );
  }

  Widget getFollowView(bool isFollow) {
    return Offstage(
      offstage: isFollow ? false : true,
      child: Container(
        padding: EdgeInsets.all(2),
        margin: EdgeInsets.only(left: Dimens.pt5),
        decoration: BoxDecoration(color: Color(0xFFD8D8D8), borderRadius: BorderRadius.circular(3)),
        child: Text(
          Lang.COMMENT_YOU_FOLLOW_USER,
          style: TextStyle(color: Color(0x80000000), fontSize: 11),
        ),
      ),
    );
  }

  Widget getAuthorView(bool isAuthor) {
    if (isAuthor == true) {
      return Container(
        padding: EdgeInsets.all(Dimens.pt2),
        margin: EdgeInsets.only(left: 0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Text(
          "作者",
          style: TextStyle(color: Colors.white, fontSize: Dimens.pt8),
        ),
      );
    }
    return Container();
  }

  Widget getVipHuangguanView(int vipLevel) {
    return vipLevel > 0
        ? Container(
            padding: EdgeInsets.only(left: 10.w),
            child: Image.asset(
              "assets/weibo/huangguan.png",
              width: 18.w,
              height: 18.w,
              fit: BoxFit.contain,
            ))
        : Container();
  }

  Widget getUserGenderAndAge(int age, String gender) {
    //gender
    age = age ?? 0;
    var w = Dimens.pt15;
    if (age >= 18) {
      w = Dimens.pt24;
    }
    Widget genderWidget = svgAssets(AssetsSvg.USER_IC_USER_GENDER_FAMALE, width: Dimens.pt10, height: Dimens.pt10);
    Widget genderWidgetBg = svgAssets(AssetsSvg.USER_IC_USER_GENDER_BG, width: w, height: Dimens.pt14, fit: BoxFit.fill);
    if (gender != null) {
      if (gender == 'male') {
        genderWidget = svgAssets(AssetsSvg.USER_IC_USER_GENDER_MALE, width: Dimens.pt10, height: Dimens.pt10);
        genderWidgetBg = svgAssets(AssetsSvg.USER_IC_USER_GENDER_BG1, width: w, height: Dimens.pt14, fit: BoxFit.fill);
      }
    }

    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.pt7),
        color: Colors.transparent,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          genderWidgetBg,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              genderWidget,
              age >= 18
                  ? Text(
                      ' $age',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }

  ///显示评论状态
  String _commentStr(int index) {
    CommentModel commentModel = commentList[index];
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
  Widget _getReplyItem(ReplyModel replyModel, int parentIndex, int childIndex) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        showInput(parentIndex: parentIndex, childIndex: childIndex);
      },
      child: Padding(
        padding: EdgeInsets.only(top: Dimens.pt5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: Dimens.pt5),
            ),
            GestureDetector(
              ///点击头像，进入用户中心
              onTap: () {
                Map<String, dynamic> map = {
                  'uid': replyModel.userID == 0 ? 167167 : replyModel.userID,
                  'uniqueId': DateTime.now().toIso8601String(),
                };
                //JRouter().go(PAGE_VIDEO_USER_CENTER, arguments: map);
                Gets.Get.to(BloggerPage(map), opaque: false);
              },
              child: ClipOval(
                  child: CustomNetworkImage(
                width: Dimens.pt25,
                height: Dimens.pt25,
                type: ImgType.avatar,
                imageUrl: replyModel.userPortrait,
                fit: BoxFit.cover,
              )),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.w),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(top: 4.w),
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
                          "${(replyModel.userName?.isNotEmpty == true ? replyModel.userName : "妻友运营小骚货")}",
                          style: TextStyle(
                              color: replyModel.vipLevel > 0 ? Color.fromRGBO(246, 197, 89, 1) : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w300),
                        ),
                        getVipHuangguanView(replyModel.vipLevel ?? 0),
                        SizedBox(width: Dimens.pt5),
                        getAuthorView(replyModel.isAuthor ?? false),
                        // getUserGenderAndAge(replyModel.age, replyModel.gender),
                        SizedBox(width: Dimens.pt6),
                        //getVipLevelWidget(true, replyModel.level),
                        //getFollowView(replyModel.isFollow),
                        if (replyModel.isShowToName == true) ...[
                          Image.asset(
                            "assets/images/reply_right_arrow.png",
                            width: 9.w,
                            height: 10.w,
                          ),
                          SizedBox(width: Dimens.pt6),
                          Text(
                            "${replyModel.toUserName}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 8.w),
                    _getContentView(replyModel),
                    SizedBox(height: 4.w),
                    Container(
                      margin: EdgeInsets.only(right: 14.w),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        showDateDesc(replyModel.createdAt) == ""
                            ? DateUtil.formatDateStr(replyModel.createdAt, format: "yyyy-MM-dd HH:mm:ss").trim()
                            : "${showDateDesc(replyModel.createdAt)}" + "       回复",
                        style: TextStyle(color: Color.fromRGBO(124, 135, 159, 1), fontSize: 12.nsp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40.w),
              child: LikeWidget(
                isLike: replyModel.isLike ?? false,
                width: Dimens.pt20,
                height: Dimens.pt15,
                likeCountColor: Color(0xFFBBBCBB),
                likeIconPath: "assets/images/thumb_liked.png",
                // AssetsSvg.IC_COMMENT_LIKE,
                unlikeIconPath: "assets/images/thumb_like_border.png",
                // AssetsSvg.IC_COMMENT_UNLIKE,
                padding: EdgeInsets.all(Dimens.pt5),
                likeCount: replyModel.likeCount ?? 0,
                scrollDirection: Axis.horizontal,
                callback: (isLike) {
                  if (replyModel.isLike) {
                    _cancelLike(parentIndex, childIndex: childIndex);
                  } else {
                    _sendLike(parentIndex, childIndex: childIndex);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getContentView(ReplyModel replyModel) {
    return WordRichText(
      key: ValueKey(replyModel.content),
      title: replyModel.content,
      linkUrl: replyModel.linkStr,
      maxTextSize: 1000000,
      textStyle: TextStyle(color: Colors.white, fontSize: 12),
    );
  }

  ///获取评论列表
  Future<bool> _getCommentList() async {
    // if (!commentHasNext) {
    //   _controller.refreshCompleted();
    //   _controller.loadComplete();
    //   _controller.loadNoData();
    //   bus.emit(EventBusUtils.refreshComeentFinishNoData);
    //   return false;
    // }
    _pageIndex++;
    String objID = widget.videoID;
    String curTime = dateTime;
    try {
      CommentListRes commentListRes = await netManager.client.getCommentList(objID, curTime, _pageIndex, _pageSize);
      if (this.mounted == false) return false;
      _controller.refreshCompleted();
      _controller.loadComplete();
      bus.emit(EventBusUtils.refreshComeentFinish);

      _isFirstLoading = false;
      _isLoadError = false;
      commentHasNext = commentListRes.hasNext ?? false;
      if (!commentHasNext) {
        _controller.loadNoData();
      }
      if (totalNum == null) {
        totalNum = commentListRes.total;
      }
      if (_pageIndex == 1 && commentList != null) {
        commentList.clear();
      }
      if (commentListRes != null && commentListRes.list != null) {
        bigCount += commentListRes.list.length;
      }

      for (CommentModel commentModel in commentListRes.list) {
        if (commentModel.commCount > 0 ?? false) {
          bigCount += 1;
        }
        commentModel.replyPageIndex = 1;
        commentList.add(commentModel);
      }
      Map<String, dynamic> maps = Map();
      maps['bigCount'] = bigCount;
      if (widget.commentResult != null) {
        widget.commentResult(maps);
      }
      widget.dataFinishCallback?.call(commentHasNext);
      setState(() {});
    } catch (e) {
      l.d('getCommentList=', e.toString());
      _controller.loadComplete();
      widget.dataFinishCallback?.call(true);
      bus.emit(EventBusUtils.refreshComeentFinish);
      if (!mounted) {
        return false;
      }
      setState(() {
        _isLoadError = true;
        _isFirstLoading = false;
      });
    }
    return true;
  }

  ///获取回复列表
  _getReplyList(int parentIndex) async {
    if (commentList[parentIndex].isRequestReply == true) {
      return;
    }
    commentList[parentIndex].isRequestReply = true;
    setState(() {});
    if (parentIndex < 0 || parentIndex >= commentList.length) {
      commentList[parentIndex].isRequestReply = false;
      setState(() {});
      return; // [0,length)
    }
    if (!commentList[parentIndex].haveMoreData) {
      commentList[parentIndex].isRequestReply = false;
      _controller.loadNoData();
      setState(() {});
      return;
    }

    var infoList = commentList[parentIndex].info;
    String objID = widget.videoID;
    String cmtId = commentList[parentIndex].id;
    String curTime = DateTimeUtil.format2utc(DateTime.now());
    int pageNumber = commentList[parentIndex].replyPageIndex;
    int pageSize = 5;
    String fstID;
    if (infoList.isNotEmpty) {
      fstID = infoList[0].id ?? "";
    }
    try {
      ReplyListRes replyListRes = await netManager.client.getReplyList(objID, cmtId, curTime, pageNumber, pageSize, fstID);
      if (this.mounted == false) return;
      commentList[parentIndex].haveMoreData = replyListRes.hasNext ?? false;
      commentList[parentIndex].isShowReply = replyListRes.hasNext ?? false;
      ++commentList[parentIndex].replyPageIndex;
      commentList[parentIndex].info.addAll(replyListRes.list);

      Map<String, dynamic> maps = Map();
      maps['bigCount'] = bigCount;
      maps['count'] = replyListRes.list.length;
      maps['openOrClose'] = 1; //打开二级
      widget.commentResult(maps);
    } catch (e) {
      l.d('getReplyList=', e.toString());
    }
    commentList[parentIndex].isRequestReply = false; //把请求状态设置为可请求

    setState(() {});
  }

  ///取消点赞
  _cancelLike(int parentIndex, {int childIndex = -1}) async {
    String objID = childIndex == -1 ? commentList[parentIndex].id : commentList[parentIndex].info[childIndex].id;
    String type = 'comment';

    setState(() {
      if (childIndex == -1) {
        commentList[parentIndex].isLike = false;
        --commentList[parentIndex].likeCount;
        if (commentList[parentIndex].likeCount < 0) {
          commentList[parentIndex].likeCount = 0;
        }
      } else {
        commentList[parentIndex].info[childIndex].isLike = false;
        --commentList[parentIndex].info[childIndex].likeCount;
        if (commentList[parentIndex].info[childIndex].likeCount < 0) {
          commentList[parentIndex].info[childIndex].likeCount = 0;
        }
      }
    });
    try {
      await netManager.client.cancelLike(objID, type);
    } catch (e) {
      l.d('cancelLike=', e.toString());
    }
    // cancelLike(param);
  }

  ///点赞
  _sendLike(int parentIndex, {int childIndex = -1}) async {
    String objID = childIndex == -1 ? commentList[parentIndex].id : commentList[parentIndex].info[childIndex].id;
    String type = 'comment';

    setState(() {
      if (childIndex == -1) {
        commentList[parentIndex].isLike = true;
        ++commentList[parentIndex].likeCount;
      } else {
        commentList[parentIndex].info[childIndex].isLike = true;
        ++commentList[parentIndex].info[childIndex].likeCount;
      }
    });
    try {
      await netManager.client.sendLike(objID, type);
    } catch (e) {
      l.d('sendLike=', e.toString());
    }
    // sendLike(param);
  }

  ///发表评论
  _sendComment(String content, {int parentIndex = -1, int childIndex = -1}) async {
    if (content.trim().isEmpty) {
      showToast(msg: Lang.NOT_NULL_TIP);
      return;
    }
    // if (!GlobalStore.isVIP()) {
    //   _focusNode.unfocus();
    //   await Future.delayed(Duration(milliseconds: 500), () {
    //     VipRankAlert.show(
    //       context,
    //       type: VipAlertType.vip,
    //     );
    //   });
    //   return;
    // }
    if (GlobalStore.store?.getState()?.meInfo?.hasBanned ?? false) {
      showToast(msg: Lang.COMMENT_FORBID);
      return;
    }

    String objID = widget.videoID;
    int level = 1;
    String cid, rid;
    int toUserID;
    if (childIndex != -1) {
      cid = commentList[parentIndex].id;
      rid = commentList[parentIndex].info[childIndex].id;
      toUserID = commentList[parentIndex].info[childIndex].userID;
      level = 2;
    } else {
      if (parentIndex != -1) {
        cid = commentList[parentIndex].id;
        level = 2;
      }
    }
    String content1 = "";
    String name = "";
    try {
      if (childIndex != -1 || parentIndex != -1) {
        ReplyModel replyModel = await netManager.client.sendReply(objID, level, content, cid, rid, toUserID);
        content1 = replyModel.content;
        name = replyModel.userName;
        if (commentList[parentIndex].info == null) {
          commentList[parentIndex].info = [];
        }
        if (childIndex != -1 && parentIndex != -1) {
          replyModel.level = 2;
          // commentList[parentIndex].info.insert(childIndex + 1, replyModel);
        } else {
          // commentList[parentIndex].info.insert(0, replyModel);
        }
      } else {
        CommentModel commentModel = await netManager.client.sendComment(objID, level, content);
        content1 = commentModel.content;
        name = commentModel.userName;
        // commentList.insert(0, commentModel);
      }
      if (widget.commentResult != null) {
        Map<String, dynamic> maps = Map();
        maps['addComment'] = 1;
        widget.commentResult(maps);
      }
      //增加总数
      totalNum += 1;
      showToast(msg: "评论成功，请耐心等待审核");
      setState(() {});
    } on DioError catch (e) {
      var error = e.error;
      if (error is ApiException) {
        if (error.code == 7019) {
          VipRankAlert.show(
            context,
            type: VipAlertType.descText,
            descText: error.message ?? "非充值用户不可评论",
          );
        }
      }
      l.e('postBuyNovel=', e.toString());
    } catch (e) {
      // 7019
      showToast(msg: "${e.toString()}");
      l.d('sendReply/sendComment =', e.toString());
    }
  }
}
