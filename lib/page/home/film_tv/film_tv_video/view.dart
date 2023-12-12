import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/countdown_update_model.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/new_page/recharge/recharge_vip_page.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/tv_item_table_view.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/video_cell_widget.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/home/post/MySliverDelegate.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/tag/liaoba_tag_detail/page.dart';
import 'package:flutter_app/page/user/member_centre_page/vip/vip_countdown_widget.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/YYMarquee.dart';
import 'package:flutter_app/widget/common_widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/empty_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'action.dart';
import 'state.dart';
import 'package:get/route_manager.dart' as Gets;


int indexs = 1;
///影视长视频列表
Widget buildView(FilmTelevisionVideoState state, Dispatch dispatch, ViewService viewService) {
  var width = (screen.screenWidth - 10 * 2 - 7) / 2;
  var height = ((screen.screenWidth - 10 * 2 - 7) / 2) * (182 / 201);

  var imageWidth = (screen.screenWidth - 10 * 2 - 7) / 2;
  var imageHeight = ((screen.screenWidth - 10 * 2 - 7) / 2) * (113 / 201);

  return Scaffold(
    body: BaseRequestView(
      retryOnTap: () => dispatch(FilmTelevisionVideoActionCreator.loadData(state.moduleSort)),
      controller: state.baseRequestController,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverStickyHeader(
                sticky: false,
                header: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Offstage(
                        offstage: state.bannerAdsList?.length == 0 ? true : false,
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 15,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: AdsBannerWidget(
                              state.bannerAdsList,
                              width: screen.screenWidth - 10 * 2,
                              height: (screen.screenWidth - 10 * 2) * (169 / 408),
                              onItemClick: (index) {
                                var ad = state.bannerAdsList[index];
                                JRouter().handleAdsInfo(ad.href, id: ad.id);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 8.0,
                              childAspectRatio: 96 / 36,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  ///进入标签页
                                  Map<String, dynamic> maps = Map();
                                  maps['tagId'] = state.allSection[index].sectionID;
                                  maps['title'] = state.allSection[index].sectionName;
                                  Gets.Get.to(() => LiaoBaTagDetailPage().buildPage(maps), opaque: false);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/home_tag_bg.png"),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  width: (screen.screenWidth - 10 * 2 - 8 * 3) / 4,
                                  height: ((screen.screenWidth - 10 * 2 - 8 * 3) / 4) * (36 / 96),
                                  child: Text(
                                    "${state.allSection[index].sectionName}",
                                    style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            },
                            itemCount: state.allSection == null ? 0 : (state.allSection?.length ?? 0)),
                      ),
                    ],
                  ),
                )),
          ];
        },


        body: pullYsRefresh(

          refreshController: state.refreshController,
          onLoading: () {
            dispatch(FilmTelevisionVideoActionCreator.loadMoreData(indexs));
          },
          onRefresh: () {
            dispatch(FilmTelevisionVideoActionCreator.loadData(indexs));
          },

          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: MySliverDelegate(
                  maxHeight: 40.w,
                  minHeight: 40.w,
                 child: StatefulBuilder(
                   builder: (contexts, setStates) {



                     return Container(
                       width: screen.screenWidth,
                       height: 40.w,
                       color: AppColors.primaryColor,
                       alignment: Alignment.center,
                       child: ListView.builder(
                         scrollDirection: Axis.horizontal,
                         itemCount: Config.homeVideType.length,
                         shrinkWrap: true,
                         physics: NeverScrollableScrollPhysics(),
                         itemBuilder: (context, index) {
                           return Container(
                               margin: EdgeInsets.fromLTRB(4, 6, 16, 0),
                               child: GestureDetector(
                                 onTap: () {

                                   state.moduleSort = index + 1;

                                   indexs = index + 1;

                                   state.loadingWidget.show(FlutterBase.appContext);

                                   dispatch(FilmTelevisionVideoActionCreator.loadData(state.moduleSort));
                                   dispatch(FilmTelevisionVideoActionCreator.updateUI());


                                   setStates(() {

                                   });


                                 },
                                 child: Text(
                                   Config.homeVideType[index],
                                   style: (index + 1 == indexs)
                                       ? TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)
                                       : TextStyle(color: Color(0xff999999), fontSize: 14),
                                 ),
                               ));
                         },
                       ),
                     );
                   },
                 ),
                ),
              ),
               SliverPadding(
                padding: EdgeInsets.only(left: 10, right: 10),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 7.0,
                    childAspectRatio: 201 / 182,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          LiaoBaTagsDetailDataVideos videoItem = state.videList[index];
                          return GestureDetector(
                            onTap: () {
                              if (videoItem.isRandomAd) {
                                var ad = videoItem.randomAdsInfo;
                                JRouter().handleAdsInfo(ad.href, id: ad.id);
                              } else {
                                Map<String, dynamic> maps = Map();
                                maps["videoId"] = state.videList[index]?.id;
                                maps['sectionID'] = state.sectionID;
                                Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps), opaque: false);
                              }
                            },
                            child: Container(
                              child: SizedBox(
                                width: width,
                                height: height,
                                child: videoItem.isRandomAd
                                    ? _buildAdImageItem(videoItem, width, height, imageWidth, imageHeight)
                                    : VideoCellWidget(
                                  isShowVip: false,
                                  videoInfo2: state.videList[index],
                                  textLine: 2,
                                  imageWidth: imageWidth,
                                  imageHeight: imageHeight,
                                ),
                              ),
                            ),
                          );
                    },
                    childCount: state.videList == null ? 0 : (state.videList?.length ?? 0),
                  ),
                ),
              ),

            ],

          ),
        ),


       /* body: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                alignment: Alignment.center,
                height: 24,
                width: screen.screenWidth,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Config.homeVideType.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      child: Container(
                          margin: EdgeInsets.fromLTRB(4, 6, 8, 0),
                          child: GestureDetector(
                            onTap: () {
                              state.moduleSort = (index += 1);
                              dispatch(FilmTelevisionVideoActionCreator.loadData());
                              dispatch(FilmTelevisionVideoActionCreator.updateUI());
                            },
                            child: Text(
                              Config.homeVideType[index],
                              style: (index + 1 == state.moduleSort)
                                  ? TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)
                                  : TextStyle(color: Color(0xff999999), fontSize: 14),
                            ),
                          )),
                    );
                  },
                ),
              ),
              Expanded(
                  child: (state.videList == null || state.videList.length == 0)
                      ? EmptyWidget("mine", 3)
                      : pullYsRefresh(
                          refreshController: state.refreshController,
                          onLoading: () {
                            dispatch(FilmTelevisionVideoActionCreator.loadMoreData());
                          },
                          onRefresh: () {
                            dispatch(FilmTelevisionVideoActionCreator.loadData());
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 7.0,
                                  childAspectRatio: 201 / 182,
                                ),
                                itemBuilder: (context, index) {
                                  LiaoBaTagsDetailDataVideos videoItem = state.videList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      if (videoItem.isRandomAd) {
                                        var ad = videoItem.randomAdsInfo;
                                        JRouter().handleAdsInfo(ad.href, id: ad.id);
                                      } else {
                                        Map<String, dynamic> maps = Map();
                                        maps["videoId"] = state.videList[index]?.id;
                                        maps['sectionID'] = state.sectionID;
                                        Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps), opaque: false);
                                      }
                                    },
                                    child: Container(
                                      child: SizedBox(
                                        width: width,
                                        height: height,
                                        child: videoItem.isRandomAd
                                            ? _buildAdImageItem(videoItem, width, height, imageWidth, imageHeight)
                                            : VideoCellWidget(
                                                isShowVip: false,
                                                videoInfo2: state.videList[index],
                                                textLine: 2,
                                                imageWidth: imageWidth,
                                                imageHeight: imageHeight,
                                              ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: state.videList == null ? 0 : (state.videList?.length ?? 0)),
                          ),
                        ))
            ],
          ),
        ),*/

      ),
    ),
  );
}

