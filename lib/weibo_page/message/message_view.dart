import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/provider/msg_count_model.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/message/InCome.dart';
import 'package:flutter_app/weibo_page/message/dynamic.dart';
import 'package:flutter_app/weibo_page/message/official_message_page.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:provider/provider.dart';

import '../../page/alert/vip_rank_alert.dart';
import 'AnnouncePage.dart';
import 'add/add_page.dart';
import 'message_action.dart';
import 'message_detail/MessageDetailPage.dart';
import 'message_list_entity.dart';
import 'message_state.dart';

Widget buildView(
    MessageState state, Dispatch dispatch, ViewService viewService) {
  ///判断是否有广告位置
  bool hasAdLocaiton = (state.adsList?.length ?? 0) > 0;

  return Scaffold(
    appBar: AppBar(
      elevation: 0,
      centerTitle: true,
      titleSpacing: .0,
      title: Text(
        "我的消息",
        style: TextStyle(
            fontSize: AppFontSize.fontSize18, color: Colors.white, height: 1.4),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => safePopPage(),
      ),
    ),
    body: Container(
      margin: EdgeInsets.only(top: 20.w),
      color: AppColors.primaryColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Gets.Get.to(() => AnnouncePage(), opaque: false);
                  AnalyticsEvent.clickToHomeTab('活动');
                },
                child: Container(
                  color: Colors.transparent,
                  width: 56.w,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/weibo/message_announce.png",
                        width: 50.w,
                        height: 50.w,
                      ),
                      SizedBox(height: 10.w),
                      Text(
                        "公告",
                        style: TextStyle(color: Colors.white, fontSize: 16.nsp),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Gets.Get.to(InComePage(), opaque: false);
                },
                child: Container(
                  color: Colors.transparent,
                  width: 56.w,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/weibo/message_shouyi.png",
                        width: 50.w,
                        height: 50.w,
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      Text(
                        "收益",
                        style: TextStyle(color: Colors.white, fontSize: 16.nsp),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  var result =
                      await Gets.Get.to(() => DynamicPage(), opaque: false);
                  l.d("DynamicPage-back:", "$result");
                },
                child: Container(
                  color: Colors.transparent,
                  width: 56.w,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            "assets/weibo/message_dongtai.png",
                            width: 50.w,
                            height: 50.w,
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Text(
                            "动态",
                            style: TextStyle(
                                color: Colors.white, fontSize: 16.nsp),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Consumer<MsgCountModel>(builder:
                            (BuildContext context, MsgCountModel msgCountModel,
                                Widget child) {
                          int countNum = msgCountModel.msgCountNum;
                          return countNum == 0
                              ? Container()
                              : ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  child: Container(
                                    color: Color(0xfff65c63),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 2.w, horizontal: 4.w),
                                    child: Text(
                                      countNum > 99 ? "99+" : "$countNum",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.w),
                                    ),
                                  ),
                                );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Gets.Get.to(AddPage().buildPage(null), opaque: false);
                },
                child: Container(
                  color: Colors.transparent,
                  width: 56.w,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/weibo/message_add.png",
                        width: 50.w,
                        height: 50.w,
                      ),
                      SizedBox(
                        height: 10.w,
                      ),
                      Text(
                        "添加",
                        style: TextStyle(color: Colors.white, fontSize: 16.nsp),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.w),

          ///广告位置
          if (hasAdLocaiton) _buildMessageAdListUI(state),

          ///消息列表UI
          state.messageListData == null
              ? Container(
                  height: 1.sw,
                  width: 1.sw,
                  child: LoadingWidget(),
                )
              : state.messageListData.xList == null ||
                      state.messageListData.xList.length == 0
                  ? Container(
                      height: 1.sw,
                      width: 1.sw,
                      color: AppColors.primaryColor,
                      child: Column(
                        mainAxisAlignment: hasAdLocaiton
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          if (hasAdLocaiton) SizedBox(height: 50.w),
                          CErrorWidget("没有消息哦～"),
                        ],
                      ))
                  : Expanded(
                      child: pullYsRefresh(
                        refreshController: state.refreshController,
                        //enablePullDown: false,
                        onRefresh: () {
                          dispatch(MessageActionCreator.onLoadMore(
                              state.pageNumber = 1));
                        },
                        onLoading: () {
                          dispatch(MessageActionCreator.onLoadMore(
                              state.pageNumber += 1));
                        },
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            ///消息列表
                            return _buildMessageCell(
                                state, dispatch, viewService, index);
                          },
                          itemCount: state.messageListData?.xList?.length ?? 0,
                        ),
                      ),
                    ),
        ],
      ),
    ),
  );
}

