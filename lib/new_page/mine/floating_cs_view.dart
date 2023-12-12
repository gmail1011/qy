import 'package:flutter/material.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_base/utils/screen.dart';

class FloatingCSView extends StatefulWidget {
  final Function tapCallBack;

  const FloatingCSView({
    Key key,
    this.tapCallBack,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FloatingCSViewState();
  }
}

class _FloatingCSViewState extends State<FloatingCSView> {
  final _floatingGlobalKey = GlobalKey();
  double _bottom = 16;
  double _right = 0;
  double _width;

  double get _adSize => 96;

  double get width {
    if (_width == null) {
      var renderBox = _floatingGlobalKey.currentContext.findRenderObject() as RenderBox;
      _width = renderBox?.size?.width ?? MediaQuery.of(context).size.width;
      _height = renderBox?.size?.height ?? MediaQuery.of(context).size.height;
    }
    return _width;
  }

  double _height;

  double get height {
    if (_height == null) {
      var renderBox = _floatingGlobalKey.currentContext?.findRenderObject() as RenderBox;
      _width = renderBox?.size?.width ?? MediaQuery.of(context).size.width;
      _height = renderBox?.size?.height ?? MediaQuery.of(context).size.height;
    }
    return _height;
  }

  @override
  void initState() {
    super.initState();
    // _right = screen.screenWidth - _adSize - 16;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadAdData();
    });
  }

  void _loadAdData() async {
    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _right -= details.delta.dx;
    _bottom -= details.delta.dy;
    if (_right > width - _adSize) {
      _right = width - _adSize;
    }
    if (_right < 0) _right = 0;
    if (_bottom > height - _adSize) {
      _bottom = height - _adSize;
    }
    if (_bottom < 0) _bottom = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _floatingGlobalKey,
      child: Stack(
        children: [
          Positioned(
            bottom: _bottom,
            right: _right,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 36,
                width: _adSize,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapUp: (details) async {
                    if (widget.tapCallBack != null) {
                      widget.tapCallBack.call();
                    } else {
                      await csManager.openServices(context);
                    }
                  },
                  onPanUpdate: (DragUpdateDetails details) {
                    _onPanUpdate(details);
                  },
                  child: Image.asset(
                    "assets/images/hjll_mine_help_icon.png",
                    width: _adSize,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
