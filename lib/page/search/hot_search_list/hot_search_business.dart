import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/video_obj_model.dart';
import 'package:flutter_app/page/search/hot_search_list/find_obj.dart';
import 'package:flutter_app/page/search/hot_search_list/gold_obj.dart';
import 'package:flutter_app/page/search/hot_search_list/hot_topic_obj.dart';
import 'package:flutter_app/page/search/hot_search_list/popularity_obj.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/search/hot_search_list/hot_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

class HotSearchMgr {
  factory HotSearchMgr() => _getInstance();

  static HotSearchMgr get instance => _getInstance();
  static HotSearchMgr _instance;

  HotSearchMgr._internal();

  static HotSearchMgr _getInstance() {
    if (_instance == null) {
      _instance = HotSearchMgr._internal();
    }
    return _instance;
  }

  //////////////////////////////////////////////////////
  // UI

  Color backColor = AppColors.backgroundColor;

  // 标题
  double titleH = Dimens.pt40;

  // 圆角半径（手机样式）
  double radius = 8;

  // 左边距
  double leftSpace = Dimens.pt15;

  //=======================数据拉取===============================

  /// 拉取【热门话题】数据
  Future<List<HotTopicModel>> pullHotTopicData() async {
    // Map<String, dynamic> parameter = {
    //   "pageNumber": 1,
    //   "pageSize": 8,
    // };
    // 用专题测试
    try {
      HotTopicObj hotTopicObj = await netManager.client.getHotTopicList(1, 8);
      List<HotTopicModel> models = hotTopicObj.list ?? [];
      return models;
    } catch (e) {
      l.d('getHotTopicList', e.toString());
      showToast(msg: e.toString());
    }
    // BaseResponse baseResponse = await getHotTopicList(parameter);
    // if (baseResponse.code == Code.SUCCESS) {
    //   List<HotTopicModel> models = [];
    //   for (var dic in baseResponse.data['list']) {
    //     HotTopicModel model = HotTopicModel.fromJson(dic);
    //     models.add(model);
    //   }
    //   return models;
    // }
    return null;
  }

  /// 拉取【人气榜单】数据
  Future<
      Tuple3<List<PopularityModel>, List<PopularityModel>,
          List<PopularityModel>>> pullPopularityData() async {
    // Map<String, dynamic> parameter = {
    //   "pageNumber": 1,
    //   "pageSize": 50,
    // };
    // BaseResponse baseResponse = await getPopularityList(parameter);
    try {
      PopularityObj popularityObj =
          await netManager.client.getPopularityList(1, 50);
      List<PopularityModel> userInviteRankModels =
          popularityObj.userInviteRank?.itemList ?? [];
      List<PopularityModel> userUploadRankModels =
          popularityObj.userUploadRank?.itemList ?? [];
      List<PopularityModel> userIncomeRankModels =
          popularityObj.userIncomeRank?.itemList ?? [];
      return Tuple3(
          userInviteRankModels, userUploadRankModels, userIncomeRankModels);
    } catch (e) {
      l.d('getPopularityList', e.toString());
      showToast(msg: e.toString());
    }
    // if (baseResponse.code == Code.SUCCESS) {
    //   List<PopularityModel> userInviteRankModels = [];
    //   for (var dic in (baseResponse.data["userInviteRank"]["itemList"] ?? [])) {
    //     PopularityModel model = PopularityModel.fromJson(dic);
    //     userInviteRankModels.add(model);
    //   }
    //   List<PopularityModel> userUploadRankModels = [];
    //   for (var dic in (baseResponse.data["userUploadRank"]["itemList"] ?? [])) {
    //     PopularityModel model = PopularityModel.fromJson(dic);
    //     userUploadRankModels.add(model);
    //   }
    //   List<PopularityModel> userIncomeRankModels = [];
    //   for (var dic in (baseResponse.data["userIncomeRank"]["itemList"] ?? [])) {
    //     PopularityModel model = PopularityModel.fromJson(dic);
    //     userIncomeRankModels.add(model);
    //   }
    //   return Tuple3(userInviteRankModels, userUploadRankModels, userIncomeRankModels);
    // }
    return null;
  }

