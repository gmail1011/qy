import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/local_store/cached_video_store.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/widget/music_disk_item.dart';
import 'package:flutter_app/widget/chewie/chewie_player.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_base/player/single_player.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class VideoItemState with EagleHelper implements Cloneable<VideoItemState> {
  VideoItemState({this.videoModel}) {
    if (null != videoModel && videoModel.isVideo()) {
      cacheStatus = CachedVideoStore().getCacheState(videoModel.sourceURL);
    }
  }
  String uniqueId = Uuid().v1();

  VideoModel videoModel;

  int index;

  VideoListType type;

  /// 是否允许播放
  SingleController enablePlay = SingleController(false);

  GlobalKey<MusicDiskAnState> musicKey = GlobalKey();

  TabController tabController;

  ///缓存状态
  CacheStatus cacheStatus = CacheStatus.UNCACHED;

  ///当前正在下载的index
  int imgDownloadIndex = -1;

  VideoPlayerController videoPlayerController;

  ChewieController chewieController;

  List<PopsBean> vipPops;
  bool isDone = false;
  bool isTrandVideo = false;
  @override
  VideoItemState clone() {
    return VideoItemState()
      ..uniqueId = uniqueId
      ..videoModel = videoModel
      ..index = index
      ..type = type
      ..enablePlay = enablePlay
      ..isTrandVideo = isTrandVideo
      ..musicKey = musicKey
      ..cacheStatus = cacheStatus
      ..vipPops = vipPops
      ..videoPlayerController = videoPlayerController
      ..chewieController = chewieController
      ..tabController = tabController
      ..isDone =isDone;
  }
}

VideoItemState initState(Map<String, dynamic> args) {
  return VideoItemState();
}
