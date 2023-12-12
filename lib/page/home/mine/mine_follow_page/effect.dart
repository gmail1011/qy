import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';

// import 'package:flutter_app/common/local_router/router_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/res/watch_list_model.dart';
import 'package:flutter_base/eagle/umeng_util.dart';

// import 'package:flutter_app/model/res/recommend_follow_res.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<MineFollowState> buildEffect() {
  return combineEffects(<Object, Effect<MineFollowState>>{
    Lifecycle.initState: _initData,
    Lifecycle.dispose: _dispose,
    MineFollowAction.onRefresh: _onRefresh,
    MineFollowAction.onLoadMore: _onLoadMore,
    MineFollowAction.onFollow: _onFollow,
  });
}

void _initData(Action action, Context<MineFollowState> ctx) {
  _getData(ctx, 1);
  Future.delayed(Duration(milliseconds: 200)).then((_) {
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}

void _onRefresh(Action action, Context<MineFollowState> ctx) {
  _getData(ctx, 1);
}

void _onLoadMore(Action action, Context<MineFollowState> ctx) {
  var pageIndex = ctx.state.pageIndex + 1;
  _getData(ctx, pageIndex);
}

void _onFollow(Action action, Context<MineFollowState> ctx) async {
  if (_loading) return;
  _loading = true;
  int index = action.payload;
  try {
    var data = ctx.state.list[index];
    await netManager.client.getFollow(data.uid, !data.hasFollow);
    ctx.dispatch(MineFollowActionCreator.onFollowOkay(index, !data.hasFollow));
  } catch (e) {
    l.e("mine_follw", "_onFollow()...error:$e");
  }
  _loading = false;
}

bool _loading = false;

_getData(Context<MineFollowState> ctx, int pageNum) async {
  // if (_loading) return;
  // _loading = true;
  WatchlistModel model;
  try {
    model = await netManager.client.getFollowedUserList(pageNum);
  } catch (e) {
    // 请求失败
    if (pageNum == 1) {
      // 刷新失败
      ctx.state.refreshController.refreshFailed();
    } else {
      // 加载失败
      ctx.state.refreshController.loadFailed();
    }
    ctx.state.baseRequestController.requestFail();
    l.e("follow", "_getData()...");
  }

  ctx.state.baseRequestController.requestSuccess();
  if (pageNum == 1 && ((model?.list ?? []).isEmpty)) {
    ctx.state.baseRequestController.requestDataEmpty();
  }
  // 请求成功
  if (pageNum == 1) {
    // 刷新成功
    ctx.state.pageIndex = 1;
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);
    model?.list?.forEach((it) {
      it.hasFollow = true;
    });
    ctx.dispatch(MineFollowActionCreator.onRefreshOkay(model?.list));
  } else {
    ctx.state.pageIndex = pageNum;
    // 加载成功
    ctx.state.refreshController.loadComplete();
    model?.list?.forEach((it) {
      it.hasFollow = true;
    });
    ctx.dispatch(MineFollowActionCreator.onLoadMoreOkay(model?.list));
    // 加载成功之后没有更多
    if ((model?.list?.length ?? 0) < Config.PAGE_SIZE) {
      ctx.state.refreshController.loadNoData();
    }
  }
}

void _dispose(Action action, Context<MineFollowState> ctx) {
  ctx.state.refreshController?.dispose();
}