  /// 拉取【今日最热视频】数据
  Future<List<VideoModel>> pullTodayHottestData(int pageNumber) async {
    // Map<String, dynamic> parameter = {
    //   "pageNumber": pageNumber,
    //   "pageSize": 15,
    // };

    try {
      VideoObj videoObj =
          await netManager.client.getTodayHottestVideoList(pageNumber, 15);
      List<VideoModel> models = videoObj.list ?? [];
      return models;
    } catch (e) {
      l.d('getTodayHottestVideoList', e.toString());
      showToast(msg: e.toString());
    }
    // BaseResponse baseResponse = await getTodayHottestVideoList(parameter);
    // if (baseResponse.code == Code.SUCCESS) {
    //   List<VideoModel> models = [];
    //   for (var dic in baseResponse.data['list']) {
    //     VideoModel model = VideoModel.fromJson(dic);
    //     models.add(model);
    //   }
    //   return models;
    // } else {
    //   showToast(msg: baseResponse.toString());
    // }
    return null;
  }

  /// 拉取【精选专区】数据
  Future<List<AreaModel>> pullGoldCoinAreaData() async {
    // Map<String, dynamic> parameter = {};
    // BaseResponse baseResponse = await getGoldCoinAreaList(parameter);
    try {
      GoldObj goldObj = await netManager.client.getGoldCoinAreaList();
      List<AreaModel> models = goldObj.list ?? [];
      return models;
    } catch (e) {
      l.d('getGoldCoinAreaList', e.toString());
      showToast(msg: e.toString());
    }
    // if (baseResponse.code == Code.SUCCESS) {
    //   List<GoldModel> models = [];
    //   for (var dic in baseResponse.data['list']) {
    //     GoldModel model = GoldModel.fromJson(dic);
    //     models.add(model);
    //   }
    //   return models;
    // }
    return null;
  }

  /// 拉取【发现精彩】数据
  Future<Tuple2<List<FindModel>, bool>> pullFindData(int pageNumber) async {
    // 请求数据
    // Map<String, dynamic> parameter = {
    //   "pageNumber": pageNumber,
    //   "pageSize": 50,
    // };
    try {
      FindObj findObj =
          await netManager.client.getFindWonderfulList(pageNumber, 50);
      List<FindModel> models = findObj.list ?? [];
      var hasNext = findObj.hasNext;
      return Tuple2(models, hasNext);
    } catch (e) {
      l.d('getFindWonderfulList', e.toString());
      showToast(msg: e.toString());
    }
    // BaseResponse baseResponse = await getFindWonderfulList(parameter);
    // if (baseResponse.code == Code.SUCCESS) {
    //   List<FindModel> models = [];
    //   for (var dic in baseResponse.data['list']) {
    //     FindModel tgsBean = FindModel.fromMap(dic);
    //     models.add(tgsBean);
    //   }
    //   var hasNext = baseResponse.data['hasNext'];
    //   return Tuple2(models, hasNext);
    // }
    return null;
  }

  /// 点击【发现精彩】pull数据
  Future<List<VideoModel>> pullClickFindData(String tagID) async {
    // 请求数据
    // Map<String, dynamic> parameter = {
    //   "pageNumber": 1,
    //   "pageSize": 20,
    //   "tagID": tagID,
    // };
    // BaseResponse res =
    //     await HttpManager().post(Address.SEARCH_WONDER_API, params: parameter);
    try {
      VideoObj videoObj = await netManager.client.postSearch(1, 20, tagID);
      return videoObj.list ?? [];
    } catch (e) {
      l.e('postSearch', e.toString());
    }
    // if (res.code == Code.SUCCESS) {
    //   List<VideoModel> models = [];
    //   for (var dic in res.data['list']) {
    //     VideoModel vidModel = VideoModel.fromJson(dic);
    //     models.add(vidModel);
    //   }
    //   return models;
    // }
    return null;
  }
}
