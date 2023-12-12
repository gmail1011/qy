import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_app/page/setting/you_hui_juan/YiShiYongPage.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'YiGuoQiPage.dart';
import 'YiHuoDePage.dart';

class YouHuiJuanPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _YouHuiJuanPageState();
  }

}

class _YouHuiJuanPageState extends State<YouHuiJuanPage> with SingleTickerProviderStateMixin{

  TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = new TabController(length: 3,vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FullBg(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: Dimens.pt32,
            titleSpacing: 0,
            title: UnderLineTabBar(
              tabController: tabController,
              tabs: Lang.YOU_HUi_JUAN_TABS,
              onTab: (index) {
                //dispatch(DiscoveryTabActionCreator.onRefreshUI());
              },
            ),
          ),
          body: Container(
            child: TabBarView(
              controller: tabController,
              children: [
                YiHuoDePage(),
                YiShiYongPage(),
                YiGuoQiPage(),
              ],
            ),
          ),
        ));
  }

}