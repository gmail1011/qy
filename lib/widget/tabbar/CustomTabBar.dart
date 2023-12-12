import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class CustomTabBar extends StatefulWidget {
  CustomTabBar({
    Key key,
    @required this.tabs,
    @required this.imagePath,
    @required this.controller,
    this.isScrollable,
    this.labelColor,
    this.labelStyle,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.labelPadding,
    this.physics,
  })  : assert(tabs != null),
        super(key: key);

  final List<Widget> tabs;
  final TabController controller;
  final String imagePath;
  final bool isScrollable;
  final Color labelColor;
  final TextStyle labelStyle;
  final Color unselectedLabelColor;
  final TextStyle unselectedLabelStyle;
  final EdgeInsetsGeometry labelPadding;
  final ScrollPhysics physics;
  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  ui.Image _image;

  Future<ui.Image> loadImage(String path) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  Widget build(BuildContext context) {
    loadImage(widget.imagePath).then(
      (value) {

        if(mounted){
          setState(
                () {
              _image = value;
            },
          );
        }

      },
    );

    return TabBar(
      tabs: widget.tabs,
      isScrollable: widget.isScrollable ??  true,
      controller: widget.controller,
      indicator: ImageTabIndicator(image: _image),
      labelColor: widget.labelColor,
      labelStyle: widget.labelStyle,
      unselectedLabelColor: widget.unselectedLabelColor,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      labelPadding: widget.labelPadding,
        physics:widget.physics,
    );
  }
}

class ImageTabIndicator extends Decoration {
  final BoxPainter _painter;

  ImageTabIndicator({double radius = 10, @required ui.Image image})
      : _painter = _ImagePainter(radius, image);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _ImagePainter extends BoxPainter {
  final Paint _paint;
  final double radius;
  final ui.Image image;

  _ImagePainter(this.radius, this.image)
      : _paint = Paint()
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    if (image != null) {
      final Offset imageOffset = offset +
          Offset(cfg.size.width / 2, cfg.size.height / 2 + image.height + 2);
      paintImage(
          canvas: canvas,
          rect: Rect.fromCircle(center: imageOffset, radius: radius),
          image: image,
          fit: BoxFit.fitWidth);
    }
  }
}
