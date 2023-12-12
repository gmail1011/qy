import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image_new.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/message/my_msg_model.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MsgTable extends StatefulWidget {
  MsgTable();

  @override
  State<StatefulWidget> createState() => _MsgTableState();
}

class _MsgTableState extends State<MsgTable> with AutomaticKeepAliveClientMixin {
  RefreshController refreshController = RefreshController();
  List<MyMsgModel> list = [];
  int currentPage = 1;
  String textInputTip;

  ///输入控制
  TextEditingController contentController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData();
    });
  }

  void _loadData({int page = 1, int size = 10}) async {
    try {
      var respData = await netManager.client.getDynamic(page, size, dynamicMsgType: 1);
      currentPage = page;
      list ??= [];
      MyMsgResponse resp = MyMsgResponse.fromJson(respData);
      if (page == 1) list.clear();

      list.addAll(resp.list ?? []);
      if (resp.hasNext == true) {
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (e) {
      debugLog(e);
      showToast(msg: e.toString());
    }
    refreshController.refreshCompleted();
    list ??= [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (list == null) return LoadingCenterWidget();
    if (list.isEmpty) {
      return CErrorWidget(
        "暂无数据",
        retryOnTap: () {
          list = null;
          setState(() {});
          _loadData();
        },
      );
    }
    return pullYsRefresh(
      refreshController: refreshController,
      onRefresh: _loadData,
      onLoading: () => _loadData(page: currentPage + 1),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 12),
        itemCount: list.length,
        itemBuilder: (context, index) {
          var item = list[index];
          return getMsgItem(item, index);
        },
      ),
    );
  }

  Widget getMsgItem(MyMsgModel model, int index) {
    return buildLikeItem(context, model);
  }

  Widget buildLikeItem(BuildContext context, MyMsgModel item) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 3),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Map<String, dynamic> arguments = {
                    'uid': item.sendUid,
                    'uniqueId': DateTime.now().toIso8601String(),
                    // KEY_VIDEO_LIST_TYPE: VideoListType.NONE
                  };
                  pushToPage(BloggerPage(arguments));
                },
                child: CustomNetworkImageNew(
                  imageUrl: item.sendAvatar,
                  width: 40,
                  height: 40,
                  radius: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.sendName ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      DateTimeUtil.utc2iso(item.createdAt),
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      item.content ?? '',
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  if (item.objId != null) {
                    pushToPage(CommunityDetailPage().buildPage({"videoId": item.objId}));
                  }
                },
                child: CustomNetworkImageNew(
                  imageUrl: item.sendAvatar,
                  width: 60,
                  height: 60,
                  radius: 4,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 1,
            margin: const EdgeInsets.only(left: 6, right: 6),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(230, 230, 230, 1),
                  Color.fromRGBO(230, 230, 230, 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
