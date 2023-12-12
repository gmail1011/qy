import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user/local_user_info.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class SwitchAccountState with EagleHelper implements Cloneable<SwitchAccountState> {
  List<LocalUserInfo> localUserInfoList = [];

  ///是否可进入首页
  bool canEntryHomePage = false;
  SwitchAccountState();
  String versionStr;
  bool showLoading = false;

  @override
  SwitchAccountState clone() {
    return SwitchAccountState()
      ..localUserInfoList = localUserInfoList
      ..versionStr = versionStr
      ..showLoading = showLoading;
  }
}

SwitchAccountState initState(Map<String, dynamic> args) {
  return SwitchAccountState();
}
