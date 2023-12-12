import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../assets/lang.dart';
import '../../utils/EventBusUtils.dart';
import '../../widget/common_widget/common_widget.dart';
import 'hot_list_dsj_page.dart';
import 'hot_list_hm_page.dart';
import 'hot_list_wm_page.dart';
import 'hot_list_zy_page.dart';

class CommunityHotListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommunityHotListPageState();
  }
}

class _CommunityHotListPageState extends State<CommunityHotListPage> {
  TabController tabController =
      new TabController(length: 5, vsync: ScrollableState());

  @override
  void initState() {
    super.initState();
    bus.on(EventBusUtils.changeHotListTab, (arg) {
      tabController.index = arg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              alignment: Alignment.centerLeft,
              height: 45.w,
              margin: EdgeInsets.symmetric(vertical: 5.w),
              color: Color(0xff1e1e1e),
              child: commonTabBar(
                TabBar(
                  isScrollable: false,
                  controller: tabController,
                  tabs: Lang.COMMUNITY_HOT_LIST_TABS
                      .map(
                        (e) => Text(e),
                      )
                      ?.toList(),
                  labelColor: Color(0xfff68216),
                  labelStyle:
                      TextStyle(fontSize: 18.nsp, fontWeight: FontWeight.w500),
                  unselectedLabelColor: Colors.white,
                  unselectedLabelStyle:
                      TextStyle(fontSize: 17.nsp, fontWeight: FontWeight.w400),
                  indicator: const BoxDecoration(),
                  labelPadding: EdgeInsets.symmetric(horizontal: 0.w),
                ),
              )),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                HotListDSJPage(),
                HotListZYPage(),
                HotListWMPage(0),
                HotListWMPage(1),
                HotListHMPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
