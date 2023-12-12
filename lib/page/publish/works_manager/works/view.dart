import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:get/route_manager.dart' as Gets;

import 'action.dart';
import 'state.dart';

///作品列表
Widget buildView(
    WorksListState state, Dispatch dispatch, ViewService viewService) {
  return BaseRequestView(
    retryOnTap: () => dispatch(WorksListActionCreator.refreshData()),
    controller: state.requestController,
    child: pullYsRefresh(
      refreshController: state.refreshController,
      onRefresh: () => dispatch(WorksListActionCreator.refreshData()),
      onLoading: () => dispatch(WorksListActionCreator.loadMoreData()),
      child: ListView.builder(
        padding: EdgeInsets.only(top: Dimens.pt16),
        itemExtent: Dimens.pt118,
        itemBuilder: (BuildContext context, int index) {
          return _buildWorksListItem(
              state, dispatch, viewService, state.videoList[index], index);
        },
        itemCount: state.videoList?.length ?? 0,
      ),
    ),
  );
}

///作品列表
GestureDetector _buildWorksListItem(WorksListState state, Dispatch dispatch,
    ViewService viewService, VideoModel videoModel, int index) {
  return GestureDetector(
    onTap: () {
      if (state.delModel) {
        return;
      }
      ///进入图文详情
      if ("COVER" == videoModel.newsType) {
        Gets.Get.to(
            () => CommunityDetailPage().buildPage({"videoId": videoModel?.id}),
            opaque: false);
      } else if ("SP" == videoModel.newsType) {
        ///进入短视频
        Map<String, dynamic> map = Map();
        map['playType'] = VideoPlayConfig.VIDEO_TYPE_COLLECT;
        map['currentPosition'] = index;
        map['pageNumber'] = state.pageNum;
        map['uid'] = GlobalStore.getMe()?.uid;
        map['pageSize'] = state.pageSize;
        map['type'] = 'video';
        map['videoList'] = state.videoList;
        JRouter().go(SUB_PLAY_LIST, arguments: map);
      }
    },
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
                  imageUrl: videoModel?.cover ?? "",
                  width: Dimens.pt85,
                  height: Dimens.pt85,
                  type: ImgType.avatar,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              Visibility(
                visible: state.delModel ?? false,
                child: Container(
                  width: Dimens.pt85,
                  height: Dimens.pt85,
                  alignment: Alignment.center,
                  color: Colors.black.withAlpha(200),
                  child: GestureDetector(
                    onTap: () => dispatch(
                        WorksListActionCreator.deleteVideoById(videoModel?.id)),
                    child: Image(
                      image: AssetImage(AssetsImages.ICON_MINE_DEL),
                      width: Dimens.pt42,
                      height: Dimens.pt42,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: Dimens.pt85,
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
                    videoModel?.title ?? "",
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: Dimens.pt14),
                  ),
                ),
                const SizedBox(height: 20),
                state.worksType == 0
                    ? Container(
                        height: Dimens.pt33,
                        width: Dimens.pt232,
                        margin: EdgeInsets.only(left: 9),
                        /*decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Color.fromRGBO(29, 29, 29, 1),
                        ),*/
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            Container(
                              width: Dimens.pt75,
                              height: Dimens.pt33,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(39, 39, 39,1),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(8),bottomLeft: Radius.circular(8) ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "播放 : ",
                                    style: TextStyle(
                                        fontSize: Dimens.pt12,
                                        color: Color.fromRGBO(
                                            214, 214, 214, 1)),
                                  ),
                                  Text(
                                    getShowCountStr(videoModel.playCount),
                                    style: TextStyle(
                                        fontSize: Dimens.pt12,
                                        color: Color.fromRGBO(
                                            214, 214, 214, 1)),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: Dimens.pt75,
                              height: Dimens.pt33,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(39, 39, 39,1),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "销量 : ",
                                    style: TextStyle(
                                        fontSize: Dimens.pt12,
                                        color: Color.fromRGBO(
                                            214, 214, 214, 1)),
                                  ),
                                  Text(
                                    getShowCountStr(
                                        videoModel.purchaseCount),
                                    style: TextStyle(
                                        fontSize: Dimens.pt12,
                                        color: Color.fromRGBO(
                                            214, 214, 214, 1)),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: Dimens.pt75,
                              height: Dimens.pt33,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(52, 52, 52,1),
                                borderRadius: BorderRadius.only(topRight: Radius.circular(8),bottomRight: Radius.circular(8) ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {

                                      if(videoModel.newsType == "MOVIE" || videoModel.newsType == "COVER" ){


                                        showToast(msg: "图文和影视暂不支持推广");

                                        return;
                                      }

                                      Map<String, dynamic> maps = Map();
                                      maps['videoModel'] = videoModel;
                                      JRouter().go(EXTENSION_SETTING,
                                          arguments: maps);
                                    },
                                    child: Text(
                                      "推广",
                                      style: TextStyle(
                                          fontSize: Dimens.pt12,
                                          color: Color.fromRGBO(
                                              255, 127, 15, 1)),
                                    ),
                                  ),
                                ],
                              ),
                            ),


                                  /*Row(
                                    children: [
                                      Text(
                                        "播放 : ",
                                        style: TextStyle(
                                            fontSize: Dimens.pt12,
                                            color: Color.fromRGBO(
                                                214, 214, 214, 1)),
                                      ),
                                      Text(
                                        getShowCountStr(videoModel.playCount),
                                        style: TextStyle(
                                            fontSize: Dimens.pt12,
                                            color: videoModel.playCount == 0
                                                ? Color.fromRGBO(
                                                    214, 214, 214, 1)
                                                : Color.fromRGBO(
                                                    255, 127, 15, 1)),
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
                                            color: Color.fromRGBO(
                                                214, 214, 214, 1)),
                                      ),
                                      Text(
                                        getShowCountStr(
                                            videoModel.purchaseCount),
                                        style: TextStyle(
                                            fontSize: Dimens.pt12,
                                            color: videoModel.purchaseCount == 0
                                                ? Color.fromRGBO(
                                                    214, 214, 214, 1)
                                                : Color.fromRGBO(
                                                    255, 127, 15, 1)),
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
                                      GestureDetector(
                                        onTap: () {

                                          if(videoModel.newsType == "MOVIE" || videoModel.newsType == "COVER" ){


                                            showToast(msg: "图文和影视暂不支持推广");

                                            return;
                                          }

                                          Map<String, dynamic> maps = Map();
                                          maps['videoModel'] = videoModel;
                                          JRouter().go(EXTENSION_SETTING,
                                              arguments: maps);
                                        },
                                        child: Text(
                                          "推广",
                                          style: TextStyle(
                                              fontSize: Dimens.pt12,
                                              color: Color.fromRGBO(
                                                  255, 127, 15, 1)),
                                        ),
                                      ),
                                    ],
                                  ),*/
                                ]
                        ),
                      )
                    : state.worksType == 1
                        ? Container(
                            height: Dimens.pt33,
                            width: Dimens.pt232,
                            margin: EdgeInsets.only(left: 9),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Color.fromRGBO(29, 29, 29, 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "播放 : ",
                                      style: TextStyle(
                                          fontSize: Dimens.pt12,
                                          color:
                                              Color.fromRGBO(214, 214, 214, 1)),
                                    ),
                                    Text(
                                      getShowCountStr(videoModel.playCount),
                                      style: TextStyle(
                                          fontSize: Dimens.pt12,
                                          color: Color.fromRGBO(
                                              214, 214, 214, 1)),
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
                                          color:
                                              Color.fromRGBO(214, 214, 214, 1)),
                                    ),
                                    Text(
                                      getShowCountStr(videoModel.purchaseCount),
                                      style: TextStyle(
                                          fontSize: Dimens.pt12,
                                          color: Color.fromRGBO(
                                              214, 214, 214, 1)),
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
                                      "审核中",
                                      style: TextStyle(
                                          fontSize: Dimens.pt12,
                                          color:
                                              Color.fromRGBO(214, 214, 214, 1)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: Dimens.pt33,
                            width: Dimens.pt232,
                            margin: EdgeInsets.only(left: 9),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              color: Color.fromRGBO(29, 29, 29, 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "播放 : ",
                                      style: TextStyle(
                                          fontSize: Dimens.pt12,
                                          color:
                                              Color.fromRGBO(214, 214, 214, 1)),
                                    ),
                                    Text(
                                      getShowCountStr(videoModel.playCount),
                                      style: TextStyle(
                                          fontSize: Dimens.pt12,
                                          color:
                                              Color.fromRGBO(214, 214, 214, 1)),
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
                                          color:
                                              Color.fromRGBO(214, 214, 214, 1)),
                                    ),
                                    Text(
                                      getShowCountStr(videoModel.purchaseCount),
                                      style: TextStyle(
                                          fontSize: Dimens.pt12,
                                          color:
                                              Color.fromRGBO(214, 214, 214, 1)),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: Dimens.pt24,
                                  width: Dimens.pt1,
                                  color: Color.fromRGBO(21, 21, 21, 1),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    showNotifyDialog(viewService.context, videoModel?.reason);
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "未通过",
                                        style: TextStyle(
                                            fontSize: Dimens.pt12,
                                            color:
                                                Color.fromRGBO(214, 214, 214, 1)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                /*Row(
                  children: [
                    const SizedBox(width: 10),
                    Image(
                        image: AssetImage(AssetsImages.IC_WORKS_MSG),
                        width: Dimens.pt22,
                        height: Dimens.pt22),
                    const SizedBox(width: 10),
                    Text(
                      "${videoModel?.commentCount ?? 0}",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: Dimens.pt12),
                    ),
                    const SizedBox(width: 25),
                    Image(
                        image: AssetImage(AssetsImages.IC_WORKS_EYE),
                        width: Dimens.pt22,
                        height: Dimens.pt22),
                    const SizedBox(width: 10),
                    Text(
                      "${videoModel?.playCount ?? 0}",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: Dimens.pt12),
                    ),
                    const SizedBox(width: 25),
                    Visibility(
                      visible: videoModel?.status == 2,
                      child: GestureDetector(
                        onTap: () =>
                            showNotifyDialog(viewService, videoModel?.reason),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xff2c2c2c),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14)),
                          ),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.pt15, Dimens.pt6, Dimens.pt15, Dimens.pt6),
                          child: Text(
                            "未通过",
                            style: TextStyle(
                              color: Color(0xffe3e3e3),
                              fontSize: Dimens.pt12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),*/
              ],
            ),
          )
        ],
      ),
    ),
  );
}

///展示通知对话框UI
Future<String> showNotifyDialog(BuildContext context, String reason) {
  return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: Dimens.pt286,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(Dimens.pt30),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        AssetsImages.BG_WORKS_NOTIFY,
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "审核通知!",
                        style: TextStyle(
                            fontSize: Dimens.pt18,
                            color: Color(0xffff7600),
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: Dimens.pt17, bottom: Dimens.pt20),
                        child: Text(
                          reason ?? "",
                          style: TextStyle(
                              fontSize: Dimens.pt16,
                              color: Color(0xff151515).withOpacity(0.5)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimens.pt16),
                GestureDetector(
                  onTap: () => safePopPage("cancel"),
                  child: svgAssets(AssetsSvg.CLOSE_BTN,
                      width: Dimens.pt33, height: Dimens.pt33),
                ),
              ],
            ),
          ),
        );
      });
}
