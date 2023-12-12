import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_app/widget/custom_text_edit_controller.dart';
import 'package:phone_number/phone_number.dart';

class RebindPhoneState with EagleHelper implements Cloneable<RebindPhoneState> {
  TextEditingControllerWorkRound phoneController;

  TextEditingControllerWorkRound smsCodeController;

  bool getSMSCodeSuccess = false;

  bool isBinding = false;

  ///手机区号
  String phoneCode = "86";
  PhoneNumber phoneNumberMgr = PhoneNumber();

  @override
  RebindPhoneState clone() {
    return RebindPhoneState()
      ..phoneController = phoneController
      ..smsCodeController = smsCodeController
      ..getSMSCodeSuccess = getSMSCodeSuccess
      ..isBinding = isBinding
      ..phoneCode = phoneCode
      ..phoneNumberMgr = phoneNumberMgr;
  }
}

RebindPhoneState initState(Map<String, dynamic> args) {
  RebindPhoneState state = RebindPhoneState();
  state.phoneController = TextEditingControllerWorkRound();
  state.smsCodeController = TextEditingControllerWorkRound();
  if(args != null && args.containsKey('mobile')) {
    state.phoneController.text = args['mobile'];
  }
  return state;
}
