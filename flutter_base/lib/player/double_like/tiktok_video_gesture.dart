import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_base/utils/screen.dart';

import 'tiktok_like_anim_item.dart';

class TikTokVideoGesture extends StatefulWidget {
  const TikTokVideoGesture({
    Key key,
    @required this.child,
    this.onDoubleClick,
    this.onSingleTap,
  }) : super(key: key);

  final Function onDoubleClick;
  final Function onSingleTap;
  final Widget child;

  @override
  _TikTokVideoGestureState createState() => _TikTokVideoGestureState();
}

class _TikTokVideoGestureState extends State<TikTokVideoGesture> {
  GlobalKey _key = GlobalKey();
  // 内部转换坐标点
  Offset _transP(Offset p) {
    RenderBox getBox = _key.currentContext.findRenderObject();
    Offset resultOffset = getBox.globalToLocal(p);
    if (resultOffset.dy < screen.screenHeight * 0.9 && resultOffset.dy > 50) {
      resultOffset = Offset(resultOffset.dx, resultOffset.dy - 45);
    }
    return Offset((resultOffset.dx + Random().nextInt(15)),
        (resultOffset.dy + Random().nextInt(15)));
    // return resultOffset;
  }

  List<Offset> icons = [];
  bool inDoubleCheck = false;
  bool doDoubleClick = false;
  Timer timer;

  @override
  Widget build(BuildContext context) {
    var iconStack = Stack(
      children: icons.map<Widget>((p) {
        // print("add icon :$p");
        return TikTokLikeAnimItem(
          key: Key(p.toString()),
          position: p,
          onAnimationComplete: () {
            setState(() {
              // print("remove icon:$p hash:${p.hashCode}");
              icons.remove(p);
            });
          },
        );
      }).toList(),
    );
    return GestureDetector(
      key: _key,
      behavior: HitTestBehavior.opaque,
      onTapDown: (detail) {
        if (inDoubleCheck) {
          doDoubleClick = true;
          setState(() {
            var p = _transP(detail.globalPosition);
            // print("add icon :$p hash:${p.hashCode} length:${icons.length}");
            icons.add(p);
          });
          widget.onDoubleClick?.call();
        } else {
          doDoubleClick = false;
        }
      },
      onTapUp: (detail) {
        timer?.cancel();
        var delay = inDoubleCheck ? 800 : 400;
        timer = Timer(Duration(milliseconds: delay), () {
          inDoubleCheck = false;
          timer = null;
          if (!doDoubleClick) {
            widget.onSingleTap?.call();
          }
        });
        inDoubleCheck = true;
      },
      child: Stack(
        children: <Widget>[
          widget.child,
          // Container(
          //   width: 400,
          //   height: 600,
          //   color: Colors.blue,
          // ),
          iconStack,
        ],
      ),
    );
  }
}
