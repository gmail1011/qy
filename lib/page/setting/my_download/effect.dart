import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_store/cache_video_model.dart';
import 'package:flutter_app/common/local_store/cached_video_store.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'action.dart';
import 'state.dart';

Effect<MyDownloadState> buildEffect() {
  return combineEffects(<Object, Effect<MyDownloadState>>{
    MyDownloadAction.beginUpdateList: _getDownData,
    Lifecycle.initState: _initState,
  });
}

void _initState(Action action, Context<MyDownloadState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () {
    _getDownData(action, ctx);
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}

void _getDownData(Action action, Context<MyDownloadState> ctx) async {
  List<CachedVideoModel> list = await CachedVideoStore().getCachedVideos();
  if (list.isEmpty) {
    ctx.state.requestController.requestDataEmpty();
  } else {
    ctx.state.requestController.requestSuccess();
    var newList = list.map((item) => item.videoModel).toList();
    ctx.dispatch(MyDownloadActionCreator.onUpdateList(newList));
  }
}
