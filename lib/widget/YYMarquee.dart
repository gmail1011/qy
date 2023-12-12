import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:visibility_detector/visibility_detector.dart'; //Timer

class YYMarquee extends StatefulWidget {
  final Widget child; // 轮播的内容
  final Duration duration; // 轮播时间
  final double stepOffset; // 偏移量
  final double paddingLeft; // 内容之间的间距
  final String keyName;

  YYMarquee(this.child, this.paddingLeft, this.duration, this.stepOffset,
      {this.keyName = "YYMarquee"});

  _YYMarqueeState createState() => _YYMarqueeState();
}

class _YYMarqueeState extends State<YYMarquee> {
  ScrollController _controller; // 执行动画的controller
  Timer _timer; // 定时器timer
  double _offset = 0.0; // 执行动画的偏移量

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void _initTimer() {
    l.d("_initTimer", "");
    _controller = ScrollController(initialScrollOffset: _offset);
    _timer = Timer.periodic(widget.duration, (timer) {
      double newOffset = _controller.offset + widget.stepOffset;
      if (newOffset != _offset) {
        _offset = newOffset;
        _controller.animateTo(_offset,
            duration: widget.duration, curve: Curves.linear); // 线性曲线动画
      }
    });
  }

  void _cancelTimer() {
    l.d("_cancelTimer", "");
    _timer?.cancel();
    _controller?.dispose();
    _timer = null;
    _controller = null;
  }

  Widget _child() {
    return Row(children: _children());
  }

  // 子视图
  List<Widget> _children() {
    List<Widget> items = [];
    for (var i = 0; i <= 2; i++) {
      Container item = Container(
        margin: EdgeInsets.only(right: i != 0 ? 0.0 : widget.paddingLeft),
        child: i != 0 ? null : widget.child,
      );
      items.add(item);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("YYMarquee"),
      onVisibilityChanged: (visibleInfo) {
        if (visibleInfo.visibleFraction == 0) {
          _cancelTimer();
          if(mounted) {
            setState(() {});
          }

          return;
        }
        if (_controller != null && (_timer?.isActive ?? false)) {
          return;
        }
        _initTimer();
        if(mounted) {
          setState(() {});
        }
      },
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 横向滚动
        controller: _controller, // 滚动的controller
        itemBuilder: (context, index) {
          return _child();
        },
      ),
    );
  }
}
