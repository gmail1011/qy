import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/new_page/recharge/recharge_vip_page.dart';
import 'package:flutter_app/page/home/film_tv/action.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_page.dart';
import 'package:flutter_app/widget/HjllSearchAction.dart';
import 'package:flutter_app/widget/HjllSearchWIdget.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:get/route_manager.dart' as Gets;

import '../../../app.dart';
import 'film_tv_video/page.dart';
import 'state.dart';

///影视-长视频
Widget buildView(FilmTelevisionState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
      child: Stack(
    children: [
      Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            titleSpacing: 0,
            toolbarHeight: Dimens.pt40,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black,
            title: HjllSearchWidget(),
            actions: [HjllSearchButton()],
          ),
          body: Config.homeDataTags == null || Config.homeDataTags.isEmpty ? CErrorWidget("暂无数据") : Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 12),
                child: commonTabBar(
                  TabBar(
                    controller: state.tabController,
                    tabs: state.dataType == 0
                        ? Config.homeDataTags
                            .map(
                              (e) => Container(
                                alignment: Alignment.center,
                                height: Dimens.pt38,
                                child: Text(e.moduleName),
                              ),
                            )
                            .toList()
                        : Config.deepWeb
                            .map(
                              (e) => Container(
                                alignment: Alignment.center,
                                height: Dimens.pt38,
                                child: Text(e.moduleName),
                              ),
                            )
                            .toList(),
                    indicator: RoundUnderlineTabIndicator(
                      borderSide: BorderSide(color: Color(0xffca452e), width: 3),
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    unselectedLabelColor: Color.fromRGBO(153, 153, 153, 1),
                    unselectedLabelStyle: TextStyle(fontSize: Dimens.pt16),
                    labelColor: Color(0xffca452e),
                    isScrollable: true,
                    labelStyle: TextStyle(fontSize: Dimens.pt18),
                    labelPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: state.tabController,
                  children: state.dataType == 0
                      ? Config.homeDataTags
                          .map(
                            (e) => routers
                                .buildPage(FILM_TV_VIDEO_PAGE, {"videoName": e.moduleName, "sectionID": e.id, "dataType": state.dataType}),
                          )
                          .toList()
                      : Config.deepWeb
                          .map(
                            (e) => routers
                                .buildPage(FILM_TV_VIDEO_PAGE, {"videoName": e.moduleName, "sectionID": e.id, "dataType": state.dataType}),
                          )
                          .toList(),
                ),
              )
            ],
          )),
      if (!(GlobalStore.isVIP() && GlobalStore.getMe().vipLevel >= 3) && (state.dataType == 1))
        GestureDetector(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Opacity(
              opacity: 1,
              child: Container(
                width: screen.screenWidth,
                decoration: BoxDecoration(color: Color.fromRGBO(7, 10, 15, 0.5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   "assets/images/warning.png",
                    //   width: 62,
                    //   height: 62,
                    // ),
                    SizedBox(height: 16),
                    Text(
                        "此板块都是暗网禁片真实解密的内容，\n"
                        "只对少量需求用户开放，\n"
                        " 无承受能力者勿入！！",
                        style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 14.0),
                        textAlign: TextAlign.center),
                    SizedBox(
                      height: 24,
                    ),
                    Text("点击开通",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 14,
                        )),
                    (Config.anWangVipCard == null ||
                            Config.anWangVipCard.vipCardList == null ||
                            Config.anWangVipCard.vipCardList.length == 0)
                        ? SizedBox()
                        : Wrap(
                            //  mainAxisAlignment: MainAxisAlignment.center,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: Config.anWangVipCard.vipCardList.map((e) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.of(viewService.context).push(MaterialPageRoute(builder: (BuildContext context) {
                                      return RechargeVipPage(e.id);
                                    }));
                                  },
                                  child: (Config.anWangVipCard.vipCardList.indexOf(e) == (Config.anWangVipCard.vipCardList.length - 1))
                                      ? Text(e.productName,
                                          style: TextStyle(
                                            color: AppColors.primaryTextColor,
                                            fontSize: 14,
                                          ))
                                      : Text(e.productName + "/",
                                          style: TextStyle(
                                            color: AppColors.primaryTextColor,
                                            fontSize: 14,
                                          )));
                            }).toList(),
                          ),
                    Text("解锁进入暗网",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 14,
                        )),
                    SizedBox(
                      height: 24,
                    ),
                    Text("开通者，严禁分享传播！！",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: 14,
                        )),
                  ],
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.of(viewService.context).push(MaterialPageRoute(
              builder: (context) {
                return RechargeVipPage("");
              },
            )).then((value) async {
              await GlobalStore.updateUserInfo(null, true);
              dispatch(FilmTelevisionActionCreator.onRefreshUI());
            });
          },
        ),
    ],
  ));
}
