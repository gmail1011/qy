import 'package:flutter/material.dart';

/// create by 张风捷特烈 on 2020/9/3
/// contact me by email 1981462002@qq.com
/// 说明:

class WrapColor extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radius;
  final EdgeInsetsGeometry padding;

  WrapColor(
      {this.child,
      this.color,
      this.radius = 5,
      this.padding =
          const EdgeInsets.only(left: 4, right: 4, top: 0, bottom: 0)});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: child,
      padding: padding,
      decoration: BoxDecoration(
          color: color??Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(radius))),
    );
  }
}

class Circled extends StatelessWidget {
  final Widget child;
  final Color color;
  final double radius;

  Circled({this.child, this.color = Colors.white, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
     // width: radius * 2,
     // height: radius * 2,
      width: 40,
      height: 40,
      child: child,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              //阴影
              color: Colors.grey.withOpacity(0.3),
              offset: Offset(0.0, 0.0), blurRadius: 3.0, spreadRadius: 0.0,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(radius))),
    );
  }
}
