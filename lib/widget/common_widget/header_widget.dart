import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:lottie/lottie.dart';

///用户头像（包括VIP）
class HeaderWidget extends StatelessWidget {
  final String headPath;

  final double headWidth;

  final double headHeight;

  //vip显示的高度
  final double borderHeight;

  final Widget defaultHead;

  final int level;

  final double levelSize;

  final double positionedSize;

  //点击头像
  final VoidCallback tabCallback;

  final bool isCertified; //是否认证

  HeaderWidget({
    Key key,
    @required this.headPath,
    @required this.level,
    @required this.headWidth,
    @required this.headHeight,
    this.levelSize = 16,
    this.positionedSize = 2,
    this.isCertified = false,
    this.borderHeight,
    this.defaultHead,
    this.tabCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tabCallback,
      child: Stack(
        alignment: AlignmentDirectional.center,
        overflow: Overflow.visible,
        children: <Widget>[
          ClipOval(
            child: CustomNetworkImage(
              imageUrl: headPath ?? "",
              width: headWidth,
              height: headHeight,
            ),
          ),
          // if (isCertified)
          //   Container(
          //     width: headWidth,
          //     height: headHeight,
          //     decoration: BoxDecoration(
          //       border: Border.all(width: Dimens.pt1, color: Color(0xffd82d0b)),
          //       shape: BoxShape.circle,
          //     ),
          //   ),
          // if (level > 0)
          //   Positioned(
          //     bottom: positionedSize,
          //     right: positionedSize,
          //     child: ClipOval(
          //       child: Stack(
          //         children: [
          //           assetsImg(
          //             "assets/weibo/images/img_0.png",
          //             width: levelSize,
          //             height: levelSize,
          //           ),
          //           Lottie.asset(
          //             "assets/dh.json",
          //             width: levelSize,
          //             height: levelSize,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          //
          // ///设置认证头像
          // if (isCertified)
          //   Positioned(
          //     top: -Dimens.pt5,
          //     child: Container(
          //       child: assetsImg(AssetsImages.IC_USER_HEAD_MARK,
          //           width: headWidth, fit: BoxFit.fitWidth),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
