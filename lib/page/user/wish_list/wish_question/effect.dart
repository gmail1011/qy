import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/wish_list_entity.dart';
import 'package:flutter_base/utils/log.dart';

import 'action.dart';
import 'state.dart';

Effect<WishQuestionState> buildEffect() {
  return combineEffects(<Object, Effect<WishQuestionState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    WishQuestionAction.refreshData: _refreshWishList,
    WishQuestionAction.loadMoreData: _loadMoreData,
  });
}

void _initState(Action action, Context<WishQuestionState> ctx) async {
  _refreshWishList(action, ctx);
}

void _refreshWishList(Action action, Context<WishQuestionState> ctx) async {
  ctx.state.pageNumber = 1;
  _loadWishData(action, ctx);
}

///加载更多数据
void _loadMoreData(Action action, Context<WishQuestionState> ctx) async {
  if (ctx.state.pageNumber * ctx.state.pageSize <= ctx.state.wishList?.length) {
    ctx.state.pageNumber = ctx.state.pageNumber + 1;
    _loadWishData(action, ctx);
  } else {
    ctx.state.refreshController?.loadNoData();
  }
}

///刷新心愿列表
void _loadWishData(Action action, Context<WishQuestionState> ctx) async {
  try {
    l.d("_loadWishData", "刷新心愿列表");
    WishListData wishListData = await netManager.client.getWishList(
        ctx.state.pageNumber,
        ctx.state.pageSize,
        ctx.state.questionType == 1 ? "${GlobalStore.getMe()?.uid}" : "");

    if (ctx.state.pageNumber == 1) {
      ctx.state.wishList.clear();
    }
    ctx.state.hasNext = wishListData?.hasNext ?? true;
    if ((wishListData?.xList ?? []).isNotEmpty) {
      ctx.state.wishList?.addAll(wishListData?.xList);
      ctx.state.requestController?.requestSuccess();
      if (ctx.state.pageNumber == 1) {
        ctx.state.refreshController?.refreshCompleted(resetFooterState: true);
      } else {
        ctx.state.refreshController?.loadComplete();
      }
    } else {
      if (ctx.state.wishList?.isEmpty ?? false) {
        ctx.state.requestController.requestDataEmpty();
      } else {
        ctx.state.refreshController.loadNoData();
      }
    }
  } catch (e) {
    if (ctx.state.wishList?.isEmpty ?? false) {
      ctx.state.requestController.requestFail();
    } else {
      if(ctx.state.pageNumber == 1) {
        ctx.state.refreshController?.refreshFailed();
        return;
      }
      ctx.state.refreshController.loadFailed();
    }
  }
  ctx.dispatch(WishQuestionActionCreator.updateUI());
}

void _dispose(Action action, Context<WishQuestionState> ctx) async {
  ctx.state.refreshController?.dispose();
}
