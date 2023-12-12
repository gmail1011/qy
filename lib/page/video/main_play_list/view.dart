import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    MainPlayerListState state, Dispatch dispatch, ViewService viewService) {
  ListAdapter adapter = viewService.buildAdapter();
  Widget adsWidget = state.adsInfoBean == null
      ? Container()
      : state.isShowBigAds
          ? Container(
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                      onTap: () async {
                        autoPlayModel.disposeAll();
                        await JRouter().handleAdsInfo(state.adsInfoBean.href,
                            id: state.adsInfoBean.id);
                        autoPlayModel.startAvailblePlayer();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: Dimens.pt5,
                            top: screen.topDistanceH + Dimens.pt26),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CustomNetworkImage(
                            width: Dimens.pt80,
                            height: Dimens.pt80,
                            placeholder: Container(
                              color: Color(0x0),
                              width: Dimens.pt80,
                              height: Dimens.pt80,
                            ),
                            imageUrl: state.adsInfoBean.cover,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )),
                  Positioned(
                    right: Dimens.pt2,
                    top: screen.topDistanceH + Dimens.pt24,
                    child: GestureDetector(
                      onTap: () {
                        dispatch(
                            MainPlayerListActionCreator.configAdsStatus(false));
                      },
                      child: svgAssets(AssetsSvg.CLOSE_BTN,
                          width: Dimens.pt15, height: Dimens.pt15),
                    ),
                  )
                ],
              ),
            )
          : GestureDetector(
              onTap: () {
                dispatch(MainPlayerListActionCreator.configAdsStatus(true));
              },
              child: Padding(
                padding: EdgeInsets.only(
                    left: Dimens.pt5, top: screen.topDistanceH + Dimens.pt10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomNetworkImage(
                    width: Dimens.pt15,
                    height: Dimens.pt100,
                    placeholder: Container(
                      color: Color(0x0),
                      width: Dimens.pt15,
                      height: Dimens.pt100,
                    ),
                    imageUrl: state.adsInfoBean.cover,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
  Widget _getEmptyWidget(MainPlayerListState state) {
    if (state.type == VideoListType.FOLLOW) {
      return Center(
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(Lang.NO_FOLLOW_TITLE,
                  style: TextStyle(color: Colors.white, fontSize: Dimens.pt15)),
              Padding(
                padding: EdgeInsets.only(top: Dimens.pt5),
                child: Text(Lang.NO_FOLLOW_CONTENT,
                    style: TextStyle(
                        color: Color(0xff808080), fontSize: Dimens.pt12)),
              )
            ],
          ),
          onTap: () => dispatch(MainPlayerListActionCreator.refreshData()),
        ),
      );
    } else {
      return Center(
        child: LoadingWidget(),
      );
    }
  }

  return FullBg(
    child: Stack(
      children: <Widget>[
        Scaffold(
          body: ArrayUtil.isEmpty(state.videoList)
              ? _getEmptyWidget(state)
              : RefreshIndicator(
                  onRefresh: () async {
                    dispatch(MainPlayerListActionCreator.refreshData());
                  },
                  child: PageView.builder(
                    onPageChanged: (int index) {
                      if (index == state.curIndex) return;
                      state.curIndex = index;
                      dispatch(
                          MainPlayerListActionCreator.setAutoPlayIndex(index));
                      eagleClick(state.selfId(),
                          sourceId: state.eagleId(viewService.context),
                          label: state.type.toString());

                      state.videoListModel.onItemChange(index);
                      if (state.videoList.length - index <= 6) {
                        dispatch(MainPlayerListActionCreator.loadMoreData());
                      }
                    },
                    physics: ClampingScrollPhysics(),
                    controller: state.pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: adapter.itemCount,
                    itemBuilder: adapter.itemBuilder,
                  )),
        ),

        ///去掉顶部的悬浮广告
        adsWidget
      ],
    ),
  );
}
