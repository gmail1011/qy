import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';

Widget agentShowItemView(String title, String value,
    {String subValue = '', AlignmentGeometry alignment = Alignment.center}) {
  return Expanded(
    child: Container(
      alignment: alignment,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: Dimens.pt12, color: Colors.white),
          ),
          SizedBox(
            height: 8,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(style: TextStyle(fontSize: Dimens.pt12), text: value),
                // TextSpan(
                //   style: TextStyle(fontSize: Dimens.pt8),
                //   text: subValue,
                // ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget agentHLine({double height = 3, bool needPadding = true}) {
  return Container(
    padding: !needPadding
        ? null
        : EdgeInsets.symmetric(vertical: AppPaddings.appMargin),
    child: ImageLoader.withP(ImageType.IMAGE_ASSETS,
        address: AssetsImages.LINE,
        width: screen.screenWidth,
        height: height)
        .load(),
  );
}

Widget agentHLine2({double height = 1, bool needPadding = true}) {
  return Container(
    padding: !needPadding
        ? null
        : EdgeInsets.symmetric(vertical: AppPaddings.appMargin),
    child: Container(
        height: height,
        color: Color(0xFF353745),
    ),
  );
}

Widget agentVLine() {
  return Container(
    child: ImageLoader.withP(
      ImageType.IMAGE_ASSETS,
      address: AssetsImages.SLINE,
      width: 1,
      height: Dimens.pt50,
    ).load(),
  );
}

Widget gameLine(color, {double height = 3, double opacity = 0.5}) {
  return Opacity(
    opacity: opacity,
    child: Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(21, 23, 64, 0),
          color,
          Color.fromRGBO(22, 24, 65, 0)
        ], begin: Alignment.centerLeft, end: Alignment.centerRight),
      ),
    ),
  );
}
