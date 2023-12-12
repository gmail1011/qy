import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/anwang_trade/AnWangTradePage.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/weibo_page/community_change_ui.dart';
import 'package:flutter_app/weibo_page/community_recommend/hot_video/HotVideoDetailPage.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/guess_like_entity.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/weibo_page/widget/post_video_logic.dart';
import 'package:flutter_app/weibo_page/widget/wordImageWidget.dart';
import 'package:flutter_app/widget/YYMarquee.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart' as Gets;

import 'community_recommend_action.dart';
import 'community_recommend_state.dart';

Widget buildView(
    CommunityRecommendState state, Dispatch dispatch, ViewService viewService) {


  void _starPlay() {
    double offset = state.scrollController.offset;
    println("====offset===offset=====${offset}");
    println("====listMaxHeight===listMaxHeight=====${state.listMaxHeight}");
    double centerY =  offset+(state.listMaxHeight/2)-460;
    double caculteHeight = 0;
    for(int i = 0; i < (state.commonPostRes?.list?.length ?? 0); i++){
      VideoModel model = state.commonPostRes?.list[i];
      caculteHeight += 360;
      if(caculteHeight > centerY){
        PostVideoLogic.play(i);
        break;
      }
    }
  }

  void playVisiblePosition() {
    if(state.visiblePosition==-1){
      return;
    }
    PostVideoLogic.play(state.visiblePosition);
  }

  void _stopPlay() {
    PostVideoLogic.pauseAll();
  }

  return Listener(
      onPointerDown: (event){
        state.isScrolling = true;
        println("滑动===onPointerDown==");
      },
      onPointerMove: (event) {
        _stopPlay();
        println("滑动===onPointerMove==");
      },
      onPointerUp: (event) {
        state.isScrolling = false;
        // playVisiblePosition();
        println("滑动===onPointerUp==");
      },
      onPointerCancel: (event) {
        state.isScrolling = false;
        // playVisiblePosition();
        println("滑动===onPointerCancel==");
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollStartNotification) {
          } else if (notification is ScrollUpdateNotification) {
          } else if (notification is ScrollEndNotification) {
            print('结束滚动...');
            playVisiblePosition();
          }
          return false;
        },
      child: Container(
      color: AppColors.weiboBackgroundColor,
      child: pullYsRefresh(
        enableTwoLevel:true,
        canTwoLevelText:"松手进入暗网交易",
        onTwoLevel:(){
          Map<String, dynamic> maps = Map();
          Gets.Get.to(AnWangTradePage()).then((value) {
            state.refreshController.requestRefresh();
          });
        },
        refreshController: state.refreshController,
        onRefresh: () {
          dispatch(
              CommunityRecommendActionCreator.onLoadMore(state.pageNumber = 1));
        },
        onLoading: () {
          dispatch(
              CommunityRecommendActionCreator.onLoadMore(state.pageNumber += 1));
        },
        child: CustomScrollView(
          controller: state.scrollController,
          slivers: [
            (state.adsList==null || state.adsList.length==0)?SliverToBoxAdapter(
              child: SizedBox(),
            ):SliverPadding(
              padding: EdgeInsets.only(top: 0.w),
              sliver: SliverToBoxAdapter(
                child: AdsBannerWidget(
                  state.adsList,
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().screenWidth * 350 / 750,
                  onItemClick: (index) {
                    var ad = state.adsList[index];
                    JRouter().handleAdsInfo(ad.href, id: ad.id);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 40.w,
                width: ScreenUtil().screenWidth,
                color: AppColors.weiboJianPrimaryBackground,
                child: Row(
                  children: [
                    SizedBox(
                      width: 18.w,
                    ),
                    Image.asset(
                      "assets/weibo/lingdang.png",
                      width: 16.w,
                      height: 16.w,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text("活动公告 : ",
                        style: TextStyle(
                          fontSize: 14.nsp,
                          color: Colors.white,
                        )),
                    Expanded(
                      child: Container(
                        height: 40.w,
                        padding: EdgeInsets.only(
                          left: 6.w,
                          right: 16.w,
                        ),
                        child: YYMarquee(
                            Text(
                                state.announce == null
                                    ? " "
                                    : state.announce.toString(),
                                style: TextStyle(
                                  fontSize: 14.nsp,
                                  color: Colors.white,
                                )),
                            200,
                            new Duration(seconds: 5),
                            230.0,
                            keyName: "community_recommend"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.w)),
            if (state.commonPostResHotVideo?.list?.isNotEmpty == true && state.name.contains("最新")) ...[
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(left: 14, right: 12, bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        '热门作品',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimens.pt17,
                            fontWeight: FontWeight.w600),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          bus.emit(EventBusUtils.closeActivityFloating);

                          Map<String, dynamic> maps = Map();
                          maps['id'] = state.id;
                          Gets.Get.to(HotVideoDetailPage(state.id)).then((value) {
                            bus.emit(EventBusUtils.showActivityFloating);
                          });
                          //JRouter().go(HOMEPAGE_HOT_VIDEO_DETAIL, arguments: maps);
                        },
                        child: Text(
                          '更多',
                          style: TextStyle(
                            color: Color.fromRGBO(126, 160, 190, 1),
                            fontSize: Dimens.pt13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: Dimens.pt230,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.commonPostResHotVideo.list.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(left: index == 0 ? 14:0, right: 10),
                        child: GestureDetector(
                          onTap: () {
                            if (state
                                .commonPostResHotVideo.list[index].newsType ==
                                "SP") {
                              List<VideoModel> lists = [];

                              state.commonPostResHotVideo.list.forEach((element) {
                                lists.add(element);
                              });

                              //lists = state.commonPostResHotVideo.list;

                              //lists.insert(0, state.commonPostResHotVideo.list[index]);

                              Map<String, dynamic> maps = Map();
                              maps['pageNumber'] = 1;
                              maps['pageSize'] = 3;
                              maps['currentPosition'] = index;
                              maps['videoList'] = lists;
                              maps['tagID'] = state.commonPostResHotVideo
                                  .list[index].tags?.isNotEmpty == true
                                  ?state.commonPostResHotVideo.list[index]
                                  .tags[0].id
                                  : null;
                              maps['playType'] = VideoPlayConfig.VIDEO_POST;

                              maps['isNewListRequest'] = true;
                              maps['isNewListRequestId'] = state.id;

                              Config.isNewListRequest = true;

                              Config.isNewListRequestId = state.id;

                              bus.emit(EventBusUtils.closeActivityFloating);

                              Gets.Get.to(SubPlayListPage().buildPage(maps),
                                  opaque: false)
                                  .then((value) {
                                bus.emit(EventBusUtils.showActivityFloating);
                              });

                              return;
                            }
                            Map<String, dynamic> maps = Map();
                            maps["videoId"] =
                                state.commonPostResHotVideo.list[index].id;

                            bus.emit(EventBusUtils.closeActivityFloating);
                            Gets.Get.to(
                                    () => FilmTvVideoDetailPage().buildPage(maps),
                                opaque: false)
                                .then((value) {
                              bus.emit(EventBusUtils.showActivityFloating);
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                                child: CustomNetworkImage(
                                  imageUrl: state
                                      .commonPostResHotVideo.list[index].cover,
                                  width: Dimens.pt152,
                                  height: Dimens.pt190,
                                ),
                              ),
                              SizedBox(height: 6),
                              Container(
                                width: Dimens.pt152,
                                child: Text(
                                  state.commonPostResHotVideo.list[index].title,
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: Dimens.pt12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
            state.commonPostRes == null
                ? SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 200.w),
                child: LoadingWidget(),
              ),
            )
                : SliverList(//63f8678842cc1aa7fa13d0ac
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  VideoModel videoModel = state.commonPostRes.list[index];
                  if (videoModel.isRandomAd() && state.name.contains("最新")) {
                    AdsInfoBean adModel = videoModel.randomAdsInfo;
                    return Container(
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: InkWell(
                        onTap: () {
                          bus.emit(EventBusUtils.closeActivityFloating);

                          JRouter()
                              .handleAdsInfo(adModel.href, id: adModel.id);
                        },
                        child: CustomNetworkImage(
                          width: screen.screenWidth - 32.w,
                          height: (screen.screenWidth - 32.w) * 150 / 720,
                          fit: BoxFit.fill,
                          imageUrl: adModel.cover,
                        ),
                      ),
                    );
                  }

                  ///添加换一换类型
                  if (videoModel.newsType == NEWSTYPE_CHANGE_FUNC) {
                    return _buildChangeFuncUI(state, dispatch, videoModel.newsTypeIndex);
                  }

                  ///普通图文类型
                  return WordImageWidget(
                    videoModel: videoModel,
                    index: index,
                    autoPlayStyle: true,
                    visibleCallBack:(index){
                      state.visiblePosition = index;
                    },
                    hideCallBack: (index){
                      if(index ==  state.visiblePosition){
                        state.visiblePosition = -1;
                      }
                    },
                  );

                },
                childCount: (state.commonPostRes?.list?.length ?? 0),
                // addAutomaticKeepAlives: false,
              ),
            ),
          ],
        ),
      ),
     ),
    )

  );
}



///换一换UI
Widget _buildChangeFuncUI(
    CommunityRecommendState state, Dispatch dispatch, int changeDataIndex) {
  List<GuessLikeDataList> changeDataList =
      state.changeDataListMap[changeDataIndex];
  // if(changeDataList == null){
  //   changeDataList = state.changeDataListMap[changeDataIndex+1];
  // }
  // if(changeDataList == null){
  //   changeDataList = state.changeDataListMap[changeDataIndex-1];
  // }
  return ((changeDataList ?? []).isEmpty)
      ? Container()
      : CommunityChangeUI(
          changeDataList: changeDataList,
          changeDataIndex: changeDataIndex,
          onChangeTap: () {
            dispatch(CommunityRecommendActionCreator.getChangeDataListByIndex(changeDataIndex));
          },
          toBloggerTap: (item) async {
            Map<String, dynamic> arguments = {
              'uid': item?.uid,
              'uniqueId': DateTime.now().toIso8601String(),
            };

            bus.emit(EventBusUtils.closeActivityFloating);

            await Gets.Get.to(() => BloggerPage(arguments), opaque: false)
                .then((value) {
              bus.emit(EventBusUtils.showActivityFloating);
            });
            if (item?.hasFollow == false) {
              dispatch(CommunityRecommendActionCreator.checkFollowUser(
                  item?.uid, changeDataIndex));
            }
          },
          flollowTap: (uid) {
            // 自己不能关注自己
            if (GlobalStore.isMe(uid)) {
              showToast(msg: Lang.GLOBAL_TIP_TXT1);
              return;
            }
            dispatch(
                CommunityRecommendActionCreator.doFollow(changeDataIndex, uid));
          },
        );
}
