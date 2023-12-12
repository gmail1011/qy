import 'package:flutter/material.dart';
import './model.dart';
import 'dot_painter.dart';
import 'circle_painter.dart';

class LoveController extends ValueNotifier<bool> {
  LoveController(value) : super(value);
}

class LoveButton extends StatefulWidget {
  final double imgWidth;
  final double imgHeight;
  final double cWidth;
  final double cHeight;
  final Widget imageTrue;
  final Widget imageFalse;
  final Duration duration;
  final DotColor dotColor;
  final Color circleStartColor;
  final Color circleEndColor;
  final VoidCallback onIconClicked;
  final VoidCallback onIconCompleted;
  final LoveController loveController;
  final bool enable;

  const LoveButton({
    Key key,
    @required this.imgWidth,
    @required this.imgHeight,
    @required this.cWidth,
    @required this.cHeight,
    this.imageTrue,
    this.imageFalse,
    this.duration = const Duration(milliseconds: 5000),
    this.dotColor = const DotColor(
      dotPrimaryColor: const Color(0xFFFFC107),
      dotSecondaryColor: const Color(0xFFFF9800),
      dotThirdColor: const Color(0xFFFF5722),
      dotLastColor: const Color(0xFFF44336),
    ),
    this.circleStartColor = const Color(0xFFFF5722),
    this.circleEndColor = const Color(0xFFFFC107),
    this.onIconClicked,
    this.onIconCompleted,
    @required this.loveController,
    this.enable = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoveButtonState();
}

class _LoveButtonState extends State<LoveButton> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> outerCircle;
  Animation<double> innerCircle;
  Animation<double> scale;
  Animation<double> dots;

  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.loveController.value;
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          widget.onIconCompleted.call();
        }
      });
    _initAllAnimation();

    widget.loveController.addListener(_handleValueChanged);
  }

  void _handleValueChanged() {
    setState(() {
      var newLike = widget.loveController.value;
      if (newLike && !isLiked) {
        if (_controller.isAnimating) return;
        setState(() {
          isLiked = true;
        });

        if (isLiked) {
          _controller.reset();
          _controller.forward();
        }
      } else {
        setState(() {
          isLiked = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant LoveButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loveController != widget.loveController) {
      // print(
      //     "LoveButton .........didUpdateWidget()....=========>old:${oldWidget.loveController.value} new:${widget.loveController.value}");
      oldWidget.loveController.removeListener(_handleValueChanged);
      widget.loveController.addListener(_handleValueChanged);
      if (oldWidget.loveController.value != widget.loveController.value) {
        _handleValueChanged();
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    widget.loveController.removeListener(_handleValueChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var myScale =
        isLiked ? (!_controller.isAnimating ? 1.0 : scale.value) : 1.0;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CustomPaint(
          size: Size(widget.cWidth, widget.cHeight),
          painter: DotPainter(
            currentProgress: dots.value,
            color1: widget.dotColor.dotPrimaryColor,
            color2: widget.dotColor.dotSecondaryColor,
            color3: widget.dotColor.dotThirdColorReal,
            color4: widget.dotColor.dotLastColorReal,
          ),
        ),
        CustomPaint(
          size: Size(widget.imgWidth, widget.imgHeight),
          painter: CirclePainter(
              innerCircleRadiusProgress: innerCircle.value,
              outerCircleRadiusProgress: outerCircle.value,
              startColor: widget.circleStartColor,
              endColor: widget.circleEndColor),
        ),
        Container(
          width: widget.imgWidth,
          height: widget.imgHeight,
          alignment: Alignment.center,
          child: Transform.scale(
            scale: myScale,
            child: GestureDetector(
              child: isLiked ? widget.imageTrue : widget.imageFalse,
              onTap: _onTap,
            ),
          ),
        ),
      ],
    );
  }

  void _onTap() async {
    if (!widget.enable) return;
    if (_controller.isAnimating) return;
    // setState(() {
    //   isLiked = !isLiked;
    // });
    // if (isLiked) {
    //   _controller.reset();
    //   await _controller.forward();
    // }
    if (widget.onIconClicked != null) widget.onIconClicked();
  }

  void _initAllAnimation() {
    outerCircle = new Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.0,
          0.3,
          curve: Curves.ease,
        ),
      ),
    );
    innerCircle = new Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.2,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );
    scale = new Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.35,
          0.7,
          curve: OvershootCurve(),
        ),
      ),
    );
    dots = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.1,
          1.0,
          curve: Curves.decelerate,
        ),
      ),
    );
  }
}
