

import 'package:chat_online_customers/chat_widget/chat_core/network/connection/msg_manager.dart';
import 'package:chat_online_customers/chat_widget/com_component/stars/stars.dart';

import '../../../chat_core/pkt/pb.pb.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BulletBox extends StatefulWidget {
  BulletBox(Dispatch dispatch,
      {this.text: '请选择！', this.sessionId, this.size, this.score})
      : super();
  final String text;
  final String sessionId;
  // 星星大小
  final double size;
  // 分数
  final double score;
  @override
  _BulletBoxState createState() => _BulletBoxState();
}

class _BulletBoxState extends State<BulletBox> {
  // 分数
  double _score;

  double _listenerConW;
  GlobalKey _anchorKey;
  // 星星大小
  double _size;
  // 星星个数
  int _number;
  @override
  void initState() {
    super.initState();
    _anchorKey = GlobalKey();
    _score = widget.score ?? 5.0;
    _size = widget.size ?? 30;
    _number = _score.ceil();
    print(_number);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      RenderBox renderBox = _anchorKey.currentContext.findRenderObject();
      setState(() {
        _listenerConW = renderBox.size.width;
      });
    });
  }

  // 根据滑动获取分数
  _pointValue(double x) {
    // 星星默认5颗 大小为30
    double _margingLeft = (_listenerConW - _size * _number) / 2;
    // 变量
    double _dx = x - _margingLeft;
    _dx = _dx > 0 ? _dx : 0;
    var _variable =
        _dx / _size > _number ? double.parse(_number.toString()) : _dx / _size;
    setState(() {
      _score = _variable;
    });
  }

  // 服务打分事件
  _rateScore(String type, {double score: 0}) {
    if (type == 'ok' && score != null) {
      BaseMessage baseMessage = BaseMessage.create()
        ..action = 1011
        ..data = (EvaluateScore.create()
              ..content = '还可以'
              ..sessionId = widget.sessionId
              ..score = _score.round())
            .writeToBuffer();
      MsgUtils.sendMessage(baseMessage.writeToBuffer());
    }
    // 退出弹框
    Navigator.of(context).pop();
    // 退出当前页面
    Navigator.of(context).pop(); //关闭对话框
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        width: 200, //Dialog内置最小宽度280，其宽度大于280（包括填充）时以子组件宽度为准，设置成200让其宽度保持280
        child: Text(
          widget.text,
          style: TextStyle(fontSize: 14, height: 1),
        ),
      ),
      content: Listener(
        onPointerDown: (dowPointEvent) {
          var x = dowPointEvent.localPosition.dx;
          _pointValue(x);
        },
        onPointerMove: (movePointEvent) {
          var x = movePointEvent.localPosition.dx;
          _pointValue(x);
        },
        child: Container(
          key: _anchorKey,
          height: _size, //和星星大小一样
          child: Stars(
            factor: _score,
            size: _size,
            number: _number,
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      actions: <Widget>[
        FlatButton(
            child: Text("确定"),
            onPressed: () => _rateScore('ok', score: _score)),
        FlatButton(child: Text("取消"), onPressed: () => _rateScore('close')),
      ],
    );
  }
}
