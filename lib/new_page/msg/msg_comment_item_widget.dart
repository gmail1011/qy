import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/custom_network_image_new.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/comment_model.dart';
import 'package:flutter_app/model/message/my_msg_model.dart';
import 'package:flutter_app/model/res/reply_list_res.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/user/video_user_center/page.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:get/route_manager.dart' as Gets;

import 'commemt_reply_item_widget.dart';
import 'official_top_comment.dart';

class MsgCommentItemWidget extends StatefulWidget {
  final MyMsgModel msgModel;
  final int index;
  final Function(int, int) callback;

  MsgCommentItemWidget({
    this.msgModel,
    this.index,
    this.callback,
  });

  @override
  State<StatefulWidget> createState() {
    return _MsgCommentItemWidgetState();
  }
}

class _MsgCommentItemWidgetState extends State<MsgCommentItemWidget> {
  CommentModel get commentModel => widget.msgModel.detail ?? CommentModel();

  VideoModel get videoModel => widget.msgModel.videoInfo;

  int get index => widget.index;

  Function(int, int) get callback => widget.callback;

  ///显示评论状态
  String get _commentStr {
    if (commentModel.isDelete == true) {
      return Lang.COMMENT_STATUS_DELETE;
    }
    if (commentModel.status == 3) {
      return Lang.COMMENT_STATUS_SHIELD;
    } else if (commentModel.status == 2) {
      return Lang.COMMENT_STATUS_CHECK;
    } else {
      return "${widget.msgModel.desc}：${commentModel.content}";
    }
  }

  ///获取回复列表
  _getReplyList(int parentIndex) async {
    if (commentModel.haveMoreData == false) {
      return;
    }
    var infoList = commentModel.info;

    String objID = videoModel?.id;
    String cmtId = commentModel.id;
    String curTime = DateTimeUtil.format2utc(DateTime.now());
    int pageNumber = commentModel.replyPageIndex ?? 1;
    int pageSize = 5;
    String fstID;
    if (infoList?.isNotEmpty == true) {
      fstID = infoList[0].id ?? "";
    }
    try {

      ReplyListRes replyListRes = await netManager.client.getReplyList(objID, cmtId, curTime, pageNumber, pageSize, fstID);
      commentModel.haveMoreData = replyListRes.hasNext;
      commentModel.replyPageIndex = (commentModel.replyPageIndex ?? 0) + 1;
      commentModel.info?.addAll(replyListRes.list ?? []);

      setState(() {});
    } catch (e) {
      debugLog("getReplyList='${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        ///点击评论进行回复
        if (commentModel.isTop != true && callback != null) {
          callback(index, -1);
        }
      },
      child: commentModel.isTop == true
          ? OfficialTopComment(model: commentModel, commentStatus: _commentStr)
          : Container(
        child: Stack(
          children: [
            if (commentModel.isGodComment == true)
              Positioned(
                right: 36,
                top: 12,
                child: Image.asset(
                  "assets/images/comment_god.png",
                  width: 56,
                  height: 56,
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      ///点击头像，进入用户中心
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Map<String, dynamic> arguments = {
                          'uid': widget.msgModel.sendUid,
                          'uniqueId': DateTime.now().toIso8601String(),
                          // KEY_VIDEO_LIST_TYPE: VideoListType.NONE
                        };
                        pushToPage(BloggerPage(arguments));
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        child: ClipOval(
                          child: CustomNetworkImageNew(
                            width: 40,
                            height: 40,
                            imageUrl: widget.msgModel.sendAvatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "${widget.msgModel.sendName}",
                            style: const TextStyle(
                              color: Color(0xff666666),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateTimeUtil.utcTurnYear(widget.msgModel.createdAt, char: "/"),
                            style: const TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.msgModel.content,
                            style:  TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            // maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.msgModel.objId != null) {
                          pushToPage(CommunityDetailPage().buildPage({"videoId": widget.msgModel.objId}));
                        }
                      },
                      child: Container(
                        color: Color(0xff333333),
                        child: CustomNetworkImage(
                          imageUrl: videoModel?.cover,
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 5),
                  child: ListView.builder(
                    itemCount: commentModel.info?.length ?? 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int childIndex) {
                      return CommentReplyItemWidget(
                        commentModel.info[childIndex],
                        childIndex,
                        callback: () {
                          if (callback != null) {
                            callback(index, childIndex);
                          }
                        },
                      );
                    },
                  ),
                ),
                Visibility(
                    visible: commentModel.hasSubComment ?? false,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            ///获取更多回复
                            commentModel.isOpen = true;
                            if (commentModel.isRequestReply != true) {
                              commentModel.isRequestReply = true;
                              await _getReplyList(index);
                              commentModel.isRequestReply = false;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(top: 14, bottom: 8),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 30,
                                  height: 1,
                                  color: const Color(0xFF999999),
                                ),
                                Text(
                                  " 查看更多", //' ${Lang.COMMENT_SHOW_MORE_REPLY}' //展開更多回復
                                  // " 展开${commentModel.commCount}条回復",
                                  style: const TextStyle(
                                    color: Color(0xFF999999),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Image.asset(
                                  "assets/images/arrow_down.png",
                                  width: 12,
                                  height: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 32),
                        if(commentModel.isShowCloseReplyMsg)
                          InkWell(
                            onTap: () {
                              commentModel.isOpen = false;
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.only(top: 14, bottom: 8),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    " 收起",
                                    style: const TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Image.asset(
                                    "assets/images/arrow_down.png",
                                    width: 12,
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    )
                ),
                Container(
                  height: 1,
                  margin: const EdgeInsets.only(top: 6, left: 6, right: 6),
                  color: Color(0xff333333),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
