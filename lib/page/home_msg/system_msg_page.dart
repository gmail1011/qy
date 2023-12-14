import 'dart:ui';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/message/message_list_entity.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SystemMsgPage extends StatefulWidget {
  final MessageListData systemMsgModel;

  const SystemMsgPage({Key key, this.systemMsgModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SystemMsgPageState();
  }
}

class _SystemMsgPageState extends State<SystemMsgPage> {
  RefreshController refreshController = RefreshController();
  int pageNumber = 1;
  List<MessageListDataList> xList;

  @override
  void initState() {
    super.initState();
    xList = widget.systemMsgModel?.xList;
    if (xList.isNotEmpty != true) {
      xList = null;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _loadData();
      });
    }
  }

  Future _loadData({int page = 1}) async {
    try {
      dynamic commonPostRes = await netManager.client.getSystemMessage(page, 10);
      MessageListData messageListData = MessageListData().fromJson(commonPostRes);
      xList ??= [];
      if (page == 1) {
        xList.clear();
      }
      pageNumber = page;
      xList.addAll(messageListData.xList ?? []);
      if (messageListData.hasNext == true) {
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (e) {
      xList ??= [];
      debugLog(e);
    }
    refreshController.refreshCompleted();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar("系统消息"),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: _buildListContent(),
      ),
    );
  }

  Widget _buildListContent() {
    if (xList == null) {
      return LoadingCenterWidget();
    } else if (xList.isEmpty == true) {
      return CErrorWidget(
        "暂无数据",
        retryOnTap: () {
          xList = null;
          setState(() {});
          _loadData();
        },
      );
    }
    return pullYsRefresh(
      refreshController: refreshController,
      onRefresh: _loadData,
      onLoading: () => _loadData(page: pageNumber + 1),
      child: ListView.builder(
        itemCount: xList?.length ?? 0,
        itemBuilder: (context, index) {
          MessageListDataList model = xList[index];
          return Container(
            color: Color(0xff242424),
            padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
            margin: EdgeInsets.only(bottom: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.content,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  formatTimeThree(model.createdAt),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
