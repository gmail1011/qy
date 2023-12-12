import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/weibo_page/community_recommend/hot_blogger/hot_blogger_bean.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/guess_like_entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HotBloggerState implements Cloneable<HotBloggerState> {

  //List<GuessLikeDataList> bloggerDataList;


  List<HotBloggerEntity> bloggerDataList;

  RefreshController refreshController = RefreshController();

  @override
  HotBloggerState clone() {
    return HotBloggerState()..bloggerDataList = bloggerDataList..refreshController = refreshController;
  }
}

HotBloggerState initState(Map<String, dynamic> args) {
  return HotBloggerState();
}
