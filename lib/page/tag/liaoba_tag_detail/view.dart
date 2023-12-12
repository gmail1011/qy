import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'action.dart';
import 'more_video_page.dart';
import 'state.dart';

Widget buildView(TagState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: MoreVideoPage(sectionID: state.tagId,tagName:state.title),
  );
}


///创建视频播放列表
GestureDetector _buildVideoItemUI(
        TagState state, LiaoBaTagsDetailDataVideos videoItem, int index) =>
    GestureDetector(
      onTap: () {
        if ((state.videoModelList ?? []).isEmpty) {
          return;
        }
        Map<String, dynamic> maps = Map();
        maps["videoId"] = state.videoModelList[index]?.id;
        maps["sectionID"] = state.tagId;
        JRouter().go(FILM_TV_VIDEO_DETAIL_PAGE, arguments: maps);
      },
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2.w),
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  CustomNetworkImage(
                      imageUrl: videoItem?.cover,
                      height: 106.w,
                      fit: BoxFit.cover),
                  Container(
                    height: 20.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6)
                          ]),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(AssetsImages.IC_LONG_VIDEO_EYE,
                                  width: 11.w, height: 11.w),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                videoItem.playCount > 10000
                                    ? (videoItem.playCount / 10000)
                                            .toStringAsFixed(1) +
                                        "w"
                                    : videoItem.playCount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.w,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            TimeHelper.getTimeText(
                                videoItem.playTime.toDouble()),
                            style:
                                TextStyle(color: Colors.white, fontSize: 10.w),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -1,
                    left: -3,
                    child: Visibility(
                      visible: videoItem?.originCoins != null &&
                          videoItem?.originCoins == 0 &&
                          !(videoItem?.watch?.isFreeWatch),
                      child: Image(
                        image: const AssetImage(AssetsImages.IC_VIDEO_VIP),
                        width: 50.w,
                        height: 20.w,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -1,
                    left: -1,
                    child: Visibility(
                      visible: videoItem?.originCoins != null &&
                              videoItem?.originCoins != 0 &&
                              !(videoItem?.watch?.isFreeWatch)
                          ? true
                          : false,
                      child: Stack(alignment: Alignment.center, children: [
                        Container(
                          //height: 20,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomRight: Radius.circular(4)),
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
                            top: 3.w,
                            bottom: 3.w,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageLoader.withP(ImageType.IMAGE_SVG,
                                      address: AssetsSvg.ICON_VIDEO_GOLD,
                                      width: 12.w,
                                      height: 12.w)
                                  .load(),
                              SizedBox(width: 6.w),
                              Text(videoItem?.originCoins.toString(),
                                  style: TextStyle(
                                      color: AppColors.textColorWhite,
                                      fontSize: 14.w)),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.w),
            Text(
              videoItem?.title,
              style: TextStyle(fontSize: 16.w, color: Colors.white),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
