import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/hj_custom_tabbar.dart';
import 'package:flutter_app/widget/tabbar/CustomTabBar.dart';
import 'package:flutter_base/utils/screen.dart';
import 'history_post_table.dart';
import 'history_video_table.dart';

class HistoryRecordPage extends StatefulWidget {
  const HistoryRecordPage();

  @override
  State<StatefulWidget> createState() {
    return _HistoryRecordPageState();
  }
}

class _HistoryRecordPageState extends State<HistoryRecordPage> with SingleTickerProviderStateMixin {
  TabController tabController;
  final typeTabs = <String>["视频", "帖子",];

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: typeTabs.length,
      vsync: this,
    );
  }

  bool isEdit = false;
  void _editEvent() {
    isEdit = !isEdit;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: getCommonAppBar("历史记录", actions: [
        InkWell(
          onTap: _editEvent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Text(isEdit ? "保存" : "编辑"),
          ),
        ),
      ],),
      body: Column(
        children: [
          Container(
            height: 32,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16),
            margin: EdgeInsets.only(top: 12),
            child: HJCustomTabBar(
              ["视频", "帖子"],
              tabController,
              bgColor: Colors.transparent,
              selectedColor: Color(0xff202020),
            ),
          ),
          Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                child:TabBarView(
                  controller: tabController,
                  children:  [
                    HistoryVideoTable(isEdit: isEdit),
                    HistoryPostTable(isEdit: isEdit),
                  ],
                ),
              ),),
        ],
      ),
    );
  }
}
