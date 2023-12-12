/// File : 推荐右侧控件集合

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/video_list_model/main_player_ui_show_model.dart';
import 'package:flutter_app/page/video/video_list_model/second_player_ui_show_model.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/shadow_text.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/local_server/video_cache_manager.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:popup_window/popup_window.dart';
import 'package:provider/provider.dart';
import 'avater_circle_painter.dart';
import 'follow_item.dart';
import 'love_button/love_button.dart';
import 'love_button/model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'music_disk_item.dart';

/// 推荐右侧控件集合
class RightItem extends StatelessWidget {
  /// 自己的索引
  final int index;
  final VideoModel videoModel;
  final Function onAvatar;
  final Function onLove;
  final Function onComment;
  final Function onFollow;
  final Function onShare;
  final Function onDownload;
  final bool showDownload;

  /// 这个不用统一的  有小数点
  final double width = Dimens.pt40;
  final double loveSize = Dimens.pt38 / 0.6;
  final double iconSize = Dimens.pt38 / (1 - 0.6);

  GlobalKey<MusicDiskAnState> musicKey = GlobalKey();

  RightItem(
    this.index,
    this.videoModel, {
    Key key,
    this.onAvatar,
    this.onComment,
    this.onLove,
    this.onShare,
    this.onFollow,
    this.onDownload,
    this.showDownload = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 数据截取
    String avatarUrl = videoModel.publisher?.portrait ?? "";
    bool isFollow;

    if (Config.followBlogger.containsKey(videoModel.publisher?.uid)) {
      isFollow = Config.followBlogger[videoModel.publisher?.uid];
    } else {
      isFollow = videoModel.publisher?.hasFollowed ?? false;
    }

    bool hasCollected = videoModel.vidStatus?.hasCollected ?? false;
    bool isLove = videoModel.vidStatus?.hasLiked;
    int loveCount = videoModel.likeCount ?? 0;
    int commentCount = videoModel.commentCount ?? 0;
    int shareCount = videoModel.shareCount;

    // 头像
    var avatarItem = Container(
      width: Dimens.pt50,
      height: Dimens.pt50 + Dimens.pt10,
      child: Stack(
        children: <Widget>[
          Container(
              width: Dimens.pt50,
              height: Dimens.pt50,
              child: GestureDetector(
                onTap: onAvatar,
                child: Stack(
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(42)),
                        child: ClipOval(
                          child: CustomNetworkImage(
                            type: ImgType.avatar,
                            imageUrl: avatarUrl ?? '',
                            // width: Dimens.pt50 - 2,
                            // height: Dimens.pt50 - 2,
                            width: 54.w,
                            height: 54.w,
                          ),
                        ),
                      ),
                    ),

                    // CustomPaint(
                    //   size: Size(Dimens.pt50, Dimens.pt50),
                    //   painter: AvatarCirclePainter(Dimens.pt50 / 2, 2),
                    // ),
                  ],
                ),
              )),
          Positioned(
            bottom: 0,
            left: Dimens.pt15,
            child: Center(
              child: Container(
                width: Dimens.pt20,
                height: Dimens.pt20,
                child: FollowItem(
                  isFollow: isFollow,
                  userID: videoModel.publisher?.uid,
                  updateFollow: (bool isFollow) {
                    if (isFollow) {
                      onFollow();
                    }
                    //针对自己页面提出关注请求
                    videoModel.publisher?.hasFollowed = isFollow;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // 金币购买
    Widget getBuyWidget() {
      return Center(
        child: Container(
          width: width,
          child: Column(
            children: <Widget>[
              ImageLoader.withP(
                ImageType.IMAGE_SVG,
                address: AssetsSvg.IC_GOLD,
                width: iconSize,
                height: iconSize,
              ).load(),
              // SizedBox(height: Dimens.pt5),
              Container(
                decoration: BoxDecoration(
                    color: AppColors.black28,
                    borderRadius: BorderRadius.circular(Dimens.pt8)),
                padding:
                    EdgeInsets.symmetric(vertical: 0.5, horizontal: Dimens.pt5),
                child: ShadowText(
                  "${videoModel.coins}",
                  fontSize: AppFontSize.fontSize12,
                  color: AppColors.textColorWhite,
                ),
              ),
            ],
          ),
        ),
      );
    }

    var loveItem = getLoveItem(hasCollected, loveCount);

    // 评论
    var commentItem = Center(
      //key: videoModel.key,
      key: Key(videoModel.id),
      child: Container(
        width: 40.w,
        height: 40.w + Dimens.pt18,
        child: Column(
          children: <Widget>[
            Container(
              width: 40.w,
              height: 40.w,
              child: Image.asset(
                "assets/weibo/video_comment.png",
                width: 40.w,
                height: 40.w,
                fit: BoxFit.cover,
              ),
            ),
            ShadowText(
              commentCount <= 0 ? Lang.COMMENT : getShowCountStr(commentCount),
              fontSize: 14.w,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );

    /// 分享
    var shareItem = Center(
      child: Container(
        width: 34.w,
        height: 34.w,
        alignment: Alignment.topCenter,
        child: Image.asset(
          "assets/weibo/video_share.png",
          width: 34.w,
          height: 34.w,
          fit: BoxFit.cover,
        ),
      ),
    );

    /// 下载
    var downloadItem = Center(
      child: Container(
        width: 40.w,
        height: 40.w,
        alignment: Alignment.topCenter,
        child: Image.asset(
          "assets/images/hls_video_item_icon_download.png",
          width: 40.w,
          height: 40.w,
          fit: BoxFit.cover,
        ),
      ),
    );

    /*var hideWidget = Consumer2<MainPlayerUIShowModel, SecondPlayerShowModel>(
     builder: (BuildContext context, MainPlayerUIShowModel main,
         SecondPlayerShowModel second, Widget child) {
       var addr = Config.hideEye
           ? AssetsSvg.IC_EYE_OPEN
           : AssetsSvg.IC_EYE_CLOSE;
       return GestureDetector(
         onTap: () {

           if(Config.hideEye){
             main.setShow(main.isShow);
             Config.hideEye = false;
           }else{
             main.setShow(!main.isShow);
             Config.hideEye = true;
           }

         },
         child: Container(
           width: 34.w,
           height: 34.w,
           alignment: Alignment.center,
           child: ImageLoader.withP(
             ImageType.IMAGE_SVG,
             address: addr,
             width: 34.w,
             height: 34.w,
           ).load(),
         ),
       );
     },
   );*/
    var switchLine = PopupWindowButton(
      offset: Offset(340, 200),
      buttonBuilder: (BuildContext context) {
        return Center(
          child: Container(
            width: Dimens.pt46,
            height: Dimens.pt24 + Dimens.pt40,
            child: Column(
              children: <Widget>[
                Container(
                  width: Dimens.pt24,
                  height: Dimens.pt24,
                  child: Image.asset(
                    "assets/images/switch_line.png",
                    width: Dimens.pt24,
                    height: Dimens.pt24,
                    fit: BoxFit.cover,
                  ),
                ),
                ShadowText(
                  "线路",
                  fontSize: Dimens.pt12,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
      windowBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              child: Material(
                color: AppColors.primaryColor,
                child: Container(
                  color: Color.fromRGBO(56, 57, 66, 1),
                  height: 90,
                  width: 80,
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      itemCount: Address.cdnAddressLists.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            Address.cdnAddress =
                                Address.cdnAddressLists[index].url;

                            CacheServer().addReqFilter(
                                LOCAL_TS_FILTER, Address.cdnAddress);

                            await VideoCacheManager().emptyCache();

                            CacheServer().setSelectLine(Address.cdnAddress);

                            safePopPage();
                          },
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 4, bottom: 4),
                                  child: Text(
                                    Address.cdnAddressLists[index].desc,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Address.cdnAddressLists[index]
                                            .url ==
                                            Address.cdnAddress
                                            ? Color.fromRGBO(74, 190, 255, 1)
                                            : Colors.white),
                                  )),
                              Container(
                                margin: EdgeInsets.only(left: 6, right: 6),
                                height: 0.6,
                                color: Colors.white,
                                width: 80,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      onWindowShow: () {
        print('PopupWindowButton window show');
      },
      onWindowDismiss: () {
        print('PopupWindowButton window dismiss');
        /* if (widget.callback != null) {
                        widget.callback(selectedType, selectedSort);
                      }*/
      },
    );

    /// 行距
    return Container(
      width: loveSize,
      height: Dimens.pt294,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          avatarItem,
          SizedBox(height: 18.w),
          loveItem,
          SizedBox(height: 10.w),
          GestureDetector(onTap: onComment, child: commentItem),
          SizedBox(height: 12.w),
          GestureDetector(onTap: onShare, child: shareItem),
          if (showDownload) SizedBox(height: 12.w),
          if (showDownload)
            GestureDetector(onTap: onDownload, child: downloadItem),
          Padding(
            padding: EdgeInsets.only(top: Dimens.pt10),
            child: switchLine,
          ),
          SizedBox(height: 25.w),
        ],
      ),
    );
  }

  Widget getLoveItem(bool isLove, int loveCount) {
    var txt = ShadowText(
      loveCount == 0 ? Lang.LIKE : getShowCountStr(loveCount),
      fontSize: 14.w,
      maxLines: 1,
      color: Colors.white,
    );

    var love1 = assetsImg(
      "assets/weibo/video_liked.png",
      fit: BoxFit.cover,
    );
    var love2 = assetsImg(
      "assets/weibo/video_like.png",
      fit: BoxFit.cover,
    );
    var loveItem = Container(
        width: 40.w,
        height: 64.w,
        child: Column(
          children: <Widget>[
            Container(
              child: LoveButton(
                loveController: LoveController(isLove),
                dotColor: DotColor(
                  dotPrimaryColor: Color.fromARGB(1, 152, 219, 236),
                  dotSecondaryColor: Color.fromARGB(1, 247, 188, 48),
                  dotLastColor: Color.fromARGB(1, 221, 70, 136),
                  dotThirdColor: Color.fromARGB(1, 205, 143, 246),
                ),
                imgWidth: 40.w,
                imgHeight: 40.w,
                cWidth: 40.w,
                cHeight: 40.w,
                imageTrue: love1,
                imageFalse: love2,
                duration: Duration(milliseconds: 800),
                enable: !(videoModel.status == 0 || videoModel.status == 2),
                onIconCompleted: () {},
                onIconClicked: () {
                  if (videoModel.status == 0 || videoModel.status == 2) {
                    showToast(
                        msg: videoModel.status == 0
                            ? Lang.REVIEW_HINT1
                            : Lang.REVIEW_HINT2);
                    return;
                  }
                  onLove();
                },
              ),
            ),
            Container(
              // color: Colors.red,
              // padding: EdgeInsets.only(top: 0),
              width: 40.w,
              child: Center(
                child: txt,
              ),
            ),
          ],
        ));
    return loveItem;
  }
}
