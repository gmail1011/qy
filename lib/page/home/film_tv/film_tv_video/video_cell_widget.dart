import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/custom_network_image_new.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_video_entity.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoCellWidget extends StatelessWidget {
  final SearchVideoDataList model;
  final VideoModel videoModel;
  final TagsDetailDataSectionsVideoInfo videoInfo;
  final LiaoBaTagsDetailDataVideos videoInfo2;
  final Color imageBgColor;
  final double imageHeight;
  final double imageWidth;
  final BoxFit imageFit;
  final int textLine;
  final bool isShowVip;
  final bool timeCommentStyle;
  final bool isShowBottom;
  final bool isShowDeleteStatus;
  final Function(VideoModel) deleteCallback; // 点击删除回调
  const VideoCellWidget({
    Key key,
    this.model,
    this.imageBgColor,
    this.videoModel,
    this.imageHeight,
    this.imageWidth,
    this.videoInfo,
    this.videoInfo2,
    this.imageFit,
    this.textLine,
    this.isShowVip = false,
    this.timeCommentStyle = false,
    this.isShowBottom = true,
    this.isShowDeleteStatus = false,
    this.deleteCallback,
  }) : super(key: key);

  VideoModel get realModel {
    VideoModel _realModel;
    if (videoModel != null) {
      _realModel = videoModel;
    } else if (model != null) {
      _realModel = VideoModel.fromJson(model.toJson());
    } else if (videoInfo != null) {
      _realModel = VideoModel.fromJson(videoInfo.toJson());
    } else if (videoInfo2 != null) {
      _realModel = VideoModel.fromJson(videoInfo2.toJson());
    }
    if (_realModel == null) {
      debugLog("_realModel == null");
    }
    return _realModel;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomNetworkImageNew(
                imageUrl: realModel.cover ?? "",
                fit: BoxFit.cover,
                width: imageWidth,
                height: imageHeight,
                // placeholder:
                // _buildPlaceholderUI(height: imageHeight, borRadius: 2),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomData(realModel),
              ),
              if (isShowVip) _buildTopIndicator(realModel),
              if (isShowDeleteStatus == true) _buildDeleteState(),
            ],
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(top: 6),
          child: Text(
            realModel.title ?? "",
            maxLines: textLine ?? 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textColorWhite,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(
          height: 2,
        ),
        _buildBottomWidget(),
      ],
    );
  }

  Widget _buildBottomWidget() {
    if (isShowBottom == true) {
      if (timeCommentStyle == true)
        return Row(
          children: [
            Text(
              formatTimeTwo(realModel.createdAt),
              style: TextStyle(color: Color.fromRGBO(147, 147, 147, 1), fontSize: 11),
            ),
            Text(
              " / 评论${realModel.commentCount}",
              style: TextStyle(color: Color.fromRGBO(147, 147, 147, 1), fontSize: 11),
            ),
            SizedBox(
              width: 3,
            ),
          ],
        );
      else
        return Row(
          children: [
            Expanded(
              child: Text(
                formatTimeTwo(realModel.createdAt),
                style: TextStyle(color: Color.fromRGBO(147, 147, 147, 1), fontSize: 11),
              ),
            ),
            Text(
              "评论${realModel.commentCount}",
              style: TextStyle(color: Color.fromRGBO(147, 147, 147, 1), fontSize: 12),
            ),
            SizedBox(
              width: 3,
            ),
          ],
        );
    } else {
      return SizedBox();
    }
  }

  Widget _buildTopIndicator(VideoModel model) {
    if (model?.watch?.isFreeWatch == true) {
      return SizedBox();
    }
    if (model?.originCoins != null && model?.originCoins == 0 && !(model?.watch?.isFreeWatch ?? false))
      return Image(
        image: AssetImage(AssetsImages.IC_VIDEO_VIP),
        width: 49.w,
        height: 20.w,
        fit: BoxFit.fill,
      );
    if (model?.originCoins != null && model?.originCoins != 0 && !(model?.watch?.isFreeWatch ?? false))
      return Container(
        height: 20.w,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(2), bottomRight: Radius.circular(2)),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(247, 131, 97, 1),
              Color.fromRGBO(245, 75, 100, 1),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: EdgeInsets.only(
          left: 8.w,
          right: 8.w,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageLoader.withP(ImageType.IMAGE_SVG, address: AssetsSvg.ICON_VIDEO_GOLD, width: 12.w, height: 12.w).load(),
            SizedBox(width: 6.w),
            Text(model.originCoins.toString(), style: TextStyle(color: AppColors.textColorWhite)),
          ],
        ),
      );

    return SizedBox();
  }

  Widget _buildBottomData(VideoModel model) {
    return Container(
      height: 24,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.6)]),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 4.w, right: 10.w),
        child: Row(
          children: [
            Expanded(
              child:  Text(
                model.playCountDescTwo,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
            model.playTime == null
                ? SizedBox()
                : Text(
                    TimeHelper.getTimeText(model.playTime?.toDouble() ?? 0),
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteState() {
    return InkWell(
      onTap: (){
        deleteCallback?.call(videoModel);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x99707070),
        ),
        child: Center(
          child: Image.asset(
            "assets/images/delete_icon.png",
            width: 30,
            height: 30,
          ),
        ),
      ),
    );
  }
}
