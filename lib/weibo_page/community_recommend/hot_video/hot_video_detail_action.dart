import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/res/common_post_res.dart';
import 'package:flutter_app/weibo_page/community_recommend/community_recommend_action.dart';

//TODO replace with your own action
enum HotVideoDetailAction { action , getHotVideo, }

class HotVideoDetailActionCreator {
  static Action onAction() {
    return const Action(HotVideoDetailAction.action);
  }


  static Action onGetHotVideo(CommonPostRes commonPostRes) {
    return Action(CommunityRecommendAction.getHotVideo, payload: commonPostRes);
  }
}
