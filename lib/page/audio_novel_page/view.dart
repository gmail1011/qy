import 'package:audioplayers/audioplayers.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/local_audio_store.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_app/page/audio_novel_page/action.dart';
import 'package:flutter_app/page/audio_novel_page/rotate_image.dart';
import 'package:flutter_app/page/audio_novel_page/ys_audio_player.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/view.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rive/rive.dart';
import 'audio_player_widget.dart';
import 'state.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;

Widget buildView(
    AudioNovelState state, Dispatch dispatch, ViewService viewService) {
  Widget _getAnchor() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (state.audioBook?.anchorInfo == null) {
          return;
        }
        await JRouter().go(PAGE_VOICE_ANCHOR_INFO,
            arguments: {'model': state.audioBook?.anchorInfo});
        dispatch(AudioNovelActionCreator.onRefresh());
      },
      child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppPaddings.appMargin,
          ),
          child: Column(
            children: [
              // getHengLine(),
              novelHline(),
              SizedBox(height: AppPaddings.padding8),
              Row(children: [
                HeaderWidget(
                  headPath: state.audioBook?.anchorInfo?.avatar ?? '',
                  level: 0,
                  headWidth: Dimens.pt40,
                  headHeight: Dimens.pt40,
                ),
                SizedBox(width: AppPaddings.padding8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.audioBook?.anchorInfo?.name ?? "",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: AppFontSize.fontSize16),
                    ),
                    SizedBox(height: AppPaddings.padding4),
                    Text(
                      "作品: ${state.audioBook?.anchorInfo?.totalRaido ?? 0}部",
                      style: TextStyle(
                          color: AppColors.tipTextColor99,
                          fontSize: AppFontSize.fontSize10),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                getLinearGradientBtn(
                    (state.audioBook?.anchorInfo?.isCollect ?? false)
                        ? "已收藏"
                        : "收藏",
                    width: Dimens.pt60,
                    height: Dimens.pt28,
                    enableColors:
                        (state.audioBook?.anchorInfo?.isCollect ?? false)
                            ? [Colors.grey, Colors.grey]
                            : null,
                    onTap: () =>
                        dispatch(AudioNovelActionCreator.collectAnchor()))
              ]),
              SizedBox(height: AppPaddings.padding8),
              // getHengLine(),
              // agentHLine(),
              novelHline()
            ],
          )),
    );
  }

  var playerH = Dimens.pt20 + 126;
  return FullBg(
    child: Scaffold(
        appBar: getCommonAppBar(state.audioBook?.title ?? '',
            centerTitle: false,
            actions: [
              GestureDetector(
                  onTap: () =>
                      dispatch(AudioNovelActionCreator.collectAudioBook()),
                  child: Row(
                    children: [
                      ImageLoader.withP(ImageType.IMAGE_SVG,
                              address: (state.audioBook?.isCollect ?? false)
                                  ? AssetsSvg.COLLECTIONED
                                  : AssetsSvg.NO_COLLECTION)
                          .load(),
                      SizedBox(width: Dimens.pt6),
                      Text(
                        (state.audioBook?.isCollect ?? false) ? "已收藏" : "收藏",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: AppFontSize.fontSize12),
                      ),
                      SizedBox(width: Dimens.pt12)
                    ],
                  ))
            ]),
        body: extended.NestedScrollView(
          body: ListView.builder(
            padding: EdgeInsets.all(0),
            itemBuilder: (context, index) {
              var item = state.recommendList[index];
              return _item(
                item,
                () async {
                  var res = await showConfirm(context,
                      cancelText: "取消",
                      showCancelBtn: true,
                      title: "温馨提示",
                      content: "确认播放《${item.title}》");
                  if (res) {
                    dispatch(AudioNovelActionCreator.loadData(item.id, null));
                  }
                },
              );
            },
            itemCount: state.recommendList?.length ?? 0,
          ),
          pinnedHeaderSliverHeightBuilder: () =>
              playerH + kToolbarHeight + screen.paddingTop + 20,
          innerScrollPositionKeyBuilder: () {
            return Key("index11111");
          },
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            var name = state.audioBook?.contentSet
                    ?.firstWhere(
                        (it) => it.episodeNumber == state.episodeNumber,
                        orElse: () => null)
                    ?.name ??
                Lang.UN_KNOWN;
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                snap: false,
                expandedHeight: Dimens.pt370,
                primary: true,
                elevation: 0,
                bottom: PreferredSize(
                  child: AudioPlayerWidget(
                    url: state.url,
                    title: Row(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("正在播放: $name",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFontSize.fontSize12)),
                          SizedBox(width: Dimens.pt2),
                          if ((state.record?.cur ?? 0) > 0)
                            GestureDetector(
                              onTap: () {
                                // do seek
                                if (!(curAudioPlayer?.isDispose ?? false)) {
                                  showToast(
                                      msg: "正在缓冲，请稍后...",
                                      toastLength: Toast.LENGTH_SHORT);
                                  curAudioPlayer.seek(Duration(
                                      seconds: state.record?.cur ?? 0));
                                }
                              },
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: Dimens.pt2),
                                child: Text(
                                    "上次播放进度: ${buildMMSS(state.record.cur)}",
                                    style: TextStyle(
                                        color: Color(0xFF2AB1DB),
                                        decoration: TextDecoration.underline,
                                        // decorationStyle: TextDecorationStyle(),
                                        fontSize: AppFontSize.fontSize10)),
                              ),
                            ),
                        ]),
                    prevClick: () {
                      if (state.audioBook == null || state.episodeNumber <= 0)
                        return;
                      var index = state.audioBook?.contentSet?.indexWhere(
                              (it) =>
                                  it.episodeNumber == state.episodeNumber) ??
                          -1;
                      if (index - 1 < 0) {
                        showToast(msg: "没有更多集数了");
                        return;
                      }
                      dispatch(AudioNovelActionCreator.playAudioEpisode(
                          state.audioBook.contentSet[index - 1]));
                    },
                    nextClick: () {
                      if (state.audioBook == null || state.episodeNumber <= 0)
                        return;
                      var index = state.audioBook?.contentSet?.indexWhere(
                              (it) =>
                                  it.episodeNumber == state.episodeNumber) ??
                          state.audioBook.totalEpisode;
                      if (index + 1 >=
                          (state.audioBook?.contentSet?.length ?? 0)) {
                        showToast(msg: "没有更多集数了");
                        return;
                      }
                      dispatch(AudioNovelActionCreator.playAudioEpisode(
                          state.audioBook.contentSet[index + 1]));
                    },
                    leftChild: GestureDetector(
                      onTap: () {
                        // 播放列表
                        dispatch(AudioNovelActionCreator.onClickPlayList());
                      },
                      child: Column(
                        children: [
                          ImageLoader.withP(ImageType.IMAGE_SVG,
                                  address: AssetsSvg.AUDIO_PLAYER_LIST)
                              .load(),
                          Text("播放列表",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFontSize.fontSize12))
                        ],
                      ),
                    ),
                    rightChild: GestureDetector(
                      onTap: () {
                        // 分享
                        showShareVideoDialog(context, null);
                      },
                      child: Column(
                        children: [
                          ImageLoader.withP(ImageType.IMAGE_SVG,
                                  address: AssetsSvg.AUDIO_PLAYER_SHARE)
                              .load(),
                          Text("无限畅听",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFontSize.fontSize12))
                        ],
                      ),
                    ),
                    onStateChange: (playerState) async {
                      // var position = await curAudioPlayer.getCurrentPosition();
                      // var duration = await curAudioPlayer.getDuration();
                      // LocalAudioStore().saveRecord(state.audioBook,
                      //     state.curEpisode, position ~/ 1000, duration ~/ 1000);
                      // print(
                      //     "getDuration()...position:$position duration:$duration");
                      if (playerState == AudioPlayerState.PLAYING) {
                        state.riveController?.isActive = true;
                        state.imageKey.currentState.startPlay();
                      } else {
                        state.imageKey.currentState.stopPlay();
                        state.riveController?.isActive = false;
                      }
                    },
                    onPosUpdate: (update) async {
                      var curEpisode = state.audioBook?.contentSet?.firstWhere(
                          (it) => it.episodeNumber == state.episodeNumber,
                          orElse: () => null);
                      LocalAudioStore().saveRecord(state.audioBook, curEpisode,
                          update.pos.inSeconds, update.duration.inSeconds);
                    },
                    onInit: (player) {
                      if (TextUtil.isNotEmpty(state.url)) return true;
                      var curEpisode = state.audioBook?.contentSet?.firstWhere(
                          (it) => it.episodeNumber == state.episodeNumber,
                          orElse: () => null);
                      if (null == curEpisode) return false;
                      var per = -1;
                      if (ArrayUtil.isNotEmpty(state.audioBook?.contentSet)) {
                        per = curEpisode?.listenPermission ?? -1;
                      }
                      if (per == 0) {
                        // show buy vip
                        if ((GlobalStore.getMe()?.isVip ?? false)) {
                          return true;
                        } else {
                          dispatch(AudioNovelActionCreator.buyVip());
                          return false;
                        }
                      } else if (per == 1) {
                        // show buy gold
                        if (null != curEpisode) {
                          if (curEpisode.isBrought) {
                            return true;
                          } else {
                            dispatch(
                                AudioNovelActionCreator.buyAudio(curEpisode));
                          }
                        }
                        return false;
                      }
                      return true;
                    },
                    shouldPlay: () async {
                      if (TextUtil.isNotEmpty(state.url)) return true;
                      var curEpisode = state.audioBook?.contentSet?.firstWhere(
                          (it) => it.episodeNumber == state.episodeNumber,
                          orElse: () => null);
                      if (null == curEpisode) return false;
                      var per = -1;
                      if (ArrayUtil.isNotEmpty(state.audioBook?.contentSet)) {
                        per = curEpisode?.listenPermission ?? -1;
                      }
                      if (per == 0) {
                        // show buy vip
                        if ((GlobalStore.getMe()?.isVip ?? false)) {
                          return true;
                        } else {
                          dispatch(AudioNovelActionCreator.buyVip());
                          return false;
                        }
                      } else if (per == 1) {
                        // show buy gold
                        if (null != curEpisode) {
                          if (curEpisode.isBrought) {
                            return true;
                          } else {
                            dispatch(
                                AudioNovelActionCreator.buyAudio(curEpisode));
                          }
                        }
                        return false;
                      }
                      return true;
                    },
                  ),
                  preferredSize: Size(Dimens.pt360, playerH),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Column(
                    children: [
                      Container(
                        width: screen.screenWidth,
                        height: Dimens.pt220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            null == state.riveArtboard
                                ? Container()
                                : Container(
                                    child: Rive(artboard: state.riveArtboard)),
                            RotateImage(
                                url: state.audioBook?.cover ?? "",
                                key: state.imageKey,
                                iconSize: Dimens.pt48)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _getAnchor(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(AppPaddings.appMargin),
                  child: Text(
                    "听了该节目的也在听",
                    style: TextStyle(
                        fontSize: AppFontSize.fontSize13,
                        color: AppColors.itemBgWhite),
                  ),
                ),
              )
            ];
          },
        )),
  );
}

_item(AudioBook item, VoidCallback onTap) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: Container(
      margin:
          EdgeInsets.symmetric(horizontal: AppPaddings.appMargin, vertical: 6),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF2F2F5F),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                CustomNetworkImage(
                  imageUrl: item.cover ?? '',
                  fit: BoxFit.cover,
                  height: Dimens.pt50,
                  width: Dimens.pt50,
                ),
                ((item?.contentSet?.length ?? 0) == 0
                        ? false
                        : ((item?.contentSet?.first?.listenPermission ?? 0) ==
                            1))
                    ? Positioned(
                        right: 0,
                        top: -2,
                        child: svgAssets(AssetsSvg.XIAOSHUO_VIP, height: 16),
                      )
                    : Container(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: Dimens.pt50,
              padding: EdgeInsets.only(left: 16),
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
                            fontSize: AppFontSize.fontSize14,
                          ),
                        ),
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
                  ),
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
                        "${item.countCollect}",
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
  );
}
