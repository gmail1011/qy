import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/wallet/withdraw_details_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'action.dart';
import 'state.dart';

Effect<WithdrawDetailsState> buildEffect() {
  return combineEffects(<Object, Effect<WithdrawDetailsState>>{
    WithdrawDetailsAction.loadData: _loadData,
    Lifecycle.initState: _requestData,
  });
}

void _requestData(Action action, Context<WithdrawDetailsState> ctx) {
  Future.delayed(Duration(milliseconds: 200), () async {
    requestData(ctx);
  });
}

void requestData(Context<WithdrawDetailsState> ctx) async {
  ctx.state.pageNumber = 1;
  // Map<String, dynamic> map = Map();
  // map['pageNumber'] = ctx.state.pageNumber;
  // map['pageSize'] = ctx.state.pageSize;
  int pageNumber = ctx.state.pageNumber;
  int pageSize = ctx.state.pageSize;
  if (ctx.state.type == 0) {
    try {
      WithdrawDetailsModel model =
          await netManager.client.getIncomeDetails(pageNumber, pageSize);
      ctx.dispatch(WithdrawDetailsActionCreator.onRefreshData(model));
    } catch (e) {
      l.e('getIncomeDetails', e.toString());
      ctx.dispatch(WithdrawDetailsActionCreator.onRefreshData(e.toString()));
    }
    // getIncomeDetails(map).then((res) {
    //   if (res.code == 200) {
    //     WithdrawDetailsModel model = WithdrawDetailsModel.fromMap(res.data);
    //     ctx.dispatch(WithdrawDetailsActionCreator.onRefreshData(model));
    //   } else {
    //     //失败
    //     ctx.dispatch(WithdrawDetailsActionCreator.onRefreshData(res.msg));
    //   }
    // });
  } else if (ctx.state.type == 1) {
    try {
      WithdrawDetailsModel model =
          await netManager.client.getWithdrawDetails(pageNumber, pageSize);
      ctx.dispatch(WithdrawDetailsActionCreator.onRefreshData(model));
    } catch (e) {
      l.e('getWithdrawDetails', e.toString());
      //失败
      ctx.dispatch(WithdrawDetailsActionCreator.onRefreshData(e.toString()));
    }
    // getWithdrawDetails(map).then((res) {
    //   if (res.code == 200) {
    //     WithdrawDetailsModel model = WithdrawDetailsModel.fromMap(res.data);
    //     ctx.dispatch(WithdrawDetailsActionCreator.onRefreshData(model));
    //   } else {
    //     //失败
    //     ctx.dispatch(WithdrawDetailsActionCreator.onRefreshData(res.msg));
    //   }
    // });
  }
}

void _loadData(Action action, Context<WithdrawDetailsState> ctx) async {
  ctx.state.pageNumber++;
  // Map<String, dynamic> map = Map();
  // map['pageNumber'] = ctx.state.pageNumber;
  // map['pageSize'] = ctx.state.pageSize;

  int pageNumber = ctx.state.pageNumber;
  int pageSize = ctx.state.pageSize;
  if (ctx.state.type == 0) {
    try {
      WithdrawDetailsModel model =
          await netManager.client.getIncomeDetails(pageNumber, pageSize);
      ctx.dispatch(WithdrawDetailsActionCreator.onLoadData(
          {"list": model.list, "hasNext": model?.hasNext ?? false}));
    } catch (e) {
      //失败
      l.d("oldLog", e.toString());
    }
    // getIncomeDetails(map).then((res) {
    //   if (res.code == 200) {
    //     WithdrawDetailsModel model = WithdrawDetailsModel.fromMap(res.data);
    //     ctx.dispatch(WithdrawDetailsActionCreator.onLoadData(
    //         {"list": model.list, "hasNext": model?.hasNext ?? false}));
    //   } else {
    //     //失败
    //     l.d("oldLog", res.msg);
    //   }
    // });
  } else if (ctx.state.type == 1) {
    try {
      WithdrawDetailsModel model =
          await netManager.client.getWithdrawDetails(pageNumber, pageSize);
      ctx.dispatch(WithdrawDetailsActionCreator.onLoadData(
          {"list": model.list, "hasNext": model?.hasNext ?? false}));
    } catch (e) {
      //失败
      l.d("oldLog", e.toString());
    }
    // getWithdrawDetails(map).then((res) {
    //   if (res.code == 200) {
    //     WithdrawDetailsModel model = WithdrawDetailsModel.fromMap(res.data);
    //     ctx.dispatch(WithdrawDetailsActionCreator.onLoadData(
    //         {"list": model.list, "hasNext": model?.hasNext ?? false}));
    //   } else {
    //     //失败
    //     l.d("oldLog", res.msg);
    //   }
    // });
  }
}
