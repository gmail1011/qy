import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/audiobook_data_list_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/voice_anchor_info_page/action.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

import 'state.dart';

Widget buildView(
    VoiceAnchorInfoState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      floatingActionButton: Container(
        padding: EdgeInsets.only(bottom: 50),
        child: GestureDetector(
          onTap: () {
            dispatch(VoiceAnchorInfoActionCreator.randomAnchor());
          },
          child: svgAssets(AssetsSvg.NEXT_ANCHOR),
        ),
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipPath(
                clipper: MyClipper(),
                child: Stack(
                  children: [
                    CustomNetworkImage(
                      // isGauss: true,
                      imageUrl: state.model?.avatar ?? '',
                      fit: BoxFit.fitWidth,
                      width: screen.screenWidth,
                      height: Dimens.pt220,
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.6),
                      width: screen.screenWidth,
                      height: Dimens.pt220,
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  child: _transparentAppbar(state, dispatch, viewService)),
              Positioned(
                top: kToolbarHeight + screen.paddingTop,
                child: Column(
                  children: [
                    HeaderWidget(
                        headPath: state.model?.avatar ?? '',
                        level: 0,
                        headWidth: Dimens.pt60,
                        headHeight: Dimens.pt60),
                    Text(
                      state.model?.name ?? '',
                      style: TextStyle(
                        fontSize: AppFontSize.fontSize18,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "作品：${state.model?.totalRaido ?? 0}部",
                      style: TextStyle(
                        fontSize: AppFontSize.fontSize10,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(AppPaddings.appMargin),
            alignment: Alignment.centerLeft,
            child: Text(
              "相关作品",
              style: TextStyle(
                fontSize: AppFontSize.fontSize18,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: AudiobookDataListPage()
                .buildPage({'type': 1, 'typeStr': state.model?.name ?? ''}),
          ),
        ],
      ),
    ),
  );
}

/// 透明的appbar
Widget _transparentAppbar(
    VoiceAnchorInfoState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    width: screen.screenWidth,
    height: kToolbarHeight + screen.paddingTop,
    padding: EdgeInsets.only(
        right: AppPaddings.appMargin,
        top: screen.paddingTop,
        left: AppPaddings.appMargin),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          child: Container(
              height: Dimens.pt26,
              width: Dimens.pt26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: ImageLoader.withP(ImageType.IMAGE_SVG,
                      address: AssetsSvg.BACK, fit: BoxFit.scaleDown)
                  .load()),
          onTap: () {
            safePopPage();
          },
        ),
        GestureDetector(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 13),
              height: Dimens.pt26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: (state.model?.isCollect ?? false)
                      ? Colors.grey
                      : Colors.red,
                  borderRadius: BorderRadius.circular(Dimens.pt13)),
              child: Text(
                (state.model?.isCollect ?? false) ? '已收藏' : "收藏",
                style: TextStyle(
                  fontSize: AppFontSize.fontSize14,
                  color: Colors.white,
                ),
              )),
          onTap: () {
            dispatch(VoiceAnchorInfoActionCreator.collect());
          },
        ),
      ],
    ),
  );
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // 从 60，0 开始
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 30);
    // 二阶贝塞尔曲线画弧
    path.quadraticBezierTo(
        size.width / 2, size.height + 30, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
