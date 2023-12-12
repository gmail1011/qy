import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/search/hot_search_list/hot_model.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class SplashState implements Cloneable<SplashState> {
  ///广告信息
  AdsInfoBean adsBean;

  int countdownTime = 4;

  SwiperController swipeController = SwiperController();

  bool loginSuccess = false;

  // 标签页推荐数据
  List<VideoModel> list = [];

/*============发现数据============*/
  // areaList
  List<AreaModel> areaList = [];

  // findList
  List<FindModel> findList = [];

  ///首页推荐
  List<TagDetailModel> community = [];

  @override
  SplashState clone() {
    return SplashState()
      ..adsBean = adsBean
      ..areaList = areaList
      ..findList = findList
      ..countdownTime = countdownTime
      ..swipeController = swipeController
      ..loginSuccess = loginSuccess
      ..list = list
      ..community = community;
  }
}

SplashState initState(Map<String, dynamic> args) {
  return SplashState()..swipeController.startAutoplay();
}
