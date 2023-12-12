import 'dart:async';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/chewie/chewie_player.dart';
import 'package:flutter_app/widget/chewie/film_video_controls.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/dialog/popup_view.dart';
import 'package:video_player/video_player.dart';

class FilmTvVideoDetailState implements Cloneable<FilmTvVideoDetailState> {
  BaseRequestController baseRequestController = BaseRequestController();
  TabController tabController;
  String videoId;
  String sectionId;
  VideoModel viewModel;
  List<AdsInfoBean> adsList = [];
  int adsIndex = 0;
  int countdownTime = 0; // 广告倒计时

  ///video player info
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  FilmVideoControls videoUIControls;
  bool alreadyShowDialog = false;
  bool videoInited = false;
  int videoStatus = 0; //视频状态
  String vStatusName = ""; //视频状态

  Timer timerFinished;
  Timer timer;
  int currentPlayDuration = 0; //当前播放视频暂停进度
  //是否已离线缓存的视频
  bool isCacheVideo = false;
  VoidCallback videoListener;
  bool isStopPlayStatus = false;
  bool isToVipPage = false;
  bool intoBuyVideoPoiont = false;
  bool intoBuyVipPoiont = false;
  DomainInfo domainInfo;
  GlobalKey rightKey = GlobalKey();
  List<PopModel> listPopModel = [];



  LoadingWidget loadingWidget = LoadingWidget(title: "加载中...",canCancel: false,);

  bool get isCanClose {
    bool _isCanClose = false;
    if (GlobalStore.isVIP()) {
      _isCanClose = true;
    }else if (viewModel.isCoinVideo()) {
      if (viewModel.vidStatus.hasPaid == true) {
        _isCanClose = true;
      }
    } else {
    }
    if(countdownTime <= 0){
      _isCanClose = true;
    }
    return _isCanClose;
  }

  @override
  FilmTvVideoDetailState clone() {
    return FilmTvVideoDetailState()
      ..videoId = videoId
      ..sectionId = sectionId
      ..viewModel = viewModel
      ..adsList = adsList
      ..countdownTime = countdownTime
      ..videoInited = videoInited
      ..tabController = tabController
      ..baseRequestController = baseRequestController
      ..videoPlayerController = videoPlayerController
      ..chewieController = chewieController
      ..alreadyShowDialog = alreadyShowDialog
      ..videoStatus = videoStatus
      ..vStatusName = vStatusName
      ..isCacheVideo = isCacheVideo
      ..videoUIControls = videoUIControls
      ..currentPlayDuration = currentPlayDuration
      ..videoListener = videoListener
      ..isStopPlayStatus = isStopPlayStatus
      ..adsIndex = adsIndex
      ..isToVipPage = isToVipPage
      ..timer = timer
      ..intoBuyVideoPoiont = intoBuyVideoPoiont
      ..intoBuyVipPoiont = intoBuyVipPoiont
      ..domainInfo = domainInfo
      ..rightKey = rightKey
      ..loadingWidget = loadingWidget
      ..listPopModel = listPopModel
      ..timerFinished =timerFinished;
  }
}

FilmTvVideoDetailState initState(Map<String, dynamic> args) {
  return FilmTvVideoDetailState()
    ..videoId = args["videoId"]
    ..sectionId = args["sectionID"]
    ..isCacheVideo = args["isCacheVideo"] ?? false
    ..viewModel = args["videoModel"];
}
