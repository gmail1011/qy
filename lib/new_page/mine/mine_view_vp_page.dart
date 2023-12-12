import 'package:flutter/material.dart';
import 'package:flutter_app/new_page/mine/mine_view_buy_table_view.dart';
import 'package:flutter_app/new_page/mine/mine_view_cache_table_view.dart';
import 'package:flutter_app/new_page/mine/mine_view_collect_table_view.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/hj_custom_tabbar.dart';

///我的收藏：1、我的购买：2、我的下载：3
///view_vp  view-Video-Post（视频、帖子）
class MineViewVPPage extends StatefulWidget {
  final int type;

  MineViewVPPage(this.type);

  @override
  State<StatefulWidget> createState() {
    return _MineViewVPPageState();
  }
}

class _MineViewVPPageState extends State<MineViewVPPage> with TickerProviderStateMixin {
  bool isEdit = false;

  TabController _controller;

  List<Widget> collectTabList = [
    MineViewCollectTableView(1),
    MineViewCollectTableView(2),
  ];

  List<Widget> cacheTabList = [MineViewCacheTableView()];

  List<Widget> buyTabList = [
    MineViewBuyTableView(1),
    MineViewBuyTableView(2),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: widget.type == 3 ? 1 : 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var title = "我的收藏";
    var tabList = collectTabList;

    switch (widget.type) {
      case 1:
        title = "我的收藏";
        tabList = collectTabList;
        break;
      case 2:
        title = "我的购买";
        tabList = buyTabList;
        break;
      case 3:
        title = "我的下载";
        tabList = cacheTabList;
        break;
    }

    return FullBg(
      child: Scaffold(
        backgroundColor: Color(0xff0d0e1e),
        appBar: CustomAppbar(
          title: title,
          actions: [
            Visibility(
                visible: widget.type == 1 || widget.type == 3,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isEdit = !isEdit;
                    });
                    bus.emit(EventBusUtils.changeEditStatus, isEdit);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      isEdit ? "完成" : "编辑",
                      style: const TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 12.0),
                    ),
                  ),
                ))
          ],
        ),
        body: Column(
          children: [
            if (widget.type != 3)
              Container(
                height: 32,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 16),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: HJCustomTabBar(
                  ["视频", "帖子"],
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
