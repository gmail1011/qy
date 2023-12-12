import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';

/// 透明的appbar
Widget transparentAppbar(BuildContext context, String title) {
  return Container(
    width: screen.screenWidth,
    height: kToolbarHeight + screen.paddingTop,
    padding:
        EdgeInsets.only(right: AppPaddings.appMargin, top: screen.paddingTop),
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          left: 0,
          child: GestureDetector(
            child: Container(
                width: kToolbarHeight,
                height: kToolbarHeight,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: ImageLoader.withP(ImageType.IMAGE_SVG,
                        address: AssetsSvg.BACK,
                        width: 16,
                        height: 16,
                        fit: BoxFit.scaleDown)
                    .load()),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        Text(title ?? '',
            style: TextStyle(
                fontSize: Dimens.pt17,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none))
      ],
    ),
  );
}
