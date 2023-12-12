import 'package:fish_redux/fish_redux.dart';

enum CityAdapterAction { action }

class CityAdapterActionCreator {
  static Action onAction() {
    return const Action(CityAdapterAction.action);
  }
}
