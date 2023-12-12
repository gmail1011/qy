import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_base/flutter_base.dart';

/// 自己定义的通用背景
class FullBg extends StatelessWidget {
  final Widget child;

  const FullBg({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: AppColors.primaryColor,
        child: Container(
            width: screen.screenWidth,
            height: screen.screenHeight,
            decoration: BoxDecoration(color: AppColors.primaryColor),
            child: child));
  }
}
