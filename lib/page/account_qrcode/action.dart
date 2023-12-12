import 'package:fish_redux/fish_redux.dart';


enum AccountQrCodeAction { onSaveQrCode,getQrCodeSuccess }

class AccountQrCodeActionCreator {

  static Action onSaveQrCode() {
    return const Action(AccountQrCodeAction.onSaveQrCode);
  }

  static Action getQrCodeSuccess(String qrCode) {
    return  Action(AccountQrCodeAction.getQrCodeSuccess,payload: qrCode);
  }
}
