import 'package:fish_redux/fish_redux.dart';

class BindingPhoneSuccessState implements Cloneable<BindingPhoneSuccessState> {

  String newPhoneNum;
  @override
  BindingPhoneSuccessState clone() {
    return BindingPhoneSuccessState()..newPhoneNum=newPhoneNum;
  }
}

BindingPhoneSuccessState initState(Map<String, dynamic> args) {
  return BindingPhoneSuccessState()..newPhoneNum= args["newPhoneNum"];
}
