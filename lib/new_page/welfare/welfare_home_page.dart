import 'package:flutter/material.dart';
import 'package:flutter_app/new_page/mine/mine_share_page.dart';
import 'package:flutter_app/new_page/welfare/welfare_view_app_center.dart';
import 'package:flutter_app/new_page/welfare/welfare_view_recommend.dart';
import 'package:flutter_app/new_page/welfare/welfare_view_task.dart';
import 'package:flutter_app/page/game_page/LouFengAdNewPage.dart';
import 'package:flutter_app/page/game_page/LouFengAdPage.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/tabbar/custom_tabbr_indicator.dart';
import 'package:flutter_base/flutter_base.dart';

class WelfareHomePage extends StatefulWidget {

  int index = 1;

  WelfareHomePage(this.index);

  @override
  State<StatefulWidget> createState() {
    return _WelfareHomePageState();
  }
}

class _WelfareHomePageState extends State<WelfareHomePage> with TickerProviderStateMixin {
  List<String> tabs = ["我的收益", "福利任务", "应用推荐"];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex:widget.index,length: 3, vsync: this);
    bus.on(EventBusUtils.flPage1, (arg) {
      _tabController.animateTo(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Container(
        child: Column(
          children: [
            Container(
              color: Colors.black,
              width: screen.screenWidth,
              alignment: Alignment.center,
              child: TabBar(
                isScrollable: true,
                labelStyle: TextStyle(fontSize: 18, color: Color(0xffca452e)),
                unselectedLabelStyle: TextStyle(fontSize: 14, color: Color(0xff999999)),
                indicator: CustomTabBarIndicator(),
                controller: _tabController,
                unselectedLabelColor:Color(0xff999999),
                labelColor: Colors.white,
                tabs: tabs.map((it) => Tab(text: it))?.toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  WelfareViewRecommend(),

                  //MineSharePage(),

                  WelfareViewTask(),

                  LouFengAdNewPage(),

                  //WelfareViewAppCenter(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
