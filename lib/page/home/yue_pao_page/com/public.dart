import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/model/verifyreport_model.dart';
import 'package:flutter_app/page/home/yue_pao_page/com/expandable_ext.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:video_player/video_player.dart';

/// 总共星星数量，
int getStarNum(int num1, int num2, int num3) {
  num1 = num1 > 5 ? 5 : num1;
  num2 = num2 > 5 ? 5 : num2;
  num3 = num3 > 5 ? 5 : num3;
  return num1 + num2 + num3;
}

/// 每颗新星分数默认20分
int getAllScore(int starNum, [double starScor = 20]) {
  int score = (starNum * starScor / 3).floor();
  return score > 100 ? 100 : score;
}

String _getTypeString(String key) {
  String str;
  switch (key) {
    case 'pluralism':
      str = Lang.YUE_PAO_MAP1;
      break;
    case 'ad':
      str = Lang.YUE_PAO_MAP2;
      break;
    default:
      str = Lang.UN_KNOWN;
  }
  return str;
}

/// 下一个按钮
class NextView extends StatelessWidget {
  final VoidCallback click;

  const NextView({Key key, this.click}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (click != null) {
          click();
        }
      },
      child: Container(
        height: Dimens.pt40,
        width: Dimens.pt40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.pt20),
          color: Color(0xfffafafa),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '下一个',
              style: TextStyle(color: Colors.black87, fontSize: Dimens.pt10),
            ),
            svgAssets(AssetsSvg.IC_NEXT, height: Dimens.pt12),
          ],
        ),
      ),
    );
  }
}

class YuePaoResources {
  int type; //1 视频  2 图片
  String path; //资源地址
  YuePaoResources({
    this.type,
    this.path,
  });
}

class YuePaoVideo extends StatefulWidget {
  final String url;
  final VoidCallback onTap;
  final ValueChanged<VideoPlayerController> videoController;

  const YuePaoVideo({Key key, this.url, this.onTap, this.videoController})
      : super(key: key);
  @override
  _YuePaoVideoState createState() => _YuePaoVideoState();
}

