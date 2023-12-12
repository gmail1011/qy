import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/widget/common_widget/load_more_footer.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    NearbyState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: Dimens.pt20),
        child: NotificationListener(
            onNotification: (ScrollNotification notification) {
              switch (notification.runtimeType) {
                case ScrollStartNotification:
                  break;
                case ScrollUpdateNotification:
                  if (notification.metrics.pixels < screen.displayHeight &&
                      state.showToTopBtn) {
                    dispatch(NearbyActionCreator.setIsShowTopBtn(false));
                  } else if (notification.metrics.pixels >=
                          screen.displayHeight &&
                      state.showToTopBtn == false) {
                    dispatch(NearbyActionCreator.setIsShowTopBtn(true));
                  }
                  break;
                case ScrollEndNotification:
                  break;
                case OverscrollNotification:
                  break;
              }
              return true;
            },
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      padding: CustomEdgeInsets.only(top: 4, bottom: 2),
                      height: Dimens.pt90,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: <Widget>[
                          Positioned(
                            bottom: Dimens.pt4,
                            left: Dimens.pt4,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                svgAssets(AssetsSvg.AUTO_LOCAL,
                                    width: Dimens.pt10, height: Dimens.pt11),
                                Padding(
                                  padding: EdgeInsets.only(left: Dimens.pt4),
                                  child: Text(
                                    state.city ?? '',
                                    style: TextStyle(
                                        color: Color(0xffbbbcbb),
                                        fontSize: Dimens.pt12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: Dimens.pt4,
                              right: Dimens.pt10,
                              child: GestureDetector(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(Lang.SWITCH_TAB,
                                        style: TextStyle(
                                            color: Color(0xffbbbcbb),
                                            fontSize: Dimens.pt12)),
                                    Padding(
                                        padding:
                                            EdgeInsets.only(left: Dimens.pt4),
                                        child:
                                            svgAssets(AssetsSvg.CITY_SWITCH)),
                                  ],
                                ),
                                onTap: () {
                                  //跳到城市选择界面
                                  dispatch(NearbyActionCreator.selectCity());
                                },
                              )),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: EasyRefresh(
                          controller: state.controller,
                          footer:
                              LoadMoreFooter(hasNext: state.hasNext ?? false),
                          header: MaterialHeader(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.black)),
                          onRefresh: () async {
                            //下拉刷新:拉下同上拉加载逻辑一样
                            if (state.hasNext ?? true) {
                              dispatch(NearbyActionCreator.onRefresh());
                            } else {
                              state.controller
                                  .finishRefresh(success: true, noMore: true);
                            }
                          },
                          onLoad: () async {
                            //上拉加载
                            if (state.hasNext ?? false) {
                              dispatch(NearbyActionCreator.loadMore());
                            } else {
                              state.controller
                                  .finishLoad(success: true, noMore: true);
                            }
                          },
                          child: StaggeredGridView.countBuilder(
                            controller: state.scrollController,
                            crossAxisCount: 2,
                            addAutomaticKeepAlives: true,
                            shrinkWrap: true,
                            itemCount: state.videoList.length,
                            itemBuilder: (BuildContext context, int index) {
                              //过滤空值为0的情况
                              var ratio = state.videoList[index]?.ratio ?? 1;
                              if (ratio == 0) {
                                ratio = 1;
                              }
                              return state.videoList[index] == null
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        dispatch(
                                            NearbyActionCreator.onItemClick(
                                                index));
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              Container(
                                                child: ClipRRect(
                                                  child: CustomNetworkImage(
                                                    imageUrl: state
                                                        .videoList[index].cover,
                                                    width: Dimens.pt177,
                                                    height:
                                                        (Dimens.pt190 / ratio) -
                                                            Dimens.pt45,
                                                    placeholder: assetsImg(
                                                      AssetsImages
                                                          .IC_DEFAULT_IMG,
                                                      width: Dimens.pt177,
                                                      height: (Dimens.pt190 /
                                                              ratio) -
                                                          Dimens.pt45,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.pt4),
                                                ),
                                                width: Dimens.pt177,
                                                height: (Dimens.pt190 / ratio) -
                                                    Dimens.pt45,
                                              ),
                                              Positioned(
                                                right: Dimens.pt2,
                                                bottom: Dimens.pt4,
                                                child: ClipOval(
                                                  child: CustomNetworkImage(
                                                    imageUrl: state
                                                            .videoList[index]
                                                            ?.publisher
                                                            ?.portrait ??
                                                        "",
                                                    placeholder: assetsImg(
                                                      AssetsImages
                                                          .USER_DEFAULT_AVATAR,
                                                      width: Dimens.pt30,
                                                      height: Dimens.pt30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    errorWidget: assetsImg(
                                                      AssetsImages
                                                          .USER_DEFAULT_AVATAR,
                                                      width: Dimens.pt30,
                                                      height: Dimens.pt30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    width: Dimens.pt30,
                                                    height: Dimens.pt30,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            margin:
                                                CustomEdgeInsets.only(top: 3),
                                            child: Text(
                                              state.videoList?.length == 0
                                                  ? ""
                                                  : state
                                                      .videoList[index]?.title,
                                              style: TextStyle(
                                                  color: Color(0xffbcbcbc),
                                                  fontSize: Dimens.pt12,
                                                  decoration:
                                                      TextDecoration.none),
                                              maxLines: 1,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                            },
                            staggeredTileBuilder: (int index) {
                              //过滤空值为0的情况
                              var ratio = state.videoList[index]?.ratio ?? 1;
                              if (ratio == 0) {
                                ratio = 1;
                              }
                              return new StaggeredTile.count(1, 1 / ratio);
                            },
                            mainAxisSpacing: 3.0,
                            crossAxisSpacing: 1.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                ///加载动画
                Offstage(
                  offstage: state.requestSuccess ? true : false,
                  child: LoadingWidget(),
                ),

                ///异常页面
                Offstage(
                  offstage: state.videoList.length == 0
                      ? (state.serverIsNormal ? true : false)
                      : true,
                  child: GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage(AssetsImages.IC_NO_DATA_NEARBY),
                          width: Dimens.pt190,
                          height: Dimens.pt190,
                        ),
                        Text(state.errorMsg,
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                    onTap: () {
                      dispatch(NearbyActionCreator.onRefresh());
                    },
                  ),
                ),

                //回到顶部
                state.showToTopBtn
                    ? Positioned(
                        right: Dimens.pt16,
                        bottom: screen.paddingBottom,
                        child: InkResponse(
                          splashColor: Colors.transparent,
                          child: svgAssets(
                              AssetsSvg.COMMUNITY_COMMUNITY_BACK_TOP,
                              width: Dimens.pt50,
                              height: Dimens.pt50),
                          onTap: () {
                            state.scrollController.animateTo(0.0,
                                duration: Duration(milliseconds: 50),
                                curve: Curves.easeIn);
                          },
                        ),
                      )
                    : Container()
              ],
            )),
      ),
    ),
  );
}
