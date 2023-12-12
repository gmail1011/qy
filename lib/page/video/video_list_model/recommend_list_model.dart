// 推荐数据共享模型
import 'package:flutter/foundation.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/res/recommend_video_res.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/player_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/utils/log.dart';
import 'abs_video_list_model.dart';

RecommendListModel recommendListModel = RecommendListModel();

/// 推荐页面共享数据模型，不才用GlobalStore的形式
class RecommendListModel extends AbsVideoListModel with ChangeNotifier {
  VideoModel lastModel;
  ValueChanged<int> _onItemChanged;
  static RecommendListModel _instance;
  factory RecommendListModel() {
    if (_instance == null) {
      _instance = RecommendListModel._();
    }
    return _instance;
  }
  RecommendListModel._();
  @override
  Future<RecommendListRes> getNetData(int page) async {
    RecommendListRes resp;
    try {
      resp = await netManager.client.getRecommendVideoList(page, 20);
    } catch (e) {
      l.e(tag, "loadMoreRecommendList()...$e");
    }
    l.i(tag, "loadMoreRecommendList()...");
    return resp;
  }

  void registerItemChanged(ValueChanged<int> onItemChanged) =>
      this._onItemChanged = onItemChanged;

  @override
  VideoModel onItemChange(int index) {
    super.onItemChange(index);
    // print("====>onItemChange()...index:$index");
    this._onItemChanged?.call(index);
    if (null != lastModel &&
        lastModel != curItem() &&
        lastModel.isAd() != curItem().isAd()) {
      // print("====>onItemChange()...set notify");
      lastModel = curItem();
      notifyListeners();
    } else {
      lastModel = curItem();
    }
    return lastModel;
  }

  bool _isGetCaching = false;

  /// 获取需要缓存的url, 闲时缓存使用
  Future<String> getNeedCachedUrl() async {
    if (_isGetCaching) return null;
    _isGetCaching = true;
    await Future.delayed(Duration(milliseconds: 500));
    var url = await _getNeedCachedUrl();
    _isGetCaching = false;
    return url;
  }

  /// 获取需要缓存的url, 闲时缓存使用
  Future<String> _getNeedCachedUrl() async {
    // return null;
    var cur = curItem();
    if (null != cur) {
      if (await needBuyVip(cur)) {
        l.i(tag, "getNeedCachedUrl()...非vip闲时缓存策略没有意义");
        return null;
      }
      var index = videoLists.indexOf(cur);
      var iterater = 3;
      var length = videoLists.length;
      // l.i(tag, "getNeedCachedUrl()...进入闲时缓存策略 curIndex:$index");
      try {
        while (index >= 0 && iterater < 6 && (index + iterater) < length) {
          var remotePath = videoLists[index + iterater]?.sourceURL;
          var cacheKey = getCacheKey(remotePath);
          if (TextUtil.isNotEmpty(cacheKey) &&
              !CacheServer().failedM3u8List.contains(cacheKey)) {
            var fileInfo = await CacheServer().getCacheFile(remotePath);
            if (null == fileInfo) {
              l.i(tag,
                  "getNeedCachedUrl()...闲时缓存策略(${index + iterater})$cacheKey=>预测需要缓存的url:$remotePath");
              return remotePath;
            }
            // else {
            //   l.i(tag,
            //       "getNeedCachedUrl()..闲时缓存策略url:$cacheKey => ${fileInfo?.file?.path}");
            // }
          }
          // else {
          //   l.i(tag,
          //       "getNeedCachedUrl()..闲时缓存策略url:$cacheKey => failed:${CacheServer().failedM3u8List.contains(cacheKey)}");
          // }

          iterater++;
        }
      } catch (e) {
        l.e('getCacheFile', e.toString());
      }
    }
    l.i(tag, "getNeedCachedUrl()..闲时缓存策略=>没有可以预测的url来缓存");
    return null;
  }
}
