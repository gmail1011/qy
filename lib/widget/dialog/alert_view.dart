/*
 * @author admin.
 * @date: 2021/6/23 4:41 下午
 * @description: flutter
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertView extends StatelessWidget {
  ///标题
  final String title;

  ///内容
  final String content;

  ///标题样式
  final TextStyle titleTextStyle;

  ///内容样式
  final TextStyle contentTextStyle;

  ///确定样式
  final TextStyle confirmTextStyle;

  ///取消样式
  final TextStyle cancelTextStyle;

  ///确定文字描述
  final String confirmText;

  ///确定回调
  final Function confirmAction;

  ///取消文字描述
  final String cancelText;

  ///取消回调
  final Function cancelAction;

  const AlertView({
    Key key,
    @required this.confirmAction,
    this.cancelAction,
    this.title,
    @required this.content,
    this.titleTextStyle,
    this.contentTextStyle,
    this.confirmTextStyle,
    this.cancelTextStyle,
    this.confirmText,
    this.cancelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: CupertinoAlertDialog(
        content: Column(
          children: <Widget>[
            Text(
              title ?? "提示",
              style: titleTextStyle ??
                  TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
            SizedBox(
              height: 15,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 100),
              child: SingleChildScrollView(
                child: Container(
                  child: Text(
                    content,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    maxLines: null,
                  ),
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(
              cancelText ?? "取消",
              style: cancelTextStyle,
            ),
            onPressed: () {
              cancelAction?.call();
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text(
              confirmText ?? "确定",
              style: confirmTextStyle,
            ),
            onPressed: () {
              confirmAction.call();
            },
          ),
        ],
      ),
    );
  }
}
