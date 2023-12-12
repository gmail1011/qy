import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_work/component/action.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'state.dart';

Widget buildView(
    WorkItemState state, Dispatch dispatch, ViewService viewService) {
  return GestureDetector(
    onTap: () {
      dispatch(WorkItemActionCreator.onTapItem(state.uniqueId));
    },
    child: Column(
      children: [
        Stack(
          //overflow: Overflow.clip, //超出部分会被切掉
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                /*child: CustomNetworkImage(
                  imageUrl: state.videoModel.cover,
                  height: Dimens.pt220,
                  placeholder: assetsImg(
                    AssetsImages.IC_DEFAULT_IMG,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  fit: BoxFit.cover,
                ),*/
                child: Stack(children: [
                  KeepAliveWidget(
                    CachedNetworkImage(
                      imageUrl: getImagePath(
                          state.videoModel.cover,
                          true,
                          false),
                      fit: BoxFit.cover,
                      width: screen.screenWidth,
                      memCacheHeight: 600,
                      cacheManager: ImageCacheManager(),
                      fadeInCurve: Curves.linear,
                      fadeOutCurve: Curves.linear,
                      fadeInDuration: Duration(milliseconds: 100),
                      fadeOutDuration: Duration(milliseconds: 100),
                      /*placeholder: (context, url) {
                        return placeHolder(ImgType.cover,
                            null, Dimens.pt280);
                      },*/
                    ),
                  ),
                  Positioned(
                      top: -1,
                      right: -1,
                      child: Visibility(
                        visible: state.videoModel
                            .originCoins !=
                            null &&
                            state.videoModel.originCoins !=
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
                                        state.videoModel
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
                        visible: state.videoModel
                            .originCoins == 0
                            ? true
                            : false,
                        child: Stack(
                            alignment:
                            Alignment.center,
                            children: [
                              Container(
                                //height: Dimens.pt20,
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.only(
                                      bottomLeft:
                                      Radius.circular(
                                          4)),
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
                                padding:
                                EdgeInsets.only(
                                  left: Dimens.pt10,
                                  right: Dimens.pt10,
                                  top: Dimens.pt2,
                                  bottom: Dimens.pt2,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                                  children: [
                                    Text(
                                      "VIP",
                                      style: TextStyle(
                                        color: Colors
                                            .white,fontSize: Dimens.pt12,),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      )),
                ],),
              ),
            ),
            Positioned(
              top: Dimens.pt5,
              right: Dimens.pt5,
              child: state.videoModel.isVideo()
                  ? Container()
                  : svgAssets(
                      AssetsSvg.ITEM_IMG_TIP,
                      width: Dimens.pt16,
                      height: Dimens.pt16,
                    ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: Dimens.pt40,
                width: Dimens.pt180,
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
                            state.videoModel.playCount > 10000
                                ? (state.videoModel.playCount / 10000)
                                        .toStringAsFixed(1) +
                                    "w"
                                : state.videoModel.playCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimens.pt12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        TimeHelper.getTimeText(
                            state.videoModel.playTime.toDouble()),
                        style: TextStyle(
                            color: Colors.white, fontSize: Dimens.pt12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: Visibility(
                  visible: state.videoModel.originCoins != null &&
                          state.videoModel.originCoins != 0
                      ? true
                      : false,
                  child: Stack(alignment: Alignment.center, children: [
                    Container(
                      //height: Dimens.pt20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          topRight: Radius.circular(10),
                        ),
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
                      padding: EdgeInsets.only(
                        left: Dimens.pt8,
                        right: Dimens.pt8,
                        top: Dimens.pt3,
                        bottom: Dimens.pt3,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ImageLoader.withP(ImageType.IMAGE_SVG,
                                  address: AssetsSvg.IC_GOLD,
                                  width: Dimens.pt12,
                                  height: Dimens.pt12)
                              .load(),
                          SizedBox(width: Dimens.pt6),
                          Text(state.videoModel.originCoins.toString(),
                              style:
                                  TextStyle(color: AppColors.textColorWhite)),
                        ],
                      ),
                    ),
                  ]),
                )),

            /*Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                  padding: EdgeInsets.all(Dimens.pt2),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AssetsImages.IC_JUXING),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          svgAssets(AssetsSvg.MINE_PLAY,
                              width: Dimens.pt14, height: Dimens.pt12),
                          Text(
                            "  " +
                                getShowCountStr(
                                    state.videoModel.likeCount),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: (state.videoModel.coins ?? 0) > 0,
                        child: Row(
                          children: <Widget>[
                            svgAssets(AssetsSvg.IC_GOLD,
                                width: Dimens.pt12, height: Dimens.pt12),
                            Text(
                              " ${state.videoModel.coins ?? 0}",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            )*/
          ],
        ),
        SizedBox(
          height: Dimens.pt4,
        ),
        Container(
            alignment: Alignment.centerLeft,
            child: Text(
              state.videoModel.title,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimens.pt12,
              ),
            )),
        SizedBox(
          height: Dimens.pt4,
        ),
        Row(
          children: [
            ClipOval(
              child: CustomNetworkImage(
                imageUrl: state.videoModel.publisher.portrait,
                width: Dimens.pt26,
                height: Dimens.pt26,
                placeholder: assetsImg(
                  AssetsImages.IC_DEFAULT_IMG,
                  width: Dimens.pt26,
                  height: Dimens.pt26,
                  fit: BoxFit.cover,
                ),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: Dimens.pt6,
            ),
            Container(
                width: Dimens.pt70,
                child: Text(
              state.videoModel.publisher.name,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: Dimens.pt12,
              ),
            )),
            SizedBox(
              width: Dimens.pt4,
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset("assets/svg/heart.svg",
                        width: Dimens.pt11, height: Dimens.pt11),
                    SizedBox(
                      width: Dimens.pt4,
                    ),
                    Text(
                      state.videoModel.likeCount > 10000
                          ? (state.videoModel.likeCount / 10000)
                                  .toStringAsFixed(1) +
                              "w"
                          : state.videoModel.likeCount.toString(),
                      //state.videoModel.likeCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimens.pt12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
