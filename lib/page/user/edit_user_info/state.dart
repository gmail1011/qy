import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class EditUserInfoState extends GlobalBaseState
    with EagleHelper
    implements Cloneable<EditUserInfoState> {
  String tempPhoto = '';

  /// 缓存大小
  String cacheSize;

  EditUserInfoState();

  @override
  EditUserInfoState clone() {
    return EditUserInfoState()
      ..tempPhoto = tempPhoto
      ..cacheSize = cacheSize;
  }
}

EditUserInfoState initState(Map<String, dynamic> args) {
  return EditUserInfoState();
}
