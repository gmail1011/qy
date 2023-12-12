import 'package:extended_tabs/extended_tabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/page/user/video_user_center/action.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:provider/provider.dart';
import 'state.dart';

Widget buildView(
    VideoUserCenterState state, Dispatch dispatch, ViewService viewService) {
  /// 获取tab 标题
  List<Widget> _getTabWidget() {
    return state.tabTitle.map((it) => Tab(text: it)).toList();
  }

  ///如果没有性别的话 默认女性
  Widget _getUserGenderAndAge() {
    //gender
    var age = state.userInfoModel?.age ?? 0;
    var w = Dimens.pt15;
    if (age >= 18) {
      w = Dimens.pt35;
    }
    Widget genderWidget = svgAssets(AssetsSvg.USER_IC_USER_GENDER_FAMALE,
        width: Dimens.pt12, height: Dimens.pt12);
    Widget genderWidgetBg = svgAssets(AssetsSvg.USER_IC_USER_GENDER_BG,
        width: w, height: Dimens.pt15, fit: BoxFit.fill);
    if (state?.userInfoModel != null) {
      if (state.userInfoModel.gender == 'male') {
        genderWidget = svgAssets(AssetsSvg.USER_IC_USER_GENDER_MALE,
            width: Dimens.pt12, height: Dimens.pt12);
        genderWidgetBg = svgAssets(AssetsSvg.USER_IC_USER_GENDER_BG1,
            width: w, height: Dimens.pt15, fit: BoxFit.fill);
      }
    }

    return Container(
      // width: w,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(Dimens.pt7)),
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
                      '$age',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }

  Widget _getUserInfoSign1() {
    var signList = <Widget>[];

    var address = Lang.UN_KNOWN;
    var id = "0";
    if (state?.userInfoModel != null) {
      if (state.userInfoModel.city.length != 0) {
        address = state.userInfoModel.city;
      }
      id = "${state.userInfoModel.uid ?? 0}";
    }
    //address
    signList.add(Container(
      //  width: Dimens.pt50,
      height: Dimens.pt16,
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: Dimens.pt2, top: Dimens.pt2),
            child: svgAssets(AssetsSvg.USER_IC_USER_ID),
          ),
          Padding(
            padding: EdgeInsets.only(left: Dimens.pt2),
            child: Text(
              id,
              style: TextStyle(fontSize: Dimens.pt10, color: Color(0xFF848699)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: Dimens.pt10, top: Dimens.pt2),
            child: svgAssets(AssetsSvg.USER_IC_USER_ADDRESS),
          ),
          Padding(
            padding: EdgeInsets.only(left: Dimens.pt2),
            child: Text(
              address,
              style: TextStyle(fontSize: Dimens.pt10, color: Color(0xFF848699)),
            ),
          )
        ],
      ),
    ));

    //activity
    var wap = Wrap(
      spacing: Dimens.pt1,
      runSpacing: Dimens.pt5,
      alignment: WrapAlignment.start,
      children: signList,
    );
    return Container(
      alignment: Alignment.centerLeft,
      child: wap,
    );
  }

  Widget _getUserInfoSign2() {
    var signList = <Widget>[];
    if (state?.userInfoModel != null) {
      // big v
      if (state.userInfoModel?.superUser??false) {
        signList.add(Container(
          margin: EdgeInsets.only(right: Dimens.pt2),
          child: svgAssets(AssetsSvg.USER_USER_ICON_V, height: Dimens.pt18),
        ));
      }

      signList.add(getVipLevelWidget(state.userInfoModel?.isVip ?? false,
          state.userInfoModel?.vipLevel ?? 0));
      //certification
      if (state.userInfoModel?.officialCert ?? false) {
        signList.add(Container(
          margin: EdgeInsets.only(left: Dimens.pt2),
          child: svgAssets(AssetsSvg.USER_USER_ICON_ZHENG, height: Dimens.pt18),
        ));
      }
      //activeValue
    }
    if (signList.length == 0) {
      signList.add(
        Container(
          height: Dimens.pt20,
        ),
      );
    }
    // var wap = Wrap(
    //   spacing: Dimens.pt1,
    //   runSpacing: Dimens.pt5,
    //   alignment: WrapAlignment.start,
    //   children: signList,
    // );
    return Container(
      // width: Dimens.pt60,
      // color: Colors.red,
      constraints: BoxConstraints(
        minWidth: Dimens.pt60,
      ),
      alignment: Alignment.center,
      child: Row(
        children: signList,
      ),
    );
  }

  Widget _getUcView() {
    return Stack(
      children: <Widget>[
        extended.NestedScrollView(
          pinnedHeaderSliverHeightBuilder: () {
            return Dimens.pt44 + screen.paddingTop;
          },
          innerScrollPositionKeyBuilder: () {
            var index = "Tab" + state.tabController.index.toString();
            return Key(index);
          },
          controller: state.scrollController,
          headerSliverBuilder: (context, bool) {
            // 刘海屏 top 为 44 ，其他设备为20
            var topNum = MediaQuery.of(context).padding.top;
            return [
              SliverAppBar(
                  title: Container(),
                  leading: IconButton(
                    icon: svgAssets(AssetsSvg.USER_IC_USER_BTN_BACK,
                        width: Dimens.pt30, height: Dimens.pt32),
                    onPressed: () {
                      dispatch(VideoUserCenterActionCreator.onBack());
                    },
                  ),
                  expandedHeight: Dimens.pt390 -
                      Dimens.pt130 +
                      (topNum == 44 ? 0 : 24) +
                      190.w,
                  floating: true,
                  pinned: true,
                  snap: false,
                  automaticallyImplyLeading: false,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin, //视差效果
                    background: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 188.w,
                            width: screen.screenWidth,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/game_er_ba_gang.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          //头部
                          Stack(
                            children: <Widget>[
                              Container(
                                height: Dimens.pt100,
                                width: screen.screenWidth,
                              ),
                              Positioned(
                                left: Dimens.pt15,
                                //top: Dimens.pt100,
                                child: GestureDetector(
                                  child: HeaderWidget(
                                    headPath: state.userInfoModel == null
                                        ? GlobalStore.getMe().portrait
                                        : state.userInfoModel.portrait,
                                    level: state.userInfoModel?.isVip ?? false
                                        ? state.userInfoModel.vipLevel
                                        : 0,
                                    headWidth: Dimens.pt60,
                                    headHeight: Dimens.pt60,
                                  ),
                                  onTap: () {
                                    if (state?.userInfoModel?.portrait !=
                                        null) {
                                      showPictureSwipe(context,
                                          [state.userInfoModel.portrait], 0);
                                    }
                                  },
                                ),
                              ),
                              Positioned(
                                right: Dimens.pt10,
                                //top: Dimens.pt100,
                                width: Dimens.pt260,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    top: Dimens.pt11),
                                                constraints: BoxConstraints(
                                                    maxWidth: Dimens.pt100),
                                                height: Dimens.pt25,
                                                child: Text(
                                                  state.userInfoModel == null
                                                      ? Lang.UN_KNOWN
                                                      : getNameMaxLength(state
                                                          .userInfoModel.name),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: Dimens.pt12,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: Dimens.pt5,
                                                    left: Dimens.pt6),
                                                child: _getUserGenderAndAge(),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: Dimens.pt2),
                                            child: _getUserInfoSign1(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        dispatch(VideoUserCenterActionCreator
                                            .onFollow(!state.isFollowed));
                                      },
                                      child: Container(
                                        height: Dimens.pt20,
                                        width: Dimens.pt80,
                                        alignment: Alignment.center,
                                        margin:
                                            EdgeInsets.only(top: Dimens.pt11),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: state.isFollowed ?? false
                                                ? [
                                                    Color.fromRGBO(
                                                        151, 151, 151, 1),
                                                    Color.fromRGBO(
                                                        151, 151, 151, 1)
                                                  ]
                                                : [
                                                    Color.fromRGBO(
                                                        255, 0, 169, 1),
                                                    Color.fromRGBO(
                                                        242, 3, 255, 1)
                                                  ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                              Dimens.pt10),
                                        ),
                                        child: Text(
                                          state.isFollowed ?? false
                                              ? Lang.NO_MINE_FOLLOW
                                              : Lang.MINE_FOLLOW,
                                          style: TextStyle(
                                            fontSize: Dimens.pt12,
                                            color: state.isFollowed ?? false
                                                ? Colors.white70
                                                : Colors.white,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: Dimens.pt15,
                                bottom: Dimens.pt3,
                                child: Padding(
                                  padding: EdgeInsets.only(top: Dimens.pt5),
                                  child: _getUserInfoSign2(),
                                ),
                              )
                            ],
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: Dimens.pt34,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: Dimens.pt18),
                                  child: Text(
                                    state?.userInfoModel == null
                                        ? Lang.WRITE_TO_SOMETHINGS
                                        : state.userInfoModel.summary.length ==
                                                0
                                            ? Lang.WRITE_TO_SOMETHINGS
                                            : state.userInfoModel.summary,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: Dimens.pt12,
                                        color: Colors.white),
                                  ),
                                ),
                                Container(
                                  margin: CustomEdgeInsets.only(
                                      left: Dimens.pt18, top: Dimens.pt8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                          state.userInfoModel == null
                                              ? "0"
                                              : getShowCountStr(
                                                  state.userInfoModel.like),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Dimens.pt12)),
                                      Text(Lang.PRAISE,
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: Dimens.pt12)),
                                      Text(
                                          state.userInfoModel == null
                                              ? "0"
                                              : getShowCountStr(
                                                  state.userInfoModel.follow),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Dimens.pt12)),
                                      Text(Lang.ATTENTION,
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: Dimens.pt12)),
                                      Text(
                                          state.userInfoModel == null
                                              ? "0"
                                              : getShowCountStr(
                                                  state.userInfoModel.fans),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Dimens.pt12)),
                                      Text(Lang.FAN,
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: Dimens.pt12)),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: getShowCountStr(
                                                  double.parse(state
                                                              .userInfoModel
                                                              ?.rewarded ??
                                                          '0')
                                                      .toInt()),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Dimens.pt12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            TextSpan(
                                              text: Lang.REWARD,
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: Dimens.pt12,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: Dimens.pt10,
                                  ),
                                  child: Divider(
                                    height: 2,
                                    color: Color.fromRGBO(255, 255, 255, 0.1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  bottom: PreferredSize(
                      child: Stack(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              TabBar(
                                  tabs: _getTabWidget(),
                                  isScrollable: true,
                                  indicatorColor: Colors.white,
                                  indicatorWeight: 3.0,
                                  labelStyle: TextStyle(
                                      color: Color(0xffffffff),
                                      fontSize: Dimens.pt12),
                                  unselectedLabelStyle: TextStyle(
                                      color: Color(0xffBDBDBD),
                                      fontSize: Dimens.pt14),
                                  indicatorSize: TabBarIndicatorSize.label,
                                  controller: state.tabController,
                                  indicator: RoundUnderlineTabIndicator(
                                    borderSide: BorderSide(
                                      width: 3.5,
                                      color: Colors.white,
                                    ),
                                  )),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  top: Dimens.pt45,
                                ),
                                child: Divider(
                                  height: 2,
                                  color: Color.fromRGBO(255, 255, 255, 0.1),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      preferredSize: Size(360, Dimens.pt48))),
            ];
          },
          body: ExtendedTabBarView(
            controller: state.tabController,
            children: state.pageList,
            linkWithAncestor: true,
          ),
        ),
        //回到顶部
        Visibility(
          visible: state.showToTopBtn,
          child: Positioned(
            right: Dimens.pt16,
            bottom: screen.paddingBottom + Dimens.pt30,
            child: InkResponse(
              splashColor: Colors.transparent,
              child: ImageLoader.withP(ImageType.IMAGE_SVG,
                      address: AssetsSvg.COMMUNITY_COMMUNITY_BACK_TOP,
                      width: Dimens.pt40,
                      height: Dimens.pt40)
                  .load(),
              onTap: () {
                state.scrollController.animateTo(0.0,
                    duration: Duration(milliseconds: 50), curve: Curves.easeIn);
              },
            ),
          ),
        )
      ],
    );
  }

  /// 获取广告位置
  Widget getAdView(String title, List<String> imgUrls, String adUrl) {
    var imgUrl = '';
    if (ArrayUtil.isNotEmpty(imgUrls)) {
      imgUrl = imgUrls.first;
    }
    return Scaffold(
        appBar: getCommonAppBar(
          title,
          onBack: () {
            dispatch(VideoUserCenterActionCreator.onBack());
          },
        ),
        body: Stack(
          children: <Widget>[
            // ImageLoader.withP(ImageType.IMAGE_NETWORK_HTTP,
            //         width: screen.screenWidth,
            //         height: screen.screenHeight,
            //         address: imgUrl)
            //     .load(),
            TextUtil.isNotEmpty(imgUrl)
                ? CustomNetworkImage(
                    imageUrl: imgUrl,
                    width: screen.screenWidth,
                    height: screen.screenHeight,
                    type: ImgType.cover,
                    fit: BoxFit.fitWidth,
                  )
                : Container(
                    width: screen.screenWidth,
                    height: screen.screenHeight,
                    child: Text(Lang.NO_AD_COVER),
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  margin: EdgeInsets.only(bottom: Dimens.pt50),
                  child: getCommonBtn(Lang.DOWNLOAD_NOW, onTap: () {
                    JRouter().handleAdsInfo(adUrl);
                  })),
            ),
          ],
        ));
  }

  return FullBg(
    child: Scaffold(
      body: Consumer<AutoPlayModel>(
        builder: (ctx, model, child) {
          return model.isAd
              ? getAdView(state.videoModel?.title ?? Lang.VIDEO_AD,
                  state.videoModel?.seriesCover, state.videoModel?.linkUrl)
              : _getUcView();
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: Visibility(
      //   // visible: (state.showFollowBtn && state.enableShowFollowBtn),
      //   child: Padding(
      //     padding: EdgeInsets.only(bottom: Dimens.pt20),
      //     child: FloatingActionButton(
      //         backgroundColor:
      //             (state.isFollowed ?? false) ? Colors.grey : Colors.red,
      //         child: Container(
      //           alignment: Alignment.center,
      //           child: Text(
      //             state.isFollowed ?? false ? "取消\n关注" : "关注",
      //             style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
      //           ),
      //         ),
      //         onPressed: () {
      //           dispatch(
      //               VideoUserCenterActionCreator.onFollow(!state.isFollowed));
      //         }),
      //   ),
      // ),
    ),
  );
}
