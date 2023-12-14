import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page/home_msg/view/topic_info_cell.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TopicDiscussPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TopicDiscussPageState();
  }
}

class _TopicDiscussPageState extends State<TopicDiscussPage> {
  var dataModel;
  RefreshController refreshController = RefreshController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData() async {

    refreshController?.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/hot_topic_bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 8, 0),
                    child: Image.asset(
                      "assets/images/video_back.png",
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Text(
                  "#海角知识课堂#",
                  style: TextStyle(
                    color: Color(0xff3867f6),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 18),
                Container(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    "assets/images/topic_title.png",
                    width: 200,
                    height: 37,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "每周五18:00更新",
                    style: TextStyle(
                      color: Color(0xff3867f6),
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Expanded(
                  child: pullYsRefresh(
                    refreshController: refreshController,
                    onRefresh: _loadData,
                    enablePullUp: false,
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(bottom: 12),
                          child: TopicInfoCell(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (dataModel == null) {
      return LoadingCenterWidget();
    } else if (dataModel == null) {
      return CErrorWidget(
        "暂无数据",
        retryOnTap: () {
          dataModel = null;
          setState(() {});
          _loadData();
        },
      );
    } else {
      return Container();
    }
  }
}
