import 'package:flutter/material.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/hj_custom_tabbar.dart';

import 'mine_follow_table_view.dart';

///我的关注
class MineFollowPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineFollowPageState();
  }
}

class _MineFollowPageState extends State<MineFollowPage>
    with TickerProviderStateMixin {
  TabController _controller;

  List<Widget> tabList = [
    MineFollowTableView(1),
    MineFollowTableView(2),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        appBar: CustomAppbar(title: "我的关注"),
        body: Column(
          children: [
            Container(
              height: 32,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16),
              margin: EdgeInsets.symmetric(vertical: 10),
              child: HJCustomTabBar(
                ["博主", "话题"],
                _controller,
                isSearchStyle: true,
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _controller,
                children: tabList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
