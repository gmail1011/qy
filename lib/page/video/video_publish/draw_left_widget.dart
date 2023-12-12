/*
 * @Author: your name
 * @Date: 2020-05-20 10:51:50
 * @LastEditTime: 2020-05-23 11:05:12
 * @LastEditors: your name
 * @Description: In User Settings Edit
 * @FilePath: /flutter-client-yh/lib/page/video/video_publish/component/draw_left_widget.dart
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_base/utils/dimens.dart';

class DrawableLeftWidget extends StatelessWidget {
  final VoidCallback onTap;

  final String icon;

  final String name;

  final Color background;

  final Color textColor;
  final Color iconColor;

  DrawableLeftWidget(
      {this.icon,
      @required this.name,
      this.onTap,
      this.background,
      this.textColor,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: Dimens.pt74,
        height: Dimens.pt28,
        decoration: BoxDecoration(
          color: background ?? Color(0x803a3a44),
          borderRadius: BorderRadius.circular((4.0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: icon != null,
              child: Padding(
                padding: EdgeInsets.only(left: Dimens.pt3, right: Dimens.pt3),
                child: icon != null
                    ? ImageLoader.withP(ImageType.IMAGE_SVG,
                            address: icon,
                            color: iconColor,
                            width: 14,
                            height: 14)
                        .load()
                    : Container(),
              ),
            ),
            Text('$name',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Dimens.pt12,
                  color: textColor ?? Color(0xff333333),
                ))
          ],
        ),
      ),
    );
  }
}
