import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_base/utils/dimens.dart';

///点赞或取消点赞回调
typedef LikeCallback = Function(bool isLike);

///点赞 widget
class CustomLikeWidget extends StatefulWidget {
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

  CustomLikeWidget({
    Key key,
    this.isLike = false,
    this.width,
    this.height,
    this.callback,
    this.padding,
    this.likeCount,
    this.scrollDirection = Axis.vertical,
    this.likeCountColor = Colors.white,
    this.likeIconPath = AssetsSvg.COMMENT_LIKE,
    this.unlikeIconPath = AssetsSvg.COMMENT_UNLIKE,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LikeWidgetState();
}

class _LikeWidgetState extends State<CustomLikeWidget> {
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
                      ? Image(
                          image: AssetImage(AssetsImages.IC_QUESTION_LIKE),
                          width: widget.width ?? Dimens.pt16,
                          height: widget.height ?? Dimens.pt16,
                          fit: BoxFit.fitHeight,
                        )
                      : Image(
                          image: AssetImage(widget.unlikeIconPath),
                          width: widget.width ?? Dimens.pt16,
                          height: widget.height ?? Dimens.pt16,
                        ),
                  Padding(
                    padding: EdgeInsets.only(top: Dimens.pt5),
                  ),
                  Text(
                    "${numCoverStr(likeCount)}",
                    style: TextStyle(
                        color: widget.likeCountColor,
                        fontSize: AppFontSize.fontSize10),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  isLike
                      ? Image(
                          image: AssetImage(AssetsImages.IC_QUESTION_LIKE),
                          width: widget.width ?? Dimens.pt16,
                          height: widget.height ?? Dimens.pt16,
                          fit: BoxFit.cover,
                        )
                      : Image(
                          image: AssetImage(widget.unlikeIconPath),
                          width: widget.width ?? Dimens.pt16,
                          height: widget.height ?? Dimens.pt16,
                        ),
                  Padding(
                    padding: EdgeInsets.only(left: Dimens.pt5),
                  ),
                  Text("${numCoverStr(likeCount ?? 0)}",
                      style: TextStyle(
                          color: widget.likeCountColor, fontSize: Dimens.pt10))
                ],
              ),
      ),
    );
  }
}
