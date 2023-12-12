import 'package:flutter/material.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';

class EmptyWidget extends StatefulWidget {
  final String fromPage;

  ///(mine) 我的   user(用户)
  final int numType;

  ///0作品   1购买    2喜欢

  EmptyWidget(this.fromPage, this.numType);

  @override
  State<StatefulWidget> createState() {
    return _EmptyWidgetState();
  }
}

class _EmptyWidgetState extends State<EmptyWidget> {
  // ignore: missing_return
  String getText() {
    if (widget.fromPage == "mine") {
      switch (widget.numType) {
        case 0:
          return Lang.NOT_WORK_VIDEO;
        case 1:
          return Lang.NOT_BUY_VIDEO;
        case 2:
          return Lang.NOT_LIKE_VIDEO;
        case 3:
          return "暂无数据";
      }
    } else {
      switch (widget.numType) {
        case 0:
          return Lang.USER_NOT_WORK_VIDEO;
        case 1:
          return Lang.USER_NOT_BUY_VIDEO;
        case 2:
          return Lang.USER_NOT_LIKE_VIDEO;
        case 3:
          return "暂无数据";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: Dimens.pt40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(getText(),
                style: TextStyle(color: Colors.white, fontSize: 15)),
          ],
        ));
  }
}
