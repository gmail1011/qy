import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/audiobook_list_model.dart';
import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_app/model/novel_model.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'action.dart';
import 'state.dart';

Effect<NovelSearchState> buildEffect() {
  return combineEffects(<Object, Effect<NovelSearchState>>{
    Lifecycle.initState: _init,
    NovelSearchAction.onSubmitted: _onSubmitted,
    NovelSearchAction.delete: _delete,
    NovelSearchAction.deleteAll: _deleteAll,
    NovelSearchAction.broadcastRefreshHistorys: _broadcastRefreshHistorys,
    NovelSearchAction.moreData: _getDataView,
    NovelSearchAction.refresh: _refresh,
  });
}

String _historyKey(NOVEL_SEARCH_PAGE_TYPE type) {
  if (type == NOVEL_SEARCH_PAGE_TYPE.PAGE_AUDIOBOOK) {
    return "NovelSearchHistoryKey";
  } else {
    return "AudioBookSearchHistoryKey";
  }
}

void _broadcastRefreshHistorys(Action action, Context<NovelSearchState> ctx) {
  var text = action.payload;
  if (TextUtil.isEmpty(text)) {
    return;
  }
  var state = ctx.state;
  //如果超出最大個數
  if (state.searchHistorys.length >= ctx.state.maxSearchHistoryNum) {
    state.searchHistorys.removeLast();
  }
  //如果包含該條記錄
  if (state.searchHistorys.contains(text)) {
    state.searchHistorys.remove(text);
  }
  state.searchHistorys.insert(0, text);
  _save(ctx, state.searchHistorys);
}

void _deleteAll(Action action, Context<NovelSearchState> ctx) {
  var state = ctx.state.clone();
  state.searchHistorys.clear();
  _save(ctx, ctx.state.searchHistorys);
}

void _delete(Action action, Context<NovelSearchState> ctx) {
  var index = (action.payload as int) ?? 0;

  ctx.state.searchHistorys.removeAt(index);
  _save(ctx, ctx.state.searchHistorys);
}

void _save(Context<NovelSearchState> ctx, List<String> list) {
  lightKV.setStringList(_historyKey(ctx.state.type), list);
  ctx.dispatch(NovelSearchActionCreator.onRefreshHistorys(list));
}

void _onSubmitted(Action action, Context<NovelSearchState> ctx) {
  var text = (action.payload as String) ?? '';
  if (TextUtil.isEmpty(text)) {
    showToast(msg: "请输入搜索内容");
    return;
  }
  var state = ctx.state;
  //如果超出最大個數
  if (state.searchHistorys.length >= ctx.state.maxSearchHistoryNum) {
    state.searchHistorys.removeLast();
  }
  //如果包含該條記錄
  if (state.searchHistorys.contains(text)) {
    state.searchHistorys.remove(text);
  }
  state.searchHistorys.insert(0, text);
  _save(ctx, state.searchHistorys);
  Map<String, dynamic> map = {"keywords": text ?? '', 'type': state.type};
  JRouter().go(PAGE_NOVEL_SEARCH_RESULT, arguments: map);
}

Future<List<String>> _getSearchHistorys(Context<NovelSearchState> ctx) async {
  return (await lightKV.getStringList(_historyKey(ctx.state.type))) ??
      <String>[];
}

void _init(Action action, Context<NovelSearchState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () async {
    _getHistorys(action, ctx);
    _getDataView(action, ctx);
  });
}

void _getHistorys(Action action, Context<NovelSearchState> ctx) async {
  var list = await _getSearchHistorys(ctx);
  ctx.dispatch(NovelSearchActionCreator.onRefreshHistorys(list));
}
void _refresh(Action action, Context<NovelSearchState> ctx) {
  ctx.dispatch(NovelSearchActionCreator.initPageNumber());
  _getDataView(action, ctx);
}
/// 拉取数据刷新页面
void _getDataView(Action action, Context<NovelSearchState> ctx) async {
  switch (ctx.state.type) {
    case NOVEL_SEARCH_PAGE_TYPE.PAGE_NOVEL:
      _getFictionHotsView(action, ctx);
      break;
    case NOVEL_SEARCH_PAGE_TYPE.PAGE_AUDIOBOOK:
      _getAudioHotsView(action, ctx);
      break;
    default:
  }
}
/// 拉取激情小说数据并刷新页面
void _getFictionHotsView(Action action, Context<NovelSearchState> ctx) async{
  int pageNumber = ctx.state.pageNumber;
  var resp = await _getData<NovelModel>(ctx, pageNumber);
   if (resp != null) {
    List<NoveItem> list = resp.list ?? [];
    ctx.dispatch(NovelSearchActionCreator.onChangeNovelList(list));
    if (resp.hasNext) {
      ctx.dispatch(NovelSearchActionCreator.onChangePageNumber());
    }
    ctx.state.pullController.requestSuccess(
        isFirstPageNum: pageNumber == 1,
        isEmpty: list.isEmpty,
        hasMore: resp.hasNext);
  } else {
    ctx.state.pullController.requestFail(isFirstPageNum: pageNumber == 1);
  }
}

/// 拉取有声小说数据并刷新页面
void _getAudioHotsView(Action action, Context<NovelSearchState> ctx) async{
  int pageNumber = ctx.state.pageNumber;
  var resp = await _getData<AudioBookListModel>(ctx, pageNumber);
   if (resp != null) {
    List<AudioBook> audioList = resp.list ?? [];
    ctx.dispatch(NovelSearchActionCreator.onChangeAudioBookList(audioList));
    if (resp.hasNext) {
      ctx.dispatch(NovelSearchActionCreator.onChangePageNumber());
    }
    ctx.state.pullController.requestSuccess(
        isFirstPageNum: pageNumber == 1,
        isEmpty: audioList.isEmpty,
        hasMore: resp.hasNext);
  } else {
    ctx.state.pullController.requestFail(isFirstPageNum: pageNumber == 1);
  }
}

/// 拉取数据
Future<T> _getData<T>(Context<NovelSearchState> ctx, int pageNumber) async{
  T resp;
  int pageSize = ctx.state.pageSize;
  switch (ctx.state.type) {
    case NOVEL_SEARCH_PAGE_TYPE.PAGE_NOVEL:
      resp = (await netManager.client.getFictionHots(pageNumber, pageSize)) as T;
      break;
    case NOVEL_SEARCH_PAGE_TYPE.PAGE_AUDIOBOOK:
      resp = (await netManager.client.getAudioHots(pageNumber, pageSize)) as T;
      break;
    default:
  }
  return resp;
}