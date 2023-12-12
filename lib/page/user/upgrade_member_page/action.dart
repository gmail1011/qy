import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/upgrade_vip_info.dart';

enum UpgradeMemberAction { getInfoOkay, upgrade }

class UpgradeMemberActionCreator {
  static Action onUpgrade() {
    return const Action(UpgradeMemberAction.upgrade);
  }

  static Action getInfoOkay(UpGradeVipInfo upgradeInfo) {
    return Action(UpgradeMemberAction.getInfoOkay, payload: upgradeInfo);
  }
}
