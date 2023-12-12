import 'package:fish_redux/fish_redux.dart';

enum BoutiqueAppAction { updateUI }

class BoutiqueAppActionCreator {
  static Action updateUI() => const Action(BoutiqueAppAction.updateUI);
}
