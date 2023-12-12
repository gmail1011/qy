import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/publish/works_manager/works/view.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:get/route_manager.dart' as Gets;

class WorkItemView extends StatefulWidget {
  final int worksType; //类型，0推广，1普通
  final int statusType; //全部，审核，通过，未通过
  final VideoModel videoModel;
  final bool isEditStatus;

  const WorkItemView({
    Key key,
    this.worksType,
    this.videoModel,
    this.statusType,
    this.isEditStatus,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WorkItemViewState();
  }
}

class _WorkItemViewState extends State<WorkItemView> {
  VideoModel get videoModel => widget.videoModel;

  int get _videosStatus => videoModel.status;

  void _clickEvent() {
    // if (widget.worksType == 0) {
    //   if (videoModel.newsType == "MOVIE" || videoModel.newsType == "COVER") {
    //     showToast(msg: "图文和影视暂不支持推广");
    //     return;
    //   }
    //   Map<String, dynamic> maps = Map();
    //   maps['videoModel'] = videoModel;
    //   JRouter().go(EXTENSION_SETTING, arguments: maps);
    //   return;
    // }

    ///进入图文详情
    if ("COVER" == videoModel.newsType) {
      Gets.Get.to(
          () => CommunityDetailPage().buildPage({"videoId": videoModel?.id}),
          opaque: false);
    } else if ("SP" == videoModel.newsType) {
      ///进入短视频
      Map<String, dynamic> map = Map();
      map['playType'] = VideoPlayConfig.VIDEO_TYPE_COLLECT;
      map['currentPosition'] = 0;
      map['pageNumber'] = 1;
      map['uid'] = GlobalStore.getMe()?.uid;
      map['pageSize'] = 1;
      map['type'] = 'video';
      map['videoList'] = [widget.videoModel];
      JRouter().go(SUB_PLAY_LIST, arguments: map);
    } else if ("MOVIE" == videoModel.newsType) {
      Map<String, dynamic> maps = Map();
      maps["videoId"] = videoModel.id;
      Gets.Get.to(() => FilmTvVideoDetailPage().buildPage(maps), opaque: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEditStatus == true ? null : _clickEvent,
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(left: Dimens.pt16, right: Dimens.pt16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  child: CustomNetworkImage(
                    imageUrl: widget.videoModel?.coverThumb ??
                        widget.videoModel?.cover,
                    width: 85,
                    height: 85,
                    type: ImgType.avatar,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            Container(
              height: 85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: screen.screenWidth -
                        Dimens.pt85 -
                        Dimens.pt9 -
                        (Dimens.pt16 * 2),
                    margin: EdgeInsets.only(left: Dimens.pt9),
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.videoModel?.title ?? "",
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: Dimens.pt14),
                    ),
                  ),
                  _buildItemStaticsCount(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItemStaticsCount() {
    if (_videosStatus == 1) {
      //已通过
      return Container(
        height: Dimens.pt33,
        width: Dimens.pt232,
        margin: EdgeInsets.only(left: 9),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            width: Dimens.pt75,
            height: Dimens.pt33,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromRGBO(39, 39, 39, 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.worksType == 0 ? "已推: " : "播放: ",
                  style: TextStyle(
                      fontSize: Dimens.pt12,
                      color: Color.fromRGBO(214, 214, 214, 1)),
                ),
                Text(
                  widget.worksType == 0
                      ? (videoModel.promotionDays.toString() + "天")
                      : getShowCountStr(videoModel.playCount),
                  style: TextStyle(
                      fontSize: Dimens.pt12,
                      color: Color.fromRGBO(214, 214, 214, 1)),
                ),
              ],
            ),
          ),
          Container(
            width: Dimens.pt75,
            height: Dimens.pt33,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromRGBO(39, 39, 39, 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "销量 : ",
                  style: TextStyle(
                      fontSize: Dimens.pt12,
                      color: Color.fromRGBO(214, 214, 214, 1)),
                ),
                Text(
                  getShowCountStr(videoModel.purchaseCount),
                  style: TextStyle(
                      fontSize: Dimens.pt12,
                      color: Color.fromRGBO(214, 214, 214, 1)),
                ),
              ],
            ),
          ),
          Container(
            width: Dimens.pt75,
            height: Dimens.pt33,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromRGBO(52, 52, 52, 1),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (videoModel.newsType == "COVER") {
                      showToast(msg: "图文暂不支持推广");
                      return;
                    }
                    Map<String, dynamic> maps = Map();
                    maps['videoModel'] = videoModel;
                    JRouter().go(EXTENSION_SETTING, arguments: maps);
                  },
                  child: Text(
                    "推广",
                    style: TextStyle(
                        fontSize: Dimens.pt12,
                        color: Color.fromRGBO(255, 127, 15, 1)),
                  ),
                ),
              ],
            ),
          ),
        ]),
      );
    } else {
      // 0 审核中， 2未通过
      return Container(
        height: Dimens.pt33,
        width: Dimens.pt232,
        margin: EdgeInsets.only(left: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Color.fromRGBO(29, 29, 29, 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Text(
                  widget.worksType == 0 ? "已推: " : "播放: ",
                  style: TextStyle(
                      fontSize: Dimens.pt12,
                      color: Color.fromRGBO(214, 214, 214, 1)),
                ),
                Text(
                  widget.worksType == 0
                      ? (videoModel.promotionDays.toString() + "天")
                      : getShowCountStr(videoModel.playCount),
                  style: TextStyle(
                      fontSize: Dimens.pt12,
                      color: Color.fromRGBO(214, 214, 214, 1)),
                ),
              ],
            ),
            Container(
              height: Dimens.pt24,
              width: Dimens.pt1,
              color: Color.fromRGBO(21, 21, 21, 1),
            ),
            Row(
              children: [
                Text(
                  "销量 : ",
                  style: TextStyle(
                      fontSize: Dimens.pt12,
                      color: Color.fromRGBO(214, 214, 214, 1)),
                ),
                Text(
                  getShowCountStr(videoModel.purchaseCount),
                  style: TextStyle(
                      fontSize: Dimens.pt12,
                      color: Color.fromRGBO(214, 214, 214, 1)),
                ),
              ],
            ),
            Container(
              height: Dimens.pt24,
              width: Dimens.pt1,
              color: Color.fromRGBO(21, 21, 21, 1),
            ),
            GestureDetector(
              onTap: () {
                if (_videosStatus == 2) {
                  // 未通过
                  showNotifyDialog(context, videoModel?.reason);
                }
              },
              child: Row(
                children: [
                  Text(
                    _videosStatus == 0 ? "审核中" : "未通过",
                    style: TextStyle(
                        fontSize: Dimens.pt12,
                        color: Color.fromRGBO(214, 214, 214, 1)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
