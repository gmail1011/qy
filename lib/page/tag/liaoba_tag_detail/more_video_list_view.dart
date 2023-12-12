import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/manager/ad_Insert_manager.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/video_cell_widget.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoreVideoListView extends StatefulWidget {
  final String type;
  final String sectionID;

  MoreVideoListView({Key key, this.type, this.sectionID}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MoreVideoListViewState();
  }
}

class _MoreVideoListViewState extends State<MoreVideoListView>
    with AutomaticKeepAliveClientMixin {
  RefreshController refreshController = RefreshController();
  List<LiaoBaTagsDetailDataVideos> videoModelList;
  int pageNumber = 1;
  List<AdsInfoBean> adsList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    _loadData(page: 1);
  }

  void _loadMoreData() {
    _loadData(page: pageNumber + 1);
  }


  void _loadData({int page, int size = 15}) async {
    try {
      LiaoBaTagsDetailData tagListModel = await netManager.client
          .requestSelectedTagListData(
              page, size, widget.sectionID, widget.type, 1);
      videoModelList ??= [];
      if ((tagListModel.videos ?? []).isNotEmpty) {
        pageNumber = page;
        if (page == 1) {
          videoModelList = [];
        }
        tagListModel.videos.forEach((element) {
          LiaoBaTagsDetailDataVideos video = element;
          // LiaoBaTagsDetailDataVideos video = VideoModel.fromJson(element.toJson());
          videoModelList.add(video);
        });
        AdInsertManager.insertTagAd(videoModelList);
        if (tagListModel.videos.length < size) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
      } else {
        refreshController.loadNoData();
      }
      refreshController.refreshCompleted();
    } catch (e) {
      videoModelList ??= [];
      refreshController.refreshCompleted();
      refreshController.loadComplete();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return Column(
    //   children: [
    //     Expanded(child: _buildContent()),
    //   ],
    // );
    return _buildContent();
  }

  Widget _buildAds() {
    if (adsList.isEmpty) return SizedBox();
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12),
      child: AdsBannerWidget(
        adsList,
        width: Dimens.pt360,
        height: Dimens.pt180,
        onItemClick: (index) {
          var ad = adsList[index];
          JRouter().handleAdsInfo(ad.href, id: ad.id);
        },
      ),
    );
  }

  Widget _buildContent() {
    if (videoModelList == null) {
      return Center(child: LoadingWidget());
    } else if (videoModelList.isEmpty) {
      return Center(
        child: CErrorWidget(
          Lang.EMPTY_DATA,
          retryOnTap: () {
            videoModelList = [];
            _refreshData();
            setState(() {});
          },
        ),
      );
    }
    return pullYsRefresh(
      refreshController: refreshController,
      enablePullUp: true,
      onRefresh: _refreshData,
      onLoading: _loadMoreData,
      child: GridView.builder(
        padding: EdgeInsets.only(left: 10,right: 10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 7.0,
          childAspectRatio: 201 / 182,
        ),
        itemCount: videoModelList?.length ?? 0,
        itemBuilder: (context, index) {
          return _buildVideoItemUI(videoModelList[index], index);
        },
      ),

    );
  }

  Widget _buildVideoItemUI(LiaoBaTagsDetailDataVideos videoItem, int index) {
    return GestureDetector(
      onTap: () {
        if (videoItem.isRandomAd) {
          var ad = videoItem.randomAdsInfo;
          JRouter().handleAdsInfo(ad.href, id: ad.id);
        } else {
          Map<String, dynamic> maps = Map();
          maps["videoId"] = videoItem.id;
          maps["sectionID"] = widget.sectionID;

          VideoModel videos = VideoModel.fromJson(videoItem.toJson());
          maps["videoModel"] = videos;

          JRouter().go(FILM_TV_VIDEO_DETAIL_PAGE, arguments: maps);
        }
      },
      child:
      Container(
        child: SizedBox(
          width: (screen.screenWidth - 10*2-7)/2,
          height: ((screen.screenWidth - 10*2-7)/2)*(182/201),

          child: videoItem.isRandomAd
              ? _buildAdImageItem(videoItem):VideoCellWidget(
            isShowVip: false,
            videoInfo2: videoItem,
            textLine: 2,
            imageWidth: (screen.screenWidth - 10*2-7)/2,
            imageHeight: ((screen.screenWidth - 10*2-7)/2)*(113/201),
          ),
        ),
      ),
      // VideoCellWidget(
      //         videoInfo2: videoItem,isShowVip: false,
      //         imageWidth: (screen.screenWidth - 10*2-7)/2,
      //         imageHeight: ((screen.screenWidth - 10*2-7)/2)*(113/201),
      //     ),
    );
  }


  Widget _buildAdImageItem(LiaoBaTagsDetailDataVideos videoItem) {
    return Container(
        width: (screen.screenWidth - 10*2-7)/2,
        height: ((screen.screenWidth - 10*2-7)/2)*(182/201),
        child: Column(
          children: [
            Stack(
              children: [
                CustomNetworkImage(
                  imageUrl: videoItem.randomAdsInfo.cover,
                  placeholder: Image(
                    image: AssetImage(AssetsImages.LOADING_HORIZONTAL_IMAGE),
                    width: (screen.screenWidth - 10*2-7)/2,
                    height: ((screen.screenWidth - 10*2-7)/2)*(113/201),
                    fit: BoxFit.fill,
                  ),
                  height: ((screen.screenWidth - 10*2-7)/2)*(113/201),
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 34,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(255, 235, 58, 1),
                        Color.fromRGBO(255, 235, 58, 1),
                      ]),
                    ),
                    child: Text(
                      "广告",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color.fromRGBO(0,0,0, 1),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.w),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                videoItem.randomAdsInfo.title,
                style: TextStyle(fontSize: 16.w, color: Colors.white),
                maxLines: 2,
              ),
            ),

          ],
        ));
  }

  Widget _buildVideoItem(LiaoBaTagsDetailDataVideos videoItem, int index) {
    return Container(
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
                          TimeHelper.getTimeText(videoItem.playTime.toDouble()),
                          style: TextStyle(color: Colors.white, fontSize: 10.w),
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
                      height: 22.w,
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
    );
  }
}
