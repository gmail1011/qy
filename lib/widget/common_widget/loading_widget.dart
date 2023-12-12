import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/flare.dart';
import 'package:flutter_base/flutter_base.dart';

///加载中动画效果,默认
class LoadingWidget extends StatelessWidget {
  final double width;

  final double height;

  final Color color;

   LoadingWidget(
      {this.width = 40,
      this.height = 20,
      this.color,});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        color: color ?? Colors.transparent,
        child: FlareActor(
          AssetsFlare.LOADING,
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: "loading",
        ),
      ),
    );
  }
}
