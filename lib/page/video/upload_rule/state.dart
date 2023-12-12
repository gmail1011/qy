import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:package_info/package_info.dart';

class UploadRuleState with EagleHelper implements Cloneable<UploadRuleState> {
  /// packageInfo
  PackageInfo packageInfo;
  @override
  UploadRuleState clone() {
    return UploadRuleState()..packageInfo=packageInfo;
  }
}

UploadRuleState initState(Map<String, dynamic> args) {
  return UploadRuleState();
}
