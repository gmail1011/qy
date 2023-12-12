import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/tag/liaoba_tag_detail/more_video_list_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/hj_custom_tabbar.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MoreVideoPage extends StatefulWidget {
  final String sectionID;
  final String tagName;
  const MoreVideoPage({Key key, this.sectionID,this.tagName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MoreVideoPageState();
  }
}


class _MoreVideoPageState extends State<MoreVideoPage> {

  TabController tabController = new TabController(length: 2, vsync: ScrollableState(), initialIndex: 0);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar(widget.tagName??""),
      body:
      Column(
        children: [
          Container(
            height: 32,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16),
            margin: EdgeInsets.symmetric(vertical: 10),
            child: HJCustomTabBar(
              ["最新", "最热"],
              tabController,
              isSearchStyle: true,
            ),
          ),
          Expanded(child:TabBarView(
            controller: tabController,
            children: [
              MoreVideoListView(type: "new", sectionID: widget.sectionID,),
              MoreVideoListView(type: "hot", sectionID: widget.sectionID,),
            ],
          ),)
        ],
      )

    );
  }

  Widget _buildNavMenu() {
    return TabBar(
      isScrollable: true,
      controller: tabController,
      tabs: Lang.More_Video_TABS
          .map(
            (e) => Text(
          e,
          style: TextStyle(fontSize: 22.nsp),
        ),
      )
          .toList(),
      indicator: RoundUnderlineTabIndicator(
        borderSide: BorderSide(
          color: AppColors.weiboColor,
          width: 3,
        ),
      ),
      indicatorWeight: 4,
      unselectedLabelColor: Color.fromRGBO(115, 122, 139, 1),
      labelColor: Colors.white,
      labelStyle: TextStyle(fontSize: 22.nsp),
      unselectedLabelStyle: TextStyle(fontSize: 22.nsp),
      labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
    );
  }
}