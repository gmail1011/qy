import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeMsgPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeMsgPageState();
  }
}

class _HomeMsgPageState extends State<HomeMsgPage> {
  RefreshController controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          children: [
            Container(
              height: 90,
              child: Row(
                children: [
                  Expanded(
                    child: _buildMenuItem(
                      0,
                      "测试题",
                      "探索真实人性",
                      Color(0xff538df7),
                      "assets/images/title_hot_logo.png",
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildMenuItem(
                      1,
                      "热门话题",
                      "探索真实人性",
                      Color(0xff6866f6),
                      "assets/images/title_logo.png",
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: pullYsRefresh(
                refreshController: controller,
                enablePullUp: false,
                child: ListView.builder(
                  itemCount: 0,
                  itemBuilder: (context, index) {
                    return Container();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(int index, String title, String desc, Color bgColor, String imagePath) {
    return Container(
      height: 90,
      padding: EdgeInsets.fromLTRB(12, 12, 10, 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  desc,
                  style: TextStyle(
                    color: Color(0xffcccccc),
                    fontSize: 12,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    index == 0 ? "立即测试" : "前往群聊",
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Image.asset(imagePath, width: 60),
        ],
      ),
    );
  }
}
