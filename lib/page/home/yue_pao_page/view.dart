import 'package:extended_tabs/extended_tabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/home/yue_pao_page/yue_pao_tab_page/page.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    YuePaoState state, Dispatch dispatch, ViewService viewService) {


  Widget bannerWidget = ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(6)),
    child: AdsBannerWidget(
      state.adsList,
      width: Dimens.pt360,
      //height: Dimens.pt250,
      height: Dimens.pt160,
      onItemClick: (index) {
        var ad = state.adsList[index];
        JRouter().handleAdsInfo(ad.href, id: ad.id);
        /*eagleClick(state.selfId(),
            sourceId: state.eagleId(viewService.context),
            label: "banner(${ad?.id ?? ""})");*/
      },
    ),
  );


  return FullBg(
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.topCenter,
          // image: AssetImage(AssetsImages.IC_YUEPAO_TOP_BG),
          image: AssetImage(AssetsImages.IC_YUEPAO_TOP_BG_2),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          toolbarHeight: Dimens.pt44,
          // titleSpacing: .0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    dispatch(YuePaoActionCreator.onSelectCity());
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: Dimens.pt10),
                    key: state.intro.keys[0],
                    child: Row(
                      children: [
                        svgAssets(AssetsSvg.IC_ADDRESS, height: Dimens.pt15),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: Dimens.pt2),
                            child: Text(
                              '${state.city == '' ? Lang.CITY1 : state.city}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFontSize.fontSize14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    Lang.NAV_YUEPAO,
                    style: TextStyle(
                      fontSize: Dimens.pt20,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      JRouter().go(YUE_PAO_SEARCH_PAGE);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        left: Dimens.pt10,
                        top: Dimens.pt10,
                        bottom: Dimens.pt10,
                      ),
                      color: Colors.transparent,
                      child:
                          svgAssets(AssetsSvg.IC_SEARCH, height: Dimens.pt15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // 个人记录
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Lang.YUE_PAO_MSG,
                    style:
                        TextStyle(fontSize: Dimens.pt10, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      JRouter().go(RECORDING_PAGE);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: Dimens.pt5),
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Text(
                            Lang.RECORD,
                            style: TextStyle(
                                fontSize: Dimens.pt12, color: Colors.white),
                          ),
                          svgAssets(
                            AssetsSvg.IC_LEFT,
                            height: Dimens.pt12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 妹子认证
           /* Container(
              padding: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
              child: GestureDetector(
                onTap: () {
                  *//*eagleClick(state.selfId(),
                      sourceId: state.eagleId(viewService.context),
                      label: "妹子认证");*//*
                  csManager.openServices(viewService.context);
                },
                child: Container(
                  width: double.infinity,
                  height: Dimens.pt92,
                  // margin: EdgeInsets.only(top: Dimens.pt16),
                  padding: EdgeInsets.only(left: Dimens.pt12),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // image: AssetImage(AssetsImages.IC_YUEPAO_AUTH_BG),
                      image: AssetImage(AssetsImages.IC_YUEPAO_AUTH_BG_2),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: Dimens.pt8),
                        margin: EdgeInsets.only(top: Dimens.pt10),
                        child:
                            //  Row(
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //     Container(
                            //       padding: EdgeInsets.only(right: Dimens.pt6),
                            //       child: Text(
                            //         Lang.CERTIFICATION,
                            //         style: TextStyle(
                            //             fontSize: Dimens.pt16,
                            //             color: Colors.white,
                            //             fontWeight: FontWeight.w600),
                            //       ),
                            //     ),
                            //     svgAssets(
                            //       AssetsSvg.IC_LEFT,
                            //       height: Dimens.pt16,
                            //     ),
                            //   ],
                            // ),
                            Text(
                          "千万流量",
                          style: TextStyle(
                              fontSize: Dimens.pt16,
                              color: Color(0xFF654312),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      // Container(
                      //   child: Text(
                      //     Lang.YUE_PAO_MSG1,
                      //     style: TextStyle(
                      //         fontSize: Dimens.pt11,
                      //         color: Colors.white,
                      //         height: 1.8),
                      //   ),
                      // ),
                      Container(
                        child: Text(
                          "让你数钱数到手抽筋",
                          style: TextStyle(
                              fontSize: Dimens.pt11,
                              color: Color(0xFFA87D44),
                              height: 1.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),*/


            //Container(margin: EdgeInsets.only(left: Dimens.pt10,right: Dimens.pt10,top: Dimens.pt3,),child: bannerWidget),

            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: Dimens.pt8),
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      isScrollable: true,
                      controller: state.tabController,
                      tabs: Lang.YUE_PAO_TABS
                          .map(
                            (e) => Text(
                              e,
                              style: TextStyle(fontSize: Dimens.pt16),
                            ),
                          )
                          .toList(),
                      labelColor: Colors.white,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      unselectedLabelColor: Colors.white.withOpacity(0.6),
                      indicator: RoundUnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ExtendedTabBarView(
                controller: state.tabController,
                children: [
                  YuePaoTabPage().buildPage({'pageTitle': 2,}),
                  YuePaoTabPage().buildPage({'pageTitle': 1,}),
                  YuePaoTabPage().buildPage({'pageTitle': 0,}),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
