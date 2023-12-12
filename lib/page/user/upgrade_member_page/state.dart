import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/upgrade_vip_info.dart';

class UpgradeMemberState implements Cloneable<UpgradeMemberState> {
  UpGradeVipInfo upgradeInfo;
  @override
  UpgradeMemberState clone() {
    return UpgradeMemberState()..upgradeInfo = upgradeInfo;
  }
}

UpgradeMemberState initState(Map<String, dynamic> args) {
  return UpgradeMemberState();
}
