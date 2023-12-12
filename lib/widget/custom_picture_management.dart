import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/page/video/video_publish/state.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_pickers/image_pickers.dart';

import 'dialog/dialog_entry.dart';

class PictureMangeWidget extends StatelessWidget {
  final List<String> picList;
  final double width;
  final ImageTyp imageType;
  final double height;

  ///删除item
  final ValueChanged<int> deleteItemCallback;

  ///添加图片
  final VoidCallback addItemCallback;

  ///选择封面
  final VoidCallback onSelectCover;

  final UploadType uploadType;
  final String videoPath;
  final bool showText;
  final bool isAi;
  final int mainAixCount;
  final Widget showTextValue;

  PictureMangeWidget(
      {Key key,
      this.picList,
      this.addItemCallback,
      this.width,
      this.height,
      this.deleteItemCallback,
      this.onSelectCover,
      this.imageType = ImageTyp.FILE,
      this.uploadType = UploadType.UPLOAD_IMG,
      this.showText = true,
      this.showTextValue,
      this.isAi = false,
      this.mainAixCount = 1,
      this.videoPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var picWidgetList = <Widget>[];
    for (var index = 0; index < picList.length; index++) {
      var curWidget = GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            /*ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: _getImageType(index)),*/
            Container(
              decoration: BoxDecoration(
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(5)),
                //设置四周边框
                border: new Border.all(width: 0.6, color: AppColors.primaryTextColor),
              ),
              child: _getImageType(index),
            ),
            //视频播放按钮
            Visibility(
              visible: uploadType == UploadType.UPLOAD_VIDEO,
              child: GestureDetector(
                child: svgAssets(AssetsSvg.IC_UPLOAD_PLAY, width: Dimens.pt24, height: Dimens.pt24),
                onTap: () async {
                  ImagePickers.previewVideo(videoPath);
                },
              ),
            ),
            // 删除
            Positioned(
                top: Dimens.pt4,
                right: Dimens.pt4,
                child: GestureDetector(
                  child: Image.asset("assets/images/hls_ai_icon_close.png", width: Dimens.pt23, height: Dimens.pt23),
                  onTap: () => deleteItemCallback?.call(index),
                )),
            // 上传封面
            Positioned(
              bottom: 0,
              child: Visibility(
                visible: uploadType == UploadType.UPLOAD_VIDEO,
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.6)),
                    alignment: Alignment.center,
                    width: screen.screenWidth,
                    height: Dimens.pt25,
                    child: Text("上传封面", style: TextStyle(color: Colors.white)),
                  ),
                  onTap: onSelectCover,
                ),
              ),
            )
          ],
        ),
        onTap: () {
          if (ImageTyp.FILE == imageType) {
            ImagePickers.previewImages(picList, index);
          }
        },
      );
      picWidgetList.add(curWidget);
    }

    if (isAi) {
      //显示添加图标
      if (picWidgetList.length == 0) {
        var addWidget = GestureDetector(
          child: Container(
            width: 83.w,
            height: 83.w,
          //  padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/ai_add_bg.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment:  MainAxisAlignment.center,
                children:[
                  Image.asset(
                    "assets/images/hls_ai_icon_plus.png",
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "图片大小低于2Mb",
                    style: TextStyle(
                      color: Color(0xff999999),
                      fontSize: 12,
                    ),
                  ),
                ]
            ),
          ),
          onTap: addItemCallback,
        );
        picWidgetList.add(addWidget);
      }
    } else {
      //显示添加图标
      if ((uploadType == UploadType.UPLOAD_IMG) || (picWidgetList.length == 0 && uploadType == UploadType.UPLOAD_VIDEO)) {
        var addWidget = GestureDetector(
          child: Container(
            width: 83.w,
            height: 83.w,
            decoration: BoxDecoration(
              color: Color(0xff202020),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/hls_ai_icon_plus.png",
                  width: 30,
                  height: 30,
                ),
                SizedBox(height: 8),
                Text(
                  "添加图片",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          onTap: addItemCallback,
        );
        picWidgetList.add(addWidget);
      } else if (picWidgetList.length > 9) {}
    }

    if(isAi){
      return Container(
        child: GridView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isAi ? mainAixCount : 3, //横轴三个子widget
            childAspectRatio: 1, //宽高比为1时，子widget
            mainAxisSpacing: Dimens.pt4,
            crossAxisSpacing: Dimens.pt4,
          ),
          children: picWidgetList,
        ),
      );
    }
    return Column(
      children: [
        // Container(alignment: Alignment.centerLeft,child: Text(uploadType == UploadType.UPLOAD_IMG ? "选择图片" : "选择视频",style: TextStyle(color: Colors.white,fontSize: 18.nsp),)),
        (showText ?? false)
            ? Container(
                margin: EdgeInsets.only(top: 4.w),
                alignment: Alignment.centerLeft,
                child: (showTextValue == null)
                    ? Text(
                        "上传图片 最多上传9张，最大每张1M以内",
                        style: TextStyle(
                          color: Color(0xffdadada),
                          fontSize: 12,
                        ),
                      )
                    : showTextValue)
            : SizedBox(),
        SizedBox(height: 16.w),
        SizedBox(
          height: Dimens.pt10,
        ),
        Container(
          child: GridView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isAi ? mainAixCount : 3, //横轴三个子widget
              childAspectRatio: 1, //宽高比为1时，子widget
              mainAxisSpacing: Dimens.pt4,
              crossAxisSpacing: Dimens.pt4,
            ),
            children: picWidgetList,
          ),
        ),
      ],
    );
  }

  Widget _getImageType(int index) {
    if (imageType == ImageTyp.ASSETS) {
      return assetsImg(
        picList[index],
        width: width ?? Dimens.pt106,
        height: height ?? Dimens.pt106,
        fit: BoxFit.cover,
      );
    } else if (imageType == ImageTyp.FILE) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.file(
          File(picList[index]),
          width: width ?? Dimens.pt106,
          height: height ?? Dimens.pt106,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return CustomNetworkImage(
          imageUrl: picList[index], width: width ?? Dimens.pt106, height: height ?? Dimens.pt106, fit: BoxFit.cover, type: ImgType.cover);
    }
  }
}
