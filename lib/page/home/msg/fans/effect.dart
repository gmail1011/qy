import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/message/fans_obj.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

import '../../../../common/net2/net_manager.dart';
import 'action.dart';
import 'state.dart';

Effect<FansState> buildEffect() {
  return combineEffects(<Object, Effect<FansState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    FansAction.followUserAction: _followUser,
    FansAction.refreshFansAction: _refreshFans,
    FansAction.loadMoreFansAction: _loadMoreFans,
  });
}

void _initState(Action action, Context<FansState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () async {
    await getFans(ctx);
  });
}

void _refreshFans(Action action, Context<FansState> ctx) {
  ctx.state.pageNumber = 1;
  getFans(ctx);
}

void _loadMoreFans(Action action, Context<FansState> ctx) {
  if (ctx.state.pageNumber * ctx.state.pageSize <= ctx.state.fansList?.length) {
    ctx.state.pageNumber = ctx.state.pageNumber + 1;
    getFans(ctx);
  } else {
    ctx.state.refreshController?.loadNoData();
  }
}

/// 获取
getFans(Context<FansState> ctx) async {
  int pageNumber = ctx.state.pageNumber;
  int pageSize = ctx.state.pageSize;
  try {
    FansObj fansObj = await netManager.client.getFansList(pageNumber, pageSize);
    ctx.state.hasNext = fansObj?.hasNext ?? false;

    if (ctx.state.pageNumber == 1) {
      ctx.state.fansList?.clear();
    }
    if ((fansObj?.list ?? []).isNotEmpty) {
      ctx.state.fansList?.addAll(fansObj?.list);
      ctx.state.requestController?.requestSuccess();
      if (ctx.state.pageNumber == 1) {
        ctx.state.refreshController?.refreshCompleted(resetFooterState: true);
      } else {
        ctx.state.refreshController?.loadComplete();
      }
    } else {
      if (ctx.state.fansList?.isEmpty ?? false) {
        ctx.state.requestController.requestDataEmpty();
      } else {
        ctx.state.refreshController.loadNoData();
      }
    }
  } catch (e) {
    l.e('getFansList', e.toString());
    if (ctx.state.fansList?.isEmpty ?? false) {
      ctx.state.requestController.requestFail();
    } else {
      ctx.state.refreshController.loadFailed();
    }
  }
  ctx.dispatch(FansActionCreator.refreshUI());
}

///关注用户
void _followUser(Action action, Context<FansState> ctx) async {
  /// 储存uid
  try {
    int followUID = action.payload['followUID'];
    bool isFollow = action.payload['isFollow'];
    await netManager.client.getFollow(followUID, isFollow);
  } catch (e) {
    l.d('getFollow', e.toString());
    showToast(msg: e.toString() ?? '');
  }
}

void _dispose(Action action, Context<FansState> ctx) {
  ctx.state.refreshController?.dispose();
}
