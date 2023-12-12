import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/comment_model.dart';
import 'package:flutter_app/model/message/my_msg_model.dart';
import 'package:flutter_app/model/reply_model.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'msg_comment_item_widget.dart';


class MsgCommentTable extends StatefulWidget {

  MsgCommentTable();

  @override
  State<StatefulWidget> createState() => _MsgCommentTableState();
}

class _MsgCommentTableState extends State<MsgCommentTable> {
  RefreshController refreshController = RefreshController();
  List<MyMsgModel> list;
  int currentPage = 1;
  String textInputTip;

  ///输入控制
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData({int page = 1, int size = 10}) async {

    try {
      var respData = await netManager.client.getDynamic(page, size, dynamicMsgType:2);
      currentPage = page;
      list ??= [];
      MyMsgResponse resp = MyMsgResponse.fromJson(respData);
      if (page == 1) {
        list.clear();
      }
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
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
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
        itemCount: list.length,
        itemBuilder: (context, index) {
          var model = list[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: MsgCommentItemWidget(
                msgModel: model,
                index: index,
                callback: (paIndex, childIndex) {
                  _showInput(model);
                }),
          );
        },
      ),
    );
  }

  ///输入框弹出
  _showInput(MyMsgModel msgModel) {

    ///绑定过手机号
    if ((GlobalStore.getMe().mobile ?? '').isEmpty && GlobalStore.isVIP() == false) {
      showToast(msg: "只有会员才能发表评论哦～");
      //chooseBindPhone(context);
      return;
    }
    var hint = Lang.COMMENT_INPUT_TIP; //二级评论不需要提示语 南宫要求
    textInputTip = "回復 ${msgModel.sendName}:";

    // showCommentInput(
    //   context,
    //   contentController,
    //   textInputTip: textInputTip,
    //   hint: hint,
    //   sendCallback: () {
    //     String content = contentController.text;
    //     _sendComment(msgModel, content);
    //   },
    // );
  }

  ///发表评论
  _sendComment(MyMsgModel msgModel, String content) async {
    var commentList = list.map((e) => e.detail ?? CommentModel()).toList();
    // if (GlobalStore.getMe()?.isVip != true) {
    //   showToast(msg: "VIP用户才可评论");
    //   return;
    // }
    if (GlobalStore.getMe().hasBanned ?? false) {
      showToast(msg: Lang.COMMENT_FORBID);
      return;
    }

    String objID = msgModel.detail?.objID ?? "";
    int level = 2;
    // String? cid, rid;
    String cid = msgModel.detail?.cid;
    String rid = msgModel.detail?.id;
    int toUserID = msgModel.sendUid;

    try {
      ReplyModel replyModel = await netManager.client.sendReply(objID, level, content, cid, rid, toUserID);
      if(replyModel.id==null || replyModel.userID==null){
        showToast(msg: "评论失败");
        return;
      }else {
        showToast(msg: "回复成功");
      }
      setState(() {});
    } catch (e) {
      showToast(msg: e.toString());
      debugLog('sendReply/sendComment =${e.toString()}');
    }
  }
}
