import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';

//TODO replace with your own action
enum FuLiGuangChangAction { action ,}

class FuLiGuangChangActionCreator {
  static Action onAction() {
    return const Action(FuLiGuangChangAction.action);
  }
}
