import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class DetailState with EagleHelper implements Cloneable<DetailState> {

  @override
  DetailState clone() {
    return DetailState();
  }
}

DetailState initState(Map<String, dynamic> args) {
  return DetailState();
}
