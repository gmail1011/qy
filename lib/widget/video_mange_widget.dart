import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/page/video/video_publish/state.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/utils/svg_util.dart';
// import 'package:image_pickers/image_pickers.dart';

/// 带删除和选择的图片空间
class VideoMangeWidget extends StatelessWidget {
  final List<String> picList;
  final double width;
  final ImageTyp imageType;
  final double height;

  ///删除item
  final ValueChanged<int> deleteItemCallback;

  ///添加图片
  final VoidCallback addItemCallback;

  final UploadType uploadType;
  final String videoPath;

  VideoMangeWidget(
      {Key key,
      this.picList,
      this.addItemCallback,
      this.width,
      this.height,
      this.deleteItemCallback,
      this.imageType = ImageTyp.FILE,
      this.uploadType = UploadType.UPLOAD_IMG,
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
            ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: _getImageType(index)),
            Visibility(
                visible: uploadType == UploadType.UPLOAD_VIDEO,
                child: GestureDetector(
                  child: svgAssets(AssetsSvg.IC_UPLOAD_PLAY,
                      width: Dimens.pt24, height: Dimens.pt24),
                  onTap: () async {
                    // FIXME video 的地址是一个/data/user里面的假地址，
                    // 选取和预览不是同一个地址，暂时不支持预览
                    // if (TextUtil.isNotEmpty(videoPath))
                    //   OpenFile.open(videoPath);
                    // ImagePickers.previewVideo(playPath);
                  },
                )),
            Positioned(
                top: Dimens.pt6,
                right: Dimens.pt6,
                child: GestureDetector(
                    child: svgAssets(AssetsSvg.IC_CLOSEBTN,
                        width: Dimens.pt14, height: Dimens.pt14),
                    onTap: () {
                      deleteItemCallback(index);
                    }))
          ],
        ),
        onTap: () {
          if (ImageTyp.FILE == imageType) {
            // ImagePickers.previewImages(picList, index);
          }
        },
      );
      picWidgetList.add(curWidget);
    }

    //显示添加图标
    if ((picWidgetList.length < 9 && uploadType == UploadType.UPLOAD_IMG) ||
        (picWidgetList.length < 3 && uploadType == UploadType.UPLOAD_VIDEO)) {
      var addWidget = GestureDetector(
        child: Container(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Color(0xffD8D8D8),
                padding: EdgeInsets.all(30),
                child: svgAssets(
                  AssetsSvg.IC_ADD,
                  color: Color(0xffABA7A7),
                ),
              ),
            )),
        onTap: () {
          addItemCallback();
        },
      );
      picWidgetList.add(addWidget);
    } else if (picWidgetList.length > 9) {
      picList.removeRange(9, picList.length);
      picWidgetList.removeRange(9, picWidgetList.length);
    }
    return Container(
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, //横轴三个子widget
          childAspectRatio: 1, //宽高比为1时，子widget
          mainAxisSpacing: Dimens.pt4,
          crossAxisSpacing: Dimens.pt4,
        ),
        children: picWidgetList,
      ),
    );
  }

  Widget _getImageType(int index) {
    if (imageType == ImageTyp.ASSETS) {
      return assetsImg(
        picList[index],
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        fit: BoxFit.cover,
      );
    } else if (imageType == ImageTyp.FILE) {
      return Image.file(
        File(picList[index]),
        width: width ?? double.infinity,
        height: height ?? double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return CustomNetworkImage(
          imageUrl: picList[index],
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          fit: BoxFit.cover,
          type: ImgType.cover);
    }
  }
}
