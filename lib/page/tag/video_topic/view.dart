import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/model/special_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/tag/video_topic/action.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_app/widget/video_time_view.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:get/route_manager.dart' as Gets;

import 'state.dart';

/// 专题页
Widget buildView(
    VideoTopicState state, Dispatch dispatch, ViewService viewService) {
  ///主体
  return FullBg(
    child: GestureDetector(
      onTap: () {
        FocusScope.of(viewService.context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: ((state.adsList?.length ?? 0) != 0),
              child: AdsBannerWidget(
                state.adsList,
                width: Dimens.pt360,
                height: Dimens.pt180,
              ),
            ),
            Expanded(
              child: BaseRequestView(
                controller: state.baseRequestController,
                child: pullYsRefresh(
                  refreshController: state.refreshController,
                  child: ListView.builder(
                    shrinkWrap: true,
                    //是否应该由正在查看的内容确定scrollDirection中滚动视图的范围
                    itemCount: state.list?.length ?? 0,
                    itemBuilder: (context, index) {
                      var item = state.list[index];
                      //todo 判断展示正常UI 还是配置背景图片UI
                      /* return index > 1
                          ? itemView(item, dispatch, viewService)
                          : _getVideoItemUI(index, item, dispatch, viewService);*/

                      return itemView(item, dispatch, viewService);
                    },
                  ),
                  onLoading: () {
                    dispatch(VideoTopicActionCreator.loadMoreData());
                  },
                  onRefresh: () {
                    dispatch(VideoTopicActionCreator.loadData());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

///获取视频item UI
Widget _getVideoItemUI(
    int index, ListBeanSp item, Dispatch dispatch, ViewService viewService) {
  return Stack(
    children: [
      itemView(item, dispatch, viewService,
          appMainTop: Dimens.pt30, showNormalTitle: false),
      _getSpecialHeaderUI(index, item),
    ],
  );
}

//todo 配置背景图片
//AssetsImages.BG_GOLD_COIN
//AssetsImages.BG_OFFICIAL
///获取特别header UI
Widget _getSpecialHeaderUI(index, item) {
  String tagName = item.tagName.length > 2 ? item.tagName : item.tagName + "專區";
  return Stack(
    children: [
      Container(
        padding: EdgeInsets.only(left: AppPaddings.appMargin),
        child: assetsImg(
            index == 0 ? AssetsImages.BG_PURPLE : AssetsImages.BG_OFFICIAL,
            width: Dimens.pt150),
      ),
      Container(
        padding: EdgeInsets.only(left: Dimens.pt32),
        alignment: Alignment.center,
        width: Dimens.pt150,
        height: Dimens.pt60,
        child: Text(tagName,
            style: TextStyle(
                color: Colors.white,
                fontSize: AppFontSize.fontSize26,
                fontWeight: FontWeight.w400,
                fontFamily: "HYZhuZiMeiXinTiW")),
      ),
    ],
  );
}

///获取item UI
Widget itemView(ListBeanSp item, Dispatch dispatch, ViewService viewService,
    {double appMainTop = 16, bool showNormalTitle = true}) {
  var list = item.vidInfo;

  ///改版了
  /*if (item.vidInfo.length > 3) {
    list = item.vidInfo.sublist(0, 3);
  }*/
  String tagDesc = item.tagDesc != null && item.tagDesc.isNotEmpty
      ? " - ${item.tagDesc}"
      : "";
  return Container(
    padding: EdgeInsets.only(
        left: AppPaddings.appMargin,
        //top: appMainTop,
        right: AppPaddings.appMargin,
        bottom: AppPaddings.appMargin),
    child: Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.0)),
          child: Column(
            children: [
              /*GestureDetector(
                onTap: () {
                  dispatch(VideoTopicActionCreator.onTagClick(item));
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(top: Dimens.pt6, left: Dimens.pt10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: Dimens.pt220,
                        child: Text(
                          showNormalTitle
                              ? (item.tagName + tagDesc)
                              : "",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: AppFontSize.fontSize20,
                              fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xFFF5164E),
                              Color(0xFFFF6538),
                              Color(0xFFF54404)
                            ]),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: Dimens.pt6,
                                  offset: Offset(0, 6),
                                  color: Color.fromRGBO(248, 44, 44, 0.4))
                            ],
                            borderRadius: BorderRadius.circular(6.0)),
                        padding: EdgeInsets.only(left: Dimens.pt8),
                        margin: EdgeInsets.only(right: Dimens.pt10),
                        child: Row(
                          children: [
                            Text(
                              Lang.MORE,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFontSize.fontSize10),
                            ),
                            Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: screen.screenWidth,
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: Dimens.pt5, left: Dimens.pt5, right: Dimens.pt5),
                  child: Row(
                    children: list
                        .map((e) => getBodyItem(e, () {
                              Map<String, dynamic> maps = Map();
                              maps['pageNumber'] = 1;
                              maps['pageSize'] = 3;
                              maps['currentPosition'] = item.vidInfo.indexOf(e);
                              maps['videoList'] = item.vidInfo;
                              maps['tagID'] = item.tagId;
                              maps['playType'] = VideoPlayConfig.VIDEO_TAG;
                              JRouter().go(SUB_PLAY_LIST, arguments: maps);
                            }))
                        .toList(),
                  ),
                ),
              ),*/

              GestureDetector(
                onTap: () {
                  dispatch(VideoTopicActionCreator.onTagClick(item));
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(top: Dimens.pt6, left: Dimens.pt6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: Dimens.pt220,
                        child: Text(
                          (item.tagName + tagDesc),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSize.fontSize16,
                              fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        /*decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0xFFF5164E),
                              Color(0xFFFF6538),
                              Color(0xFFF54404)
                            ]),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: Dimens.pt6,
                                  offset: Offset(0, 6),
                                  color: Color.fromRGBO(248, 44, 44, 0.4))
                            ],
                            borderRadius: BorderRadius.circular(6.0)),*/
                        padding: EdgeInsets.only(left: Dimens.pt8),
                        margin: EdgeInsets.only(right: Dimens.pt10),
                        child: Row(
                          children: [
                            Text(
                              Lang.MORE,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFontSize.fontSize10),
                            ),
                            Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )
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
        GestureDetector(
          onTap: () {
            Map<String, dynamic> maps = Map();
            maps['pageNumber'] = 1;
            maps['pageSize'] = 3;
            maps['currentPosition'] = 0;
            maps['videoList'] = item.vidInfo;
            maps['tagID'] = item.tagId;
            maps['playType'] = VideoPlayConfig.VIDEO_TAG;
            if (isHorizontalVideo(
                resolutionWidth(item.vidInfo[0].resolution),
                resolutionHeight(item.vidInfo[0].resolution))) {
              Gets.Get.to(() =>VideoPage(item.vidInfo[0]),opaque: false);
            } else {
              Gets.Get.to(() =>SubPlayListPage().buildPage(maps), opaque: false);
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                CustomNetworkImage(
                  imageUrl: list[0].cover,
                  type: ImgType.cover,
                  height: Dimens.pt180,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: Dimens.pt40,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black54, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: Dimens.pt10,
                        right: Dimens.pt10,
                        bottom: Dimens.pt10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/images/play_icon.png",
                                width: Dimens.pt11, height: Dimens.pt11),
                            SizedBox(
                              width: Dimens.pt4,
                            ),
                            Text(
                              list[0].playCount > 10000 ? (list[0].playCount / 10000).toStringAsFixed(1) + "w": list[0].playCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Dimens.pt12,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          TimeHelper.getTimeText(
                              item.vidInfo[0].playTime.toDouble()),
                          style: TextStyle(
                              color: Colors.white, fontSize: Dimens.pt12),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -1,
                    right: -1,
                    child: Visibility(
                      visible: list[0].originCoins != null && list[0].originCoins != 0 ? true : false,
                      child: Stack(alignment: Alignment.center, children: [
                        Container(
                          //height: Dimens.pt20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(4)),
                            //color: Color.fromRGBO(255, 0, 169, 1),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(245, 22, 78, 1),
                                Color.fromRGBO(255, 101, 56, 1),
                                Color.fromRGBO(245, 68, 4, 1),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          padding: EdgeInsets.only(left: Dimens.pt8,right: Dimens.pt8,top: Dimens.pt3,bottom: Dimens.pt3,),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ImageLoader.withP(ImageType.IMAGE_SVG,
                                      address: AssetsSvg.IC_GOLD,
                                      width: Dimens.pt12,
                                      height: Dimens.pt12)
                                  .load(),
                              SizedBox(width: Dimens.pt6),
                              Text(
                                  list[0].originCoins.toString(),
                                  style: TextStyle(
                                      color: AppColors.textColorWhite)),
                            ],
                          ),
                        ),
                      ]),
                    )),
              ],
            ),
          ),
        ),
        SizedBox(
          height: Dimens.pt8,
        ),
        Container(
            alignment: Alignment.centerLeft,
            child: Text(
              list[0].title,
              style: TextStyle(color: Colors.white),
            )),
        SizedBox(
          height: Dimens.pt8,
        ),
        Container(
          height: Dimens.pt294,
          child: MediaQuery.removePadding(
            removeTop: true,
            context: viewService.context,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 4.0,
                  childAspectRatio: 1.15),
              itemCount: list.length - 1,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Map<String, dynamic> maps = Map();
                    maps['pageNumber'] = 1;
                    maps['pageSize'] = 3;
                    maps['currentPosition'] = index + 1;
                    maps['videoList'] = item.vidInfo;
                    maps['tagID'] = item.tagId;
                    maps['playType'] = VideoPlayConfig.VIDEO_TAG;
                    if (isHorizontalVideo(
                        resolutionWidth(item.vidInfo[index + 1].resolution),
                        resolutionHeight(item.vidInfo[index + 1].resolution))) {
                      Gets.Get.to(() =>VideoPage(item.vidInfo[index + 1]),opaque: false);
                    } else {
                      Gets.Get.to(() =>SubPlayListPage().buildPage(maps), opaque: false);
                    }
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            CustomNetworkImage(
                              imageUrl: list[index + 1].cover,
                              type: ImgType.cover,
                              height: Dimens.pt100,
                              fit: BoxFit.cover,
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
                                    left: Dimens.pt10,
                                    right: Dimens.pt10,
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
                                          list[1 + index].playCount > 10000 ? (list[1 + index].playCount / 10000).toStringAsFixed(1) + "w" : list[1 + index].playCount.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Dimens.pt12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      TimeHelper.getTimeText(
                                          list[1 + index].playTime.toDouble()),
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
                                  visible: list[1 + index].originCoins != null && list[1 + index].originCoins != 0 ? true : false,
                                  child: Stack(alignment: Alignment.center, children: [
                                    Container(
                                      //height: Dimens.pt20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(4)),
                                        //color: Color.fromRGBO(255, 0, 169, 1),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromRGBO(245, 22, 78, 1),
                                            Color.fromRGBO(255, 101, 56, 1),
                                            Color.fromRGBO(245, 68, 4, 1),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                      padding: EdgeInsets.only(left: Dimens.pt4,right: Dimens.pt7,top: Dimens.pt2,bottom: Dimens.pt2,),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ImageLoader.withP(ImageType.IMAGE_SVG,
                                              address: AssetsSvg.IC_GOLD,
                                              width: Dimens.pt12,
                                              height: Dimens.pt12)
                                              .load(),
                                          SizedBox(width: Dimens.pt4),
                                          Text(
                                              list[1 + index].originCoins.toString(),
                                              style: TextStyle(
                                                  color: AppColors.textColorWhite,fontSize: Dimens.pt12,)),
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
                            list[1 + index].title,
                            maxLines: 2,
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        /*Container(
           height: Dimens.pt140,
           child: Row(
             children: [
                Container(
                  //width: Dimens.pt130,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CustomNetworkImage(
                          imageUrl: list[1].cover,
                          type: ImgType.cover,
                          height: Dimens.pt180,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Text(list[1].title,style: TextStyle(color: Colors.white),),
                    ],
                  ),
                ),

               SizedBox(
                 width: Dimens.pt8,
               ),


               Container(
                 //width: Dimens.pt130,
                 child: Column(
                   children: [
                     ClipRRect(
                       borderRadius: BorderRadius.circular(10.0),
                       child: CustomNetworkImage(
                         imageUrl: list[1].cover,
                         type: ImgType.cover,
                         height: Dimens.pt180,
                         fit: BoxFit.cover,
                       ),
                     ),

                     Text(list[1].title,style: TextStyle(color: Colors.white),),
                   ],
                 ),
               ),
             ],
           ),
         ),*/
      ],
    ),
  );
}

///图片UI
Widget getBodyItem(VideoModel item, VoidCallback onTap) {
  return Expanded(
    flex: 1,
    child: Container(
      padding: EdgeInsets.only(
          top: Dimens.pt12,
          left: Dimens.pt5,
          right: Dimens.pt5,
          bottom: Dimens.pt2),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: Dimens.pt5,
                            offset: Offset(0, 2),
                            color: Color.fromRGBO(0, 0, 0, 0.5))
                      ],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: CustomNetworkImage(
                        imageUrl: item.cover,
                        type: ImgType.cover,
                        height: Dimens.pt145,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: Dimens.pt5,
                  top: Dimens.pt5,
                  child: item.isVideo()
                      ? Container()
                      : svgAssets(
                          AssetsSvg.ITEM_IMG_TIP,
                          width: Dimens.pt16,
                          height: Dimens.pt16,
                        ),
                ),
                Positioned(
                  bottom: Dimens.pt6,
                  right: Dimens.pt5,
                  child: VideoTimeView(
                    seconds: item.playTime,
                  ),
                ),
                Positioned(
                  top: Dimens.pt0,
                  right: Dimens.pt0,
                  child: Container(
                    width: Dimens.pt45,
                    height: Dimens.pt16,
                    padding: EdgeInsets.only(left: Dimens.pt5),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color(0xFFF5164E),
                          Color(0xFFFF6538),
                          Color(0xFFF54404)
                        ]),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: Dimens.pt6,
                              offset: Offset(0, 6),
                              color: Color.fromRGBO(248, 44, 44, 0.4))
                        ],
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(16.0))),
                    child: _getFreeOrVipUI(item),
                    // child: _getGoldCoinUI(),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: Dimens.pt6, bottom: Dimens.pt10),
              child: Text(
                item.title ?? "",
                style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 0.12,
                    fontSize: AppFontSize.fontSize12),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 1,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

///获取金币UI
Widget _getGoldCoinUI() {
  return Row(
    children: [
      svgAssets(AssetsSvg.GOLD_COIN),
      Text('100',
          style: TextStyle(
              color: Colors.white,
              fontSize: AppFontSize.fontSize10,
              fontWeight: FontWeight.w600)),
    ],
  );
}

///获取会员或者免费UI
Widget _getFreeOrVipUI(item) {
  int amount = item.coins ?? 0;
  if (amount > 0) {
    return Row(
      children: [
        svgAssets(AssetsSvg.GOLD_COIN),
        Text(amount.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: AppFontSize.fontSize10,
                fontWeight: FontWeight.w600)),
      ],
    );
  } else {
    return Center(
      child: Text(item.freeArea ? "免费" : "会员",
          style: TextStyle(
              color: Colors.white,
              fontSize: AppFontSize.fontSize10,
              fontWeight: FontWeight.w400,
              fontFamily: "HYZhuZiMeiXinTiW")),
    );
  }
}
