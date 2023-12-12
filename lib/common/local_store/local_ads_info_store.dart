import 'dart:convert';

import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/text_util.dart';

/// 不含状态的本地存储，主要是lightmodel的序列化存储

enum AdsType {
  ///表示启动页广告 position 0
  splashType,

  ///社区推荐广告 position 1
  recommendType,

  ///影视国产 position 2，
  movie,

  ///社区详情广告 position 3
  communityDetail,

  ///社区推荐列表广告 position 4
  communityRecommend,

  ///消息列表广告 position 5
  message,

  ///创作中心广告 position 6
  creationCenter,

  ///游戏大厅 position 7
  gamesLobby,

  ///免费专区 position 8
  freeVideo,

  ///首页弹窗图片广告 position 9
  homeAdsImg,
  mineAds, //我的广告  position 10
  placeholder1, //占位
  placeholder2, //占位
  placeholder3, //占位
  placeholder4, //占位
  ProMoteSetting, //推广设置
  homeFloating, //占位
  shortVideoFloating, //占位
  placeholder8, //占位
  placeholder9, //占位
  placeholder10, //占位
}

///获取某一个广告数据
Future<List<AdsInfoBean>> getAdsByType(AdsType adsType) async {
  if (null == adsType) return null;
  List<AdsInfoBean> resultList = await LocalAdsStore().getAllAds();
  if (ArrayUtil.isEmpty(resultList)) return <AdsInfoBean>[];

  List<AdsInfoBean> newList = resultList?.where((it) => it.position == adsType.index)?.toList();
  return newList;
}

///根据位置获取某一个广告数据
Future<List<AdsInfoBean>> getAdvByType(int position) async {
  if (null == position) return null;
  List<AdsInfoBean> resultList = await LocalAdsStore().getAllAds();
  if (ArrayUtil.isEmpty(resultList)) return <AdsInfoBean>[];

  List<AdsInfoBean> newList = resultList?.where((it) => it.position == position)?.toList();
  return newList;
}

class LocalAdsStore {
  static LocalAdsStore _instance;

  factory LocalAdsStore() {
    if (_instance == null) {
      _instance = LocalAdsStore._();
    }
    return _instance;
  }

  LocalAdsStore._();

  List<AdsInfoBean> _adsList;

  ///获取本地存储的TAG信息
  Future<List<AdsInfoBean>> getAllAds() async {
    if (ArrayUtil.isNotEmpty(_adsList)) return _adsList;
    // 非共享key
    String localAdsStr = await lightKV.getString("_key_ads_list${Config.DEBUG}");
    try {
      if (TextUtil.isNotEmpty(localAdsStr)) {
        _adsList = List()..addAll((jsonDecode(localAdsStr) as List ?? []).map((o) => AdsInfoBean.fromMap(o)));
      }
    } catch (_) {}
    return _adsList;
  }

  Future<bool> setAdsList(List<AdsInfoBean> ads) async {
    if (ArrayUtil.isEmpty(ads)) return false;
    try {
      _adsList = ads;
      String jsonStr = json.encode(ads);
      if (TextUtil.isEmpty(jsonStr)) return false;
      // 非共享key
      return lightKV.setString("_key_ads_list${Config.DEBUG}", jsonStr);
    } catch (e) {
      return false;
    }
  }

  ///清除记录
  clean() {
    lightKV.setString("_key_ads_list${Config.DEBUG}", "");
  }
}