Widget _buildAdImageItem(LiaoBaTagsDetailDataVideos videoItem, double width, double height, double imageWidth, double imageHeight) {
  return Container(
      width: width,
      height: height,
      child: Column(
        children: [
          Stack(
            children: [
              // CustomNetworkImage(
              //   imageUrl: videoItem.randomAdsInfo.cover,
              //   placeholder: Image(
              //     image: AssetImage(AssetsImages.LOADING_HORIZONTAL_IMAGE),
              //     width: imageWidth,
              //     height: imageHeight,
              //     fit: BoxFit.fill,
              //   ),
              //   height: imageHeight,
              //   fit: BoxFit.cover,
              // ),
              KeepAliveWidget(
                CachedNetworkImage(
                  width: imageWidth,
                  height: imageHeight,
                  placeholder: (context, url) => Container(
                    alignment: Alignment.center,
                    color: Color(0xff151515),
                    child: Image.asset(
                      "assets/weibo/loading_normal.png",
                      width: 53,
                      height: 46,
                    ),
                  ),
                  imageUrl: getImagePath(videoItem.randomAdsInfo.cover, true, false),
                  fit: BoxFit.cover,
                  memCacheHeight: 600,
                  cacheManager: ImageCacheManager(),
                  fadeInCurve: Curves.linear,
                  fadeOutCurve: Curves.linear,
                  fadeInDuration: Duration(milliseconds: 100),
                  fadeOutDuration: Duration(milliseconds: 100),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 34,
                  height: 16,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(255, 235, 58, 1),
                      Color.fromRGBO(255, 235, 58, 1),
                    ]),
                  ),
                  child: Text(
                    "广告",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              videoItem.randomAdsInfo.title,
              style: TextStyle(fontSize: 16.w, color: Colors.white),
              maxLines: 2,
            ),
          ),
        ],
      ));
}

