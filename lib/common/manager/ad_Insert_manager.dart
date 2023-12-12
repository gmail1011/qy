
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';
import 'package:flutter_app/model/video_model.dart';

class AdInsertManager {
  ///随机横屏广告
  static List<AdsInfoBean> randomAds = [];
  ///随机竖屏广告
  static List<AdsInfoBean> randomVerAds = [];
  ///社区广告
  static List<AdsInfoBean> randomCommunityAds = [];
  ///视频栏目广告
  static List<AdsInfoBean> randomVideoTabAds = [];
  ///更多
  static void insertTagAd(List<LiaoBaTagsDetailDataVideos> videoModelList, {int adGap = 4}){
    if(videoModelList.isEmpty || videoModelList == null) return;
    if(randomAds.isEmpty || randomAds == null) {
      return;
    }
    int _countGap = 0;
    int _adIndex = 0;
    List<AdsInfoBean> randomAdArr = randomAds;
    for(int i = 0; i < videoModelList.length; i++){
      LiaoBaTagsDetailDataVideos model =  videoModelList[i];
      if(_countGap >= adGap){
        _countGap = 0;
        if(model.isRandomAd){
          _adIndex++;
        }else {
          LiaoBaTagsDetailDataVideos adModel = LiaoBaTagsDetailDataVideos();
          int realIndex = _adIndex%randomAdArr.length;
          adModel.randomAdsInfo = randomAdArr[realIndex];
          _adIndex++;
          videoModelList.insert(i, adModel);
        }
      }else {
        if (model.isRandomAd) {
          _countGap = 0;
        } else {
          _countGap++;
        }
      }
      if(_countGap == adGap && i == videoModelList.length - 1){
        LiaoBaTagsDetailDataVideos adModel = LiaoBaTagsDetailDataVideos();
        int realIndex = _adIndex%randomAdArr.length;
        adModel.randomAdsInfo = randomAdArr[realIndex];
        _adIndex++;
        videoModelList.add(adModel);
        break;
      }
    }
  }
/// 短视频
  static void insertVideoAd(List<VideoModel> modelArr, {List<AdsInfoBean> adArr, int adGap = 4}) {
    if(randomVerAds?.isNotEmpty != true && (adArr?.isNotEmpty != true)) {
      return;
    }
    if(modelArr?.isNotEmpty != true){
      return;
    }
    int _countGap = 0;
    int _adIndex = 0;
    List<AdsInfoBean> randomAdArr = randomVerAds;
    for(int i = 0; i < modelArr.length; i++){
      VideoModel model =  modelArr[i];
      if(_countGap >= adGap){
        _countGap = 0;
        if(model.isRandomAd()){
          _adIndex++;
        }else {
          VideoModel adModel = VideoModel();
          int realIndex = _adIndex%randomAdArr.length;
          adModel.randomAdsInfo = randomAdArr[realIndex];
          _adIndex++;
          modelArr.insert(i, adModel);
        }
      }else {
        if (model.isRandomAd()) {
          _countGap = 0;
        } else {
          _countGap++;
        }
      }
      if(_countGap == adGap && i == modelArr.length - 1){
        VideoModel adModel = VideoModel();
        int realIndex = _adIndex%randomAdArr.length;
        adModel.randomAdsInfo = randomAdArr[realIndex];
        _adIndex++;
        modelArr.add(adModel);
        break;
      }
    }
  }

  static void insertHomeVideoAd(List<LiaoBaTagsDetailDataVideos> modelArr, {List<AdsInfoBean> adArr, int adGap = 4}) {
    if(randomVerAds?.isNotEmpty != true && (adArr?.isNotEmpty != true)) {
      return;
    }
    if(modelArr?.isNotEmpty != true){
      return;
    }
    int _countGap = 0;
    int _adIndex = 0;
    List<AdsInfoBean> randomAdArr = adArr ?? randomVerAds;
    for(int i = 0; i < modelArr.length; i++){
      LiaoBaTagsDetailDataVideos model =  modelArr[i];
      if(_countGap >= adGap){
        _countGap = 0;
        if(model.isRandomAd){
          _adIndex++;
        }else {
          LiaoBaTagsDetailDataVideos adModel = LiaoBaTagsDetailDataVideos();
          int realIndex = _adIndex%randomAdArr.length;
          adModel.randomAdsInfo = randomAdArr[realIndex];
          _adIndex++;
          modelArr.insert(i, adModel);
        }
      }else {
        if (model.isRandomAd) {
          _countGap = 0;
        } else {
          _countGap++;
        }
      }
      if(_countGap == adGap && i == modelArr.length - 1){
        LiaoBaTagsDetailDataVideos adModel = LiaoBaTagsDetailDataVideos();
        int realIndex = _adIndex%randomAdArr.length;
        adModel.randomAdsInfo = randomAdArr[realIndex];
        _adIndex++;
        modelArr.add(adModel);
        break;
      }
    }
  }

  //社区 广告
  static void insertCommunityAd(List<VideoModel> modelArr, {int adGap = 4}) {
    if(randomCommunityAds.isEmpty) {
      return;
    }
    int _countGap = 0;
    int _adIndex = 0;
    List<AdsInfoBean> randomAdArr = randomCommunityAds;
    for(int i = 0; i < modelArr.length; i++){
      VideoModel model =  modelArr[i];
      if(_countGap >= adGap){
        _countGap = 0;
        if(model.isRandomAd()){
          _adIndex++;
        }else {
          VideoModel adModel = VideoModel();
          int realIndex = _adIndex%randomAdArr.length;
          adModel.randomAdsInfo = randomAdArr[realIndex];
          _adIndex++;
          modelArr.insert(i, adModel);
        }
      }else {
        if (model.isRandomAd()) {
          _countGap = 0;
        } else {
          _countGap++;
        }
      }
      if(_countGap == adGap && i == modelArr.length - 1){
        VideoModel adModel = VideoModel();
        int realIndex = _adIndex%randomAdArr.length;
        adModel.randomAdsInfo = randomAdArr[realIndex];
        _adIndex++;
        modelArr.add(adModel);
        break;
      }
    }
  }

  // 视频专栏 广告
  static void insertVideoTabAd(List<TagsDetailDataSections> modelArr, {int adGap = 1}) {
    if(randomVideoTabAds.isEmpty) {
      return;
    }
    int _countGap = 0;
    int _adIndex = 0;
    List<AdsInfoBean> randomAdArr = randomVideoTabAds;
    for(int i = 0; i < modelArr.length; i++){
      TagsDetailDataSections model =  modelArr[i];
      if(_countGap >= adGap){
        _countGap = 0;
        if(model.isRandomAd()){
          _adIndex++;
        }else {
          TagsDetailDataSections adModel = TagsDetailDataSections();
          int realIndex = _adIndex%randomAdArr.length;
          adModel.randomAdsInfo = randomAdArr[realIndex];
          _adIndex++;
          modelArr.insert(i, adModel);
        }
      }else {
        if (model.isRandomAd()) {
          _countGap = 0;
        } else {
          _countGap++;
        }
      }
      if(_countGap == adGap && i == modelArr.length - 1){
        TagsDetailDataSections adModel = TagsDetailDataSections();
        int realIndex = _adIndex%randomAdArr.length;
        adModel.randomAdsInfo = randomAdArr[realIndex];
        _adIndex++;
        modelArr.add(adModel);
        break;
      }
    }
  }
}