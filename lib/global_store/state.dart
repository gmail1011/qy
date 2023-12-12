import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_base/utils/log.dart';

/// 主要为保持继承到的类初始化值
WalletModelEntity _globalWallet;
UserInfoModel _globalMeInfo;

abstract class GlobalBaseState {
  //全局用户，自己, 设置父类的一个默认值
  // UserInfoModel get meInfo => GlobalStore.store?.getState()?.meInfo;

  // set meInfo(UserInfoModel me) => GlobalStore.store?.getState()?.meInfo = me;

  // WalletModelEntity get wallet => GlobalStore.store?.getState()?.wallet;
  // set wallet(WalletModelEntity wallet) =>
  //     GlobalStore.store?.getState()?.wallet = wallet;
  UserInfoModel meInfo;
  WalletModelEntity wallet;

  GlobalBaseState() {
    meInfo = _globalMeInfo;
    wallet = _globalWallet;
    // print(
    //     "global base new page wallet is null :${null == _globalWallet} money:${_globalWallet?.income ?? 0}");
  }
}

class GlobalState extends GlobalBaseState implements Cloneable<GlobalState> {
  GlobalState();

  /// warning 对于改变Global的状态不要再设置属性了
  setMeInfo(UserInfoModel user) {
    meInfo = user;
    _globalMeInfo = user;
    l.d("setMeInfo-vipExpireDate", "${user.vipExpireDate}");
  }

  setWallet(WalletModelEntity entity) {
    wallet = entity;
    _globalWallet = entity;
  }

  @override
  GlobalState clone() {
    return GlobalState()
      ..meInfo = meInfo
      ..wallet = wallet;
  }
}

GlobalState initState(Map<String, dynamic> args) {
  var fakeUser = UserInfoModel()
    ..uid = 0
    ..name = "游客";
  var fakeWallet = WalletModelEntity(
      income: 0,
      amount: 0,
      performance: 0,
      money: 0,
      consumption: 0,
      takeOut: 0);
  
  return GlobalState()
    ..setMeInfo(fakeUser)
    ..setWallet(fakeWallet);
}
