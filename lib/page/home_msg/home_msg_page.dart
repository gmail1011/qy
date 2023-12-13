import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/message/message_detail/MessageDetailPage.dart';
import 'package:flutter_app/weibo_page/message/message_list_entity.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:flutter_app/widget/common_widget/LoadingWidget.dart' as Loadings;

class HomeMsgPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeMsgPageState();
  }
}

class _HomeMsgPageState extends State<HomeMsgPage> {
  RefreshController refreshController = RefreshController();
  int pageNumber = 1;
  List<MessageListDataList> xList;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadAllMsg();
    });
  }

  Future _loadAllMsg() async{
    _loadSystemMsg();
    _loadPersonalMessage();
  }

  Future _loadSystemMsg () async{

  }

  Future _loadPersonalMessage({int page = 1}) async {
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
    return Scaffold(
      body: SafeArea(
        child: Container(
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
              SizedBox(height: 18),
              Expanded(
                child: _buildListContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListContent() {
    if(xList == null){
      return LoadingCenterWidget();
    }else if(xList?.isNotEmpty != true){
      return CErrorWidget(
        "暂无数据",
        retryOnTap: (){
          xList = null;
          setState(() {});
          _loadAllMsg();
        },
      );
    }
    return pullYsRefresh(
      refreshController: refreshController,
      onRefresh: _loadAllMsg,
      onLoading:() => _loadPersonalMessage(page: pageNumber + 1),
      child: ListView.builder(
        itemCount: xList.length,
        itemBuilder: (context, index) {
          return _buildMessageCell(index);
        },
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
                  maxLines: 1,
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
                          pushToPage(BloggerPage(arguments));
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
