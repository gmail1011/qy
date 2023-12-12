import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'state.dart';

Widget buildView(VoiceState state, Dispatch dispatch, ViewService viewService) {
  return Center(
    child: Opacity(
      opacity: 0.5,
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: Color(0xff77797A),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Column(
          children: <Widget>[
            VoiceImageWidget(),
            Container(
              padding: EdgeInsets.only(right: 20, left: 20, top: 0),
              child: Text(
                state.voiceContent ?? '松开手指，立即发送',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

class VoiceImageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VoiceImageState();
  }
}

class VoiceImageState extends State<VoiceImageWidget> {
  String imgStr = 'assets/images/voice_volume_7.png';
  @override
  Widget build(Object context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Image.asset(
        imgStr,
        width: 100,
        height: 100,
        package: 'chat_online_customers',
      ),
    );
  }
}
