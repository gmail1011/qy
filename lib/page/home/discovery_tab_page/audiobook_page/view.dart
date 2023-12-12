import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/action.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';

import 'state.dart';

Widget buildView(
    AudiobookState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    child: PullRefreshView(
      controller: state.pullRefreshController,
      enablePullUp: false,
      retryOnTap: () {
        dispatch(AudiobookActionCreator.loadData());
      },
      onRefresh: () {
        dispatch(AudiobookActionCreator.loadData());
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            _bgView(
              visible: (state.audioBookHomeModel?.anchor?.length ?? 0) != 0,
              title: "主播",
              titleTap: () {
                JRouter().go(PAGE_VOICE_ANCHOR_LIST);
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      (state.audioBookHomeModel?.anchor?.length ?? 0),
                      (index) {
                        var item = state.audioBookHomeModel?.anchor[index];
                        return GestureDetector(
                          onTap: () {
                            /*eagleClick(state.selfId(),
                                sourceId: state.eagleId(viewService.context),
                                label:
                                    "audio_novel_author:${GlobalStore.isVIP()}");*/
                            JRouter().go(PAGE_VOICE_ANCHOR_INFO,
                                arguments: {'model': item});
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HeaderWidget(
                                headPath: item.avatar,
                                level: 0,
                                headWidth: Dimens.pt40,
                                headHeight: Dimens.pt40,
                              ),
                              Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  height: 1.8,
                                  fontSize: AppFontSize.fontSize12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            _bgView(
              visible:
                  (state.audioBookHomeModel?.pushAudioBook?.length ?? 0) != 0,
              title: "推荐",
              titleTap: () {
                JRouter().go(PAGE_AUDIOBOOK_MORE);
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.all(0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      var item = state.audioBookHomeModel?.pushAudioBook[index];
                      return GestureDetector(
                          onTap: () {
                            /*eagleClick(state.selfId(),
                                sourceId: state.eagleId(viewService.context),
                                label: "audio_novel:${GlobalStore.isVIP()}");*/
                            JRouter().go(AUDIO_NOVEL_PAGE,
                                arguments: {"id": item.id});
                          },
                          child: _pushItem(item));
                    },
                    itemCount:
                        state.audioBookHomeModel?.pushAudioBook?.length ?? 0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      dispatch(AudiobookActionCreator.setLoading(true));
                      dispatch(AudiobookActionCreator.changePush());
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: AppPaddings.appMargin),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          state.isLoading
                              ? LoadingWidget(
                                  width: 20,
                                  height: 20,
                                )
                              : svgAssets(AssetsSvg.HUANYIHUAN),
                          SizedBox(
                            width: 6,
                          ),
                          Text(
                            "换一换",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSize.fontSize14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            _bgView(
              visible:
                  (state.audioBookHomeModel?.newAudioBook?.length ?? 0) != 0,
              title: "最新",
              titleTap: () {
                JRouter().go(PAGE_AUDIOBOOK_MORE);
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      var item = state.audioBookHomeModel?.newAudioBook[index];
                      return _newsItem(item);
                    },
                    itemCount:
                        state.audioBookHomeModel?.newAudioBook?.length ?? 0,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _pushItem(AudioBook item) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                CustomNetworkImage(
                  imageUrl: item.cover ?? '',
                  fit: BoxFit.cover,
                  type: ImgType.audiobook,
                  height: double.infinity,
                ),
                ((item?.contentSet?.length ?? 0) == 0
                        ? false
                        : ((item?.contentSet?.first?.listenPermission ?? 0) ==
                            1))
                    ? Positioned(
                        right: 0,
                        top: -2,
                        child: svgAssets(AssetsSvg.XIAOSHUO_VIP, height: 20),
                      )
                    : Container(
                        padding: EdgeInsets.all(3),
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.3)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${item.totalEpisode ?? 0}集',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: Dimens.pt9,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            svgAssets(AssetsSvg.PLAYER_COUNT),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              '${item.countBrowse ?? 0}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: Dimens.pt9,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Text(
            item.title ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppFontSize.fontSize12,
            ),
          ),
        ),
        Text(
          item.anchor ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: AppFontSize.fontSize10,
          ),
        ),
      ],
    ),
  );
}

Widget _newsItem(AudioBook item) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      JRouter().go(AUDIO_NOVEL_PAGE, arguments: {"id": item.id});
    },
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  overflow: Overflow.visible,
                  children: [
                    Container(
                      width: Dimens.pt40,
                      height: Dimens.pt40,
                      child: CustomNetworkImage(
                        imageUrl: item.cover ?? '',
                        fit: BoxFit.cover,
                        type: ImgType.audiobook,
                        width: Dimens.pt40,
                        height: Dimens.pt40,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: -2,
                      child: Visibility(
                          visible: ((item?.contentSet?.length ?? 0) == 0
                              ? false
                              : ((item?.contentSet?.first?.listenPermission ??
                                      0) ==
                                  1)),
                          child: svgAssets(AssetsSvg.XIAOSHUO_VIP, height: 10)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: Dimens.pt40,
                  padding: EdgeInsets.only(left: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppFontSize.fontSize12,
                              ),
                            ),
                          ),
                          Text(
                            item.anchor ?? '',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: Dimens.pt9,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              svgAssets(
                                AssetsSvg.PLAYER_COUNT,
                                width: Dimens.pt10,
                                height: Dimens.pt10,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                "${item.countBrowse ?? 0}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: Dimens.pt9,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              svgAssets(
                                AssetsSvg.NO_COLLECTION,
                                width: Dimens.pt10,
                                height: Dimens.pt10,
                                color: Colors.white.withOpacity(0.8),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                "${item.countCollect ?? 0}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: Dimens.pt9,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${item.totalEpisode ?? 0}集',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: Dimens.pt9,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        novelHline(),
      ],
    ),
  );
}

Widget _bgView(
    {Widget child, String title, VoidCallback titleTap, bool visible = true}) {
  return Visibility(
    visible: visible,
    child: Container(
      margin:
          EdgeInsets.symmetric(horizontal: AppPaddings.appMargin, vertical: 6),
      padding: EdgeInsets.all(AppPaddings.appMargin),
      decoration: BoxDecoration(
          color: Color(0xFF2F2F5F), borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: titleTap,
            child: Container(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFFFFC700),
                      fontSize: AppFontSize.fontSize14,
                    ),
                  ),
                  svgAssets(AssetsSvg.IC_LEFT)
                ],
              ),
            ),
          ),
          novelHline(),
          child,
        ],
      ),
    ),
  );
}

Widget novelHline() {
  return Container(
    child: ImageLoader.withP(ImageType.IMAGE_ASSETS,
            address: AssetsImages.XIAOSHUO_LINE,
            width: screen.screenWidth,
            color: Colors.white.withOpacity(0.1),
            height: 1)
        .load(),
  );
}
