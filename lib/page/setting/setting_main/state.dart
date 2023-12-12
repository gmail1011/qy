import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class SettingState extends GlobalBaseState with EagleHelper implements Cloneable<SettingState> {
  Map<String, dynamic> versionMap = {};

  /// 缓存大小
  String cacheSize;

  dynamic tuiGuangCode;

  @override
  SettingState clone() {
    return SettingState()..cacheSize = cacheSize..tuiGuangCode = tuiGuangCode;
  }
}

SettingState initState(Map<String, dynamic> args) {
  return SettingState();
}
