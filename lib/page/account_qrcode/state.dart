import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';

class AccountQrCodeState extends GlobalBaseState with EagleHelper
    implements Cloneable<AccountQrCodeState> {
  GlobalKey boundaryKey = GlobalKey();

  String qrCode = '';

  @override
  AccountQrCodeState clone() {
    return AccountQrCodeState()
      ..boundaryKey = boundaryKey
      ..qrCode = qrCode;
  }
}

AccountQrCodeState initState(Map<String, dynamic> args) {
  return AccountQrCodeState()..qrCode = "";
}
