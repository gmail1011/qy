import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///点赞或取消点赞回调
typedef LikeCallback = Function(bool isLike);

///点赞 widget
class LikeWidget extends StatefulWidget {
  //图片宽
  final double width;

  // 图片高
  final double height;

  final bool isLike;

  final LikeCallback callback;

  final EdgeInsets padding;

  final int likeCount;

  final Axis scrollDirection;

  final String likeIconPath; //喜欢图标
  final String unlikeIconPath; //不喜欢图标
  final Color likeCountColor; //喜欢人数字体颜色
  final bool noShowCount;
  LikeWidget({
    Key key,
    this.isLike = false,
    this.width,
    this.height,
    this.callback,
    this.padding,
    this.likeCount,
    this.scrollDirection = Axis.vertical,
    this.likeCountColor = Colors.white,
    this.likeIconPath = "assets/weibo/comment_liked.png",
    this.unlikeIconPath = "assets/weibo/comment_unlike.png",
    this.noShowCount = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LikeWidgetState();
  }
}

class _LikeWidgetState extends State<LikeWidget> {
  bool isLike;

  int likeCount;

  @override
  void initState() {
    super.initState();
    isLike = widget.isLike;
    likeCount = widget.likeCount;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          isLike = !isLike;
          if (isLike) {
            ++likeCount;
          } else {
            --likeCount;
          }
          if (widget.callback != null) {
            widget.callback(isLike);
          }
        });
      },
      child: Container(
        padding: widget.padding ?? EdgeInsets.all(Dimens.pt5),
        child: widget.scrollDirection == Axis.vertical
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  isLike
                      ? Image.asset(
                          widget.likeIconPath,
                          width: 20.w,
                          height: 20.w,
                        )
                      : Image.asset(
                          widget.unlikeIconPath,
                          width: 20.w,
                          height: 20.w,
                        ),
                  Padding(
                    padding: EdgeInsets.only(top: Dimens.pt5),
                  ),
                  if(widget.noShowCount != true)
                  Text(
                    "${numCoverStr(likeCount)}",
                    style: TextStyle(color: widget.likeCountColor, fontSize: 12.nsp),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isLike
                      ? Image.asset(
                          widget.likeIconPath,
                          width: 20.w,
                          height: 20.w,
                        )
                      : Image.asset(
                          widget.unlikeIconPath,
                          width: 20.w,
                          height: 20.w,
                        ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.w, top: 4.w),
                  ),
                  if(widget.noShowCount != true)
                  Text("${numCoverStr(likeCount ?? 0)}", style: TextStyle(color: widget.likeCountColor, fontSize: 12.nsp))
                ],
              ),
      ),
    );
  }
}
