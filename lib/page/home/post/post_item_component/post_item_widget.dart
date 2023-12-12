import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/shadow_text.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/player_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';

import 'package:flutter_app/widget/custom_like_widget.dart';
import 'package:flutter_app/widget/custom_nine_picture.dart';
import 'package:flutter_app/widget/text_drawable_widget.dart';
import 'package:flutter_base/utils/screen.dart';

/// 哪里的帖子
enum PostFrom {
  // 帖子列表
  POST,
  //个人中心
  UC,
  //我的页面
  MINE,
}
enum ItemHighlightType { IS_TOP, IS_RECOMMEND, IS_CHOOSE }

class PostItemWidgets {
  ///header View
  static Widget createTopHeaderView(VideoModel videoModel,
      {VoidCallback onHeadClick, VoidCallback onMoreClick}) {
    String timeStr = showDateDesc(videoModel?.createdAt);
    var tempText = (videoModel?.publisher?.name ?? "").replaceAll(" \t\n", "");
    // var sRunes = tempText.runes;
    // if (sRunes.length > 6) {
    //   tempText = String.fromCharCodes(sRunes, 0, min(sRunes.length, 6)) + "...";
    // }
    var userName = tempText;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          HeaderWidget(
            headPath: videoModel?.publisher?.portrait ?? '',
            level: 0,
            headWidth: Dimens.pt50,
            headHeight: Dimens.pt50,
            tabCallback: onHeadClick,
          ),
          Padding(padding: EdgeInsets.only(left: Dimens.pt7)),
          Expanded(
            flex: 5,
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: Dimens.pt8)),
                Row(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(left: Dimens.pt7)),
                    Flexible(
                        child: Text(userName,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: Dimens.pt14,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis)),
                    Padding(padding: EdgeInsets.only(left: Dimens.pt3)),
                    PostItemWidgets.buildSexWidget(videoModel),
                    SizedBox(width: Dimens.pt6),
                    // Container(
                    //   height: Dimens.pt14,
                    //   padding: EdgeInsets.symmetric(horizontal: Dimens.pt5),
                    //   decoration: BoxDecoration(
                    //       gradient: LinearGradient(
                    //         colors: [
                    //           Color.fromRGBO(77, 77, 77, 1),
                    //           Color.fromRGBO(71, 71, 71, 1)
                    //         ],
                    //         // colors: [Color.fromRGBO(250, 152, 169, 1),Color.fromRGBO(222, 147, 144, 1),Color.fromRGBO(250, 152, 169, 1),Color.fromRGBO(222, 147, 144, 1)],
                    //         // colors: [Color.fromRGBO(77, 77, 77, 1),Color.fromRGBO(71, 71, 71, 1)],
                    //         // colors: [Color.fromRGBO(77, 77, 77, 1),Color.fromRGBO(71, 71, 71, 1)],
                    //       ),
                    //       borderRadius: BorderRadius.circular(Dimens.pt7)),
                    //   child: Text(
                    //     'LV ${videoModel?.publisher?.rechargeLevel ?? 0}',
                    //     style: TextStyle(
                    //         color: Colors.white, fontSize: Dimens.pt11),
                    //   ),
                    // ),
                    getVipLevelWidget(videoModel?.publisher?.isVip ?? false,
                        videoModel?.publisher?.vipLevel ?? 0),

