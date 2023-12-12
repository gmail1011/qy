import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/audiobook_list_model.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<AudiobookDataListState> buildEffect() {
  return combineEffects(<Object, Effect<AudiobookDataListState>>{
    Lifecycle.initState: _initState,
    AudiobookDataListAction.loadData: _loadData,
    AudiobookDataListAction.loadMoreData: _loadMoreData,
    AudiobookDataListAction.broadcastSearchAction: _broadcastSearchAction,
  });
}

void _broadcastSearchAction(
    Action action, Context<AudiobookDataListState> ctx) {
  if (ctx.state.type != 6) {
    return;
  }
  var keywords = action.payload ?? '';
  ctx.state.typeStr = keywords;
  ctx.state.pullRefreshController.requesting();
  _loadData(action, ctx);
}

void _initState(Action action, Context<AudiobookDataListState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () async {
    _loadData(action, ctx);
  });
}

void _loadData(Action action, Context<AudiobookDataListState> ctx) async {
  var model = await _getNetData(ctx, 1);
  if (model == null) {
    ctx.state.pullRefreshController.requestFail(isFirstPageNum: true);
    return;
  }
  ctx.state.pullRefreshController.requestSuccess(
    isFirstPageNum: true,
    hasMore: model.hasNext,
    isEmpty: (model.list?.length ?? 0) == 0,
  );
  ctx.dispatch(AudiobookDataListActionCreator.setLoadData(model.list));
}

void _loadMoreData(Action action, Context<AudiobookDataListState> ctx) async {
  var number = ctx.state.pageNumber + 1;
  var model = await _getNetData(ctx, number);
  if (model == null) {
    ctx.state.pullRefreshController.requestFail(isFirstPageNum: false);
    return;
  }
  ctx.state.pullRefreshController.requestSuccess(
    isFirstPageNum: false,
    hasMore: model.hasNext,
  );
  ctx.dispatch(AudiobookDataListActionCreator.setLoadMoreData(model.list));
}

Future<AudioBookListModel> _getNetData(
    Context<AudiobookDataListState> ctx, int number) async {
  AudioBookListModel model;
  try {
    if (ctx.state.type == 1) {
      model = await netManager.client.getAnchorAudioBookList(
          ctx.state.pageSize, number, ctx.state.typeStr);
    } else if (ctx.state.type == 2) {
      model = await netManager.client
          .getAudioBookList(ctx.state.pageSize, number, ctx.state.typeStr);
    } else if (ctx.state.type == 3) {
      model = await netManager.client
          .getAudioBookBuylogList(ctx.state.pageSize, number);
    } else if (ctx.state.type == 4) {
      model = await netManager.client.getAudioBookCollectList(
        number,
        ctx.state.pageSize,
        GlobalStore.getMe().uid,
      );
    } else if (ctx.state.type == 5) {
      model = await getAudioBookBrowse(
        number,
        ctx.state.pageSize,
      );
    } else if (ctx.state.type == 6) {
      model = await netManager.client.seachAudioBook(
        ctx.state.pageSize,
        number,
        ctx.state.typeStr,
      );
    }
  } catch (e) {
    l.d("getAnchorAudioBookList", _getNetData);
  }
  return model;
}
