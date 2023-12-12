import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/page/home/yue_pao_page/com/public.dart';
import 'package:flutter_base/flutter_base.dart';
import 'action.dart';
import 'state.dart';

Effect<YuePaoIndexTabViewState> buildEffect() {
  return combineEffects(<Object, Effect<YuePaoIndexTabViewState>>{
    YuePaoIndexTabViewAction.loadMoreData: _loadMoreData,
    YuePaoIndexTabViewAction.onSelectCity: _onSelectCity,
    YuePaoIndexTabViewAction.loadRefresh: _loadRefresh,
    Lifecycle.initState: _initData,
  });
}

void _initData(Action action, Context<YuePaoIndexTabViewState> ctx) {
  Future.delayed(Duration(milliseconds: 500), () async {
    String city = await getCity('lou_feng_city');
    if (!TextUtil.isEmpty(city)) {
      /// 刷新当前ui
      ctx.dispatch(YuePaoIndexTabViewActionCreator.onChangeCity(city));
    }
    _getDataView(action, ctx);
  });
}
/// 城市变更
void _onSelectCity(Action action, Context<YuePaoIndexTabViewState> ctx) {
  ctx.state.pullController.requesting();
  // 缓存城市
  setCity(action.payload, 'lou_feng_city');
  ctx.dispatch(YuePaoIndexTabViewActionCreator.onChangeCity(action.payload));
  ctx.dispatch(YuePaoIndexTabViewActionCreator.onChangeAD(false));
  ctx.dispatch(YuePaoIndexTabViewActionCreator.initPageNumber());
  _getDataView(action, ctx);
}

/// 获取数据并调整视图
void _getDataView(Action action, Context<YuePaoIndexTabViewState> ctx) async {
  int pageNumber = ctx.state.pageNumber;
  var resp = await _getData(ctx);
  if (resp != null) {
    bool isEmpty = (resp.list ?? []).isEmpty;
    ctx.dispatch(YuePaoIndexTabViewActionCreator.onChangeList(
        resp.list, ctx.state.pageNumber));
    if (resp.hasNext) {
      ctx.dispatch(YuePaoIndexTabViewActionCreator.onChangePageNumber());
    } else {
      // 没有就重置pageNumber
      ctx.dispatch(YuePaoIndexTabViewActionCreator.initPageNumber());
    }
    ctx.state.pullController.requestSuccess(
      isFirstPageNum: pageNumber == 1,
      hasMore: resp.hasNext,
      isEmpty: isEmpty,
    );
  } else {
    ctx.state.pullController.requestFail(isFirstPageNum: pageNumber == 1);
  }
}
/// 加载更多数据
void _loadMoreData(Action action, Context<YuePaoIndexTabViewState> ctx) {
  ctx.dispatch(YuePaoIndexTabViewActionCreator.onChangeAD(action.payload));
  _getDataView(action, ctx);
}
/// 上拉刷新
void _loadRefresh(Action action, Context<YuePaoIndexTabViewState> ctx) {
  ctx.dispatch(YuePaoIndexTabViewActionCreator.initPageNumber());
  _getDataView(action, ctx);
}

/// 获取数据
Future<LouFengModel> _getData(Context<YuePaoIndexTabViewState> ctx) async {
  LouFengModel louFengModel;
  try {
    int pageNumber = ctx.state.pageNumber;
    int pageSize = ctx.state.pageSize;
    String city = ctx.state.city;
    bool hasAD = ctx.state.hasAD;
    int pageTitle = ctx.state.pageTitle;
    int pageType = ctx.state.pageType;
    louFengModel = await netManager.client
        .getLouFengListNew(pageNumber, pageSize, city, hasAD, pageTitle, pageType);
  } catch (e) {
    l.e('getLouFengList=>', e.toString());
  }
  return louFengModel;
}