                    // getVipLevelWidget(true, 2),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: Dimens.pt6)),
                Row(children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: Dimens.pt7)),
                  //城市
                  PostItemWidgets.buildCityWidget(videoModel, timeStr),
                  Padding(padding: EdgeInsets.only(left: Dimens.pt4)),
                  videoModel?.publisher?.vipLevel != 0
                      ? Padding(padding: EdgeInsets.only(left: Dimens.pt4))
                      : Container(),
                  //VIP
                  videoModel?.publisher?.superUser != 0
                      ? ImageLoader.withP(ImageType.IMAGE_SVG,
                      address: AssetsSvg.USER_USER_ICON_V,
                      height: Dimens.pt18,
                      width: Dimens.pt18)
                      .load()
                      : Container(),
                  videoModel?.publisher?.superUser != 0
                      ? Padding(padding: EdgeInsets.only(left: Dimens.pt4))
                      : Container(),
                  //认证
                  videoModel?.publisher?.officialCert ?? false
                      ? ImageLoader.withP(ImageType.IMAGE_SVG,
                      address: AssetsSvg.USER_USER_ICON_ZHENG,
                      width: Dimens.pt18,
                      height: Dimens.pt18)
                      .load()
                      : Container(),
                ])
              ],
            ),
          ),
          GestureDetector(
            onTap: onMoreClick,
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.symmetric(
                  horizontal: Dimens.pt10, vertical: Dimens.pt12),
              child: ImageLoader.withP(
                ImageType.IMAGE_SVG,
                address: AssetsSvg.IC_BOTTOM,
                width: Dimens.pt13,
                height: Dimens.pt6,
              ).load(),
            ),
          ),
        ],
      ),
    );
  }

  //post video layout
  static Widget createVideoLayout(VideoModel videoModel,
      {VoidCallback onItemClick,
      VoidCallback onPlayClick,
      VoidCallback needPay}) {
    if (null == videoModel) return Container();
    VideoResolution videoResolution;
    double vHeight = Dimens.pt250;
    double vWidth = Dimens.pt360;
    if (videoModel.resolution?.isNotEmpty ?? false) {
      List<String> list = videoModel.resolution.split("*");
      if (list.length == 2) {
        vWidth = double.parse(list[0]);
        vHeight = double.parse(list[1]);
      }
    }
    //横屏
    if (vWidth > vHeight) {
      videoResolution = configVideoSize(Dimens.pt328, Dimens.pt328 * 9 / 16,
          videoModel.resolutionWidth(), videoModel.resolutionHeight(), true);
      if (videoResolution.videoWidth > screen.screenWidth) {
        //32 为左右边距
        videoResolution.videoWidth = screen.screenWidth - 32;
      }
    } else {
      //竖屏
      videoResolution = configVideoSize(Dimens.pt250, Dimens.pt360,
          videoModel.resolutionWidth(), videoModel.resolutionHeight(), true);
      if (videoResolution.videoHeight > Dimens.pt360) {
        videoResolution.videoHeight = Dimens.pt360;
      }
    }
    return Container(
      padding: EdgeInsets.only(
          top: ((videoModel?.title?.length ?? 0) > 0) ? Dimens.pt10 : 0),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: Container(
              width: videoResolution.videoWidth,
              height: videoResolution.videoHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimens.pt5),
                child: CustomNetworkImage(
                  width: videoResolution.videoWidth,
                  height: videoResolution.videoHeight,
                  imageUrl: videoModel.cover,
                  placeholder: Container(
                    color: Color(0xff000000),
                  ),
                  fit: vWidth > vHeight ? BoxFit.cover : BoxFit.fitWidth,
                ),
              ),
            ),
            onTap: onItemClick,
          ),

          /// 标签
          // Positioned(
          //     bottom: Dimens.pt6,
          //     left: Dimens.pt5,
          //     child: tagsStr != null
          //         ? CustomLabelWidget(
          //             list: tagsStr,
          //             fontSize: Dimens.pt12,
          //             fontColor: Colors.white,
          //             width: Dimens.pt200,
          //             heigth: Dimens.pt24,
          //             onTag: (int index) {
          //               dispatch(PostItemActionCreator.onTag(index, state));
          //             },
          //           )
          //         : Container()),
          Positioned(
            left: 0,
            width: videoResolution.videoWidth,
            height: videoResolution.videoHeight,
            child: GestureDetector(
              onTap: onPlayClick,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(Dimens.pt5),
                  child: ImageLoader.withP(ImageType.IMAGE_SVG,
                          address: AssetsSvg.VIDEO_PAUSE_TIP,
                          width: Dimens.pt50,
                          height: Dimens.pt50)
                      .load(),
                ),
              ),
            ),
          ),

          Positioned(
              bottom: Dimens.pt0,
              right: Dimens.pt0,
              child: getCoinConner(videoModel, needPay: needPay)),

          /// 展示付费金币
          // Positioned(
          //     bottom: Dimens.pt10,
          //     right: Dimens.pt10,
          //     child: (videoModel.coins ?? 0) > 0
          //         ? Container(
          //             padding: EdgeInsets.all(2.0),
          //             decoration: BoxDecoration(
          //                 color: Color(0x66000000),
          //                 borderRadius: BorderRadius.circular(Dimens.pt12)),
          //             child: Row(
          //               children: <Widget>[
          //                 noMyself
          //                     ? Padding(
          //                         padding: EdgeInsets.only(left: Dimens.pt12))
          //                     : Container(),
          //                 noMyself
          //                     ? Text(Lang.UN_LOCK,
          //                         style: TextStyle(
          //                             fontSize: Dimens.pt12, color: Colors.white))
          //                     : Container(),
          //                 Padding(padding: EdgeInsets.only(left: Dimens.pt8)),
          // svgAssets(AssetsSvg.IC_GOLD,
          //                     width: Dimens.pt17, height: Dimens.pt17),
          //                 Padding(padding: EdgeInsets.only(left: Dimens.pt8)),
          //                 Text("${videoModel?.coins ?? ''}",
          //                     style: TextStyle(
          //                         fontSize: Dimens.pt14, color: Colors.white)),
          //                 Padding(padding: EdgeInsets.only(right: Dimens.pt6)),
          //               ],
          //             ),
          //           )
          //         : Container()),
        ],
      ),
    );
  }

  /// post image layout
  static Widget createImageLayout(VideoModel videoModel,
      {VoidCallback needPay}) {
    return videoModel?.seriesCover?.isNotEmpty ?? false
        ? Container(
            padding: EdgeInsets.only(
                top: ((videoModel?.title?.length ?? 0) > 0) ? Dimens.pt10 : 0),
            child: Stack(
              children: <Widget>[
                CustomNinePicture(
                  pictureList: videoModel?.seriesCover ?? [],
                  // isGauss: isNeedPay,
                  isGauss: needBuyVideo(videoModel),
                  picRadius: BorderRadius.circular(8),
                ),
                // Positioned(
                //     bottom: Dimens.pt6,
                //     left: Dimens.pt10,
                //     child: tagsStr != null
                //         ? CustomLabelWidget(
                //             list: tagsStr,
                //             fontSize: Dimens.pt12,
                //             fontColor: Color(0xFFFFFFFF),
                //             width: Dimens.pt190,
                //             heigth: Dimens.pt24,
                //             onTag: (int index) {
                //               dispatch(PostItemActionCreator.onTag(index, state));
                //             },
                //           )
                //         : Container()),
                Positioned(
                    bottom: -1,
                    right: -1,
                    child: getCoinConner(videoModel, needPay: needPay)),
              ],
            ),
          )
        : Container();
  }

  /// 获取标签列表
  static Widget getTagList(VideoModel videoModel,
      {ValueChanged<int> onTagClick}) {
    return Container(
      width: Dimens.pt280,
      height: Dimens.pt24, // 最多1排
      child: Wrap(
        crossAxisAlignment:
            WrapCrossAlignment.center, //垂直居中 交叉轴（crossAxis）��向上的对齐方式。
        spacing: Dimens.pt10, // 主轴(水平)方向间距
        runSpacing: Dimens.pt4, // 纵��（垂直）方向间距
        alignment: WrapAlignment.start,
        children: videoModel.tags.map((it) {
          var index = videoModel.tags.indexOf(it) ?? 0;
          var mod = (index + Random().nextInt(2)) % AppColors.rainbows.length;

          return GestureDetector(
              onTap: () => onTagClick?.call(index),
              child: ShadowText("#${it.name}",
                  maxLines: 1,
                  fontSize: Dimens.pt14,
                  color: AppColors.rainbows[mod]));
        }).toList(),
      ),
    );
  }

  //bottom bar 点赞关注评论
  static Widget createBottomView(VideoModel videoModel,
      {ValueChanged<bool> onLike,
      VoidCallback onComment,
      VoidCallback onShare,
      VoidCallback onReward}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Visibility(
          visible: videoModel.isImg() ? false : true,
          child: Text("${numCoverStr(videoModel?.playCount ?? 0)} 次播放",
              style: TextStyle(color: Colors.white, fontSize: Dimens.pt10)),
        ),

        // TextDrawableWidget(
        //     text: numCoverStr(videoModel?.playCount ?? 0),
        //     image: ImageLoader.withP(
        //       ImageType.IMAGE_SVG,
        //       address: AssetsSvg.MINE_PLAY,
        //       width: Dimens.pt13,
        //       height: Dimens.pt13,
        //     ).load(),
        //     scrollDirection: Axis.horizontal),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextDrawableWidget(
                  text: double.parse(videoModel.rewarded ?? ".0").toInt() <= 0
                      ? Lang.REWARD
                      : numCoverStr(
                          double.parse(videoModel.rewarded ?? ".0").toInt()),
                  textStyle:
                      TextStyle(color: Colors.white, fontSize: Dimens.pt10),
                  image: ImageLoader.withP(
                    ImageType.IMAGE_SVG,
                    address: AssetsSvg.COMMUNITY_IC_COMMUNITY_REWARD,
                    width: Dimens.pt13,
                    height: Dimens.pt13,
                  ).load(),
                  scrollDirection: Axis.horizontal,
                  callback: onReward),
              SizedBox(width: Dimens.pt1),
              videoModel != null
                  ? LikeWidget(
                      isLike: videoModel.vidStatus.hasLiked ?? false,
                      width: Dimens.pt13,
                      height: Dimens.pt11,
                      padding: EdgeInsets.all(Dimens.pt5),
                      likeCount: videoModel.likeCount,
                      callback: onLike,
                      scrollDirection: Axis.horizontal)
                  : Container(),
              SizedBox(width: Dimens.pt1),
              TextDrawableWidget(
                text: videoModel.commentCount <= 0
                    ? Lang.COMMENT
                    : numCoverStr(videoModel.commentCount),
                textStyle:
                    TextStyle(color: Colors.white, fontSize: Dimens.pt10),
                image: ImageLoader.withP(
                  ImageType.IMAGE_SVG,
                  address: AssetsSvg.RECD_RIGHT_COMMENT_PNG,
                  width: Dimens.pt13,
                  height: Dimens.pt13,
                ).load(),
                scrollDirection: Axis.horizontal,
                callback: onComment,
              ),
              SizedBox(width: Dimens.pt1),
              TextDrawableWidget(
                text: videoModel.shareCount <= 0
                    ? Lang.SHARE
                    : numCoverStr(videoModel.shareCount),
                textStyle:
                    TextStyle(color: Colors.white, fontSize: Dimens.pt10),
                image: ImageLoader.withP(
                  ImageType.IMAGE_SVG,
                  address: AssetsSvg.RECD_RIGHT_SHARE_PNG,
                  width: Dimens.pt13,
                  height: Dimens.pt13,
                ).load(),
                scrollDirection: Axis.horizontal,
                callback: onShare,
              ),

              SizedBox(width: Dimens.pt6),



            ],
          ),
        )
      ],
    );
  }

  //hot comment
  static Widget createHotCommend(VideoModel videoModel) {
    return Container(
      margin: EdgeInsets.only(top: Dimens.pt10, bottom: Dimens.pt10),
      padding: EdgeInsets.only(
          top: Dimens.pt5,
          bottom: Dimens.pt9,
          left: Dimens.pt7,
          right: Dimens.pt7),
      decoration: BoxDecoration(
          color: Color(0xFF242630),
          borderRadius: BorderRadius.circular(Dimens.pt8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ImageLoader.withP(ImageType.IMAGE_SVG,
                          address: AssetsSvg.COMMUNITY_COMMUNITY_HOT_COMMENT,
                          width: Dimens.pt8,
                          height: Dimens.pt10)
                      .load(),
                  Padding(
                    padding: EdgeInsets.only(left: Dimens.pt4),
                    child: Text("热评",
                        style: TextStyle(
                            fontSize: Dimens.pt10, color: Color(0xffffffff))),
                  )
                ],
              ),
              Text(
                "${videoModel?.likeCount ?? 0}赞",
                style:
                    TextStyle(fontSize: Dimens.pt8, color: Color(0xFF737479)),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: Dimens.pt5),
          ),
          RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "${videoModel?.comment?.name ?? "精彩评论"}：",
                    style: TextStyle(
                        fontSize: Dimens.pt10, color: Color(0xFFFFCA00))),
                TextSpan(
                    text: "${videoModel?.comment?.content ?? ""}",
                    style: TextStyle(
                        fontSize: Dimens.pt10, color: Color(0xFFBDBDBD))),
              ]))
        ],
      ),
    );
  }

  ///性别
  static Widget buildSexWidget(VideoModel videoModel) {
    var isWomen = videoModel?.publisher?.gender == "female";
    return Container(
      height: Dimens.pt14,
      padding: EdgeInsets.only(
          left: Dimens.pt4,
          right: Dimens.pt4,
          top: Dimens.pt0,
          bottom: Dimens.pt0),
      decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(Dimens.pt7),
          gradient: LinearGradient(
              colors: isWomen
                  ? [Color(0xffE241EF), Color(0xff954FEB)]
                  : [Color(0xff41A3EF), Color(0xff4C81EF)])),
      child: Row(
        children: <Widget>[
          ImageLoader.withP(ImageType.IMAGE_SVG,
                  address: isWomen
                      ? AssetsSvg.COMMUNITY_COMMUNITY_SEX_WOMEN
                      : AssetsSvg.COMMUNITY_COMMUNITY_SEX_MAN,
                  width: Dimens.pt9,
                  height: Dimens.pt10)
              .load(),
          SizedBox(width: Dimens.pt3),
          ((videoModel?.publisher?.age ?? 0) < 18)
              ? Container()
              : Text(
                  "${videoModel?.publisher?.age ?? ""}",
                  style: TextStyle(fontSize: Dimens.pt10, color: Colors.white),
                )
        ],
      ),
    );
  }

  /// post city
  static Widget buildCityWidget(VideoModel videoModel, String timeStr) {
    var tempName = videoModel?.location?.city ?? "";
    if (tempName.length > 2) {
      tempName = tempName.substring(0, min(tempName.length, 2));
    }
    return Container(
      child: Row(
        children: <Widget>[
          ImageLoader.withP(ImageType.IMAGE_SVG,
                  address: AssetsSvg.COMMUNITY_COMMUNITY_LOCATION,
                  width: Dimens.pt10,
                  height: Dimens.pt13)
              .load(),
          Padding(padding: EdgeInsets.only(left: Dimens.pt5)),
          Text(tempName,
              style:
                  TextStyle(fontSize: Dimens.pt12, color: Color(0xff848699))),
          Text("${timeStr == '' ? '' : ' · '}$timeStr",
              style: TextStyle(
                  fontSize: Dimens.pt11, color: Color(0xff848699))) //时间
        ],
      ),
    );
  }

  ///获取置顶 相关的widget
  static WidgetSpan createTopIndentWidget(
      VideoModel videoModel, ItemHighlightType type) {
    var colors; //默认置顶颜色
    var value;
    if ((videoModel?.isTopping ?? false) && type == ItemHighlightType.IS_TOP) {
      colors = [Color(0xffFA7E2C), Color(0xffE13F1C)]; //默认置顶颜色
      value = Lang.STICKY;
    } else if ((videoModel?.isRecommend ?? false) &&
        type == ItemHighlightType.IS_RECOMMEND) {
      colors = [Color(0xffE927AF), Color(0xffAD13CF)]; //力荐颜色
      value = Lang.RECOMMEND;
    } else if ((videoModel?.isChoosen ?? false) &&
        type == ItemHighlightType.IS_CHOOSE) {
      //置精
      colors = [Color(0xffF22A7A), Color(0xffD51220)]; //默认置顶颜色
      value = Lang.ADD_FINE;
    }
    return WidgetSpan(
      child: null != colors
          ? Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.pt3),
                  gradient: LinearGradient(colors: colors)),
              height: Dimens.pt16,
              // alignment: Alignment.center,
              padding: EdgeInsets.only(
                  left: Dimens.pt3, right: Dimens.pt3, bottom: Dimens.pt1),
              margin: EdgeInsets.only(right: Dimens.pt8),
              child: Text(
                value,
                style: TextStyle(fontSize: Dimens.pt11, color: Colors.white),
              ),
            )
          : Container(),
    );
  }

  //Text layout
  static Widget createTextLayout(VideoModel videoModel, bool fullIsClicked) {
    var tempText = videoModel?.title ?? "".replaceAll("\r\t\n", "");
    if (tempText.length == 0) {
      return Container(
        padding: EdgeInsets.only(top: Dimens.pt15),
      );
    }
    var isTopping = videoModel?.isTopping ?? false;
    var isRecommend = videoModel?.isRecommend ?? false;
    var isChoose = videoModel?.isChoosen ?? false;

    var newText = tempText;
    var tempNewText = newText;

    var indentEmpty = ""; //The space is text's width.
    if (isTopping) {
      indentEmpty = "    ";
    }
    if (isRecommend) {
      indentEmpty += "    ";
    }
    if (isChoose) {
      indentEmpty += "    ";
    }
    tempNewText = indentEmpty + tempNewText;
    // Build the textSpan
    // var span = TextSpan(
    //     text: tempNewText,
    //     style: TextStyle(
    //         fontSize: Dimens.pt14,
    //         wordSpacing: 1.37,
    //         letterSpacing: 1.37,
    //         color: Color(0xffffffff)));
    // var tp = TextPainter(
    //   maxLines: 2,
    //   textAlign: TextAlign.left,
    //   textDirection: TextDirection.ltr,
    //   text: span,
    // );
    // trigger it to layout
    // tp.layout(maxWidth: screen.designH);
    // whether the text overflowed or not
    // var exceeded = tp.didExceedMaxLines;
    // if (exceeded && !isDidFullButton) {
    //   //超过2行 截取后面5位字符并添加...
    //   var sRunes = newText.runes;
    //   newText =
    //       String.fromCharCodes(sRunes, 0, min(sRunes.length - 6, 36)) + "...";
    // }
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: Dimens.pt8),
      child: Stack(
        children: <Widget>[
          RichText(
              // maxLines: isDidFullButton ? 10000000000000 : 2,
              text: TextSpan(children: [
            videoModel?.isTopping ?? false
                ? createTopIndentWidget(videoModel, ItemHighlightType.IS_TOP)
                : TextSpan(),
            videoModel?.isRecommend ?? false
                ? createTopIndentWidget(
                    videoModel, ItemHighlightType.IS_RECOMMEND)
                : TextSpan(),
            videoModel?.isChoosen ?? false
                ? createTopIndentWidget(videoModel, ItemHighlightType.IS_CHOOSE)
                : TextSpan(),
            TextSpan(
                text: (fullIsClicked ? newText + "\n" : newText),
                style: TextStyle(
                    fontSize: Dimens.pt14,
                    wordSpacing: 1.37,
                    letterSpacing: 1.37,
                    color: Color(0xffffffff))),
          ])),
          // exceeded
          //     ? Positioned(
          //         right: Dimens.pt0,
          //         bottom: 0,
          //         child: InkWell(
          //           child: Container(
          //             color: AppColors.backgroundColor,
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //               children: <Widget>[
          //                 Container(
          //                   child: Text(
          //                     isDidFullButton ? Lang.PACK_UP : Lang.EXPAND,
          //                     style: TextStyle(
          //                         color: Color(0xFFFFCA00),
          //                         letterSpacing: Dimens.pt1,
          //                         fontSize: Dimens.pt13),
          //                   ),
          //                 ),
          //                 Icon(
          //                   isDidFullButton
          //                       ? Icons.keyboard_arrow_up
          //                       : Icons.keyboard_arrow_down,
          //                   size: Dimens.pt20,
          //                   color: Color(0xFFFFCA00),
          //                 ),
          //               ],
          //             ),
          //           ),
          //           onTap: () {
          //             dispatch(PostItemActionCreator.fullTextTap(state));
          //           },
          //         ),
          //       )
          //     : Container()
        ],
      ),
    );
  }

  /// 获取视频是否付费Label
  static Widget getCoinConner(VideoModel model, {VoidCallback needPay}) {
    /*if ((model?.coins ?? 0) <= 0 || GlobalStore.isMe(model?.publisher?.uid) || model.freeArea ) {
      return Container();*/
    ///改为判断originCoins
    if ((model?.originCoins ?? 0) <= 0 || GlobalStore.isMe(model?.publisher?.uid) || model.freeArea ) {
      return Container();
    } else if (model.vidStatus.hasPaid) {
      return _getBughtConner();
    } else {
      return _getCoinConner(model.coins, model.originCoins , needPay: needPay);
    }
  }


   bool isBeforeToday() {
    var startDate = GlobalStore.getMe().videoFreeExpiration;
    var endDate = new DateTime.now();
    return DateTime.parse(startDate).isBefore(endDate);
  }

  /// 获取金币角标  购买了视频全免卡后330金币以下视频免费
  /// [coin] 金币数量
  static Widget _getCoinConner(int coin,int originalCoin, {VoidCallback needPay}) {

    return (coin ?? 0) <= 0 && originalCoin < 30
        ? Stack(alignment: Alignment.center, children: [
      ClipRRect(
        borderRadius:
        BorderRadius.only(bottomRight: Radius.circular(4)),
        child: ImageLoader.withP(
          ImageType.IMAGE_SVG,
          address: AssetsSvg.BG_COIN_CONNER,
          // width: Dimens.pt12,
          // height: Dimens.pt12
        ).load(),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageLoader.withP(ImageType.IMAGE_SVG,
              address: AssetsSvg.IC_GOLD,
              width: Dimens.pt12,
              height: Dimens.pt12)
              .load(),
          SizedBox(width: Dimens.pt6),
          Text("0", style: TextStyle(color: AppColors.textColorWhite)),
        ],
      ),
    ])
        : GestureDetector(
      onTap: needPay,
      child: Stack(alignment: Alignment.center, children: [
        ClipRRect(
          borderRadius:
          BorderRadius.only(bottomRight: Radius.circular(4)),
          child: ImageLoader.withP(
            ImageType.IMAGE_SVG,
            address: AssetsSvg.BG_COIN_CONNER,
            // width: Dimens.pt12,
            // height: Dimens.pt12
          ).load(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageLoader.withP(ImageType.IMAGE_SVG,
                address: AssetsSvg.IC_GOLD,
                width: Dimens.pt12,
                height: Dimens.pt12)
                .load(),
            SizedBox(width: Dimens.pt4),
            Text(originalCoin.toString(),
                style: TextStyle(color: AppColors.textColorWhite)),
          ],
        ),
      ]),
    );



    /*return (coin ?? 0) <= 0
        ? Container()
        : GestureDetector(
            onTap: needPay,
            child: Stack(alignment: Alignment.center, children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(4)),
                child: ImageLoader.withP(
                  ImageType.IMAGE_SVG,
                  address: AssetsSvg.BG_COIN_CONNER,
                  // width: Dimens.pt12,
                  // height: Dimens.pt12
                ).load(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageLoader.withP(ImageType.IMAGE_SVG,
                          address: AssetsSvg.IC_GOLD,
                          width: Dimens.pt12,
                          height: Dimens.pt12)
                      .load(),
                  SizedBox(width: Dimens.pt4),
                  Text(coin.toString(),
                      style: TextStyle(color: AppColors.textColorWhite)),
                ],
              ),
            ]),
          );*/
  }

  /// 显示已购买
  static Widget _getBughtConner() {
    return
        // (coin ?? 0) <= 0
        //     ? Container()
        //     :
        Stack(alignment: Alignment.center, children: [
      ClipRRect(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(4)),
        child: ImageLoader.withP(
          ImageType.IMAGE_SVG,
          address: AssetsSvg.BG_COIN_CONNER,
          // width: Dimens.pt12,
          // height: Dimens.pt12
        ).load(),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageLoader.withP(ImageType.IMAGE_SVG,
                  address: AssetsSvg.IC_GOLD,
                  width: Dimens.pt10,
                  height: Dimens.pt10)
              .load(),
          SizedBox(width: Dimens.pt2),
          // Text(coin.toString(),
          //     style: TextStyle(color: AppColors.textColorWhite)),
          Text(Lang.BOUGHT,
              style: TextStyle(
                  fontSize: AppFontSize.fontSize10,
                  color: AppColors.textColorWhite)),
        ],
      ),
    ]);
  }
}
