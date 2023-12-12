import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/novel_model.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<PassionNovelViewState> buildEffect() {
  return combineEffects(<Object, Effect<PassionNovelViewState>>{
    PassionNovelViewAction.moreData: _getDataView,
    PassionNovelViewAction.refresh: _refresh,
    PassionNovelViewAction.onChangeKeyWord: _onChangeKeyWord,
    Lifecycle.initState: _initState,
  });
}

void _initState(Action action, Context<PassionNovelViewState> ctx) {
  Future.delayed(Duration(milliseconds: 300), () {
    _getDataView(action, ctx);
  });
}

/// 搜索
void _onChangeKeyWord(Action action, Context<PassionNovelViewState> ctx) {
  if (ctx.state.target == NOVEL_ENTRANCE.SEARCH) {
    ctx.state.pullController.requesting();
    String keyword = action.payload ?? '';
    ctx.dispatch(PassionNovelViewActionCreator.initPageNumber());
    ctx.dispatch(PassionNovelViewActionCreator.onSetKeyWord(keyword));
    _getDataView(action, ctx);
  }
}

/// 刷新页面
void _refresh(Action action, Context<PassionNovelViewState> ctx) {
  ctx.dispatch(PassionNovelViewActionCreator.initPageNumber());
  _getDataView(action, ctx);
}

/// 拉取数据刷新页面
void _getDataView(Action action, Context<PassionNovelViewState> ctx) async {
  int pageNumber = ctx.state.pageNumber;
  var resp = await _getData(ctx, pageNumber);
  if (resp != null) {
    List<NoveItem> list = resp.list ?? [];
    ctx.dispatch(PassionNovelViewActionCreator.onChangeList(list));
    if (resp.hasNext) {
      ctx.dispatch(PassionNovelViewActionCreator.onChangePageNumber());
    }
    ctx.state.pullController.requestSuccess(
        isFirstPageNum: pageNumber == 1,
        isEmpty: list.isEmpty,
        hasMore: resp.hasNext);
  } else {
    ctx.state.pullController.requestFail(isFirstPageNum: pageNumber == 1);
  }
}

/// 拉取数据
Future<NovelModel> _getData(
    Context<PassionNovelViewState> ctx, int pageNumber) async {
  NovelModel novelModel;
  int pageSize = ctx.state.pageSize;
  try {
    switch (ctx.state.target) {
      // 主页面
      case NOVEL_ENTRANCE.MAIN:
        String fictionType = ctx.state.fictionType;
        novelModel = await netManager.client
            .getFictionList(fictionType, pageNumber, pageSize);
        break;
      // 浏览记录页面
      case NOVEL_ENTRANCE.BROWSE:
        novelModel = await getBrowseRecording(pageNumber, pageSize);
        break;
      // 收藏记录页面
      case NOVEL_ENTRANCE.COLLECT:
        int uid = GlobalStore.getMe()?.uid ?? 0;
        novelModel = await netManager.client
            .getFictionCollectList(pageNumber, pageSize, uid, 'fiction');
        break;
      // 搜索页面
      case NOVEL_ENTRANCE.SEARCH:
        String keyword = ctx.state.keyword;
        novelModel = await netManager.client
            .getFictionSearch(keyword, pageNumber, pageSize);
        break;
      default:
    }
  } catch (e) {
    l.e('getFictionList', e.toString());
  }
  return novelModel;
}
