import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_bean_entity.dart';

import 'add_action.dart';
import 'add_state.dart';
import 'add_user_entity.dart';

Effect<AddState> buildEffect() {
  return combineEffects(<Object, Effect<AddState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    AddAction.onUserLoadMore: _onUserLoadMore,
    AddAction.onLoadMore: _onLoadMore,
  });
}

void _initState(Action action, Context<AddState> ctx) async {
  _onLoadMore(action, ctx);
}

void _onLoadMore(Action action, Context<AddState> ctx) async {
  int pageNumber;
  if (action.payload != null) {
    pageNumber = action.payload;
  } else {
    pageNumber = ctx.state.pageNumber;
  }

  try {
    dynamic fansObj = await netManager.client.getRecommendList(pageNumber, 16);

    AddUserData addBeanData = AddUserData().fromJson(fansObj);

    if (pageNumber > 1) {
      ctx.state.fansObj.xList.addAll(addBeanData.xList);
      ctx.dispatch(AddActionCreator.getData(ctx.state.fansObj));
      ctx.state.refreshController.refreshCompleted();
    } else {
      ctx.dispatch(AddActionCreator.getData(addBeanData));
      ctx.state.refreshController.refreshCompleted();
    }

    if (addBeanData.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
    ctx.state.refreshController.refreshCompleted();
  } catch (e) {
    //l.d('getPostList', e.toString());
    //ctx.state.refreshController.loadFailed();
  }
}

void _onUserLoadMore(Action action, Context<AddState> ctx) async {
  int pageNumber;
  if (action.payload != null) {
    pageNumber = action.payload;
  } else {
    pageNumber = ctx.state.userPageNum;
  }

  try {
    List<String> keywords = [ctx.state.textEditingController.text];

    dynamic user = await netManager.client
        .getSearchDataNew(pageNumber, 14, keywords, "user");

    SearchBeanData searchBeanData = SearchBeanData().fromJson(user);

    if (pageNumber > 1) {
      ctx.state.searchBeanData.xList.addAll(searchBeanData.xList);
      ctx.dispatch(AddActionCreator.getUserData(ctx.state.searchBeanData));
      ctx.state.refreshUserController.loadComplete();
    } else {
      ctx.dispatch(AddActionCreator.getUserData(searchBeanData));
      ctx.state.refreshUserController.loadComplete();
    }

    if (searchBeanData.hasNext) {
      ctx.state.refreshUserController.loadComplete();
    } else {
      ctx.state.refreshUserController.loadNoData();
    }
  } catch (e) {}
}

void _dispose(Action action, Context<AddState> ctx) async {
  ctx.state.refreshController?.dispose();
  ctx.state.textEditingController?.dispose();
  ctx.state.refreshUserController?.dispose();
}
