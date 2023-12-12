import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/search/search_user_obj.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'state.dart';

Effect<SearchUserState> buildEffect() {
  return combineEffects(<Object, Effect<SearchUserState>>{
    SearchUserAction.loadMoedData: _loadMoreData,
    SearchUserAction.loadData: _loadData,
    SearchUserAction.followUser: _followUser,
    SearchUserAction.broadcastSearchAction: _broadcastSearchAction,
    Lifecycle.initState: _loadData,
  });
}

void _followUser(Action action, Context<SearchUserState> ctx) async {
  var index = action.payload as int;
  var user = ctx.state.searchUsers[index];
  int followUID = user.uid;
  bool isFollow = !user.hasFollowed;
  try {
    await netManager.client.getFollow(followUID, isFollow);
    ctx.dispatch(SearchUserActionCreator.refreshFollowUser(index));
  } catch (e) {
    l.d('getFollow', e.toString());
    showToast(msg: e.toString());
  }
}

void _broadcastSearchAction(Action action, Context<SearchUserState> ctx) async {
  var keywords = action.payload ?? '';
  ctx.state.keywords = keywords;
  ctx.dispatch(SearchUserActionCreator.setKeywords(keywords));
  ctx.state.baseRequestController.requesting();
  ctx.dispatch(SearchUserActionCreator.loadData());
}

void _loadData(Action action, Context<SearchUserState> ctx) async {
  // ctx.state.refreshController.refreshCompleted();
  try {
    var model = await netManager.client
        .getUserData(1, ctx.state.pageSize, [ctx.state.keywords], 'user');
    if ((model.list.length ?? 0) == 0) {
      ctx.state.baseRequestController.requestDataEmpty();
    } else {
      ctx.state.baseRequestController.requestSuccess();
    }

    if (!model.hasNext) {
      ctx.state.refreshController.loadNoData();
    }
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);
    ctx.dispatch(SearchUserActionCreator.setLoadData(model.list));
  } catch (e) {
    ctx.state.baseRequestController.requestFail();
    ctx.state.refreshController.refreshFailed();
    l.d('getVideoData', e.toString());
  }
  // Future.delayed(Duration(milliseconds: 200),(){
  //   eaglePage(ctx.state.selfId(),
  //         sourceId: ctx.state.eagleId(ctx.context));
  // });
}

void _loadMoreData(Action action, Context<SearchUserState> ctx) async {
  try {
    var number = ctx.state.pageNumber + 1;
    var model = await netManager.client
        .getUserData(number, ctx.state.pageSize, [ctx.state.keywords], 'user');

    SearchUserObj searchUserObj = SearchUserObj.fromJson(model.toJson());
    if (model.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
    ctx.dispatch(SearchUserActionCreator.setLoadMoreData(model.list));
  } catch (e) {
    ctx.state.refreshController.loadFailed();
    l.d('getVideoData', e.toString());
  }
}
