import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/res/recommend_video_res.dart';

import 'community_follow_action.dart';
import 'community_follow_state.dart';

Effect<CommunityFollowState> buildEffect() {
  return combineEffects(<Object, Effect<CommunityFollowState>>{
    CommunityFollowAction.action: _onAction,
    CommunityFollowAction.onLoadMore: _onLoadMore,
    Lifecycle.initState: _onInitData,
  });
}

void _onAction(Action action, Context<CommunityFollowState> ctx) {

}

void _onInitData(Action action, Context<CommunityFollowState> ctx) async{

  _onLoadMore(action,ctx);

}

void _onLoadMore(Action action, Context<CommunityFollowState> ctx) async{

  int pageNumber;
  if(action.payload != null){
    pageNumber = action.payload;
  }else{
    pageNumber = ctx.state.pageNumber ;
  }


  try {

    RecommendListRes commonPostRes = await netManager.client.getFollowList(pageNumber);

    if(pageNumber > 1){
      ctx.state.commonPostRes.vInfo.addAll(commonPostRes.vInfo);
      ctx.dispatch(CommunityFollowActionCreator.onGetData(ctx.state.commonPostRes));

    }else {
      ctx.dispatch(CommunityFollowActionCreator.onGetData(commonPostRes));
    }

    ctx.state.refreshController.refreshCompleted();

    if (commonPostRes.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
  } catch (e) {
   // l.d('getPostList', e.toString());
    ctx.state.refreshController.loadFailed();
  }
}
