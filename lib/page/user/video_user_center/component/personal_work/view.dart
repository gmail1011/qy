import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/widget/common_widget/load_more_footer.dart';
import 'package:flutter_app/page/user/video_user_center/action.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_work/action.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_app/widget/common_widget/empty_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

import 'state.dart';

Widget buildView(
    UserWorkPostState state, Dispatch dispatch, ViewService viewService) {
  ListAdapter adapter = viewService.buildAdapter();
  return NotificationListener(
    onNotification: (notification) {
      switch (notification.runtimeType) {
        case ScrollStartNotification:
          viewService
              .broadcast(VideoUserCenterActionCreator.onShowFollowBtnUI(false));
          break;
        case ScrollEndNotification:
          viewService
              .broadcast(VideoUserCenterActionCreator.onShowFollowBtnUI(true));
          break;
        case ScrollUpdateNotification:
          if (notification.metrics.pixels < screen.displayHeight &&
              state.showToTopBtn) {
            state.showToTopBtn = false;
            viewService.broadcast(VideoUserCenterActionCreator.onIsShowTopBtn(
                state.showToTopBtn));
          } else if (notification.metrics.pixels >= screen.displayHeight &&
              !state.showToTopBtn) {
            state.showToTopBtn = true;
            viewService.broadcast(VideoUserCenterActionCreator.onIsShowTopBtn(
                state.showToTopBtn));
          }
          break;
      }
      return true;
    },
    child: Container(
      child: !state.loadComplete
          ? Container(
              child: Center(
              child: LoadingWidget(),
            ))
          : EasyRefresh.custom(
              controller: state.controller,
              topBouncing: false,
              //emptyWidget: state.videoList.length != 0 ? null : EmptyWidget('user', 0),
              footer: LoadMoreFooter(hasNext: state.hasNext ?? false),
              onLoad: () async {
                if (state.hasNext ?? false) {
                  dispatch(UserWorkPostActionCreator.onLoadData());
                }
              },
              slivers: <Widget>[
                /*SliverPadding(
                  padding: EdgeInsets.only(left: AppPaddings.appMargin,right: AppPaddings.appMargin,top: Dimens.pt10),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.58, //子控件宽高比
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return adapter.itemBuilder(context, index);
                    }, childCount: adapter.itemCount),
                  ),
                ),*/





                SliverStaggeredGrid.countBuilder(
                  crossAxisCount: 4,
                  itemCount: adapter.itemCount,
                  staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  itemBuilder: ((context, index) {
                    /*return FrameSeparateWidget(
                      index: index,
                      child: GestureDetector(
                        onTap: () {
                          List<VideoModel> lists = [];

                          state.works.list.forEach((element) {
                            VideoModel video =
                            VideoModel.fromJson(element.toJson());
                            lists.add(video);
                          });

                          Map<String, dynamic> maps = Map();
                          maps['pageNumber'] = 1;
                          maps['pageSize'] = 3;
                          maps['currentPosition'] = index;
                          maps['videoList'] = lists;
                          maps['tagID'] = lists[0].tags[0].id;
                          maps['playType'] = VideoPlayConfig.VIDEO_TAG;
                          JRouter().go(SUB_PLAY_LIST, arguments: maps);
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Stack(
                                alignment: AlignmentDirectional.bottomCenter,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: state.works.list[index].cover,
                                    fit: BoxFit.cover,
                                    cacheManager: ImageCacheManager(),
                                    placeholder: (context, url) {
                                      return placeHolder(
                                          ImgType.cover, null, Dimens.pt280);
                                    },
                                  ),
                                  Container(
                                    height: Dimens.pt24,
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.black54,
                                            Colors.transparent
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: Dimens.pt4,
                                          right: Dimens.pt4,
                                          bottom: Dimens.pt4),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                  "assets/images/play_icon.png",
                                                  width: Dimens.pt11,
                                                  height: Dimens.pt11),
                                              SizedBox(
                                                width: Dimens.pt4,
                                              ),
                                              Text(
                                                state.works.list[index].playCount >
                                                    10000
                                                    ? (state.works.list[index]
                                                    .playCount /
                                                    10000)
                                                    .toStringAsFixed(1) +
                                                    "w"
                                                    : state
                                                    .works.list[index].playCount
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: Dimens.pt12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            TimeHelper.getTimeText(state
                                                .works.list[index].playTime
                                                .toDouble()),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimens.pt12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: -1,
                                      right: -1,
                                      child: Visibility(
                                        visible:
                                        state.works.list[index].originCoins !=
                                            null &&
                                            state.works.list[index]
                                                .originCoins !=
                                                0
                                            ? true
                                            : false,
                                        child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                //height: Dimens.pt20,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft:
                                                      Radius.circular(4)),
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color.fromRGBO(
                                                          245, 22, 78, 1),
                                                      Color.fromRGBO(
                                                          255, 101, 56, 1),
                                                      Color.fromRGBO(
                                                          245, 68, 4, 1),
                                                    ],
                                                    begin: Alignment
                                                        .centerLeft,
                                                    end: Alignment
                                                        .centerRight,
                                                  ),
                                                ),
                                                padding: EdgeInsets.only(
                                                  left: Dimens.pt4,
                                                  right: Dimens.pt7,
                                                  top: Dimens.pt2,
                                                  bottom: Dimens.pt2,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    ImageLoader.withP(
                                                        ImageType.IMAGE_SVG,
                                                        address:
                                                        AssetsSvg.IC_GOLD,
                                                        width: Dimens.pt12,
                                                        height: Dimens.pt12)
                                                        .load(),
                                                    SizedBox(width: Dimens.pt4),
                                                    Text(
                                                        state.works.list[index]
                                                            .originCoins
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .textColorWhite,
                                                          fontSize: Dimens.pt12,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      )),
                                  Positioned(
                                      top: -1,
                                      right: -1,
                                      child: Visibility(
                                        visible:
                                        state.works.list[index].originCoins == 0
                                            ? true
                                            : false,
                                        child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                //height: Dimens.pt20,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft:
                                                      Radius.circular(4)),
                                                  color: Color.fromRGBO(
                                                      255, 0, 169, 1),
                                                ),
                                                padding: EdgeInsets.only(
                                                  left: Dimens.pt10,
                                                  right: Dimens.pt10,
                                                  top: Dimens.pt2,
                                                  bottom: Dimens.pt2,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "VIP",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Dimens.pt3,
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  state.works.list[index].title,
                                  maxLines: 1,
                                  style: TextStyle(color: Colors.white),
                                )),
                            SizedBox(
                              height: Dimens.pt4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipOval(
                                      child: CustomNetworkImage(
                                        imageUrl: state
                                            .works.list[index].publisher.portrait,
                                        type: ImgType.cover,
                                        height: Dimens.pt20,
                                        width: Dimens.pt20,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: Dimens.pt4,
                                    ),
                                    Container(
                                      width: Dimens.pt66,
                                      child: Text(
                                        state.works.list[index].publisher.name,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimens.pt10,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      state.works.list[index].likeCount > 10000
                                          ? (state.works.list[index].likeCount /
                                          10000)
                                          .toStringAsFixed(1) +
                                          "w"
                                          : state.works.list[index].likeCount
                                          .toString(),
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Dimens.pt10,
                                      ),
                                    ),
                                    SizedBox(
                                      width: Dimens.pt4,
                                    ),
                                    SvgPicture.asset("assets/svg/heart.svg"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );*/

                    return adapter.itemBuilder(context, index);
                  }),
                ),


              ],
            ),
    ),
  );
}
