import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/city/city_video/city_movie_page.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/video_cell_widget.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidget.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/page/city/city_video/action.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;

import 'state.dart';

Widget buildView(
    CityVideoState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    backgroundColor: AppColors.weiboBackgroundColor,
    appBar: AppBar(
      leading: IconButton(
        icon: svgAssets(AssetsSvg.USER_IC_USER_BTN_BACK,
            width: Dimens.pt30, height: Dimens.pt32),
        onPressed: () {
          safePopPage();
        },
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 18.w),
          child: GestureDetector(
              onTap: () {
                showShareVideoDialog(viewService.context, () async {
                  await Future.delayed(Duration(milliseconds: 500));
                },
                    videoModel: new VideoModel()
                      ..cover = state.cityDetailModel.cover
                      ..title = "网黄up的分享平台,随时随地发现性鲜事",
                    topicName: state.cityDetailModel.city,
                    isLongVideo: false);
              },
              child: Icon(
                Icons.share,
                color: Colors.white,
                size: 24,
              )),
        ),
      ],
    ),
    body: state.cityDetailModel == null
        ? LoadingWidget()
        : Container(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                      child: CustomNetworkImage(
                        fit: BoxFit.cover,
                        height: 64.w,
                        width: 64.w,
                        imageUrl: state.cityDetailModel.cover,
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "#${state.cityDetailModel.city}",
                          style:
                              TextStyle(color: Colors.white, fontSize: 20.nsp),
                        ),
                        SizedBox(
                          height: 15.w,
                        ),
                        Text(
                          "有${getShowCountStr(state.cityDetailModel.visit)}人来过",
                          style: TextStyle(
                              color: Color.fromRGBO(124, 135, 159, 1),
                              fontSize: 15.nsp),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.w,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: commonTabBar(
                    TabBar(
                      isScrollable: true,
                      controller: state.tabController,
                      tabs: Lang.CITY_TABS
                          .map(
                            (e) => Text(
                              e,
                              style: TextStyle(fontSize: 18.nsp),
                            ),
                          )
                          .toList(),
                      indicator: RoundUnderlineTabIndicator(
                        borderSide: BorderSide(
                          color: AppColors.weiboColor,
                          width: 3,
                        ),
                      ),
                      indicatorWeight: 4,
                      unselectedLabelColor: Color.fromRGBO(115, 122, 139, 1),
                      labelColor: Colors.white,
                      labelStyle: TextStyle(fontSize: 18.nsp),
                      unselectedLabelStyle: TextStyle(fontSize: 18.nsp),
                      labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
                    ),
                  ),
                ),
                SizedBox(height: 8.w),
                Expanded(
                  child: TabBarView(
                    controller: state.tabController,
                    children: [
                      _buildDouYinView(state, dispatch, viewService),
                      _buildTextPictureView(state, dispatch, viewService),
                      CityMoviePage(city: state.city),
                    ],
                  ),
                ),
              ],
            ),
          ),
  );
}

Widget _buildDouYinView(
    CityVideoState state, Dispatch dispatch, ViewService viewService) {
  if (state.nearbyBean == null) {
    return LoadingWidget();
  } else {
    if (state.nearbyBean.vInfo == null || state.nearbyBean.vInfo.length == 0) {
      return CErrorWidget("暂无数据");
    }
    return pullYsRefresh(
      refreshController: state.refreshController,
      enablePullDown: false,
      enablePullUp: true,
      onRefresh: () {
        dispatch(CityVideoActionCreator.onMovieLoadMore(state.pageNumber = 1));
      },
      onLoading: () {
        dispatch(CityVideoActionCreator.onMovieLoadMore(state.pageNumber += 1));
      },
      child: GridView.builder(
        padding: EdgeInsets.only(top: 6.w),
        itemCount: state.nearbyBean.vInfo.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //横向数量
          crossAxisSpacing: 10, //间距
          mainAxisSpacing: 10, //行距
          childAspectRatio: 191.w / 313.w,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Map<String, dynamic> maps = Map();
              maps['pageNumber'] = 1;
              maps['pageSize'] = 3;
              maps['currentPosition'] = index;
              maps['videoList'] = state.nearbyBean.vInfo;
              maps['tagID'] = state.nearbyBean.vInfo[0].tags[0].id ?? null;
              maps['playType'] = VideoPlayConfig.VIDEO_TAG;

              Gets.Get.to(SubPlayListPage().buildPage(maps), opaque: false);
            },
            child: VideoCellWidget(textLine: 1,videoModel: state.nearbyBean.vInfo[index]),
          );
        },
      ),
    );
  }
}

Widget _buildTextPictureView(
    CityVideoState state, Dispatch dispatch, ViewService viewService) {
  if (state.nearbyCoverBean == null) {
    return LoadingWidget();
  } else {
    if (state.nearbyCoverBean.vInfo == null ||
        state.nearbyCoverBean.vInfo.length == 0) {
      return CErrorWidget("暂无数据");
    }
    return pullYsRefresh(
      refreshController: state.refreshCoverController,
      enablePullDown: false,
      enablePullUp: true,
      onRefresh: () {
        dispatch(
            CityVideoActionCreator.onCoverLoadMore(state.pageCoverNumber = 1));
      },
      onLoading: () {
        dispatch(
            CityVideoActionCreator.onCoverLoadMore(state.pageCoverNumber += 1));
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 6.w,
            ),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return WordImageWidget(
                key: UniqueKey(),
                videoModel: state.nearbyCoverBean.vInfo[index],
                index: index,
              );
            }, childCount: state.nearbyCoverBean.vInfo.length),
          ),
        ],
      ),
    );
  }
}
