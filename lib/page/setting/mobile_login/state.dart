import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_app/widget/custom_text_edit_controller.dart';
import 'package:phone_number/phone_number.dart';

class MobileLoginState with EagleHelper implements Cloneable<MobileLoginState> {
  TextEditingControllerWorkRound phoneController;

  TextEditingControllerWorkRound smsCodeController;

  bool getSMSCodeSuccess = false;

  bool isLogging = false;

  PhoneNumber phoneNumberMgr = PhoneNumber();

  String areaCode = "86";

  bool isStartCountDown = false;

  AnimationController animationController;
  Animation<double> animation;
  bool hasClick = false;
  @override
  MobileLoginState clone() {
    return MobileLoginState()
      ..phoneController = phoneController
      ..smsCodeController = smsCodeController
      ..isLogging = isLogging
      ..areaCode = areaCode
      ..getSMSCodeSuccess = getSMSCodeSuccess
      ..isStartCountDown=isStartCountDown
      ..animationController=animationController
      ..animation=animation
      ..hasClick=hasClick
      ..phoneNumberMgr = phoneNumberMgr;
  }
}

MobileLoginState initState(Map<String, dynamic> args) {
  MobileLoginState state = MobileLoginState();
  state.phoneController = TextEditingControllerWorkRound();
  state.smsCodeController = TextEditingControllerWorkRound();
  if (args != null && args.containsKey('mobile')) {
    state.phoneController.text = args['mobile'];
  }

  return state;
}





