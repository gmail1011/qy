import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/res/common_post_res.dart';
import 'package:flutter_app/model/res/recommend_video_res.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommunityFollowState implements Cloneable<CommunityFollowState> {
  int pageNumber = 1;

  RefreshController refreshController = RefreshController();

  RecommendListRes commonPostRes;

  @override
  CommunityFollowState clone() {
    return CommunityFollowState()
      ..pageNumber = pageNumber
      ..refreshController = refreshController
      ..commonPostRes = commonPostRes;
  }
}

CommunityFollowState initState(Map<String, dynamic> args) {
  return CommunityFollowState();
}
