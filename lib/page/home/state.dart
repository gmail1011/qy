import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/app.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/guide/flutter_intro.dart';
import 'package:flutter_app/common/guide/step_widget_builder.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/new_page/mine/mine_home_page.dart';
import 'package:flutter_app/new_page/welfare/welfare_home_page.dart';
import 'package:flutter_app/page/game_page/game_page_page.dart';
import 'package:flutter_app/page/hjll_community/hjll_community_home/page.dart';
import 'package:flutter_app/page/home/post/page.dart';
import 'package:flutter_app/weibo_page/community_page.dart';
import 'package:flutter_app/weibo_page/loufeng/LouFengH5Page.dart';
import 'package:flutter_app/weibo_page/loufeng/page.dart';
import 'package:flutter_base/utils/page_intro_helper.dart';

import 'index/page.dart';

class HomeState with PageIntroHelper implements Cloneable<HomeState> {
  // 导航当前索引值
  int currentIndex = 0;

  final PageController pageController = PageController(initialPage: 0);

  List<Widget> pageList = [];
  DateTime lastPopTime;
  Intro intro = Intro(
      stepCount: 2,
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(
          texts: [Lang.INTRO_HOME_FIND_TIPS, Lang.INTRO_HOME_SHARE_TIPS],
          posMap: {0: 1, 1: 3},
          textBgColor: AppColors.primaryRaised),
      showMask: true);

  @override
  HomeState clone() {
    return HomeState()
      ..currentIndex = currentIndex
      ..pageList = pageList
      ..lastPopTime = lastPopTime
      ..intro = intro;
  }
}

HomeState initState(Map<String, dynamic> args) {
  // var pageList = Config.playGame
  //     ? [
  //         CommunityPage()
  //             .buildPage({"initList": null == args ? [] : args["list"]}),
  //         IndexPage().buildPage(null),
  //         GamePagePage().buildPage(null),
  //         routers.buildPage(FILM_TV_PAGE, null),
  //         routers.buildPage(PAGE_MINE, null),
  //       ]
  //     : [
  //         CommunityPage()
  //             .buildPage({"initList": null == args ? [] : args["list"]}),
  //         IndexPage().buildPage(null),
  //         routers.buildPage(FILM_TV_PAGE, null),
  //         //GamePagePage().buildPage(null),
  //         routers.buildPage(PAGE_MINE, null),
  //       ];

  // if (VariableConfig.louFengH5 != null && VariableConfig.louFengH5 != "") {
  //   pageList.insert(Config.playGame ? 3 : 2, LouFengH5Page());
  // }

  var pageList = [
    routers.buildPage(FILM_TV_PAGE, {"dataType": 0}),
    routers.buildPage(FILM_TV_PAGE, {"dataType": 1}),
    HjllCommunityPage().buildPage(null),
    MineHomePage()
  ];

  return HomeState()
    ..pageList = pageList
    ..currentIndex = 0;
}
