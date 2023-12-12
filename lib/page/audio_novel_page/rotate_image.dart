import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_base/utils/dimens.dart';

/// 旋转的图片
class RotateImage extends StatefulWidget {
  final String url;
  final double iconSize;

  const RotateImage({Key key, this.url, this.iconSize}) : super(key: key);
  @override
  RotateImageState createState() => RotateImageState();
}

class RotateImageState extends State<RotateImage>
    with TickerProviderStateMixin {
  /// 头像宽高
  double iconSize;

  /// 旋转控制器
  AnimationController _diskController;

  /// 动画的插值列表
  Animation<double> _diskAnimation;
  @override
  void initState() {
    super.initState();
    iconSize = widget.iconSize ?? (Dimens.pt28 * (50 / 58));
    _initDiskAnimationController();
  }

  /// 初始化盘子动画
  void _initDiskAnimationController() {
    _diskController = AnimationController(
        duration: Duration(milliseconds: 8000), vsync: this);
    _diskAnimation =
        Tween<double>(begin: pi * 2, end: 0.0).animate(CurvedAnimation(
      parent: _diskController,
      curve: Curves.linear,
    ))
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _diskController?.dispose();
    _diskController = null;
    _diskAnimation = null;
    super.dispose();
  }

  startPlay() {
    if (!_diskController.isAnimating) {
      _diskController.repeat();
    }
  }

  stopPlay() {
    if (_diskController.isAnimating) {
      _diskController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
          alignment: Alignment.center, //相对于坐标系原点的对齐方式
          angle: _diskAnimation.value,
          child: ClipOval(
            child: CustomNetworkImage(
              type: ImgType.avatar,
              imageUrl: widget.url ?? '',
              width: iconSize,
              height: iconSize,
            ),
          )),
    );
  }
}
