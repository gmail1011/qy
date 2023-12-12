import 'package:fish_redux/fish_redux.dart';

enum SettingAction {
  backAction,
  bindPromotionCode,
  onGetVersion,
  exChangeCode,
  clearCacheSuccess,
  tuiGuangCode,
  queryTuiGuangCode,
  getTuiGuangCode,
}

class SettingActionCreator {
  static Action onBack() {
    return const Action(SettingAction.backAction);
  }

  static Action bindPromotionCode(code) {
    return Action(SettingAction.bindPromotionCode, payload: code);
  }

  static Action onGetVersion() {
    return Action(SettingAction.onGetVersion);
  }

  static Action exChangeCode(code) {
    return Action(SettingAction.exChangeCode, payload: code);
  }

  static Action tuiGuangCode(code) {
    return Action(SettingAction.tuiGuangCode, payload: code);
  }

  static Action getTuiGuangCode(code) {
    return Action(SettingAction.getTuiGuangCode, payload: code);
  }

  static Action clearCacheSuccess() {
    return Action(SettingAction.clearCacheSuccess);
  }

  static Action queryTuiGunangCode() {
    return Action(SettingAction.queryTuiGuangCode);
  }
}
