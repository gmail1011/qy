import 'package:fish_redux/fish_redux.dart';

enum RevenueCenterAction { updateUI }

class RevenueCenterActionCreator {
  static Action updateUI() => const Action(RevenueCenterAction.updateUI);
}
