import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/video/video_publish/state.dart';
import 'package:flutter_app/widget/common_widget/empty_widget.dart';
import 'package:flutter_app/widget/common_widget/load_more_footer.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'sexy_plaza_action.dart';
import 'sexy_plaza_state.dart';

Widget buildView(
    SexyPlazaState state, Dispatch dispatch, ViewService viewService) {
  ListAdapter adapter = viewService.buildAdapter();

  Widget bannerWidget = ClipRRect(
    borderRadius: BorderRadius.all(Radius.circular(6)),
    child: AdsBannerWidget(
      state.adsList,
      width: Dimens.pt360,
      //height: Dimens.pt250,
      height: Dimens.pt180,
      onItemClick: (index) {
        var ad = state.adsList[index];
        JRouter().handleAdsInfo(ad.href, id: ad.id);
        /*eagleClick(state.selfId(),
            sourceId: state.eagleId(viewService.context),
            label: "banner(${ad?.id ?? ""})");*/
      },
    ),
  );


  return NestedScrollView(
    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      // 返回一个 Sliver 数组给外部可滚动组件。
      return <Widget>[
        SliverAppBar(
          //floating: true,
          // snap: true,
          pinned: false,
          // stretch: true,
          automaticallyImplyLeading: false,
          expandedHeight: Dimens.pt180,
          flexibleSpace: FlexibleSpaceBar(
            // title: contain,
            background: StatefulBuilder(
              builder: (contexts, setStates) {
                return Container(
                    margin: EdgeInsets.only(
                      left: AppPaddings.appMargin,
                      right: AppPaddings.appMargin,
                      bottom: AppPaddings.appMargin,
                    ),
                    child: bannerWidget);
              },
            ),
          ),
        ),
      ];
    },
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: AppPaddings.appMargin,
              right: AppPaddings.appMargin,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    await JRouter().go(PAGE_SPECIAL);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(91, 94, 124, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: EdgeInsets.only(
                        left: Dimens.pt12,
                        right: Dimens.pt12,
                        top: Dimens.pt6,
                        bottom: Dimens.pt6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        SizedBox(
                          width: Dimens.pt6,
                        ),
                        Text(
                          "搜视频，搜用户，搜话题",
                          style: TextStyle(
                              fontSize: Dimens.pt14,
                              color: Colors.white.withOpacity(0.7)),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var agree = await JRouter().go(PAGE_UPLOAD_RULE);
                    if(agree == null) {
                      agree = await lightKV.getBool(Config.VIEW_UPLOAD_RULE);
                    }
                    if (agree) {
                      Map<String, dynamic> map = {'type': UploadType.UPLOAD_IMG};
                      await JRouter().go(VIDEO_PUBLISH, arguments: map);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(91, 94, 124, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: EdgeInsets.only(
                        left: Dimens.pt12,
                        right: Dimens.pt12,
                        top: Dimens.pt6,
                        bottom: Dimens.pt6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "我要发帖",
                          style: TextStyle(
                              fontSize: Dimens.pt14,
                              color: Colors.white.withOpacity(0.7)),
                        ),
                        SizedBox(
                          width: Dimens.pt3,
                        ),
                        Icon(
                          Icons.add_circle_outline,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Dimens.pt10,
          ),
          adapter.itemCount == 0
              ? Container(
            height: Dimens.pt200,
            child: LoadingWidget(),
          )
              : Expanded(
            child: EasyRefresh.custom(
              controller: state.controller,
              footer: LoadMoreFooter(hasNext: state.hasNext ?? false),
              emptyWidget: state.videoList.length != 0
                  ? null
                  : EmptyWidget('user', 0),
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    adapter.itemBuilder,
                    /* (context,index){
                         return ;
                      },*/
                    childCount: adapter.itemCount,
                  ),
                ),
              ],
              onLoad: () async {
                if (state.hasNext ?? false) {
                  dispatch(SexyPlazaActionCreator.onLoadMore(state.pageNum += 1));
                }
              },
            ),
          ),
        ],
      ),
  );

  /*return Container(
    child: Column(
      children: [
        Container(
            margin: EdgeInsets.only(
              left: AppPaddings.appMargin,
              right: AppPaddings.appMargin,
            ),
            child: bannerWidget),
        SizedBox(
          height: Dimens.pt16,
        ),
        Container(
          margin: EdgeInsets.only(
            left: AppPaddings.appMargin,
            right: AppPaddings.appMargin,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () async {
                  await JRouter().go(PAGE_SPECIAL);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(91, 94, 124, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: EdgeInsets.only(
                      left: Dimens.pt12,
                      right: Dimens.pt12,
                      top: Dimens.pt6,
                      bottom: Dimens.pt6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      SizedBox(
                        width: Dimens.pt6,
                      ),
                      Text(
                        "搜视频，搜用户，搜话题",
                        style: TextStyle(
                            fontSize: Dimens.pt14,
                            color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  var agree = await JRouter().go(PAGE_UPLOAD_RULE);

                  if (agree) {
                    Map<String, dynamic> map = {'type': UploadType.UPLOAD_IMG};
                    await JRouter().go(VIDEO_PUBLISH, arguments: map);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(91, 94, 124, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: EdgeInsets.only(
                      left: Dimens.pt12,
                      right: Dimens.pt12,
                      top: Dimens.pt6,
                      bottom: Dimens.pt6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "我要发帖",
                        style: TextStyle(
                            fontSize: Dimens.pt14,
                            color: Colors.white.withOpacity(0.7)),
                      ),
                      SizedBox(
                        width: Dimens.pt3,
                      ),
                      Icon(
                        Icons.add_circle_outline,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: Dimens.pt10,
        ),
        adapter.itemCount == 0
            ? Container(
                height: Dimens.pt200,
                child: LoadingWidget(),
              )
            : Expanded(
                child: EasyRefresh.custom(
                  controller: state.controller,
                  footer: LoadMoreFooter(hasNext: state.hasNext ?? false),
                  emptyWidget: state.videoList.length != 0
                      ? null
                      : EmptyWidget('user', 0),
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        adapter.itemBuilder,
                        *//* (context,index){
                         return ;
                      },*//*
                        childCount: adapter.itemCount,
                      ),
                    ),
                  ],
                  onLoad: () async {
                    if (state.hasNext ?? false) {
                      dispatch(SexyPlazaActionCreator.onLoadMore(state.pageNum += 1));
                    }
                  },
                ),
              ),
      ],
    ),
  );*/
}