///bannner UI
SliverToBoxAdapter _buildBannerUI(FilmTelevisionVideoState state) => SliverToBoxAdapter(
      child: Offstage(
        offstage: state.bannerAdsList?.length == 0 ? true : false,
        child: Container(
          margin: EdgeInsets.only(
            top: 20,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: AdsBannerWidget(
              state.bannerAdsList,
              width: screen.screenWidth - 10 * 2,
              height: (screen.screenWidth - 10 * 2) * (169 / 408),
              onItemClick: (index) {
                var ad = state.bannerAdsList[index];
                JRouter().handleAdsInfo(ad.href, id: ad.id);
              },
            ),
          ),
        ),
      ),
    );

///公告UI
SliverToBoxAdapter _buildNotification(FilmTelevisionVideoState state) {
  return SliverToBoxAdapter(
    child: Offstage(
      offstage: (state.announcementContent ?? "").isEmpty,
      child: Container(
        color: AppColors.userMakeBgColor,
        margin: EdgeInsets.only(top: 16.w),
        padding: EdgeInsets.only(
          top: 8.w,
          left: 19.w,
          bottom: 8.w,
          right: 16.w,
        ),
        height: 33.w,
        child: Row(
          children: [
            Image(
              image: const AssetImage(AssetsImages.IC_LONG_VIDEO_RING),
              width: 13.w,
              height: 16.w,
            ),
            const SizedBox(width: 12),
            (state.announcementContent ?? "").isEmpty
                ? Container()
                : Expanded(
                    child: YYMarquee(
                        Text(state.announcementContent ?? "",
                            style: TextStyle(
                              fontSize: 14.w,
                              color: Colors.white,
                            )),
                        200,
                        const Duration(seconds: 5),
                        230.0,
                        keyName: "film_tv_video"),
                  ),
          ],
        ),
      ),
    ),
  );
}

