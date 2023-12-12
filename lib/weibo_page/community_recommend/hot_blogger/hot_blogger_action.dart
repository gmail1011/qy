import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/weibo_page/community_recommend/hot_blogger/hot_blogger_bean.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/guess_like_entity.dart';

//TODO replace with your own action
enum HotBloggerAction { action , getHotBlogger , reFreshFlollowUi , RefreshData }

class HotBloggerActionCreator {
  static Action onAction() {
    return const Action(HotBloggerAction.action);
  }

  static Action onGetHotBlogger(List<HotBloggerEntity> dataList) {
    return  Action(HotBloggerAction.getHotBlogger,payload: dataList );
  }

  static Action onRefreshFollow(List<HotBloggerEntity> bloggerDataList) {
    return  Action(HotBloggerAction.reFreshFlollowUi,payload: bloggerDataList );
  }

  static Action onRefreshData() {
    return  Action(HotBloggerAction.RefreshData);
  }
}
