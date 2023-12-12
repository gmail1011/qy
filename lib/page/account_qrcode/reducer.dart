import 'package:fish_redux/fish_redux.dart';

import 'action.dart';
import 'state.dart';

Reducer<AccountQrCodeState> buildReducer() {
  return asReducer(
    <Object, Reducer<AccountQrCodeState>>{
      AccountQrCodeAction.getQrCodeSuccess: _getQrCodeSuccess,
    },
  );
}

AccountQrCodeState _getQrCodeSuccess(AccountQrCodeState state, Action action) {
  final AccountQrCodeState newState = state.clone();
  newState.qrCode = action.payload;
  return newState;
}
