import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/activity_response.dart';
import 'package:flutter_app/page/home_msg/view/topic_info_cell.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TopicDiscussPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TopicDiscussPageState();
  }
}

class _TopicDiscussPageState extends State<TopicDiscussPage> {
  List<ActivityModel> dataModel;
  RefreshController refreshController = RefreshController();
  int pageNumber = 1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData({int page = 1}) async {

    try {
      dynamic response = await netManager.client.getTopicList(page, 10);
      ActivityResponse messageListData = ActivityResponse.fromJson(response);
      dataModel ??= [];
      if (page == 1) {
        dataModel.clear();
      }
      pageNumber = page;
      dataModel.addAll(messageListData.list ?? []);
      if (messageListData.hasNext == true) {
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (e) {
      dataModel ??= [];
      debugLog(e);
    }
    refreshController.refreshCompleted();
    setState(() {});
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
                Expanded(child: _buildContent()),
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
    } else if (dataModel?.isEmpty == true) {
      return CErrorWidget(
        "暂无数据",
        retryOnTap: () {
          dataModel = null;
          setState(() {});
          _loadData();
        },
      );
    } else {
      return pullYsRefresh(
        refreshController: refreshController,
        onRefresh: _loadData,
        enablePullUp: false,
        child: ListView.builder(
          itemCount: dataModel.length ?? 0,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(bottom: 12),
              child: TopicInfoCell(videoModel: dataModel[index],),
            );
          },
        ),
      );
    }
  }
}
