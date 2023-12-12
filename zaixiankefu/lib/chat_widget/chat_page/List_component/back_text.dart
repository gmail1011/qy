import 'dart:async';
import 'package:chat_online_customers/chat_widget/chat_core/network/connection/socket_manager.dart';

import '../../chat_core/network/connection/notification_center.dart';
import 'package:flutter/material.dart';

class TimeDownText extends StatefulWidget {
  final dynamic bean;
  TimeDownText(this.bean);
  @override
  createState() => TimeDownTextState();
}

class TimeDownTextState extends State<TimeDownText> {
  Timer timerPeriod;
  var textStyle;

  @override
  void initState() {
    super.initState();
    if (widget.bean.type == 1) {
      timerPeriod = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (widget.bean.time == 0) {
          timerPeriod.cancel();
          Navigator.of(context).pop();
        }
        widget.bean.time--;
        setState(() {});
      });
    }

    NotificationCenter.addObserver(this, 'cancel', (param) {
      if (timerPeriod != null) {
        widget.bean.type = 0;
        timerPeriod.cancel();
        timerPeriod = null;
      }
    });
  }

  @override
  Widget build(Object context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Text('欢迎使用客服系统～${widget.bean.time}s之后自动关闭',
            style: TextStyle(fontSize: 10,color: SocketManager().model.baseColor)),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (timerPeriod != null) {
      timerPeriod.cancel();
      timerPeriod = null;
    }
    NotificationCenter.removeObserver(this);
  }
}
