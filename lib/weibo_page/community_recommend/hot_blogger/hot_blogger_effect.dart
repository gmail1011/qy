import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/weibo_page/community_recommend/hot_blogger/hot_blogger_bean.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/guess_like_entity.dart';

import 'hot_blogger_action.dart';
import 'hot_blogger_state.dart';

Effect<HotBloggerState> buildEffect() {
  return combineEffects(<Object, Effect<HotBloggerState>>{
    HotBloggerAction.action: _onAction,
    Lifecycle.initState: _onInit,
    HotBloggerAction.RefreshData: _onInit,
  });
}

void _onAction(Action action, Context<HotBloggerState> ctx) {

}

void _onInit(Action action, Context<HotBloggerState> ctx) async{

  dynamic dataList = await netManager.client.getRecommendChangeFuncListDetail();

  List<HotBloggerEntity> bloggerDataList = [];

  dataList.forEach((v) {
    bloggerDataList.add(HotBloggerEntity.fromJson(v));
  });

  if ((dataList ?? []).isNotEmpty) {

    ctx.state.refreshController.refreshCompleted();
    ctx.dispatch(HotBloggerActionCreator.onGetHotBlogger(bloggerDataList));

  }

}
