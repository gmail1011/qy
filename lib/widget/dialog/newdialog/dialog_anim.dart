//file: 视频加载动画
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_set/animation_set.dart';
import 'package:flutter_animation_set/animator.dart';

enum DialogAnimType {
  AccountBan,//账号封禁
  TakenAbnormal,//token异常
  systemTxt,
  systemImg,
  vip,
  buyVideo,
  shareUtil,
}

///视频加载动画
class DialogAnim extends StatelessWidget {
  final Widget child;
  final int duration;

  DialogAnim({Key key, @required this.child, this.duration = 300}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatorSet(
      child: child,
      animationType: AnimationType.once,
      animatorSet: [
        Serial(
          duration: duration,
          serialList: [
            SX(from: 0.0, to: 1.0, curve: Curves.elasticOut),//elasticOut
            SY(from: 0.0, to: 1.0, curve: Curves.elasticOut),
            O(from: 0.0, to: 1.0, curve: Curves.linear),
          ],
        ),
      ],
    );
  }
}
