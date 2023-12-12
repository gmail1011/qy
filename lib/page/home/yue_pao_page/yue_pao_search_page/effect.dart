import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

bool _isClick = false;
Effect<YuePaoSearchState> buildEffect() {
  return combineEffects(<Object, Effect<YuePaoSearchState>>{
    YuePaoSearchAction.loadMoedData: _loadMoedData,
    YuePaoSearchAction.onSubmitted: _onSubmitted,
    Lifecycle.initState: _initData,
  });
}

void _initData(Action action, Context<YuePaoSearchState> ctx) {
  Future.delayed(Duration(milliseconds: 500), () {
    _loadData(ctx, true);
  });
}

/// 搜索查询
void _onSubmitted(Action action, Context<YuePaoSearchState> ctx) {
  if(_isClick) return;
  _isClick = true;
  ctx.state.baseRequestController.requesting();
  _loadData(ctx, true);
}

/// 翻页查询
void _loadMoedData(Action action, Context<YuePaoSearchState> ctx) {
  _loadData(ctx);
}

/// 获取楼风列表
void _loadData(Context<YuePaoSearchState> ctx,
    [bool isKeyWordChange = false]) async {
  try {
    int pageSize = ctx.state.pageSize;
    int pageNumber = isKeyWordChange ? 1 : ctx.state.pageNumber;
    List<String> keyWords = [ctx.state.textEditingController.text];
    LouFengModel louFengModel = await netManager.client
        .getSearchData(pageNumber, pageSize, keyWords, 'loufeng');
    if (isKeyWordChange) {
      // 如果为初始化数组，查询条件变更
      ctx.dispatch(
          YuePaoSearchActionCreator.onInitList(louFengModel.list ?? []));
    } else {
      // 查询条件没变更为翻页
      ctx.dispatch(
          YuePaoSearchActionCreator.onAddList(louFengModel.list ?? []));
    }

    if ((louFengModel.list.length ?? 0) == 0 && pageNumber == 1) {
      ctx.state.baseRequestController.requestDataEmpty();
    } else {
      ctx.state.baseRequestController.requestSuccess();
    }

    if (!louFengModel.hasNext) {
      ctx.state.refreshController.loadNoData();
    } else {
      ctx.dispatch(YuePaoSearchActionCreator.onChangePageNumber());
      ctx.state.refreshController.loadComplete();
    }
  } catch (e) {
    ctx.state.baseRequestController.requestFail();
    ctx.state.refreshController.loadFailed();
    l.e('getLouFengList=', e.toString());
  }finally{
    isKeyWordChange = false;
    _isClick = false;
  }
}
