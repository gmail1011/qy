import 'package:fish_redux/fish_redux.dart';

enum RecoverAccountAction {
  updateUI,
  changeSelectType,
  refreshUI,
  qrLogin,
  photoAlbumSelection,
}

class RecoverAccountActionCreator {
  static Action updateUI() {
    return const Action(RecoverAccountAction.updateUI);
  }

  static Action changeSelectType(int selectType) {
    return Action(RecoverAccountAction.changeSelectType, payload: selectType);
  }

  static Action refreshUI() {
    return const Action(RecoverAccountAction.refreshUI);
  }

  static Action photoAlbumSelection() {
    return const Action(RecoverAccountAction.photoAlbumSelection);
  }

  static Action qrLogin(String qrCode) {
    return Action(RecoverAccountAction.qrLogin, payload: qrCode);
  }
}
