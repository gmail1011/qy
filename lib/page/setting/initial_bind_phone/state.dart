import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/widget/custom_text_edit_controller.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:phone_number/phone_number.dart';

class InitialBindPhoneState
    with EagleHelper
    implements Cloneable<InitialBindPhoneState> {
  TextEditingControllerWorkRound phoneController;
  TextEditingControllerWorkRound smsCodeController;

  bool getSMSCodeSuccess = false;
  bool isBinding = false;

  ///是否绑定手机类型， 更换手机号类型
  bool updatePhone = false;

  ///绑定手机类型 0 绑定手机号 1更换手机号 2账号找回
  int bindMobileType = 0;
  String bindMobileTitle = "";

  ///手机区号
  String phoneCode = "+86";
  PhoneNumber phoneNumberMgr = PhoneNumber();

  ///找回手机需要填写手机号
  String mobileNum;

  @override
  InitialBindPhoneState clone() {
    return InitialBindPhoneState()
      ..phoneController = phoneController
      ..smsCodeController = smsCodeController
      ..getSMSCodeSuccess = getSMSCodeSuccess
      ..phoneCode = phoneCode
      ..phoneNumberMgr = phoneNumberMgr
      ..bindMobileType = bindMobileType
      ..bindMobileTitle = bindMobileTitle
      ..mobileNum = mobileNum;
  }
}

InitialBindPhoneState initState(Map<String, dynamic> args) {
  InitialBindPhoneState state = InitialBindPhoneState();
  state.phoneController = TextEditingControllerWorkRound();
  state.smsCodeController = TextEditingControllerWorkRound();
  return state
    ..bindMobileTitle = args["bindMobileTitle"] ?? ""
    ..mobileNum = args["mobileNum"] ?? ""
    ..bindMobileType = args["bindMobileType"] ?? 0;
}
