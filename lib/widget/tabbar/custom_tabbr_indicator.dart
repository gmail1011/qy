import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';

/// 修改下划线自定义
class CustomTabBarIndicator extends Decoration {
  final TabController tabController;
  final double indicatorBottom; // 调整指示器下边距
  final double indicatorWidth; // 指示器宽度
  final EdgeInsets insets;

  const CustomTabBarIndicator({
    // 设置下标高度、颜色
    this.borderSide = const BorderSide(width: 3.0, color: Colors.white),
    this.tabController,
    this.indicatorBottom = 0.0,
    this.indicatorWidth = 18,
    this.insets = EdgeInsets.zero,
  });

  /// The color and weight of the horizontal line drawn below the selected tab.
  final BorderSide borderSide;

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _UnderlinePainter(this, onChanged);
  }

  ///决议操控器宽度的办法
  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    assert(rect != null);
    assert(textDirection != null);
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    // 期望的宽度
    double wantWidth = this.indicatorWidth;
    // 取中心坐标
    double cw = (indicator.left + indicator.right) / 2;
    //这里是中心代码
    //下划线靠左
    // return Rect.fromLTWH(indicator.left,
    //     indicator.bottom - borderSide.width, wantWidth, borderSide.width);
    //下划线居中
    return Rect.fromLTWH(
        cw - wantWidth / 2, indicator.bottom - borderSide.width - 5, wantWidth, borderSide.width);
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  final CustomTabBarIndicator decoration;

  ///决议操控器边角形状的办法
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size;
    final TextDirection textDirection = configuration.textDirection;
    //调用 decoration._indicatorRectFor(rect, textDirection) 办法计算出指示器的方位和尺度，
    //并运用 deflate 办法缩小矩形的大小，以便将边框的一半包含在矩形内。
    final Rect indicator =
        decoration._indicatorRectFor(rect, textDirection).deflate(decoration.borderSide.width / 2.0);
    final gradient = AppColors.linearBackGround;
    final Paint paint = decoration.borderSide.toPaint()
      ..shader = gradient.createShader(indicator)
      ..strokeCap = StrokeCap.round; //这块更改为想要的形状
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
