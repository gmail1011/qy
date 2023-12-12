import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/msg_count_model.dart';
import 'package:flutter_app/model/message/message_model.dart';
import 'package:flutter_app/model/message/message_type_model.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/message/message_detail/MessageDetailPage.dart';
import 'package:flutter_app/weibo_page/message/message_list_entity.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_app/widget/common_widget/LoadingWidget.dart' as Loadings;
import 'package:get/route_manager.dart' as Gets;

///消息中心
class MessagePage extends StatefulWidget {

  final bool isShowAppbar;

  const MessagePage({Key key, this.isShowAppbar = true}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MessagePageState();
  }
}

class _MessagePageState extends State<MessagePage> {

  RefreshController refreshController = RefreshController();

  List<MessageModel> messageModelList = [];

  List<MessageListDataList> xList;

  int pageNumber = 1;

  @override
  void initState() {
    super.initState();
    // _getMessageType();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getPersonalMessage();
    });
  }

  _getPersonalMessage({int page = 1}) async {
    try {
      dynamic commonPostRes = await netManager.client.getMessageList(page, 10);
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
    return FullBg(
      child: Scaffold(
        appBar: widget.isShowAppbar == true ? CustomAppbar(title: "消息中心") : null,
        body: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (xList == null) {
      return Loadings.LoadingWidget();
    } else if (xList.isEmpty == true) {
      return CErrorWidget(
        "暂无数据",
        retryOnTap: () {
          xList = null;
          setState(() {});
          _getPersonalMessage();
        },
      );
    } else {
      return Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: pullYsRefresh(
          refreshController: refreshController,
          enablePullUp: true,
          enablePullDown: true,
          onRefresh: _getPersonalMessage,
          onLoading: () {
            _getPersonalMessage(page: pageNumber + 1);
          },
          child: ListView.builder(
              itemCount: xList.length ?? 0,
              itemBuilder: (context, index) {
                return _buildMessageCell(index);
              }),
        ),
      );
    }
  }

  Widget _getMessageLine(int index) {
    return InkWell(
      onTap: () async {
        Map<String, dynamic> map = {
          'title': messageModelList[index].title,
          'type': messageModelList[index].sender,
        };
        JRouter().go(PAGE_SYSTEM_MESSAGE, arguments: map);
      },
      child: _getLineItem(index),
    );
  }

  Widget _getLineItem(int index) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _getIcon(index),
                Container(
                  margin: EdgeInsets.only(left: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 220,
                        child: Text(
                          messageModelList[index].title ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 6),
                        width: 220,
                        child: Text(
                          messageModelList[index].content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0x80ffffff),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateTimeUtil.utc2MonthDay(messageModelList[index].sendAt ?? ''),
                  style: TextStyle(color: Color(0x80ffffff), fontSize: 12),
                ),
                messageModelList[index].sender == 'ONLINE'
                    ? Consumer<MsgCountModel>(builder: (BuildContext context, MsgCountModel msgCountModel, Widget child) {
                        return _getLineDotView(msgCountModel.countNum);
                      })
                    : _getLineDotView(messageModelList[index].newsCount),
              ],
            ),
          ],
        ));
  }

  Widget _getIcon(int index) {
    if (messageModelList[index].sender == 'SYSTEM') {
      return svgAssets(
        AssetsSvg.MESSAGE_IC_SYSTEM_MESSAGE,
        width: 50,
        height: 50,
      );
    } else if (messageModelList[index].sender == 'ACTASST') {
      return svgAssets(
        AssetsSvg.MESSAGE_IC_ASSISTANT,
        width: 50,
        height: 50,
      );
    } else {
      return svgAssets(
        messageModelList[index].icon,
        width: 50,
        height: 50,
      );
    }
  }

  ///行点计数
  Widget _getLineDotView(int newsCount) {
    // if (state.messageModelList != null && state.messageModelList.length > index) {
    if ((newsCount ?? 0) > 0) {
      return Container(
        margin: CustomEdgeInsets.only(top: 6, right: 6, left: 6),
        child: Stack(
          children: <Widget>[
            ClipOval(
              child: Container(
                width: 16,
                height: 16,
                color: Color(0xffffca00),
                alignment: Alignment.center,
                child: Text(
                  getCount(newsCount),
                  style: TextStyle(color: AppColors.primaryColor, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }

  String getCount(int count) {
    if (count > 9) {
      return '9+';
    } else if (count > 0) {
      return count.toString();
    } else {
      return '';
    }
  }

  Widget _buildMessageCell(int index) {
    MessageListDataList messageListDataList = xList[index];
    return GestureDetector(
      onTap: () async {
        Loadings.LoadingWidget loadings = new Loadings.LoadingWidget(
          title: "正在加载...",
        );
        loadings.show(context);
        dynamic videoss = await netManager.client.getSessionId(messageListDataList.userId);
        loadings.cancel();
        MessageListDataList message = new MessageListDataList();
        message.userId = messageListDataList.userId;
        message.takeUid = messageListDataList.userId;
        message.userAvatar = messageListDataList.userAvatar;
        message.sessionId = videoss;
        message.userName = messageListDataList.userName;
        pushToPage(MessageDetailPage(message));
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(left: 6, right: 6, bottom: 19),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      child: ClipOval(
                        child: CustomNetworkImage(
                          fit: BoxFit.cover,
                          width: 48,
                          height: 48,
                          imageUrl: xList[index].userAvatar ?? "",
                        ),
                      ),
                      onTap: () {
                        Map<String, dynamic> arguments = {
                          'uid': xList[index].userId,
                          'uniqueId': DateTime.now().toIso8601String(),
                        };
                        Gets.Get.to(() => BloggerPage(arguments), opaque: false);
                      },
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Visibility(
                          visible: xList[index].noReadNum > 0 ? true : false,
                          child: ClipOval(
                            child: Container(
                              width: 18,
                              height: 18,
                              alignment: Alignment.center,
                              child: Text(
                                xList[index].noReadNum.toString(),
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(247, 131, 97, 1),
                                  Color.fromRGBO(245, 75, 100, 1),
                                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            xList[index].userName,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        xList[index].preContent,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xffadadad),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatTime(xList[index].createdAt),
                  style: TextStyle(fontSize: 12, color: Color(0xffadadad)),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.only(left: 58),
              height: 1,
              color: Color(0xff333333),
            ),
          ],
        )
      ),
    );
  }
}
