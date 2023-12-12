/*
 * @author admin.
 * @date: 2021/6/23 8:49 下午
 * @description: flutter
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/dialog/popup_view.dart';

import 'alert_view.dart';
import 'bottom_sheet_view.dart';
import 'cupertino_sheet.dart';
import 'input_view.dart';

class AlertTool {
  ///中间弹出的提示弹窗
  static showTipAlert({
    @required BuildContext context,

    ///标题
    String title,

    ///内容
    @required String content,

    ///取消按钮描述文字
    String cancelText,

    ///确定按钮描述文字
    String confirmText,

    ///取消动作
    Function cancelAction,

    ///确定动作
    @required Function confirmAction,

    ///标题文字样式
    TextStyle titleTextStyle,

    ///取消按钮文字样式
    TextStyle cancelTextStyle,

    ///确定按钮文字样式
    TextStyle confirmTextStyle,

    ///弹窗内容文字样式
    TextStyle contentTextStyle,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertView(
          title: title,
          content: content,
          cancelText: cancelText,
          confirmText: confirmText,
          cancelAction: cancelAction,
          confirmAction: confirmAction,
          titleTextStyle: titleTextStyle,
          cancelTextStyle: cancelTextStyle,
          confirmTextStyle: confirmTextStyle,
          contentTextStyle: contentTextStyle,
        );
      },
    );
  }

  ///底部弹出的选择弹窗
  static showBottomPicker({
    @required BuildContext context,

    ///弹窗标题
    @required String title,

    ///弹窗选项列表
    @required List<String> options,

    ///弹窗标题文字样式
    TextStyle titleTextStyle,

    ///弹窗选项文字样式
    TextStyle optionTextStyle,

    ///弹窗取消文字样式
    TextStyle cancelTextStyle,

    ///弹窗选项选中返回选项内容
    @required Function(int index) didIndexSelected,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoSheet(
          title: title,
          options: options,
          titleTextStyle: titleTextStyle,
          optionTextStyle: optionTextStyle,
          cancelTextStyle: cancelTextStyle,
          didIndexSelected: didIndexSelected,
        );
      },
    );
  }

  ///底部弹出的选择提示弹窗
  static showBottomSheet({
    @required BuildContext context,

    ///弹窗标题
    @required String title,

    ///弹窗选项列表
    @required List<String> options,

    ///弹窗标题文字样式
    TextStyle titleTextStyle,

    ///弹窗选项文字样式
    TextStyle optionTextStyle,

    ///弹窗取消文字样式
    TextStyle cancelTextStyle,

    ///弹窗选项选中返回选项内容
    @required Function(String option) didOptionSelected,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return BottomSheetView(
          title: title,
          options: options,
          titleTextStyle: titleTextStyle,
          optionTextStyle: optionTextStyle,
          cancelTextStyle: cancelTextStyle,
          didOptionSelected: didOptionSelected,
        );
      },
    );
  }

  static showInputAlert({
    @required BuildContext context,

    ///输入弹窗标题
    @required String title,
    //输入弹窗确定按钮返回输入内容
    @required Function(String text) confirmAction,

    ///输入框可输入最大行数
    int maxLines,

    ///输入框可输入文字最大数
    int maxLength,

    ///输入框占位符
    String placeholder,

    ///取消按钮文字描述
    String cancelText,

    ///确定按钮文字描述
    String confirmText,

    ///取消按钮动作
    Function cancelAction,

    ///标题文字样式
    TextStyle titleTextStyle,

    ///输入框占位符文字样式
    TextStyle placeholderStyle,

    ///确定按钮文字描述
    TextStyle confirmTextStyle,

    ///取消按钮文字描述
    TextStyle cancelTextStyle,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return InputView(
          title: title,
          maxLines: maxLines,
          maxLength: maxLength,
          placeholder: placeholder,
          confirmAction: confirmAction,
          titleTextStyle: titleTextStyle,
          placeholderStyle: placeholderStyle,
          cancelText: cancelText,
          confirmText: confirmText,
          cancelAction: cancelAction,
          confirmTextStyle: confirmTextStyle,
          cancelTextStyle: cancelTextStyle,
        );
      },
    );
  }

  static showPopMenu(BuildContext context, {

    ///弹窗view位置上方所在widget的标识
    @required GlobalKey originKey,

    ///item数据源
    @required List<PopModel> itemsData,

    ///item点击选中时回调
    Function(int, PopModel) clickCallback,

    ///不展示小三角 默认展示
    bool noTriangle,

    ///弹窗背景色
    Color backgroundColor,

    ///默认选中的item标题
    String selectedText,

    ///item字体颜色
    Color itemTitleColor,

    ///item图标颜色
    Color itemIconColor,

    ///item选中时字体颜色
    Color itemSelectedColor,

    ///item高度 默认50
    double itemHeight,

    ///item宽度 默认120
    double itemWidth,

    ///item间隔线颜色
    Color dividerColor,

    ///小三角高度默认10
    double triangleHeight,

    ///小三角宽度 默认14
    double triangleWidth,

    bool isRight,

    ///列表弹窗最大高度，若设置最大高度则可滑动 否则高度自适应
    final double maxHeight,

    PopWindowType type,
    Gradient gradient,

  }) {
    showDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: false,
      builder: (context) {
        return PopupView(
          originKey: originKey,
          itemsData: itemsData,
          clickCallback: clickCallback,
          noTriangle: noTriangle,
          selText: selectedText,
          bgColor: backgroundColor,
          itemHeight: itemHeight,
          itemWidth: itemWidth,
          itemIconColor: itemIconColor,
          itemSelectedColor: itemSelectedColor,
          itemTitleColor: itemTitleColor,
          triangleWidth: triangleWidth,
          triangleHeight: triangleHeight,
          dividerColor: dividerColor,
          maxHeight: maxHeight,
          isRight: isRight,
          type: type,
          gradient: gradient,
        );
      },
    );
  }
}
