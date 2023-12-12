import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

import '../action.dart';
import 'action.dart';
import 'state.dart';

Effect<WorksListState> buildEffect() {
  return combineEffects(<Object, Effect<WorksListState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
    WorksListAction.refreshData: _refreshData,
    WorksListAction.loadMoreData: _loadMoreData,
    WorksManagerAction.notifyDel: _recevieDel,
    WorksListAction.delVideo: _delVideo,
  });
}

///我的作品列表
void _initState(Action action, Context<WorksListState> ctx) {
  _refreshData(action, ctx);
}

///设置请求作品状态
String _getStatus(int worksType) {
  String _status = "";
  if (worksType == 0) {
    _status = "1";
  } else if (worksType == 1) {
    _status = "0";
  } else if (worksType == 2) {
    _status = "2";
  }
  return _status;
}

///请求刷新数据
void _refreshData(Action action, Context<WorksListState> ctx) async {
  ctx.state.pageNum = 1;
  _loadData(ctx);
}

///请求加载更多数据
void _loadMoreData(Action action, Context<WorksListState> ctx) async {
  if (ctx.state.pageNum * ctx.state.pageSize <= ctx.state.videoList?.length) {
    ctx.state.pageNum = ctx.state.pageNum + 1;
    _loadData(ctx);
  } else {
    ctx.state.refreshController?.loadNoData();
  }
}

///请求数据
void _loadData(Context<WorksListState> ctx) async {
  // try {
  //   l.e("_refreshData-->", "_refreshData");
  //   MineVideo works = await netManager.client.getMyWorks(
  //       ctx.state.pageSize, ctx.state.pageNum, _getStatus(ctx.state.worksType ?? 0));
  //
  //   if (ctx.state.pageNum == 1) {
  //     ctx.state.videoList?.clear();
  //   }
  //   ctx.state.hasNext = works.hasNext;
  //   if ((works?.list ?? []).isNotEmpty) {
  //     ctx.state.videoList?.addAll(works?.list);
  //     ctx.state.requestController?.requestSuccess();
  //
  //     if (ctx.state.pageNum == 1) {
  //       ctx.state.refreshController?.refreshCompleted(resetFooterState: true);
  //     } else {
  //       ctx.state.refreshController?.loadComplete();
  //     }
  //   } else {
  //     if (ctx.state.videoList?.isEmpty ?? false) {
  //       ctx.state.requestController.requestDataEmpty();
  //     } else {
  //       ctx.state.refreshController.loadNoData();
  //     }
  //   }
  // } catch (e) {
  //   l.e("getMyWorks-error:", "$e");
  //   if (ctx.state.videoList?.isEmpty ?? false) {
  //     ctx.state.requestController.requestFail();
  //   } else {
  //     if (ctx.state.pageNum == 1) {
  //       ctx.state.refreshController.refreshFailed();
  //     } else {
  //       ctx.state.refreshController.loadFailed();
  //     }
  //   }
  // }
  // ctx.dispatch(WorksListActionCreator.updateUI());
}

///删除视频
void _delVideo(Action action, Context<WorksListState> ctx) async {
  try {
    String videoId = action.payload;
    List<String> idList = List();
    idList.add(videoId);

    await netManager.client.postDelWork(idList);
    //删除成功，重新刷新页面
    GlobalStore.updateUserInfo(null);
    showToast(msg: "删除成功");

    Future.delayed(Duration(milliseconds: 200))
        .then((value) => _refreshData(action, ctx));
  } catch (e) {
    showToast(msg: e.toString());
    l.e('_delVideo', e.toString());
  }
}

///接收删除按钮UI
void _recevieDel(Action action, Context<WorksListState> ctx) {
  if ((ctx.state.worksType ?? 0) == 2) {
    ctx.state.delModel = !ctx.state.delModel;
    ctx.dispatch(WorksListActionCreator.updateUI());
  }
}

void _dispose(Action action, Context<WorksListState> ctx) {
  ctx.state.refreshController?.dispose();
}
