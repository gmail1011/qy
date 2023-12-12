import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class TikTokLikeAnimItem extends StatefulWidget {
  final Offset position;
  final double size;
  final Function onAnimationComplete;

  const TikTokLikeAnimItem({
    Key key,
    this.onAnimationComplete,
    this.position,
    this.size: 100,
  }) : super(key: key);

  @override
  _TikTokLikeAnimItemState createState() => _TikTokLikeAnimItemState();
}

class _TikTokLikeAnimItemState extends State<TikTokLikeAnimItem>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  SequenceAnimation sequenceAnimation;
  //0-500 显示 500-1000  消失
  double rotate;
  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    rotate = pi / 10.0 * (2 * Random().nextDouble() - 1);
    _animationController = new AnimationController(vsync: this);
    _animationController.addListener(() {
      setState(() {});
    });
    Cubic inDec = Curves.easeInToLinear;
    Cubic outDec = Curves.linearToEaseOut;
    Duration showTime = Duration(milliseconds: 500);
    Duration dismissTime = Duration(milliseconds: 1000);
    var startHeight = Dimens.pt20;
    var height = Dimens.pt80;
    sequenceAnimation = new SequenceAnimationBuilder()
        .addAnimatable(
            animatable: new Tween<double>(begin: 0.1, end: 1.0),
            from: Duration.zero,
            to: showTime,
            curve: inDec,
            tag: "opacity")
        .addAnimatable(
            animatable: new Tween<double>(begin: 0.1, end: 1.0),
            from: Duration.zero,
            to: showTime,
            curve: inDec,
            tag: "scale")
        .addAnimatable(
            animatable: new EdgeInsetsTween(
              begin: EdgeInsets.only(bottom: startHeight),
              end: EdgeInsets.only(bottom: startHeight + height),
            ),
            from: Duration.zero,
            to: showTime,
            curve: inDec,
            tag: "padding")
        // 消失动画
        .addAnimatable(
            animatable: new Tween<double>(begin: 1.0, end: 0.0),
            from: showTime,
            to: dismissTime,
            curve: outDec,
            tag: "opacity")
        .addAnimatable(
            animatable: new Tween<double>(begin: 1.0, end: 2.0),
            from: showTime,
            to: dismissTime,
            curve: outDec,
            tag: "scale")
        .addAnimatable(
            animatable: new EdgeInsetsTween(
              begin: EdgeInsets.only(bottom: startHeight + height),
              end: EdgeInsets.only(bottom: startHeight + 2 * height),
            ),
            from: showTime,
            to: dismissTime,
            curve: outDec,
            tag: "padding")

        // .addAnimatable(
        //     animatable: new EdgeInsetsTween(
        //       begin: const EdgeInsets.only(bottom: 16.0),
        //       end: const EdgeInsets.only(bottom: 75.0),
        //     ),
        //     from: const Duration(milliseconds: 500),
        //     to: const Duration(milliseconds: 750),
        //     curve: Curves.ease,
        //     tag: "padding")
        // .addAnimatable(
        //     animatable: new ColorTween(
        //       begin: Colors.indigo[100],
        //       end: Colors.orange[400],
        //     ),
        //     from: const Duration(milliseconds: 1000),
        //     to: const Duration(milliseconds: 1500),
        //     curve: Curves.ease,
        //     tag: "color")
        .animate(_animationController);
    _playAnimation();
    super.initState();
  }

  Future<Null> _playAnimation() async {
    try {
      await _animationController.forward().orCancel;
      // print("end anim:${widget.position} hash:${widget.hashCode}");
      // await controller.reverse().orCancel;
      widget.onAnimationComplete?.call();
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      padding: sequenceAnimation["padding"].value,
      alignment: Alignment.bottomCenter,
      child: new Opacity(
        // 透明度
        opacity: sequenceAnimation["opacity"].value,
        child: Transform.scale(
          alignment: Alignment.bottomCenter,
          scale: sequenceAnimation["scale"].value,
          child: child,
        ),
      ),
    );
  }

  Widget _buildLikeIcon() {
    Widget content = Transform.rotate(
        angle: rotate,
        child: ShaderMask(
          child: Icon(
            Icons.favorite,
            // size: widget.size,
            size: 100,
            color: Color(0xffff5488),
          ),
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) => RadialGradient(
            center: Alignment.topLeft.add(Alignment(0.66, 0.66)),
            colors: [
              Color(0xffFF6FAF),
              Color(0xffFF3F70),
            ],
          ).createShader(bounds),
        ));
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return widget.position == null
        ? Container()
        : Positioned(
            left: widget.position.dx - widget.size / 2,
            top: widget.position.dy - widget.size / 2,
            child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, widget) =>
                    _buildAnimation(context, _buildLikeIcon())),
          );
  }
}
