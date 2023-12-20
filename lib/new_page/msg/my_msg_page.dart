import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/new_page/mine/message_page.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/tabbar/CustomTabBar.dart';
import 'package:flutter_base/utils/screen.dart';

import 'msg_comment_table.dart';
import 'msg_table.dart';

class MyMsgPage extends StatefulWidget {
  const MyMsgPage();

  @override
  State<StatefulWidget> createState() => _MyMsgPageState();
}

class MsgTabModel {
  String name;
  bool hasNew;

  MsgTabModel({this.name, this.hasNew});
}

class _MyMsgPageState extends State<MyMsgPage> with TickerProviderStateMixin {
  final tabs = [
    MsgTabModel(
      name: "评论",
      hasNew: false,
    ),
    MsgTabModel(
      name: "点赞",
      hasNew: false,
    ),
  ];

  TabController tabController;
  int selectIndex = 0;

  @override
  void initState() {
    tabController = TabController(length: tabs.length, vsync: this);
    loadData();
    super.initState();
    tabController.addListener(() {
      tabs[tabController.index].hasNew = false;
      selectIndex = tabController.index;
      setState(() {});
    });
  }

  void loadData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar("我的消息"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 4, top: 8),
            alignment: Alignment.bottomCenter,
            height: 36,
            width: screen.screenWidth,
            color: Colors.black,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                bool isSelected = selectIndex == index;
                return Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: GestureDetector(
                    onTap: () {
                      if (selectIndex != index) {
                        selectIndex = index;
                        tabController.animateTo(index);
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            tabs[index].name,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Color(0xff999999),
                            ),
                          ),
                          SizedBox(height: 2),
                          Container(
                            height: 2,
                            width: 18,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryTextColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
               // MessagePage(isShowAppbar: false),
                MsgCommentTable(),
                MsgTable(),
                // MsgChildRewardPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
