import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/reply_model.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/custom_like_widget.dart';
import 'package:flutter_base/utils/log.dart';

class CommentReplyItemWidget extends StatefulWidget {
  final ReplyModel replyModel;
  final int childIndex;
  final Function callback;

  CommentReplyItemWidget(this.replyModel, this.childIndex, {Key key, this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CommentReplyItemWidgetState();
  }
}

class _CommentReplyItemWidgetState extends State<CommentReplyItemWidget> {
  ReplyModel get replyModel => widget.replyModel;

  int get childIndex => widget.childIndex;

  ///取消点赞
  _cancelLike() async {
    String objID = replyModel.id;
    String type = 'comment';
    replyModel.isLike = false;
    replyModel.likeCount = (replyModel.likeCount ?? 1) - 1;
    setState(() {});
    try {
      await netManager.client.cancelLike(objID, type);
    } catch (e) {
      debugLog('cancelLike=${e.toString()}' );
    }
    // cancelLike(param);
  }

  ///点赞
  _sendLike() async {
    String objID = replyModel.id;
    String type = 'comment';
    replyModel.isLike = true;
    replyModel.likeCount = (replyModel.likeCount ?? 0) + 1;
    try {
      await netManager.client.sendLike(
        objID,
        type,
      );
    } catch (e) {
      debugLog('sendLike=${e.toString()}');
    }
    // sendLike(param);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        widget.callback?.call();
      },
      child: Padding(
        padding: EdgeInsets.only(top: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 5),
            GestureDetector(
              ///点击头像，进入用���中心
              onTap: () {
                FocusScope.of(context).unfocus();
                Map<String, dynamic> map = {
                  'uid': replyModel.userID,
                };
                JRouter().go(PAGE_VIDEO_USER_CENTER, arguments: map);
                //  Navigator.pushNamed(context, AppRoutes.user_center, arguments: replyModel.userID);
              },
              child: ClipOval(
                  child: CustomNetworkImage(
                width: 24,
                height: 24,
                type: ImgType.avatar,
                imageUrl: replyModel.userPortrait,
                fit: BoxFit.cover,
              )),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "${replyModel.userName}",
                        style: TextStyle(
                          color: Color(0xff333333).withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 5),
                      //getAuthorView(replyModel.isAuthor ?? false),
                      //SizedBox(width: 5),
                      //getUserGenderAndAge(replyModel.age, replyModel.gender),
                      //SizedBox(width: 4),
                      //getVipLevelWidget(true, replyModel.level),
                      // getFollowView(replyModel.isFollow),
                      _buildReplyUserName(replyModel),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    replyModel.content ?? "",
                    maxLines: 4,
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        DateTimeUtil.utcTurnYear(replyModel.createdAt, char: "-"),
                        style: TextStyle(
                          color: Color(0xFF999999),
                          fontSize: 12,
                        ),
                      ),
                      Spacer(),
                      Image.asset("assets/images/comment_msg.png",width: 20, height: 20,),
                      SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          if (replyModel.isLike == true) {
                            _cancelLike();
                          } else {
                            _sendLike();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 12),
                          child: Image.asset(
                            replyModel.isLike == true ? "assets/images/thumb_red.png" : "assets/images/thumb_grey.png",
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAuthorView(bool isAuthor) {
    return Offstage(
      offstage: isAuthor ?? false ? false : true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(2),
          child: Text(
            Lang.author,
            style: TextStyle(color: Colors.white, fontSize: 8),
          ),
        ),
      ),
    );
  }

  Widget getUserGenderAndAge(int age, String gender) {
    //gender
    age = age ?? 0;
    // double w = 15;
    // if (age >= 18) {
    //   w = 24;
    // }
    Widget genderWidget = svgAssets(AssetsSvg.USER_IC_USER_GENDER_FAMALE, width: 10, height: 10);
    //  Widget genderWidgetBg = svgAssets(AssetsSvg.USER_IC_USER_GENDER_BG, width: w, height: 14, fit: BoxFit.fill);
    if (gender != null) {
      if (gender == 'male') {
        genderWidget = svgAssets(AssetsSvg.USER_IC_USER_GENDER_MALE, width: 10, height: 10);
        //  genderWidgetBg = svgAssets(AssetsSvg.USER_IC_USER_GENDER_BG1, width: w, height: 14, fit: BoxFit.fill);
      }
    }
    return genderWidget;
  }

  /// 获取vip等级的图标
  Widget getVipLevelWidget(bool isVip, int vipLevel) {
    if (isVip && 1 == vipLevel) {
      return svgAssets(
        AssetsSvg.ICON_VIP,
        height: 14,
      );
    } else if (isVip && 2 == vipLevel) {
      return svgAssets(
        AssetsSvg.ICON_SVIP,
        height: 14,
      );
    } else {
      return SizedBox();
    }
  }

  Widget _buildReplyUserName(ReplyModel replyModel) {
    if (replyModel.toUserID == null || replyModel.toUserID == 0) {
      return SizedBox();
    } else {
      return Row(
        children: [
          SizedBox(width: 8),
          Image.asset("assets/images/arrow_right_blue.png", width: 14, height: 14,),
          SizedBox(width: 8),
          Text(
            replyModel.toUserName ?? "",
            style: TextStyle(
              color: Color(0xff999999),
              fontSize: 12,
            ),
          )
        ],
      );
    }
  }
}
