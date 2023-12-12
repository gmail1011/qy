
import 'package:flutter/material.dart';

/// 头像圆边框
class AvatarCirclePainter extends CustomPainter {
  final double radius;
  final double strokeWidth;
  final Color color;
  AvatarCirclePainter(this.radius, this.strokeWidth, {
    this.color = Colors.white
  });
  @override
  void paint(Canvas canvas, Size size) {
    var center = size.width * 0.5;
    // 绘制代码
    final Offset offsetCenter = Offset(center, center);
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(offsetCenter, radius, ringPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}