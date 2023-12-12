import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/page/video/video_publish/state.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_pickers/image_pickers.dart';

import 'dialog/dialog_entry.dart';

///上传视频控件
class VideoUploadMangeWidget extends StatefulWidget {
  final List<String> picList;
  final double width;
  final ImageTyp imageType;
  final double height;

  ///删除item
  final ValueChanged<int> deleteItemCallback;
  final ValueChanged<int>  deleteCoverCallback;

  ///添加图片
  final VoidCallback addItemCallback;

  ///选择封面
  final VoidCallback onSelectCover;

  final UploadType uploadType;
  final String videoPath;
  final String videoCover;

  VideoUploadMangeWidget({
    Key key,
    this.picList,
    this.addItemCallback,
    this.width,
    this.height,
    this.deleteItemCallback,
    this.deleteCoverCallback,
    this.onSelectCover,
    this.imageType = ImageTyp.FILE,
    this.uploadType = UploadType.UPLOAD_IMG,
    this.videoPath,
    this.videoCover,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoUploadState();
}

class _VideoUploadState extends State<VideoUploadMangeWidget> {
  @override
  Widget build(BuildContext context) {
    var picWidgetList = <Widget>[];
    var videoWidgetList = <Widget>[];

    ///添加封面控件
    // picWidgetList.add(
    //     widget.videoCover == null ? _buildVideoCoverUI() : _buildVideoCover());

    if(widget.picList!=null){
      for (var index = 0; index < widget.picList.length; index++) {
        picWidgetList.add(_buildVideoCover(index));
      }
    }
    picWidgetList.add(_buildVideoCoverUI());

    ///显示添加视频图标
    videoWidgetList
        .add(widget.videoPath == null ? _buildAddVideoUI() : _buildVideoUI());

    return Column(
      children: [
        Row(
          children: [
            Text(
              "上传图片介绍",
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),
            ),
            Text(
              " 默认第一张为封面 ",
              style: TextStyle(
                  color: Color.fromRGBO(0, 214, 190, 1),fontSize: 10),
            ),

            Text(
              "最多上传9张 最大每张1M以内",
              style: TextStyle(
                  color: Color(0xffdadada), fontSize: 10),
            ),
          ],
        ),

        SizedBox(height: 16.w),
        Container(
          child: GridView(
            //padding: EdgeInsets.all(Dimens.pt11),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //横轴三个子widget
              childAspectRatio: 1, //宽高比为1时，子widget
              mainAxisSpacing: 12.w,
              crossAxisSpacing: 12.w,
            ),
            children: picWidgetList,
          ),
        ),
        SizedBox(height: 10,),
        Row(
          children: [
            Text(
              "上传视频介绍",
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),
            ),
            Text(
              " 最大300M以内",
              style: TextStyle(
                  color: Color(0xffdadada), fontSize: 12),
            ),
          ],
        ),
        SizedBox(height: 10,),
        Container(
          child: GridView(
            //padding: EdgeInsets.all(Dimens.pt11),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //横轴三个子widget
              childAspectRatio: 1, //宽高比为1时，子widget
              mainAxisSpacing: 12.w,
              crossAxisSpacing: 12.w,
            ),
            children: videoWidgetList,
          ),
        ),
      ],
    );
  }

  ///真实封面UI
  GestureDetector _buildVideoCover(int index) => GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(5)),
                //设置四周边框
                border: new Border.all(
                    width: 0.6, color: Color.fromRGBO(159, 166, 180, 1)),
              ),
              child: _getImageTypeTwo(index),
            ),
            // 删除
            Positioned(
              top: Dimens.pt6,
              right: Dimens.pt6,
              child: GestureDetector(
                child: svgAssets(AssetsSvg.IC_CLOSEBTN,
                    width: Dimens.pt14, height: Dimens.pt14),
                onTap: () => widget.deleteCoverCallback?.call(index),
              ),
            ),
          ],
        ),
        onTap: () {
          if (ImageTyp.FILE == widget.imageType) {
            ImagePickers.previewImages([widget.videoCover], 0);
          }
        },
      );

  ///真实视频UI
  GestureDetector _buildVideoUI() => GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(5)),
                //设置四周边框
                border: new Border.all(
                    width: 0.6, color: Color.fromRGBO(159, 166, 180, 1)),
              ),
              child: _getImageType((widget.picList?.length ?? 0) > 0
                  ? widget.picList[0]
                  : widget.videoCover),
            ),
            //视频播放按钮
            svgAssets(AssetsSvg.IC_UPLOAD_PLAY,
                width: Dimens.pt24, height: Dimens.pt24),
            // 删除
            Positioned(
              top: Dimens.pt6,
              right: Dimens.pt6,
              child: GestureDetector(
                child: svgAssets(AssetsSvg.IC_CLOSEBTN,
                    width: Dimens.pt14, height: Dimens.pt14),
                onTap: () => widget.deleteItemCallback?.call(0),
              ),
            ),
          ],
        ),
        onTap: () {
          ImagePickers.previewVideo(widget.videoPath);
        },
      );

  Widget _getImageType(String videoCover) {
    if (widget.imageType == ImageTyp.ASSETS) {
      return assetsImg(
        videoCover ?? widget.picList[0],
        width: widget.width ?? Dimens.pt106,
        height: widget.height ?? Dimens.pt106,
        fit: BoxFit.cover,
      );
    } else if (widget.imageType == ImageTyp.FILE) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.file(
          File(videoCover ?? widget.picList[0]),
          width: widget.width ?? Dimens.pt106,
          height: widget.height ?? Dimens.pt106,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return CustomNetworkImage(
          imageUrl: videoCover ?? widget.picList[0],
          width: widget.width ?? Dimens.pt106,
          height: widget.height ?? Dimens.pt106,
          fit: BoxFit.cover,
          type: ImgType.cover);
    }
  }


  Widget _getImageTypeTwo(int index) {
    if (widget.imageType == ImageTyp.ASSETS) {
      return assetsImg(
        widget.picList[index],
        width: widget.width ?? Dimens.pt106,
        height: widget.height ?? Dimens.pt106,
        fit: BoxFit.cover,
      );
    } else if (widget.imageType == ImageTyp.FILE) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.file(
          File(widget.picList[index]),
          width: widget.width ?? Dimens.pt106,
          height: widget.height ?? Dimens.pt106,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return CustomNetworkImage(
          imageUrl: widget.picList[index],
          width: widget.width ?? Dimens.pt106,
          height: widget.height ?? Dimens.pt106,
          fit: BoxFit.cover,
          type: ImgType.cover);
    }
  }

  ///创建视频封面UI
  GestureDetector _buildVideoCoverUI() => GestureDetector(
        child: Container(
          width: 83.w,
          height: 83.w,
          decoration: BoxDecoration(
            color: Color(0xff1f2030),
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
        onTap: widget.onSelectCover,
      );

  ///添加视频UI
  GestureDetector _buildAddVideoUI() => GestureDetector(
        child: Container(
          width: 83.w,
          height: 83.w,
          decoration: BoxDecoration(
            color: Color(0xff1f2030),
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
                "添加视频",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        onTap: widget.addItemCallback,
      );
}
