import 'package:flutter/material.dart';
import 'package:flutter_app/widget/shadow_text.dart';
import 'package:flutter_base/utils/dimens.dart';

class VideoTimeView extends StatelessWidget {
  final int seconds;

  VideoTimeView({Key key, this.seconds = 0});

  String _constructTime(int seconds) {
    int hour = seconds ~/ 3600;
    int minute = seconds % 3600 ~/ 60;
    int second = seconds % 60;
    return _formatTime(hour) +
        ":" +
        _formatTime(minute) +
        ":" +
        _formatTime(second);
  }

//数字格式化，将 0~9 的时间转换为 00~09
  String _formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  @override
  Widget build(BuildContext context) {
    var timerStr = _constructTime(seconds);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 9.0),
      decoration: BoxDecoration(
        color: Color(0x66000000), // 半透明底色
        borderRadius: BorderRadius.circular((10.0)), // 圆角度
      ),
      child: ShadowText(
        timerStr,
        maxLines: 1,
        fontSize: Dimens.pt10,
        color: Colors.white,
      ),
    );
  }
}
