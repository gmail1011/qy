import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/res/common_post_res.dart';
import 'package:flutter_app/model/res/recommend_video_res.dart';

//TODO replace with your own action
enum CommunityFollowAction { action ,getData , onLoadMore}

class CommunityFollowActionCreator {
  static Action onAction() {
    return const Action(CommunityFollowAction.action);
  }

  static Action onGetData(RecommendListRes commonPostRes) {
    return Action(CommunityFollowAction.getData,payload: commonPostRes);
  }

  static Action onLoadMore(int pageNum) {
    return Action(CommunityFollowAction.onLoadMore,payload: pageNum);
  }
}
