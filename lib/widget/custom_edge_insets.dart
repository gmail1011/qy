import 'package:flutter/cupertino.dart';
import 'package:flutter_base/utils/screen.dart';

class CustomEdgeInsets extends EdgeInsets {
  CustomEdgeInsets.all(double value) : super.all(screen.getWidth(value));

  CustomEdgeInsets.only({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) : super.only(
            left: screen.getWidth(left),
            top: screen.getHeight(top),
            right: screen.getWidth(right),
            bottom: screen.getHeight(bottom));

  CustomEdgeInsets.fromLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) : super.fromLTRB(screen.getWidth(left), screen.getHeight(top),
            screen.getWidth(right), screen.getHeight(bottom));
}