class _YuePaoVideoState extends State<YuePaoVideo>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController _controller;
  bool isOnTap = false;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          if (widget.onTap == null) {
            if (!_controller.value.isPlaying) {
              _controller.play();
            }
            // _controller.value.isPlaying
            //     ? _controller.pause()
            //     : _controller.play();
            widget.videoController?.call(_controller);
          }
        });
      })
      ..setLooping(true);
  }

  onInitialize() {
    print('object-------------------onInitialize');
    if (widget.onTap == null) {
      setState(() {
        _controller.value.isPlaying ? _controller.pause() : _controller.play();
        widget.videoController?.call(_controller);
      });
    } else {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: onInitialize,
            child: Center(
              child: _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
          ),
          Visibility(
            visible: !_controller.value.isPlaying,
            child: GestureDetector(
              onTap: onInitialize,
              child: ImageLoader.withP(ImageType.IMAGE_SVG,
                      address: AssetsSvg.VIDEO_PAUSE,
                      fit: BoxFit.scaleDown,
                      color: Colors.white.withOpacity(0.8))
                  .load(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}

Widget yueResourcesItem(
  YuePaoResources item, {
  ValueChanged<VideoPlayerController> videoController,
  VoidCallback onTap,
}) {
  if (item.type == 1) {
    if (!(item?.path ?? '').startsWith("/")) {
      item?.path = "/" + item?.path ?? '';
    }
    var url = Address.cdnAddress + item?.path ?? '';

    print("object" + url);
    return YuePaoVideo(
      url: url,
      onTap: onTap,
      videoController: videoController,
    );
  } else {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          CustomNetworkImage(
            imageUrl: item.path,
            isGauss: true,
            fit: BoxFit.cover,
          ),
          CustomNetworkImage(
            imageUrl: item.path,
            fit: BoxFit.contain,
            placeholder: Container(),
          ),
        ],
      ),
    );
  }
}

List<YuePaoResources> getResources(VerifyReport models) {
  if (models == null) {
    return [];
  }
  var list = <YuePaoResources>[];
  if ((models?.videos?.length ?? 0) > 0) {
    var list1 =
        models.videos.map((e) => YuePaoResources(type: 1, path: e)).toList();
    list.addAll(list1);
  }
  if ((models?.imgs?.length ?? 0) > 0) {
    var list1 =
        models.imgs.map((e) => YuePaoResources(type: 2, path: e)).toList();
    list.addAll(list1);
  }
  return list;
}

openYuepaoPreview(
    BuildContext context, List<YuePaoResources> resources, int index) {
  JRouter().go(YUE_PAO_BANNER_PAGE,
      arguments: {'resources': resources, 'index': index});
}

Widget experienceItem(VerifyReport item) {
  var imageCount = getResources(item).length ?? 0;
  return Container(
    padding: EdgeInsets.all(AppPaddings.appMargin),
    margin: EdgeInsets.symmetric(
        vertical: Dimens.pt8, horizontal: AppPaddings.appMargin),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: AppColors.primaryColor,
    ),
    child: Column(
      children: [
        Row(
          children: [
            HeaderWidget(
              headPath: item.avatar ?? '',
              level: 0,
              headWidth: Dimens.pt40,
              headHeight: Dimens.pt40,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSize.fontSize12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Text(
                    "${serversTimeToString(item.createdAt ?? "")}   发布",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Dimens.pt9,
                      color: AppColors.tipTextColor99,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 7,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 9,
            ),
            Expanded(
              child: ExpandableText(
                item.serviceDetails ?? "",
                key: Key(item.id),
                expandText: '更多',
                collapseText: '收起',
                maxLines: 3,
                linkColor: AppColors.primaryRaised,
                style: TextStyle(color: Colors.white, fontSize: Dimens.pt11),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 9,
        ),
        Visibility(
          visible: imageCount != 0,
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //横向数量
                crossAxisSpacing: 9, //间距
                mainAxisSpacing: 9, //行距
                childAspectRatio: 1,
              ),
              itemCount: getResources(item).length ?? 0, //Random().nextInt(9),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              itemBuilder: (BuildContext context, int index) {
                var res = getResources(item)[index];
                return GestureDetector(
                  onTap: () {
                    openYuepaoPreview(context, getResources(item), index);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ImageLoader.withP(
                          ImageType.IMAGE_NETWORK_HTTP,
                          address: res.path,
                          fit: BoxFit.fill,
                        ).load(),
                        Visibility(
                          visible: res.type == 1,
                          child: ImageLoader.withP(
                            ImageType.IMAGE_SVG,
                            address: AssetsSvg.IC_UPLOAD_PLAY,
                            width: Dimens.pt21,
                            height: Dimens.pt21,
                          ).load(),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    ),
  );
}

Widget topView(int topLevel) {
  Widget topView = Container();
  switch (topLevel ?? 0) {
    case 20:
      topView = ImageLoader.withP(
        ImageType.IMAGE_ASSETS,
        address: AssetsImages.YUE_PAO_ZD,
        fit: BoxFit.scaleDown,
        width: Dimens.pt20,
        height: Dimens.pt20,
      ).load();
      break;
    case 10:
      topView = ImageLoader.withP(
        ImageType.IMAGE_ASSETS,
        address: AssetsImages.YUE_PAO_JP,
        fit: BoxFit.scaleDown,
        width: Dimens.pt20,
        height: Dimens.pt20,
      ).load();
      break;
    case 9:
      topView = ImageLoader.withP(
        ImageType.IMAGE_ASSETS,
        address: AssetsImages.YUE_PAO_TJ,
        fit: BoxFit.scaleDown,
        width: Dimens.pt20,
        height: Dimens.pt20,
      ).load();
      break;
    default:
  }
  return topView;
}

Widget itemBuilderView(LouFengItem item,
    {VoidCallback click, bool isMustNotShowBuyImg = false}) {
  return GestureDetector(
    onTap: () {
      if (click != null) {
        click();
      }
    },
    child: Container(
      height: Dimens.pt180,
      margin: EdgeInsets.only(bottom: Dimens.pt10),
      padding:
          EdgeInsets.symmetric(horizontal: Dimens.pt10, vertical: Dimens.pt4),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(Dimens.pt6),
      ),
      child: Row(
        children: [
          /// 左边图片位置
          Container(
            width: Dimens.pt100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                      width: double.infinity,
                      height: Dimens.pt140,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(Dimens.pt6),
                      ),
                      child: CustomNetworkImage(
                        imageUrl: item.cover.isEmpty ? '' : item.cover[0],
                        fit: BoxFit.cover,
                        errorWidget: assetsImg(AssetsImages.IC_DEFAULT_IMG1),
                      ),
                    ),
                    Positioned(
                      top: -Dimens.pt3,
                      left: Dimens.pt5,
                      child: topView(item.showTopLevel),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        svgAssets(AssetsSvg.IC_LOCK, height: Dimens.pt10),
                        Container(
                          padding: EdgeInsets.only(left: Dimens.pt2),
                          child: Text(
                            '${(item.countPurchases ?? 0) > 0 ? getShowCountStr(item.countPurchases) : Lang.UN_LOCK}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white, fontSize: Dimens.pt9),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        svgAssets(AssetsSvg.IC_EYE, height: Dimens.pt10),
                        Container(
                          padding: EdgeInsets.only(left: Dimens.pt2),
                          child: Text(
                            '${(item.countBrowse ?? 0) > 0 ? getShowCountStr(item.countBrowse) : Lang.BROWSE}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white, fontSize: Dimens.pt9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// 右边描述
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: Dimens.pt13),
              padding: EdgeInsets.symmetric(vertical: Dimens.pt6),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: Dimens.pt10),
                    child: Text(
                      item.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimens.pt14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${Lang.TYPES_OF}：',
                                  style: TextStyle(
                                      fontSize: Dimens.pt10,
                                      color: Colors.white,
                                      height: 1.8),
                                ),
                                Expanded(
                                  child: Text(
                                    '${_getTypeString(item.loufengType)}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: Dimens.pt10,
                                        color: Colors.white,
                                        height: 1.8),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${Lang.AREA}：',
                                  style: TextStyle(
                                      fontSize: Dimens.pt10,
                                      color: Colors.white,
                                      height: 1.8),
                                ),
                                Expanded(
                                  child: Text(
                                    TextUtil.isEmpty(item.district)
                                        ? (item.city ?? "")
                                        : item.district,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: Dimens.pt10,
                                        color: Colors.white,
                                        height: 1.8),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${Lang.PRICE}：',
                                  style: TextStyle(
                                      fontSize: Dimens.pt10,
                                      color: Colors.white,
                                      height: 1.8),
                                ),
                                Expanded(
                                  child: Text(
                                    '${item.price}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: Dimens.pt10,
                                        color: Colors.white,
                                        height: 1.8),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isMustNotShowBuyImg ? false : item.isBought,
                        child: Container(
                          margin: EdgeInsets.only(left: Dimens.pt6),
                          child: assetsImg(
                            AssetsImages.IC_ISBUY,
                            height: Dimens.pt50,
                            fit: BoxFit.fitHeight,
                            color: Color.fromRGBO(245, 68, 4, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '${Lang.SCORE}：',
                        style: TextStyle(
                            fontSize: Dimens.pt10, color: Colors.white),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: Dimens.pt3),
                          child: StarCom(
                            topStarNum: getStarNum(item.serviceStar,
                                    item.envStar, item.prettyStar) /
                                3,
                            topColor: Color.fromRGBO(245,22, 78, 1),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${Lang.SERVICE}：',
                        style: TextStyle(
                            fontSize: Dimens.pt10,
                            color: Colors.white,
                            height: 1.8),
                      ),
                      Expanded(
                        child: Text(
                          item.serviceItems,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: Dimens.pt10,
                              color: Colors.white,
                              height: 1.8),
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${Lang.EXPERIENCE}：',
                        style: TextStyle(
                            fontSize: Dimens.pt10,
                            color: Colors.white,
                            height: 1.8),
                      ),
                      Expanded(
                        child: Text(
                          item.impression,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: Dimens.pt10,
                              color: Colors.white,
                              height: 1.8),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


Widget itemBuilderView1(LouFengItem item,
    {VoidCallback click, bool isMustNotShowBuyImg = false,int pageTitle}) {
  return GestureDetector(
    onTap: () {
      if (click != null) {
        click();
      }
    },
    child: Container(
      //height: Dimens.pt180,
      margin: EdgeInsets.only(bottom: Dimens.pt10),
      //padding: EdgeInsets.symmetric(horizontal: Dimens.pt10, vertical: Dimens.pt4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.pt6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Stack(
            alignment: AlignmentDirectional.center,
            children: [


              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(Dimens.pt6),topRight: Radius.circular(Dimens.pt6),),
                child: CustomNetworkImage(
                  imageUrl: item.cover.isEmpty ? '' : item.cover[0],
                  fit: BoxFit.cover,
                  height: Dimens.pt200,
                  errorWidget: assetsImg(AssetsImages.IC_DEFAULT_IMG1),
                ),
              ),

              Positioned(
                  left: Dimens.pt6,
                  bottom: Dimens.pt6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.all(Radius.circular(Dimens.pt10)),
                    ),
                    padding: EdgeInsets.only(left: Dimens.pt4,right: Dimens.pt4,top: Dimens.pt2,bottom: Dimens.pt2,),
                    child: Text(item.countPurchases.toString()+ "人约过",style: TextStyle(color: Colors.white,fontSize: Dimens.pt10),),
                  ),
              ),



              Visibility(
                visible: pageTitle == 0 && item.topLevel == null,
                child: Positioned(
                  top: -1,
                  left: -1,
                  child: Container(
                    //height: Dimens.pt20,
                    decoration:
                    BoxDecoration(
                      borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(8),topLeft: Radius.circular(6)),
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
                      left: Dimens.pt4,
                      right: Dimens.pt7,
                      top: Dimens.pt3,
                      bottom: Dimens.pt3,
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                      children: [

                        SizedBox(
                            width: Dimens
                                .pt4),
                        Text(
                            "可赔付",
                            style:
                            TextStyle(
                              color: AppColors
                                  .textColorWhite,
                              fontSize:
                              Dimens
                                  .pt12,
                            )),
                      ],
                    ),
                  ),
                ),
              ),



              item.topLevel == 20 ? Positioned(
                top: -1,
                left: -1,
                child: Container(
                  //height: Dimens.pt20,
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(8),topLeft: Radius.circular(6)),
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
                    left: Dimens.pt4,
                    right: Dimens.pt7,
                    top: Dimens.pt3,
                    bottom: Dimens.pt3,
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                    children: [

                      SizedBox(
                          width: Dimens
                              .pt4),
                      Text(
                          "精品置顶",
                          style:
                          TextStyle(
                            color: AppColors
                                .textColorWhite,
                            fontSize:
                            Dimens
                                .pt12,
                          )),
                    ],
                  ),
                ),
              ): Container(),




              item.topLevel == 10 ? Positioned(
                top: -1,
                left: -1,
                child: Container(
                  //height: Dimens.pt20,
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(8),topLeft: Radius.circular(6)),
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
                    left: Dimens.pt4,
                    right: Dimens.pt7,
                    top: Dimens.pt3,
                    bottom: Dimens.pt3,
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                    children: [

                      SizedBox(
                          width: Dimens
                              .pt4),
                      Text(
                          "精品",
                          style:
                          TextStyle(
                            color: AppColors
                                .textColorWhite,
                            fontSize:
                            Dimens
                                .pt12,
                          )),
                    ],
                  ),
                ),
              ): Container(),


            ],
          ),


          Padding(
            padding:  EdgeInsets.only(top: Dimens.pt3,left: Dimens.pt6,),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,maxLines: 1,style: TextStyle(fontWeight: FontWeight.bold),),

                SizedBox(
                  height: Dimens.pt2,
                ),

                Text(item.age,style: TextStyle(color: Colors.grey,fontSize: Dimens.pt12),),

                SizedBox(
                  height: Dimens.pt2,
                ),

                Text("价格: " + item.price,maxLines: 1,style: TextStyle(color: Colors.red,fontSize: Dimens.pt12)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// 广告item
Widget adItemBuilderView(LouFengItem item) {
  return GestureDetector(
    onTap: () {
      JRouter().handleAdsInfo(item.url, id: item.id);
    },
    child: Container(
      height: Dimens.pt180,
      margin: EdgeInsets.only(bottom: Dimens.pt10),
      // width: Dimens.pt320,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(Dimens.pt6),
      ),

      child: CustomNetworkImage(
        imageUrl: item.img,
        placeholder: assetsImg(
          AssetsImages.IC_DEFAULT_IMG,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        fit: BoxFit.cover,
      ),
    ),
  );
}

/// 星星评分
// ignore: must_be_immutable
class StarCom extends StatelessWidget {
  // 底部星星数量
  final int bottomStarNum;
  // 顶部星星数量
  final double topStarNum;
  // 默认颜色
  Color topColor;
  // 大小
  double size;

  StarCom(
      {Key key,
      this.bottomStarNum = 5,
      this.topStarNum = 0,
      this.topColor,
      this.size})
      : super(key: key) {
    if (this.topColor == null) this.topColor = Color(0xffFFA26F);
    if (this.size == null) this.size = Dimens.pt12;
  }
  // 获取星星布局数组
  List<Widget> _getStarList() {
    List<Widget> list = [];
    // 填充星星数量
    int punchStar = topStarNum.floor();
    // 非满填充星星
    double clipStar = topStarNum - punchStar;
    //
    bool isTopStarPunch = false;
    for (int i = 1; i <= bottomStarNum; i++) {
      // 全填充
      if (i <= punchStar) {
        list.add(Stack(
          children: <Widget>[
            Icon(
              Icons.grade,
              color: Color(0xffdbdbdb),
              size: size,
            ),
            Icon(
              Icons.grade,
              color: topColor,
              size: size,
            )
          ],
        ));
      } else if (!isTopStarPunch) {
        // 非全填充
        isTopStarPunch = true;
        list.add(Stack(
          children: <Widget>[
            Icon(
              Icons.grade,
              color: Color(0xffdbdbdb),
              size: size,
            ),
            ClipRect(
              //将溢出部分剪裁
              child: Align(
                alignment: Alignment.topLeft,
                widthFactor: clipStar,
                child: Icon(
                  Icons.grade,
                  color: topColor,
                  size: size,
                ),
              ),
            ),
          ],
        ));
      } else {
        // 不填充
        list.add(Stack(
          children: <Widget>[
            Icon(
              Icons.grade,
              color: Color(0xffdbdbdb),
              size: size,
            ),
          ],
        ));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _getStarList(),
    );
  }
}

/// 竖线标题
class LineTitle extends StatelessWidget {
  final String text;

  const LineTitle({Key key, this.text = ''}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: Dimens.pt3,
            height: Dimens.pt16,
            margin: EdgeInsets.only(right: Dimens.pt4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.pt2),
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(245, 22, 78, 1),
                  Color.fromRGBO(255, 101, 56, 1),
                  Color.fromRGBO(245, 68, 4, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: Dimens.pt16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// 单选按钮组
class RadioGroup extends StatefulWidget {
  final ValueChanged<int> onChange;

  const RadioGroup({Key key, this.onChange}) : super(key: key);
  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  int select;
  @override
  void initState() {
    super.initState();
    select = 1;
  }

  /// 选中时
  void _change(int value) {
    setState(() {
      select = value;
    });
    if (widget.onChange != null) {
      widget.onChange(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Radio(
              groupValue: select,
              activeColor: Color(0xffFF0000),
              onChanged: _change,
              value: 1,
            ),
            Text(
              Lang.YUE_PAO_MSG3,
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimens.pt11,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: Dimens.pt20),
          child: Row(
            children: [
              Radio(
                groupValue: select,
                activeColor: Color(0xffFF0000),
                onChanged: _change,
                value: 2,
              ),
              Text(
                Lang.CON_MAN,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.pt11,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: Dimens.pt20),
          child: Row(
            children: [
              Radio(
                groupValue: select,
                activeColor: Color(0xffFF0000),
                onChanged: _change,
                value: 3,
              ),
              Text(
                Lang.REPEAT,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.pt11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}







/// 裸聊单选按钮组
class RadioGroupNakeChat extends StatefulWidget {
  final ValueChanged<int> onChange;

  const RadioGroupNakeChat({Key key, this.onChange}) : super(key: key);
  @override
  _RadioGroupStateNakeChat createState() => _RadioGroupStateNakeChat();
}

class _RadioGroupStateNakeChat extends State<RadioGroupNakeChat> {
  int select;
  @override
  void initState() {
    super.initState();
    select = 1;
  }

  /// 选中时
  void _change(int value) {
    setState(() {
      select = value;
    });
    if (widget.onChange != null) {
      widget.onChange(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Radio(
              groupValue: select,
              activeColor: Color(0xffFF0000),
              onChanged: _change,
              value: 1,
            ),
            Text(
              Lang.YUE_PAO_MSG3,
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimens.pt11,
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(left: Dimens.pt20),
          child: Row(
            children: [
              Radio(
                groupValue: select,
                activeColor: Color(0xffFF0000),
                onChanged: _change,
                value: 2,
              ),
              Text(
                Lang.CON_MAN,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.pt11,
                ),
              ),
            ],
          ),
        ),
        /*Container(
          margin: EdgeInsets.only(left: Dimens.pt20),
          child: Row(
            children: [
              Radio(
                groupValue: select,
                activeColor: Color(0xffFF0000),
                onChanged: _change,
                value: 3,
              ),
              Text(
                Lang.REPEAT,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.pt11,
                ),
              ),
            ],
          ),
        ),*/
      ],
    );
  }
}













/// 获取缓存城市
Future<String> getCity(String key) async {
  String city = await lightKV.getString(key);
  return city;
}

/// 缓存城市
void setCity(String city, String key) {
  lightKV.setString(key, city);
}
