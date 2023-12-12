import 'package:flutter/cupertino.dart';
import 'package:flutter_app/assets/lang.dart';

class CountdwonUpdate with ChangeNotifier {
  Countdown _countdown = Countdown();
  // 24小时文本
  String msg = Lang.NEW_USERS_MSG1;
  // 74小时文本
  // String i72Str1 = Lang.NEW_USERS_MSG21;
  // String i72Str2 = Lang.NEW_USERS_MSG22;
  // 24小时弹框是否显示
  // bool i24hide = false;
  // 72小时弹框是否显示
  // bool i72hide = false;
  void setCountdown(Countdown countdown) {
    _countdown = countdown;
    notifyListeners();
  }

  Countdown get countdown => _countdown;
}

class Countdown {
  int countdownSec;
  String copywriting;

  Countdown({this.countdownSec = 0});

  Countdown.fromJson(Map<String, dynamic> json) {
    countdownSec = json['countdownSec'] ?? 0;
    copywriting = json['copywriting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countdownSec'] = this.countdownSec;
    data['copywriting'] = this.copywriting;
    return data;
  }
}
