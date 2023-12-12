import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/weibo_page/community_recommend/hot_video/hot_long_video_view.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';

import 'hot_short_video_view.dart';

class HotVideoDetailPage extends StatefulWidget {
  final String id;

  HotVideoDetailPage(this.id);

  @override
  State<StatefulWidget> createState() {
    return _HotVideoDetailPageState();
  }
}

class _HotVideoDetailPageState extends State<HotVideoDetailPage> {
  TabController tabController =
      new TabController(length: 2, vsync: ScrollableState(), initialIndex: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "热门作品",
      ),
      body: Column(
        children: [
          SizedBox(height: 4),
          _buildNavMenu(),
          SizedBox(height: 16),
          Expanded(
            child: ExtendedTabBarView(
              controller: tabController,
              cacheExtent: 1,
              children: [
                HotShortVideoView(
                  id: widget.id,
                  type: "SP",
                ),
                HotLongVideoView(
                  id: widget.id,
                  type: "MOVIE",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavMenu() {
    return TabBar(
      isScrollable: true,
      controller: tabController,
      tabs: ["抖音", "影视"]
          .map(
            (e) => Text(
              e,
              style: TextStyle(fontSize: 16),
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
      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      unselectedLabelStyle:
          TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
      labelPadding: EdgeInsets.symmetric(horizontal: 32),
    );
  }
}
