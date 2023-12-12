import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_svg/svg.dart';

///配置svg处理
Widget svgAssets(
  String assetName, {
  Key key,
  bool matchTextDirection = false,
  AssetBundle bundle,
  String package,
  double width,
  double height,
  BoxFit fit = BoxFit.contain,
  Alignment alignment = Alignment.center,
  bool allowDrawingOutsideViewBox = false,
  WidgetBuilder placeholderBuilder,
  Color color,
  BlendMode colorBlendMode = BlendMode.srcIn,
  String semanticsLabel,
  bool excludeFromSemantics = false,
}) {
  if (assetName == null || assetName.isEmpty) {
    assert(false);
    assetName = AssetsSvg.ICON_SEND_COMMENT;
  }
  return SvgPicture.asset(
    assetName,
    key: key,
    matchTextDirection: matchTextDirection,
    bundle: bundle,
    package: package,
    width: width,
    height: height,
    fit: fit,
    alignment: alignment,
    allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
    placeholderBuilder: placeholderBuilder,
    color: color,
    colorBlendMode: colorBlendMode,
    semanticsLabel: semanticsLabel,
    excludeFromSemantics: excludeFromSemantics,
  );
}

///网络图片svg
Widget svgNetwork(String url) {
  if (url == null || url.isEmpty) {
    return Container();
  }
  return SvgPicture.network(url);
}
