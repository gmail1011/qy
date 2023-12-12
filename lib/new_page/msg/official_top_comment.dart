
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/comment_model.dart';
import 'package:flutter_app/utils/asset_util.dart';


class OfficialTopComment extends StatelessWidget {

  final CommentModel model;
  final String commentStatus;
  final EdgeInsetsGeometry padding;
  const OfficialTopComment({Key key, @required this.model, this.commentStatus, this.padding,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 5, 16, 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                ///点击头像，进入用户中心
                onTap: () {
                  FocusScope.of(context).unfocus();
                  Map<String, dynamic> map = {
                    'uid': model.userID,
                  };
                  JRouter().go(PAGE_VIDEO_USER_CENTER, arguments: map);
                 // Navigator.pushNamed(context, AppRoutes.user_center, arguments: model.userID);
                },
                child: ClipOval(
                  child: CustomNetworkImage(
                    width: 36,
                    height: 36,
                    imageUrl: model.userPortrait,
                    type: ImgType.avatar,
                    fit: BoxFit.cover,
                    errorWidget: assetsImg(
                      AssetsImages.USER_DEFAULT_AVATAR,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      "${model.userName}",
                      style: const TextStyle(color: Color(0xff999999), fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      commentStatus ?? "",
                      style: const TextStyle(
                        color: Color(0xff333333),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "----------此评论系统生成 无法回复",
                      style: TextStyle(
                        color: Color(0xff666666),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 1,
            margin: const EdgeInsets.only(top: 6, left: 6, right: 6),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(48, 48, 48, 1),
                  Color.fromRGBO(157, 157, 157, 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
