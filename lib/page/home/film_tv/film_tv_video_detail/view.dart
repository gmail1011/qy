import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/new_page/welfare/SpecialWelfareHomePage.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/chewie/chewie_player.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/dialog/alert_tool.dart';
import 'package:flutter_app/widget/dialog/popup_view.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_app/widget/tabbar/CustomTabBar.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/local_server/video_cache_manager.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';

import 'action.dart';
import 'film_video_comment/page.dart';
import 'film_video_introduction/action.dart';
import 'film_video_introduction/page.dart';
import 'state.dart';

///长视频详情
Widget buildView(FilmTvVideoDetailState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: screen.screenWidth,
                height: screen.screenWidth / 1.78,
                margin: EdgeInsets.only(top: screen.paddingTop),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _createVodeo(state, dispatch, viewService.context),
                    if (state.timer != null)
                      _buildAdsUI(state, dispatch, viewService),
                    if (state.intoBuyVideoPoiont == true)
                      Container(
                        alignment: Alignment.center,
                        width: screen.screenWidth,
                        height: screen.screenWidth / 1.78,
                        color: Color.fromRGBO(0, 7, 18, 0.8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 57,
                            ),
                            Text(
                              "试看已结束",
                              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 14),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 2),
                                  child: Text(
                                    "${state.viewModel?.videoCoin()}",
                                    style: TextStyle(color: AppColors.primaryTextColor, fontSize: 14),
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "金币解锁完整版，剩余可用金币${GlobalStore.getWallet().amount}",
                                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 14),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 33,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    width: 105,
                                    height: 35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        gradient: AppColors.linearBackGround, borderRadius: BorderRadius.all(Radius.circular(4))),
                                    child: Text(
                                      "立即购买",
                                      style: TextStyle(color: Colors.black, fontSize: 12),
                                    ),
                                  ),
                                  onTap: () {
                                    dispatch(FilmTvVideoDetailActionCreator.hjllBuyCoinVideo());
                                  },
                                ),
                                SizedBox(
                                  width: 58,
                                ),
                                GestureDetector(
                                  child: Container(
                                    width: 105,
                                    height: 35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        gradient: AppColors.linearBackGround, borderRadius: BorderRadius.all(Radius.circular(4))),
                                    child: Text(
                                      "做任务得VIP",
                                      style: TextStyle(color: Colors.black, fontSize: 12),
                                    ),
                                  ),
                                  onTap: () {
                                    //进入任务中心
                                    Navigator.of(viewService.context).push(MaterialPageRoute(builder: (BuildContext context) {
                                      return SpecailWelfareViewTaskPage();
                                    }));
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    if (state.intoBuyVipPoiont == true)
                      Container(
                        alignment: Alignment.center,
                        width: screen.screenWidth,
                        height: screen.screenWidth / 1.78,
                        color: Color.fromRGBO(0, 7, 18, 0.8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 57,
                            ),
                            Text(
                              "试看已结束",
                              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 14),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "开通VIP或做任务获取VIP解锁精彩完整版!",
                                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 14),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 33,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    width: 105,
                                    height: 35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Color.fromRGBO(132, 164, 249, 1),
                                          AppColors.primaryTextColor,
                                        ]),
                                        borderRadius: BorderRadius.all(Radius.circular(4))),
                                    child: Text(
                                      "立即开通VIP",
                                      style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 12),
                                    ),
                                  ),
                                  onTap: () {
                                    dispatch(FilmTvVideoDetailActionCreator.hjllBuyVIP());
                                  },
                                ),
                                SizedBox(
                                  width: 58,
                                ),
                                GestureDetector(
                                  child: Container(
                                    width: 105,
                                    height: 35,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Color.fromRGBO(132, 164, 249, 1),
                                          AppColors.primaryTextColor,
                                        ]),
                                        borderRadius: BorderRadius.all(Radius.circular(4))),
                                    child: Text(
                                      "做任务得VIP",
                                      style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 12),
                                    ),
                                  ),
                                  onTap: () {
                                    //进入任务中心
                                    Navigator.of(viewService.context).push(MaterialPageRoute(builder: (BuildContext context) {
                                      return SpecailWelfareViewTaskPage();
                                    }));
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              state.tabController == null
                  ? Container()
                  : Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 2),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1)))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    commonTabBar(
                      CustomTabBar(
                        isScrollable: true,
                        controller: state.tabController,
                        physics: GlobalStore.isVIP() ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
                        tabs: [
                          Container(
                            margin: EdgeInsets.only(top: 12, bottom: 6),
                            child: Text("简介"),
                            height: 22,
                          ),
                          Container(
                            height: 22,
                            margin: EdgeInsets.only(top: 12, right: 2, bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: [
                                Text("评论 "),
                                Text(
                                  "${getShowCountStr(state.viewModel?.commentCount ?? 0)}",
                                  // style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                        unselectedLabelColor: Color(0xff9c9c9c),
                        unselectedLabelStyle: TextStyle(fontSize: Dimens.pt14),
                        labelColor: Colors.white,
                        labelStyle: TextStyle(fontSize: Dimens.pt14, fontWeight: FontWeight.w500),
                        labelPadding: EdgeInsets.symmetric(horizontal: 12),
                        imagePath: "assets/images/tab_indicator.png",
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    (TextUtil.isEmpty(state.domainInfo?.desc))
                        ? SizedBox()
                        : GestureDetector(
                      child: Container(
                          key: state.rightKey,
                          margin: EdgeInsets.only(top: 2, right: 17),
                          child: Row(
                            children: [
                              Text(
                                "${state.domainInfo?.desc}",
                                style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1), fontSize: 12),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Image.asset(
                                  "assets/images/line_switch.png",
                                  width: 12,
                                  height: 12,
                                ),
                              )
                            ],
                          ) // 下拉按钮的文字
                      ),
                      onTap: () {
                        AlertTool.showPopMenu(
                          viewService.context,
                          noTriangle: true,
                          originKey: state.rightKey,
                          itemHeight: 30,
                          itemWidth: 80,
                          type: PopWindowType.bottomRight,
                          itemTitleColor: Colors.white,
                          dividerColor: Colors.white.withOpacity(0.1),
                          backgroundColor: Color.fromRGBO(34, 34, 34, 1),
                          itemsData: state.listPopModel,
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(46, 46, 46, 1),
                              Color.fromRGBO(46, 46, 46, 1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          clickCallback: (index, model) async {
                            Address.cdnAddress = Address.cdnAddressLists[index].url;
                            Address.currentDomainInfo = Address.cdnAddressLists[index];
                            state.domainInfo = Address.cdnAddressLists[index];
                            CacheServer().addReqFilter(LOCAL_TS_FILTER, Address.cdnAddress);
                            await VideoCacheManager().emptyCache();
                            CacheServer().setSelectLine(Address.cdnAddress);
                            dispatch(FilmTvVideoDetailActionCreator.updateUI());
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 6),
              state.tabController == null
                  ? Container()
                  : Flexible(
                child: Container(
                  child: TabBarView(
                    physics: GlobalStore.isVIP() ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
                    controller: state.tabController,
                    children: [
                      state.viewModel ==null ? Center(child: LoadingWidget(color: Colors.transparent),) : FilmVideoIntroductionPage().buildPage({"viewModel": state.viewModel}),
                      FilmVideoCommentPage().buildPage({"videoId": state.videoId}),
                    ],
                    dragStartBehavior: DragStartBehavior.down,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            child: GestureDetector(
              child: Container(
                width: 55,
                height: 55,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      AppColors.primaryTextColor,
                      AppColors.primaryTextColor,
                    ]),
                    borderRadius: BorderRadius.all(Radius.circular(28))),
                child: Text(
                  "返回",
                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 16),
                ),
              ),
              onTap: () {
                if (state.chewieController != null) {
                  state.chewieController.pause();
                }
                if (state.videoPlayerController != null) {
                  state.videoPlayerController.pause();
                }
                safePopPage();
              },
            ),
            right: 10,
            bottom: 55,
          )
        ],
      ));
}

///视频显示区域
Widget _createVodeo(FilmTvVideoDetailState state, Dispatch dispatch, BuildContext context) {
  return Stack(
    alignment: Alignment.center,
    children: [
      (state.videoInited == false || state.chewieController == null)
          ? Container(
        width: screen.screenWidth,
        height: screen.screenWidth / 1.78,
        color: AppColors.videoBackgroundColor,
        child: Stack(

          alignment: AlignmentDirectional.center,

          children: [

            CustomNetworkImage(
              imageUrl: state.viewModel?.cover ?? "",
              fit: BoxFit.cover,
              width: screen.screenWidth,
              height: screen.screenWidth / 1.78,
            ),

            LoadingWidget(color: Colors.transparent),

          ],
        ),
      )
          : Container(
        width: screen.screenWidth,
        height: screen.screenWidth / 1.78,
        alignment: Alignment.bottomCenter,
        color: Colors.black,
        child: Chewie(controller: state.chewieController),
      ),
      Positioned(
        top: 16,
        right: 16,
        child: (state.videoInited == false && (state.videoStatus == 0 || state.videoStatus == 4 || state.videoStatus == 5))
            ? Container()
            : _buildVideoStatus(
          context,
          dispatch,
          state.videoStatus,
          state.vStatusName,
        ),
      ),
    ],
  );
}

///显示视频状态
GestureDetector _buildVideoStatus(BuildContext context, Dispatch dispatch, int videoStatus, String vStausName) {
  return GestureDetector(
    onTap: () {
      dispatch(FilmTvVideoDetailActionCreator.updateVideoStatus(videoStatus));
    },
    child: Container(
      padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
      decoration: BoxDecoration(color: Color.fromRGBO(0, 214, 190, 0.9), borderRadius: BorderRadius.circular(20)),
      child: Text(
        vStausName ?? "",
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    ),

    // child: ((videoStatus==0 || videoStatus==4 || videoStatus==5) && (vStausName!="") && (vStausName!=null))?Container(
    //   padding: const EdgeInsets.fromLTRB(26, 0, 10, 0),
    //   alignment: Alignment.center,
    //   height: 34,
    //   decoration: BoxDecoration(
    //     // color:
    //     //     videoStatus == -1 ? Colors.transparent : Colors.red.withAlpha(130),
    //       color: Color.fromRGBO(0, 214, 190, 0.5),
    //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),topLeft:Radius.circular(20), )
    //   ),
    //   child: Text(
    //     vStausName ?? "",
    //     style: TextStyle(color: Colors.white, fontSize: 12),
    //   ),
    // ):SizedBox(),
  );
}

///创建广告UI
Widget _buildAdsUI(FilmTvVideoDetailState state, Dispatch dispatch, ViewService viewService) {
  return Container(
      margin: EdgeInsets.only(top: screen.paddingTop),
      padding: EdgeInsets.fromLTRB(60, 40, 60, 24),
      width: screen.screenWidth,
      height: screen.screenWidth / 1.78,
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: 720 / 350,
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              child: GestureDetector(
                onTap: () async {
                  viewService.broadcast(FilmVideoIntroductionActionCreator.stopVideoPlay(state.viewModel?.id));

                  var ad = state.adsList[state.adsIndex];
                  var result = await JRouter().handleAdsInfo(ad.href, id: ad.id);
                  l.e("_buildAdsUI", "$result");
                  viewService.broadcast(FilmVideoIntroductionActionCreator.notifyReStartPlayVideo(state.viewModel?.id));
                },
                child: CustomNetworkImage(
                  imageUrl: state.adsList[state.adsIndex].cover,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  dispatch(FilmTvVideoDetailActionCreator.closeAd());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5), borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: (state.countdownTime <= 0)
                      ? Row(
                    children: [
                      Text(
                        '关闭',
                        style: TextStyle(
                          color: Color(0xffff7f0f),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                      : Row(
                    children: [
                      Text(
                        ' ${state.countdownTime}秒后',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        state.isCanClose ? " 关闭" : '关闭',
                        style: TextStyle(
                          color: state.isCanClose ? Color(0xffff7f0f) : Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      if (GlobalStore.isVIP() == false && state.isCanClose == false)
                        Text(
                          ' VIP跳过广告',
                          style: TextStyle(
                            color: Color(0xffff7f0f),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(
            //   top: MediaQuery.of(viewService.context).padding.top,
            //   left: 0,
            //   child: Container(
            //     height: 40,
            //     alignment: Alignment.topLeft,
            //     margin: EdgeInsets.only(left: 8, top: 8),
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: Colors.black.withOpacity(0.05),
            //         borderRadius: BorderRadius.circular(32),
            //       ),
            //       child: IconButton(
            //         icon: Icon(
            //           Icons.arrow_back,
            //           color: Colors.white,
            //         ),
            //         onPressed: () {
            //           safePopPage();
            //         },
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ));
}
