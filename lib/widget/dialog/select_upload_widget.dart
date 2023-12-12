/*
 * @Author: your name
 * @Date: 2020-05-26 15:49:20
 * @LastEditTime: 2020-05-28 17:13:01
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter-client-yh/lib/page/video/video_publish/component/select_upload_widget.dart
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/page/video/video_publish/state.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

///选择上传类型

/// 1: 视频 2：图片
class SelectUploadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => safePopPage(),
      child: Container(
        color: Colors.transparent,
        width: screen.screenWidth,
        height: screen.screenHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () => safePopPage(UploadType.UPLOAD_IMG),
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: <Widget>[
                        ImageLoader.withP(ImageType.IMAGE_SVG,
                                address: AssetsSvg.ICON_PIC,
                                width: Dimens.pt34,
                                height: Dimens.pt34)
                            .load(),
                        Padding(
                          padding: EdgeInsets.only(top: Dimens.pt10),
                        ),
                        Text(Lang.GRAPHIC,
                            style: TextStyle(
                                color: Colors.white, fontSize: Dimens.pt14))
                      ],
                    ),
                  ),
                ),
                SizedBox(width: Dimens.pt66),
                GestureDetector(
                  onTap: () => safePopPage(UploadType.UPLOAD_VIDEO),
                  child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          ImageLoader.withP(ImageType.IMAGE_SVG,
                                  address: AssetsSvg.ICON_VIDEO,
                                  width: Dimens.pt34,
                                  height: Dimens.pt34)
                              .load(),
                          Padding(padding: EdgeInsets.only(top: Dimens.pt10)),
                          Text(Lang.VIDEO,
                              style: TextStyle(
                                  color: Colors.white, fontSize: Dimens.pt14))
                        ],
                      )),
                )
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => safePopPage(),
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(
                    top: Dimens.pt30,
                    left: Dimens.pt20,
                    right: Dimens.pt20,
                    bottom: Dimens.pt30),
                child: ImageLoader.withP(ImageType.IMAGE_SVG,
                        address: AssetsSvg.ICON_DELETE,
                        width: Dimens.pt16,
                        height: Dimens.pt16)
                    .load(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
