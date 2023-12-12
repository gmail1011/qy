import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'state.dart';

Effect<SearchTagState> buildEffect() {
  return combineEffects(<Object, Effect<SearchTagState>>{
    SearchTagAction.loadMoedData: _loadMoreData,
    SearchTagAction.loadData: _loadData,
    SearchTagAction.broadcastSearchAction: _broadcastSearchAction,
    SearchTagAction.collectTag: _collectTag,
    Lifecycle.initState: _loadData,
  });
}

void _collectTag(Action action, Context<SearchTagState> ctx) async {
  var index = action.payload as int;
  var tag = ctx.state.searchTags[index];
  String objID = tag.id;
  bool isCollect = !tag.hasCollected;
  try {
    await netManager.client.clickCollect(objID, 'tag', isCollect);
    if (!isCollect) {
      showToast(msg: Lang.CANCEL_COLLECTION);
    } else {
      showToast(msg: Lang.COLLECTION_SUCCESS);
    }
    ctx.dispatch(SearchTagActionCreator.refreshFollowUser(index));
  } catch (e) {
    l.d('clickCollect', e.toString());
  }
}

void _broadcastSearchAction(Action action, Context<SearchTagState> ctx) async {
  var keywords = action.payload ?? '';
  ctx.state.keywords = keywords;

  ctx.dispatch(SearchTagActionCreator.setKeywords(keywords));
  ctx.state.baseRequestController.requesting();
  ctx.dispatch(SearchTagActionCreator.loadData());
}

void _loadData(Action action, Context<SearchTagState> ctx) async {
  // ctx.state.refreshController.refreshCompleted();
  try {
    var model = await netManager.client
        .getTalkData(1, ctx.state.pageSize, [ctx.state.keywords], 'tag');
    if ((model.list.length ?? 0) == 0) {
      ctx.state.baseRequestController.requestDataEmpty();
    } else {
      ctx.state.baseRequestController.requestSuccess();
    }

    if (!model.hasNext) {
      ctx.state.refreshController.loadNoData();
    }
    ctx.state.refreshController.refreshCompleted(resetFooterState: true);
    ctx.dispatch(SearchTagActionCreator.setLoadData(model.list));
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

void _loadMoreData(Action action, Context<SearchTagState> ctx) async {
  try {
    var number = ctx.state.pageNumber + 1;
    var model = await netManager.client
        .getTalkData(number, ctx.state.pageSize, [ctx.state.keywords], 'tag');
    if (model.hasNext) {
      ctx.state.refreshController.loadComplete();
    } else {
      ctx.state.refreshController.loadNoData();
    }
    ctx.dispatch(SearchTagActionCreator.setLoadMoreData(model.list));
  } catch (e) {
    ctx.state.refreshController.loadFailed();
    l.d('getVideoData', e.toString());
  }
}
