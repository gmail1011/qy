
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/flare.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/local_audio_store.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_app/new_page/recharge/recharge_vip_page.dart';
import 'package:flutter_app/widget/dialog/bottom_book_play_list.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_app/widget/dialog/vip_level_dialog.dart';
import 'package:flutter_app/widget/goldcoin_recharge_dialog.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:rive/rive.dart';
import 'action.dart';
import 'state.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart' as Gets;

Effect<AudioNovelState> buildEffect() {
  return combineEffects(<Object, Effect<AudioNovelState>>{
    Lifecycle.initState: _init,
    Lifecycle.dispose: _dispose,
    AudioNovelAction.onClickPlayList: _onClickPlayList,
    AudioNovelAction.loadData: _loadData,
    AudioNovelAction.buyVip: _onBuyVip,
    AudioNovelAction.collectAnchor: _collectAnchor,
    AudioNovelAction.collectAudioBook: _collectAudioBook,
    AudioNovelAction.buyAudio: _onBuyAudio,
  });
}

void _collectAnchor(Action action, Context<AudioNovelState> ctx) async {
  try {
    await netManager.client.clickCollect(ctx.state.audioBook.anchorInfo.id,
        "audioAnchor", !ctx.state.audioBook.anchorInfo.isCollect);
    ctx.dispatch(AudioNovelActionCreator.refreshCollectAnchor());
  } catch (e) {}
}

void _collectAudioBook(Action action, Context<AudioNovelState> ctx) async {
  try {
    await netManager.client.clickCollect(
        ctx.state.audioBook.id, "audiobook", !ctx.state.audioBook.isCollect);
    ctx.dispatch(AudioNovelActionCreator.refreshCollectAudioBook());
  } catch (e) {}
}

void _onBuyVip(Action action, Context<AudioNovelState> ctx) async {
  showVipLevelDialog(
    ctx.context,
    Lang.VIP_LEVEL_DIALOG_MSG1,
  );
}

void _onBuyAudio(Action action, Context<AudioNovelState> ctx) async {
  EpisodeModel episode = action.payload;
  int price;
  if (null != episode) {
    price = episode?.price ?? 0;
  } else {
    price = ctx.state.audioBook.discountPrice;
  }
  var val = await showConfirm(ctx.context,
      title: "需要花费$price 金币收听", showCancelBtn: true);
  if (null == val || !val) return;
  // 小说id
  String productID = ctx.state.audioBook.id;
  // 选集id
  String chapterID;
  if (episode != null) {
    // 选集对象
    chapterID = '${episode.episodeNumber}';
  }
  try {
    await netManager.client.postBuyNovel(8, productID, chapterID);
    showToast(msg: '购买成功！');
    // _loadData(action, ctx);
    ctx.dispatch(AudioNovelActionCreator.loadData(
        ctx.state.id, ctx.state.episodeNumber));
  } on DioError catch (e) {
    var error = e.error;
    if (error is ApiException) {
      if (error.code == 8000) {
        Gets.Get.to(() =>RechargeVipPage(""),opaque: false);
      }
    }
    l.e('postBuyNovel=', e.toString());
  }
}

void _init(Action action, Context<AudioNovelState> ctx) async {
  ctx.dispatch(
      AudioNovelActionCreator.loadData(ctx.state.id, ctx.state.episodeNumber));
  // _loadData(action, ctx);

  var data = await rootBundle.load(AssetsFlare.BG_AUDIO_PLAYING);
  final file = RiveFile();
  if (file.import(data)) {
    // The artboard is the root of the animation and gets drawn in the
    // Rive widget.
    ctx.state.riveArtboard = file.mainArtboard;
    // Add a controller to play back a known animation on the main/default
    // artboard.We store a reference to it so we can toggle playback.
    ctx.state.riveController = SimpleAnimation('playBG');
    ctx.state.riveController.isActive = false;
    ctx.state.riveArtboard.addController(ctx.state.riveController);
    ctx.dispatch(AudioNovelActionCreator.onRefresh());
  }
}

/// 点击播放列表图标
void _onClickPlayList(Action action, Context<AudioNovelState> ctx) async {
  /// 当前播放位置
  if (ctx.state.audioBook == null || ctx.state.episodeNumber <= 0) return;
  int playIndex = ctx.state.audioBook.contentSet
      .indexWhere((it) => it.episodeNumber == ctx.state.episodeNumber);
  var selectIndex = await showBookPlayListDialog(
      ctx.context, ctx.state.audioBook,
      playIndex: playIndex, onClickList: (index) => _selectIndex(index, ctx));

  /// 购买列表
  if (null != selectIndex) {
    if (selectIndex >= 0) {
      // buy single
      var episode = ctx.state.audioBook.contentSet[selectIndex];
      ctx.dispatch(AudioNovelActionCreator.buyAudio(episode));
    } else {
      // buy all
      ctx.dispatch(AudioNovelActionCreator.buyAudio(null));
    }
  }
}

/// 选集
void _selectIndex(int index, Context<AudioNovelState> ctx) async{
  if (ctx.state.audioBook == null || ctx.state.episodeNumber <= 0) return;
  var record = await LocalAudioStore()
          .getRecord(ctx.state.audioBook.id, ctx.state.episodeNumber);
      ctx.dispatch(AudioNovelActionCreator.getRecordOkay(record));
  ctx.dispatch(AudioNovelActionCreator.playAudioEpisode(
      ctx.state.audioBook.contentSet[index]));
}

void _loadData(Action action, Context<AudioNovelState> ctx) async {
  var map = action.payload as Map<String, dynamic>;
  String id = map['id'];
  int episodeNumber = map['episodeNumber'];
  try {
    var audioBook = await netManager.client.getAudioBookDetail(id);
    ctx.dispatch(AudioNovelActionCreator.getAudioBookOkay(audioBook));
    try {
      netManager.client.audioBookBrowse(ctx.state.id);
    } catch (e) {}

    EpisodeModel episode = audioBook?.contentSet?.firstWhere(
        (it) => it.episodeNumber == episodeNumber,
        orElse: () => null);
    if (episode == null && ArrayUtil.isNotEmpty(audioBook?.contentSet)) {
      episode = audioBook.contentSet[0];
    }
    if (null != episode) {
      ctx.dispatch(AudioNovelActionCreator.playAudioEpisode(episode));
      var record = await LocalAudioStore()
          .getRecord(audioBook.id, episode.episodeNumber);
      ctx.dispatch(AudioNovelActionCreator.getRecordOkay(record));
    }
  } catch (e) {
    l.e("getAudioBookDetail", e.toString());
    showToast(msg: "获取信息失败");
  }

  _recommendList(action, ctx);
}

void _recommendList(Action action, Context<AudioNovelState> ctx) async {
  try {
    var model = await netManager.client.getAudioBookRandomList(20);
    ctx.dispatch(AudioNovelActionCreator.setRecommendList(model.list));
  } catch (e) {}
}

void _dispose(Action action, Context<AudioNovelState> ctx) async {
  ctx.state.riveController?.isActive = false;
  ctx.state.riveController?.dispose();
  ctx.state.riveController = null;
  ctx.state.riveArtboard = null;
  ctx.state.imageKey?.currentState?.stopPlay();
}