Widget _buildMessageCell(MessageState state, Dispatch dispatch,
    ViewService viewService, int realIndex) {
  return GestureDetector(
    onLongPress: () {
      showDelDialog(state, dispatch, viewService.context, realIndex);
    },
    onTap: () {
      if(!(GlobalStore.isVIP() && GlobalStore.getWallet().consumption>0)){
        VipRankAlert.show(
          viewService.context,
          type: VipAlertType.message,
        );
        return;
      }
      MessageListDataList model = state.messageListData.xList[realIndex];
      if (model.userId == 100000) {
        Gets.Get.to(
                () => OfficalMessagePage(
                      model: model,
                    ),
                opaque: false)
            .then((value) {
          dispatch(MessageActionCreator.onLoadMore(state.pageNumber = 1));
        });
      } else {
        Gets.Get.to(() => MessageDetailPage(model), opaque: false)
            .then((value) {
          dispatch(MessageActionCreator.onLoadMore(state.pageNumber = 1));
        });
      }
    },
    child: Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 19.w),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  ClipOval(
                    child: CustomNetworkImage(
                      fit: BoxFit.cover,
                      width: 68.w,
                      height: 68.w,
                      imageUrl:
                          state.messageListData.xList[realIndex].userAvatar,
                    ),
                  ),
                  Positioned(
                      bottom: 2,
                      right: 0,
                      child: Visibility(
                        visible:
                            state.messageListData.xList[realIndex].noReadNum > 0
                                ? true
                                : false,
                        child: ClipOval(
                          child: Container(
                            width: 21.w,
                            height: 21.w,
                            alignment: Alignment.center,
                            child: Text(
                              state.messageListData.xList[realIndex].noReadNum
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10.nsp),
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(247, 131, 97, 1),
                                    Color.fromRGBO(245, 75, 100, 1),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
              SizedBox(width: 22.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        state.messageListData.xList[realIndex].userName,
                        style: TextStyle(
                            fontSize: 18.nsp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      Text(
                        formatTime(
                            state.messageListData.xList[realIndex].createdAt),
                        style: TextStyle(
                            fontSize: 13.nsp,
                            color: Color.fromRGBO(78, 88, 110, 1)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6.w,
                  ),
                  Container(
                    width: 260.w,
                    child: Text(
                      state.messageListData.xList[realIndex].preContent,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 17.nsp, color: Colors.white),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Image.asset(
                "assets/weibo/message_right_arrow.png",
                width: 30.w,
                height: 30.w,
              ),
            ],
          ),
          SizedBox(height: 16.w),
          Container(
            height: 1.w,
            margin: EdgeInsets.only(left: 90.w),
            color: Color.fromRGBO(0, 0, 0, 0.5),
          ),
        ],
      ),
    ),
  );
}

///弹出删除对话框
void showDelDialog(MessageState state, Dispatch dispatch, BuildContext context,
    int realIndex) {
  ///对方用户名
  String userName = state.messageListData?.xList[realIndex].userName ?? "";

  showDialog(
      context: context,
      builder: (contexts) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.all(22.w),
                child: Text("温馨提示",
                    style: TextStyle(
                        fontSize: 22.sp, fontWeight: FontWeight.w600)),
              ),
              Text(userName.isEmpty ? "确认删除此条消息？" : "确认删除 $userName的消息？",
                  style: TextStyle(fontSize: 20.sp)),
              SizedBox(height: 20.w),
              Divider(height: 1.w, color: Colors.grey.withOpacity(0.6)),
              Container(
                height: 50.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      color: Colors.white,
                      highlightElevation: 0,
                      elevation: 0,
                      child: Text("取消", style: TextStyle(fontSize: 18.sp)),
                      onPressed: () => safePopPage(contexts),
                    ),
                    VerticalDivider(
                        width: 1.w, color: Colors.grey.withOpacity(0.6)),
                    RaisedButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      color: Colors.white,
                      highlightElevation: 0,
                      elevation: 0,
                      child: Text(
                        "确定",
                        style: TextStyle(
                            color: AppColors.userPumpkinOrangeColor,
                            fontSize: 18.sp),
                      ),
                      onPressed: () {
                        String sessionId =
                            state.messageListData?.xList[realIndex]?.sessionId;
                        if ((sessionId ?? "").isNotEmpty) {
                          dispatch(MessageActionCreator.delMsgSession(
                              sessionId, realIndex));
                        }

                        safePopPage(contexts);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}

///创建广告列表
Container _buildMessageAdListUI(MessageState state) {
  return Container(
    margin: EdgeInsets.only(
      left: 16.w,
      right: 16.w,
      bottom: 16.w,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AdsBannerWidget(
        state.adsList,
        width: 1.sw,
        height: 126.w,
        onItemClick: (index) {
          var ad = state.adsList[index];
          JRouter().handleAdsInfo(ad.href, id: ad.id);
        },
      ),
    ),
  );
}
