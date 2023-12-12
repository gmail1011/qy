import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/history_income_model.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'action.dart';
import 'state.dart';

Effect<MyIncomeState> buildEffect() {
  return combineEffects(<Object, Effect<MyIncomeState>>{
    MyIncomeAction.withdraw: _onWithdraw,
    MyIncomeAction.onBack: _onBack,
    Lifecycle.initState: _initState,
    MyIncomeAction.loadData: _loadData,
  });
}

void _onWithdraw(Action action, Context<MyIncomeState> ctx) {
  Map<String, dynamic> map = Map();
  map['income'] = ctx.state.income;
  map['from'] = ctx.state.from;
  JRouter().go(PAGE_WITHDRAW, arguments: map);
}

void _onBack(Action action, Context<MyIncomeState> ctx) {
  safePopPage();
}

void _initState(Action action, Context<MyIncomeState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () async {
    refreshData(ctx);
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });
}

///刷新数据
void refreshData(Context<MyIncomeState> ctx) async {
  ctx.state.pageNumber = 1;
  // Map<String, dynamic> map = Map();
  // map['pageNumber'] = ctx.state.pageNumber;
  // map['pageSize'] = ctx.state.pageSize;
  int pageNumber = ctx.state.pageNumber;
  int pageSize = ctx.state.pageSize;
  try {
    HistoryIncomeModel model =
        await netManager.client.getIncomeList(pageNumber, pageSize);
    ctx.dispatch(MyIncomeActionCreator.onRefreshData(model));
  } catch (e) {
    l.e('getIncomeList', e.toString());
    showToast(msg: e.toString());
  }
  // getIncomeList(map).then((res) {
  //   if (res.code == 200) {
  //     HistoryIncomeModel model = HistoryIncomeModel.fromMap(res.data);
  //     ctx.dispatch(MyIncomeActionCreator.onRefreshData(model));
  //   } else {}
  // });
}

///加载数据
void _loadData(Action action, Context<MyIncomeState> ctx) async {
  ctx.state.pageNumber++;
  // Map<String, dynamic> map = Map();
  // map['pageNumber'] = ctx.state.pageNumber;
  // map['pageSize'] = ctx.state.pageSize;
  int pageNumber = ctx.state.pageNumber;
  int pageSize = ctx.state.pageSize;
  try {
    HistoryIncomeModel model =
        await netManager.client.getIncomeList(pageNumber, pageSize);
    ctx.dispatch(MyIncomeActionCreator.onLoadData(
        {'hasNext': model?.hasNext ?? false, 'list': model.list}));
  } catch (e) {
    l.e('getIncomeList', e.toString());
    showToast(msg: e.toString());
  }
  // getIncomeList(map).then((res) {
  //   if (res.code == 200) {
  //     HistoryIncomeModel model = HistoryIncomeModel.fromMap(res.data);
  //     ctx.dispatch(MyIncomeActionCreator.onLoadData(
  //         {'hasNext': model?.hasNext ?? false, 'list': model.list}));
  //   } else {}
  // });
}
