import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/topinfo/RankInfoModel.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/widget/dialog/popup_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FilmVideoIntroductionState
    implements Cloneable<FilmVideoIntroductionState> {
  RefreshController refreshController = RefreshController();
  VideoModel viewModel;

  bool dataReq = true;
  int pageNum = 1;
  int pageSize = 10;
  bool hasNext = true;

  List<VideoModel> videoList = [];
  List<AdsInfoBean> adsList = [];
  RankInfoModel rankInfoModel;
  GlobalKey rightKey = GlobalKey();
  List<PopModel> listPopModel = [];
  DomainInfo domainInfo;
  @override
  FilmVideoIntroductionState clone() {
    return FilmVideoIntroductionState()
      ..refreshController = refreshController
      ..pageNum = pageNum
      ..pageSize = pageSize
      ..hasNext = hasNext
      ..videoList = videoList
      ..dataReq = dataReq
      ..viewModel = viewModel
      ..rankInfoModel = rankInfoModel
      ..listPopModel = listPopModel
      ..rightKey = rightKey
      ..domainInfo = domainInfo
      ..adsList = adsList;
  }
}

FilmVideoIntroductionState initState(Map<String, dynamic> args) {
  return FilmVideoIntroductionState()..viewModel = args["viewModel"];
}
