import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';

enum HjllCommunityHomeAction {
  action,
  getAdSuccess,
}

class HjllCommunityActionCreator {
  static Action onAction() {
    return const Action(HjllCommunityHomeAction.action);
  }

}
