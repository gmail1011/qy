import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';

enum FilmTelevisionAction {
  action,
  onRefreshUI,
  getAdSuccess,
}

class FilmTelevisionActionCreator {
  static Action onAction() {
    return const Action(FilmTelevisionAction.action);
  }
  static Action onRefreshUI() {
    return const Action(FilmTelevisionAction.onRefreshUI);
  }

}
