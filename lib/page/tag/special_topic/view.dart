import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/special_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/search/search_view/search_appbar.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/page/tag/special_topic/action.dart';
import 'package:flutter_app/widget/video_time_view.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:get/route_manager.dart' as Gets;
import 'state.dart';

/// 专题页
Widget buildView(
    SpecialTopicState state, Dispatch dispatch, ViewService viewService) {
  ///主体
  return FullBg(
    child: GestureDetector(
      onTap: () {
        FocusScope.of(viewService.context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: SearchAppBar(
          controller: TextEditingController(),
          autofocus: false,
          showCancelBtn: false,
          onTap: () {
            FocusScope.of(viewService.context).requestFocus(FocusNode());
            JRouter().go(PAGE_SEARCH);
          },
        ),
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
                      return itemView(item, dispatch, viewService);
                    },
                  ),
                  onLoading: () {
                    dispatch(SpecialTopicActionCreator.loadMoreData());
                  },
                  onRefresh: () {
                    dispatch(SpecialTopicActionCreator.loadData());
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

Widget itemView(ListBeanSp item, Dispatch dispatch, ViewService viewService) {
  var list = item.vidInfo;
  if (item.vidInfo.length > 3) {
    list = item.vidInfo.sublist(0, 3);
  }

  return Container(
    padding: EdgeInsets.all(AppPaddings.appMargin),
    child: Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            dispatch(SpecialTopicActionCreator.onTagClick(item));
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "#" + item.tagName,
                  style: TextStyle(
                      color: Colors.white, fontSize: AppFontSize.fontSize20),
                ),
                Row(
                  children: [
                    Text(
                      numCoverStr(item.tPlayCount) + Lang.PLAY_COUNT,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: AppFontSize.fontSize12),
                    ),
                    Icon(
                      Icons.navigate_next,
                      color: Colors.white,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          width: screen.screenWidth,
          child: Padding(
            padding: EdgeInsets.only(
                top: Dimens.pt10, left: Dimens.pt5, right: Dimens.pt5),
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
                        if (isHorizontalVideo(
                            resolutionWidth(item.vidInfo[item.vidInfo.indexOf(e)].resolution),
                            resolutionHeight(item.vidInfo[item.vidInfo.indexOf(e)].resolution))) {
                          Gets.Get.to(VideoPage(item.vidInfo[item.vidInfo.indexOf(e)]),opaque: false);
                        } else {
                          Gets.Get.to(SubPlayListPage().buildPage(maps), opaque: false);
                        }
                      }))
                  .toList(),
            ),
          ),
        ),
        SizedBox(
          height: AppPaddings.appMargin,
        ),
        ImageLoader.withP(ImageType.IMAGE_ASSETS,
                address: AssetsImages.LINE, width: screen.screenWidth)
            .load(),
      ],
    ),
  );
}

Widget getBodyItem(VideoModel item, VoidCallback onTap) {
  return Expanded(
    flex: 1,
    child: Container(
      padding: EdgeInsets.all(2),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CustomNetworkImage(
                      imageUrl: item.cover,
                      type: ImgType.cover,
                      height: Dimens.pt145,
                      fit: BoxFit.cover,
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
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: Dimens.pt4),
              child: Text(
                item.title,
                style: TextStyle(color: Color(0xff9b9b9b)),
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
