import 'package:fish_redux/fish_redux.dart';

enum WalletAction { updateUI, selectCurrentIndex }

class WalletActionCreator {
  static Action updateUI() => const Action(WalletAction.updateUI);

  static Action selectCurrentIndex(int selectIndex) =>
      Action(WalletAction.selectCurrentIndex, payload: selectIndex);
}
