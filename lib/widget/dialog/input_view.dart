/*
 * @author admin.
 * @date: 2021/6/24 11:19 上午
 * @description: flutter
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class InputView extends StatefulWidget {
  ///标题
  final String title;

  ///最大行数
  final int maxLines;

  ///文字最大长度
  final int maxLength;

  ///占位符
  final String placeholder;

  ///取消文字描述
  final String cancelText;

  ///确定文字描述
  final String confirmText;

  ///取消动作
  final Function cancelAction;

  ///确定按钮文字样式
  final TextStyle titleTextStyle;

  ///取消按钮文字样式
  final TextStyle cancelTextStyle;

  ///确定按钮文字样式
  final TextStyle confirmTextStyle;

  ///占位符文字样式
  final TextStyle placeholderStyle;

  ///确定按钮动作返回选项
  final Function(String output) confirmAction;

  const InputView({
    Key key,
    this.maxLines,
    this.maxLength,
    this.placeholder,
    @required this.title,
    @required this.confirmAction,
    this.cancelText,
    this.confirmText,
    this.cancelAction,
    this.titleTextStyle,
    this.placeholderStyle,
    this.cancelTextStyle,
    this.confirmTextStyle,
  }) : super(key: key);

  @override
  _InputViewState createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  TextEditingController _editingController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        widget.title,
        style: widget.titleTextStyle,
      ),
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        constraints: BoxConstraints(maxHeight: 160),
        child: CupertinoTextField(
          placeholder: widget.placeholder,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          placeholderStyle: widget.placeholderStyle ??
              TextStyle(
                color: Colors.black12,
              ),
          controller: _editingController,
          // onChanged: (value) {
          //
          // },
        ),
      ),
      actions: [
        CupertinoDialogAction(
          isDestructiveAction: true,
          child: Text(
            widget.cancelText ?? "取消",
            style: widget.cancelTextStyle,
          ),
          onPressed: () {
            widget.cancelAction?.call();
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(
            widget.confirmText ?? "确定",
            style: widget.confirmTextStyle,
          ),
          onPressed: () {
            widget.confirmAction.call(_editingController.text);
          },
        ),
      ],
    );
  }
}
