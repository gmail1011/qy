import 'package:flutter/cupertino.dart';
import 'package:flutter_base/utils/log.dart';

Widget assetsImg(
  String name, {
  double width,
  double height,
  Color color,
  BoxFit fit,
  double scale,
}) {
  if (name == null || name.isEmpty) {
    l.d("oldLog", "空图片了");
  }
  assert(name != null && name.isNotEmpty);
  return Image.asset(
    name,
    width: width,
    height: height,
    color: color,
    fit: fit,
    scale: 1.0,
    filterQuality: FilterQuality.low,
  );
}
