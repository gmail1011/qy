import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:get/route_manager.dart' as Gets;
import 'action.dart';
import 'state.dart';

Widget buildView(
    SearchVideoState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    body: BaseRequestView(
      controller: state.baseRequestController,
      child: pullYsRefresh(
        onLoading: () {
          dispatch(SearchVideoActionCreator.loadMoedData());
        },
        onRefresh: () {
          dispatch(SearchVideoActionCreator.loadData());
        },
        refreshController: state.refreshController,
        child: GridView.builder(
            padding: EdgeInsets.all(2),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                childAspectRatio: 164 / 252,
                crossAxisCount: 2),
            itemCount: state.searchVideos?.length ?? 0,
            itemBuilder: (context, index) {
              var item = state.searchVideos[index];
              return GestureDetector(
                onTap: () {
                  Map<String, dynamic> map = Map();
                  map["playType"] = VideoPlayConfig.VIDEO_MORE_SEARCH;
                  map["currentPosition"] = index;
                  map["pageSize"] = state.pageSize;
                  map['keyWords'] = [state.keywords];
                  map['realm'] = 'video';
                  map["pageNumber"] = state.pageNumber;
                  map['videoList'] = state.searchVideos;
                  if (isHorizontalVideo(
                      resolutionWidth(state.searchVideos[index].resolution),
                      resolutionHeight(state.searchVideos[index].resolution))) {
                    Gets.Get.to(VideoPage(state.searchVideos[index]),opaque: false);
                  } else {
                    Gets.Get.to(SubPlayListPage().buildPage(map), opaque: false);
                  }
                },
                child: _videoStack(item),
              );
            }),
      ),
    ),
  );
}

Widget _videoStack(VideoModel model) {
  return Stack(
    children: <Widget>[
      CustomNetworkImage(
        imageUrl: model.cover,
        errorWidget: Icon(Icons.error),
        type: ImgType.common,
      ),
      Positioned(
        right: Dimens.pt5,
        top: Dimens.pt5,
        child: model.isVideo()
            ? Container()
            : svgAssets(
                AssetsSvg.ITEM_IMG_TIP,
                width: Dimens.pt16,
                height: Dimens.pt16,
              ),
      ),
      Positioned(
        bottom: 0,
        right: 0,
        left: 0,
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 6,
            top: 6,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ), //背景渐变
            //圆角
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model.title}',
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        HeaderWidget(
                          headPath: model.publisher.portrait,
                          level: model.publisher.superUser == 1 ? 1 : 0,
                          headWidth: Dimens.pt20,
                          headHeight: Dimens.pt20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            '${model.publisher.name}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white),
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        svgAssets(AssetsSvg.SEARCH_PAGE_SEARCH_WHITE_STAR,
                            width: Dimens.pt14,
                            height: Dimens.pt12,
                            fit: BoxFit.fill),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            model.likeCount >= 10000
                                ? '${(model.likeCount / 10000).toStringAsFixed(1)}W'
                                : '${model.likeCount}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
