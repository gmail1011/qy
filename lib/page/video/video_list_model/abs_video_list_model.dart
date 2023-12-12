import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/manager/ad_Insert_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/res/recommend_video_res.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/video_list_model/recommend_list_model.dart';
import 'package:flutter_base/local_server/m3u_preload.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'follow_list_model.dart';

/// 推荐页面共享数据模型，不才用GlobalStore的形式
abstract class AbsVideoListModel {
  bool hasNext = true;
  final tag = "BaseVideoListModel";
  int pageIndex = 1;
  VideoModel _curItem;
  RefreshController refreshController = RefreshController();

  List<VideoModel> videoLists = [];

  static AbsVideoListModel create(VideoListType type) {
    if (type == VideoListType.FOLLOW)
      return FollowListModel();
    else if (type == VideoListType.RECOMMEND)
      return RecommendListModel();
    else if (type == VideoListType.SECOND)
      // 二级播放页面的数据，在二级页面
      return null;
    else
      return null;
  }

  // static AbsVideoListModel create() {
  //   return RecommendListModel();
  // }

  /// 刷新热荐数据信息
  Future<List<VideoModel>> refreshList() async {
    var page = 1;
    RecommendListRes resp = await getNetData(page);
    if (null != resp) {
      refreshController.refreshCompleted();
      hasNext = resp.hasNext;
      pageIndex = page;
      if ((resp.vInfo?.length ?? 0) < Config.PAGE_SIZE) {
        refreshController.loadNoData();
      }
      videoLists = resp.vInfo ?? <VideoModel>[];
      AdInsertManager.insertVideoAd(videoLists);
      var first = videoLists.length > 0 ? videoLists[0] : null;
      var next = videoLists.length > 1 ? videoLists[1] : null;
      l.i(tag,
          "refreshList()...开始使用LRU缓存策略:${first?.sourceURL} url2:${next?.sourceURL}");
      ImageLoader.preloadVideoImg(first);
      M3uPreload().preCacheNext(first?.sourceURL, cachePath2: next?.sourceURL);
    } else {
      refreshController.refreshFailed();
    }
    return videoLists;
  }

  /// 加载更多热荐数据信息
  Future<List<VideoModel>> loadMoreList() async {
    var page = pageIndex + 1;
    RecommendListRes resp = await getNetData(page);
    if (null != resp) {
      refreshController.loadComplete();
      hasNext = resp.hasNext;
      pageIndex = page;
      if ((resp.vInfo?.length ?? 0) < Config.PAGE_SIZE) {
        refreshController.loadNoData();
      }
      videoLists.addAll(resp.vInfo ?? <VideoModel>[]);
      AdInsertManager.insertVideoAd(videoLists);
    } else {
      refreshController.loadFailed();
    }
    return videoLists;
  }

  VideoModel onItemChange(int index) {
    if (index >= videoLists.length)
      _curItem = null;
    else
      _curItem = videoLists[index];

    /// 礼让出主线程UI
    Future.delayed(Duration(milliseconds: 200), () {
      VideoModel first = (index + 1 < (videoLists?.length ?? 0))
          ? videoLists[index + 1]
          : null;
      VideoModel next = (index + 2 < (videoLists?.length ?? 0))
          ? videoLists[index + 2]
          : null;

      l.i(tag,
          "onItemChange()...开始使用LRU缓存策略:${first?.sourceURL} url2:${next?.sourceURL}");
      ImageLoader.preloadVideoImg(first);
      M3uPreload().preCacheNext(first?.sourceURL,
          cachePath2: next?.sourceURL, skipPath: _curItem?.sourceURL);
    });
    return _curItem;
  }

  Future<RecommendListRes> getNetData(int pageNum);

  VideoModel curItem() {
    if (_curItem != null) return _curItem;
    return onItemChange(0);
  }

  List<VideoModel> get peekVideos => videoLists;
}
