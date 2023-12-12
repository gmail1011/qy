import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'action.dart';
import 'state.dart';

Reducer<GlobalState> buildReducer() {
  return asReducer(
    <Object, Reducer<GlobalState>>{
      GlobalAction.userUpdateOkay: _userUpdateOkay,
      GlobalAction.walletUpdateOkay: _walletUpdateOkay,
    },
  );
}

/// 获取到用户信息更新成功后更新全局状态
GlobalState _userUpdateOkay(GlobalState state, Action action) {
  var user = action.payload as UserInfoModel;
  if (null == user) return state;
  return state.clone()..setMeInfo(user);
}

/// 获取到用户信息更新成功后更新全局状态
GlobalState _walletUpdateOkay(GlobalState state, Action action) {
  var wallet = action.payload as WalletModelEntity;
  if (null == wallet) return state;
  return state.clone()..setWallet(wallet);
}
