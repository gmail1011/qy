import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class AccountSafeState extends GlobalBaseState
    with EagleHelper
    implements Cloneable<AccountSafeState> {
  bool isShowLoading = false;

  @override
  AccountSafeState clone() {
    return AccountSafeState();
  }

  AccountSafeState();
}

AccountSafeState initState(Map<String, dynamic> args) {
  return AccountSafeState();
}
