import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';

import '../../chat_core/time_tool/date_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

//获取当前消息发送时间
String showMsgTime(var time) {
  if (time.toString().length < 13) {
    int a = int.parse(time.toString() + "000");
    time = a;
  } else {
    int a = int.parse(time.toString());
    time = a;
  }
  String t = DateUtil.formatDateMs(time, format: DataFormats.h_m, isUtc: false);
  return t;
}

String showAllTime(var time) {
  if (time.toString().length < 13) {
    int a = int.parse(time.toString() + "000");
    time = a;
  } else {
    int a = int.parse(time.toString());
    time = a;
  }
  String t =
      DateUtil.formatDateMs(time, format: DataFormats.y_mo_d_h_m, isUtc: false);
  return t;
}

//获取当前时间  年/月/日 时/分
String currentTime() {
  String t = DateUtil.formatDateMs(DateTime.now().millisecondsSinceEpoch,
      format: DataFormats.y_mo_d_h_m, isUtc: false);
  return t;
}

Map<String, dynamic> getInfoData(
  username,
  String baseUrl,
  int userId,
  String avatar,
  String connectUrl,
) {
  Map<String, dynamic> map = Map();
  map['username'] = username ?? '';
  map['baseUrl'] = baseUrl ?? '';
  map['userId'] = userId ?? 0;
  map['avatar'] = avatar ?? '';
  map['connectUrl'] = connectUrl ?? '';
  return map;
}

//图片展示  自带展位图位图
class PlaceHolderImgWidget extends StatelessWidget {
  final String url;
  final Map<String, bool> indicatorState;
  final String name;
  PlaceHolderImgWidget(this.url, {this.indicatorState, this.name});
  @override
  Widget build(BuildContext context) {
    if (url != null && url.length > 0) {
      if (url.contains('http')) {
        return CachedNetworkImage(
            imageUrl: url ?? '',
            placeholder: (context, url) =>
                CupertinoActivityIndicator()); //Image.network(url, fit: BoxFit.cover);
      }
      return Image(
          gaplessPlayback: true,
          fit: BoxFit.cover,
          image: MemoryImage(base64.decode(url ?? '')),
          loadingBuilder: (indicatorState != null) && indicatorState[name]
              ? (context, widget, event) => CupertinoActivityIndicator()
              : null);
    } else {
      return SvgPicture.asset(
        'assets/svg/default_service.svg',
        package: 'chat_online_customers',
        width: 60,
        height: 60,
      );
    }
  }
}

//禁言的弹框
typedef BackBlock = Future Function();
//禁言
YYDialog YYDialogDontTalk(BuildContext context, String content) {
  return YYDialog().build(context)
    ..width = MediaQuery.of(context).size.width - 120
    ..barrierColor = Colors.black.withOpacity(.3)
    ..animatedFunc = (child, animation) {
      return ScaleTransition(
        child: child,
        scale: Tween(begin: 0.0, end: 1.0).animate(animation),
      );
    }
    ..widget(Padding(
      padding: EdgeInsets.all(0.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 45,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '禁言提示',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Center(child: Text(content)),
                ),
              ]),
        ),
      ),
    ))
    ..doubleButton(
      padding: EdgeInsets.only(bottom: 10.0),
      gravity: Gravity.center,
      withDivider: true,
      text1: "取消",
      color1: Colors.black87,
      fontSize1: 14.0,
      fontWeight1: FontWeight.bold,
      onTap1: () {
        print("取消");
      },
      text2: "退出",
      color2: Colors.black87,
      fontSize2: 14.0,
      fontWeight2: FontWeight.bold,
      onTap2: () {
        print("退出");
        Navigator.pop(context);
      },
    )
    ..borderRadius = 4.0
    ..show();
}

final Uint8List kTransparentImage = new Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
]);

class GuideUserActionLocation extends FloatingActionButtonLocation {
  double marginRight = 20;
  double marginBottom = 100;
  GuideUserActionLocation._();

  static GuideUserActionLocation _instance;

  static GuideUserActionLocation getInstance() {
    if (_instance == null) {
      _instance = GuideUserActionLocation._();
    }
    return _instance;
  }

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    // Compute the x-axis offset.
    final double fabX = _endOffset(scaffoldGeometry);

    // Compute the y-axis offset.
    final double contentBottom = scaffoldGeometry.contentBottom;
    final double bottomSheetHeight = scaffoldGeometry.bottomSheetSize.height;
    final double fabHeight = scaffoldGeometry.floatingActionButtonSize.height;
    final double snackBarHeight = scaffoldGeometry.snackBarSize.height;

    double fabY = contentBottom - fabHeight - marginBottom;
    if (snackBarHeight > 0.0)
      fabY = math.min(
          fabY,
          contentBottom -
              snackBarHeight -
              fabHeight -
              kFloatingActionButtonMargin);
    if (bottomSheetHeight > 0.0)
      fabY =
          math.min(fabY, contentBottom - bottomSheetHeight - fabHeight / 2.0);
    return Offset(fabX, fabY);
  }

  @override
  String toString() => 'TestActionLocation';

  double _endOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
      {double offset = 0.0}) {
    assert(scaffoldGeometry.textDirection != null);
    switch (scaffoldGeometry.textDirection) {
      case TextDirection.rtl:
        return _leftOffset(scaffoldGeometry, offset: offset);
      case TextDirection.ltr:
        return _rightOffset(scaffoldGeometry, offset: offset);
    }
    return null;
  }

  double _leftOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
      {double offset = 0.0}) {
    return kFloatingActionButtonMargin +
        scaffoldGeometry.minInsets.left -
        offset;
  }

  double _rightOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
      {double offset = 0.0}) {
    return scaffoldGeometry.scaffoldSize.width -
        scaffoldGeometry.floatingActionButtonSize.width -
        marginRight;
  }
}