///用户VIP UI
SliverToBoxAdapter _buildUserVipUI(FilmTelevisionVideoState state, Dispatch dispatch) => SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Dimens.pt12, horizontal: Dimens.pt16),
        padding: EdgeInsets.symmetric(
          vertical: Dimens.pt16,
          horizontal: Dimens.pt13,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          image: DecorationImage(image: AssetImage(AssetsImages.BG_USER_VIP_FV), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 2),
                HeaderWidget(
                  headPath: (GlobalStore.getMe()?.portrait) ?? "",
                  level: 0,
                  headWidth: Dimens.pt50,
                  headHeight: Dimens.pt50,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: Dimens.pt7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GlobalStore.getMe()?.name ?? "",
                          style: TextStyle(fontSize: Dimens.pt15, color: Colors.white),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _getVipText(),
                          style: TextStyle(
                              fontSize: Dimens.pt13,
                              color: GlobalStore.isVIP() ? Color(0xfff5bc78) : Colors.white,
                              fontWeight: FontWeight.w300),
                        ),

                        /*VisibilityDetector(
                          key: Key("${state.videoName ?? ""}"),
                          onVisibilityChanged: (visibleInfo) {
                            if (visibleInfo.visibleFraction == 1) {
                              dispatch(FilmTelevisionVideoActionCreator.updateUI());
                            }
                          },
                          child: Text(
                            _getVipText(),
                            style: TextStyle(
                                fontSize: Dimens.pt13,
                                color: GlobalStore.isVIP()
                                    ? Color(0xfff5bc78)
                                    : Colors.white,
                                fontWeight: FontWeight.w300),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Config.payFromType = PayFormType.user;
                    Gets.Get.to(() =>RechargeVipPage(""),opaque: false);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xfff5b771), Color(0xfff7d599)])),
                    child: Text(
                      (GlobalStore.isVIP() ?? false) ? "去升级" : "立即开通",
                      style: TextStyle(color: Color(0xff151515), fontSize: Dimens.pt15, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),

            ///倒计时
            Visibility(visible: state.cutDownState ?? false, child: _buildCutDownUI(dispatch)),
          ],
        ),
      ),
    );

///倒计时控件
Container _buildCutDownUI(Dispatch dispatch) => Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 8, right: 8),
      height: Dimens.pt40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Color.fromRGBO(245, 183, 113, 1)),
      ),
      child: Consumer<CountdwonUpdate>(
        builder: (context, value, Widget child) {
          Countdown countdown = value.countdown;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${(countdown?.copywriting ?? "").isNotEmpty ? countdown?.copywriting : "新人限时"}",
                style: TextStyle(
                  color: Color.fromRGBO(245, 183, 113, 1),
                  fontSize: Dimens.pt15,
                ),
              ),
              SizedBox(width: Dimens.pt8),
              VIPCountDownWidget(
                fontSize: Dimens.pt15,
                color: Color.fromRGBO(245, 183, 113, 1),
                seconds: countdown.countdownSec ?? 0,
                countdownEnd: () => FilmTelevisionVideoActionCreator.checkVipCutDownState(false),
                countdownChange: (_seconds) {
                  countdown.countdownSec = _seconds;
                  Provider.of<CountdwonUpdate>(context, listen: false).setCountdown(countdown);
                },
              ),
            ],
          );
        },
      ),
    );

///用户VIP 特权 UI
SliverToBoxAdapter _buildUserVipPrivilegeUI() => SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: Dimens.pt16),
        alignment: Alignment.centerLeft,
        child: Image(
          image: AssetImage(AssetsImages.BG_USER_VIP_PRIVILEGE_FV),
          height: Dimens.pt14,
        ),
      ),
    );

///VIP特权列表
SliverToBoxAdapter _buildUserVipPrivilegeListUI(FilmTelevisionVideoState state) => SliverToBoxAdapter(
        child: Container(
      height: Dimens.pt60,
      margin: EdgeInsets.only(top: Dimens.pt8, bottom: Dimens.pt8),
      child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: Dimens.pt6, right: Dimens.pt6),
          scrollDirection: Axis.horizontal,
          children: (state.productBenefits?.length ?? 0) == 0
              ? []
              : state.productBenefits?.map((e) => _buildUserVipPrivilegeListItemUI(e))?.toList()),
    ));

///VIP特权列表item
Container _buildUserVipPrivilegeListItemUI(ProductBenefits item) => Container(
      margin: EdgeInsets.only(left: Dimens.pt8, right: Dimens.pt8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomNetworkImage(
            imageUrl: item.img ?? "",
            width: Dimens.pt34,
            height: Dimens.pt34,
          ),
          SizedBox(height: Dimens.pt5),
          Text(
            item.privilegeName ?? "",
            style: TextStyle(
              color: Color(0xff686869),
              fontSize: Dimens.pt13,
            ),
          ),
        ],
      ),
    );

///获取VIP 文本
String _getVipText() {
  if (GlobalStore.isVIP()) {
    String vipExpireTime = _getVipStringFromTime(GlobalStore.getMe()?.vipExpireDate, netManager.getFixedCurTime());
    return (GlobalStore.getMe()?.vipLevel == 2 ? "超级会员 $vipExpireTime" : "普通会员 $vipExpireTime");
  }
  return "当前未开通VIP";
}

///刷新VIP时间
String _getVipStringFromTime(String time, DateTime nowTime) {
  nowTime = nowTime ?? DateTime.now();
  String result = DateTimeUtil.calTime(DateTimeUtil.utc2iso(time), nowTime);
  String vipTime;
  List<String> timeList = result.split("_");
  if (time.length > 2) {
    if (int.parse(timeList[0]) > 3 ||
        (int.parse(timeList[0]) == 3 && int.parse(timeList[1]) > 0) ||
        (int.parse(timeList[0]) == 3 && int.parse(timeList[1]) == 0) && int.parse(timeList[2]) > 0) {
      //大于3天
      var experidTime = TextUtil.isNotEmpty(time) ? DateTime.parse(time) : DateTime.now();
      if (experidTime.year - nowTime.year > 10) {
        vipTime = Lang.VIP_FOREVER;
      } else {
        vipTime = DateTimeUtil.utcTurnYear2(time);
      }
    } else if (int.parse(timeList[0]) >= 1) {
      //大于等于1天，小于等于3天
      vipTime = timeList[0] + Lang.DAY;
    } else if (int.parse(timeList[1]) >= 1) {
      //一小时以上
      vipTime = timeList[1] + Lang.HOURS;
    } else {
      vipTime = Lang.VIP_ONE_TIME;
    }
  }
  return vipTime;
}
