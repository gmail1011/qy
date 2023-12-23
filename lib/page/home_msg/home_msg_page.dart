import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/custom_network_image_new.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/new_page/msg/my_msg_page.dart';
import 'package:flutter_app/page/home_msg/question_answ_page.dart';
import 'package:flutter_app/page/home_msg/system_msg_page.dart';
import 'package:flutter_app/page/home_msg/topic_discuss_page.dart';
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
  MessageListData systemMsgModel;

  int get allCount {
    int count = (xList.length ?? 0);


    if (Config.customerService != false) {
      count++;
    }
    count++;
    // if (systemMsgModel?.xList?.isNotEmpty == true) {
    //   count++;
    // }
    count++;
    return count;
  }

  int chatMsgIndex(int index) {
    int count = index;
    if (Config.customerService != false) {
      count--;
    }
    if (systemMsgModel?.xList?.isNotEmpty == true) {
      count--;
    }
    count--;
    return max(0, count);
  }

  bool isSystemMsg(int index) {
    if (index == 0) {
      return true;
    }
    return false;
  }

  bool isKefu(int index) {
    if (Config.customerService != false) {
      if(systemMsgModel?.xList?.isNotEmpty == true){
        if(index  == 1){
          return true;
        }
      }else {
        if(index  == 0){
          return true;
        }
      }
    }
    return false;
  }

  bool islikeMsg(int index) {
    //测试说无论什么情况都开启评论
    if(( (Config.customerService != false) )&&index == 2){
      return true;
    }
    if(( (Config.customerService == false) )&&index ==1){
      return true;
    }
    // if(Config.customerService == true && systemMsgModel?.xList?.isNotEmpty == true){
    //   if(index == 2){
    //     return true;
    //   }
    // }
    // if (Config.customerService == true || systemMsgModel?.xList?.isNotEmpty == true) {
    //   if(index  == 1){
    //     return true;
    //   }
    // }
    return false;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadAllMsg();
    });
  }

  Future _loadAllMsg() async {
    await _loadSystemMsg();
    _loadPersonalMessage();
  }

  Future _loadSystemMsg() async {
    try {
      dynamic commonPostRes = await netManager.client.getSystemMessage(1, 10);
      systemMsgModel = MessageListData().fromJson(commonPostRes);
    } catch (e) {
      debugLog(e);
    }
    setState(() {});
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
                        "乱伦人格测试",
                        "探索真实人性",
                        Color(0xff538df7),
                        "assets/images/title_logo.png",
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildMenuItem(
                        1,
                        "热门话题",
                        "分享乱伦经验",
                        Color(0xff6866f6),
                        "assets/images/title_hot_logo.png",
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
    if (xList == null) {
      return LoadingCenterWidget();
    } else if (allCount == 0) {
      return CErrorWidget(
        "暂无数据",
        retryOnTap: () {
          xList = null;
          setState(() {});
          _loadAllMsg();
        },
      );
    }
    return pullYsRefresh(
      refreshController: refreshController,
      onRefresh: _loadAllMsg,
      onLoading: () => _loadPersonalMessage(page: pageNumber + 1),
      child: ListView.builder(
        itemCount: allCount,
        itemBuilder: (context, index) {
          print(" allCount  ${allCount } index ${index}  customerService  ${Config.customerService  }   isKefu ${isKefu(index)}  islikeMsg ${islikeMsg(index)}");
          if (isKefu(index)) {
            return _buildKefuCell();
          }

          if(islikeMsg(index)){
            return _buildLikeCell();
          }
          return _buildMessageCell(index);
        },
      ),
    );
  }

  Widget _buildMenuItem(int index, String title, String desc, Color bgColor, String imagePath) {
    return GestureDetector(
      onTap: (){
        if(index == 0){
          pushToPage(QuestionAnswPage());
        }else {
          pushToPage(TopicDiscussPage());
        }
      },
      child: Container(
        height: 90,
        padding: EdgeInsets.fromLTRB(10, 12, 8, 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    desc,
                    maxLines: 1,
                    style: TextStyle(
                      color: Color(0xffcccccc),
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 6),
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
            SizedBox(width: 2),
            Image.asset(imagePath, width: 56),
          ],
        ),
      ),
    );
  }

  Widget _buildKefuCell() {
    return GestureDetector(
      onTap: () async {
        csManager.openServices(context);
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/kefu_logo.png",
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "在线客服",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6),
                  Spacer(),
                  Text(
                    "",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff999999),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 18,
              margin: EdgeInsets.only(left: 50),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff999999),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.only(left: 50),
              height: 1,
              color: Color(0xff333333),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildLikeCell() {
    return GestureDetector(
      onTap: () async {
        pushToPage(MyMsgPage(), context: context);
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/msg_icon.png",
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "评论/点赞",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6),
                  Spacer(),
                  Text(
                    "",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff999999),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 18,
              margin: EdgeInsets.only(left: 50),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff999999),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.only(left: 50),
              height: 1,
              color: Color(0xff333333),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCell(int index) {
    bool isSysMsgType = isSystemMsg(index);
    print("---> isSysMsgType  ${isSysMsgType}");
    MessageListDataList model;
    if(isSysMsgType){
      model = systemMsgModel.xList.isEmpty==true?MessageListDataList():systemMsgModel.xList.first;
    }else if(xList.isNotEmpty == true){
      model = xList[chatMsgIndex(index)];
    }
    String imageUrl = isSysMsgType ? "" : model?.userAvatar;
    String userName = isSysMsgType ? "系统消息": model?.userName;
    String createTime =  model?.createdAt;
    String descText = isSysMsgType ?  model?.content??"" : model?.preContent;
    int readNum = isSysMsgType ?  systemMsgModel.unread : model?.noReadNum;
    return GestureDetector(
      onTap: () async {
        if(isSysMsgType){
            pushToPage(SystemMsgPage(systemMsgModel: systemMsgModel));
            return;
        }
        Loadings.LoadingWidget loadings = new Loadings.LoadingWidget(
          title: "正在加载...",
        );
        loadings.show(context);
        dynamic videoss = await netManager.client.getSessionId(model.userId);
        loadings.cancel();
        MessageListDataList message = new MessageListDataList();
        message.userId = model.userId;
        message.takeUid = model.userId;
        message.userAvatar = model.userAvatar;
        message.sessionId = videoss;
        message.userName = model.userName;
        pushToPage(MessageDetailPage(message));
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              child: Row(
                children: [
                  if (isSysMsgType)
                    Image.asset(
                      "assets/images/system_msg_logo.png",
                      width: 40,
                      height: 40,
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        Map<String, dynamic> arguments = {
                          'uid': model.userId,
                          'uniqueId': DateTime.now().toIso8601String(),
                        };
                        pushToPage(BloggerPage(arguments));
                      },
                      child: CustomNetworkImageNew(
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        imageUrl: imageUrl,
                        radius: 24,
                      ),
                    ),
                  SizedBox(width: 10),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 6),
                  Spacer(),
                  Text(
                    formatTimeThree(createTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff999999),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 18,
              margin: EdgeInsets.only(left: 50),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      descText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff999999),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  if (readNum > 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Color(0xffea336c),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        readNum.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.only(left: 50),
              height: 1,
              color: Color(0xff333333),
            ),
          ],
        ),
      ),
    );
  }
}
