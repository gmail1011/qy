import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/new_page/mine/mine_account_profile_page.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:r_scan/r_scan.dart';

List<RScanCameraDescription> rScanCameras;

// double scanViewW =
class RScanCameraDialog extends StatefulWidget {
  @override
  _RScanCameraDialogState createState() => _RScanCameraDialogState();
}

class _RScanCameraDialogState extends State<RScanCameraDialog> {
  RScanCameraController _controller;
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    _initRScan();
  }

  void _initRScan() async {
    if (rScanCameras != null && rScanCameras.length > 0) {
      _controller = RScanCameraController(rScanCameras[0], RScanCameraResolutionPreset.max)
        ..addListener(() {
          final result = _controller.result;
          if (result != null) {
            if (isFirst) {
              safePopPage(result);
              isFirst = false;
            }
          }
        })
        ..initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (rScanCameras == null || rScanCameras.length == 0) {
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          alignment: Alignment.center,
          child: Text('not have available camera'),
        ),
      );
    }
    if (!_controller.value.isInitialized) {
      return Container();
    }
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ScanImageView(
            child: AspectRatio(
              aspectRatio: width / height,
              child: RScanCamera(_controller),
            ),
          ),
          Positioned(
            top: screen.paddingTop,
            left: 0,
            right: 0,
            child: Stack(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              alignment: AlignmentDirectional.centerStart,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    safePopPage();
                  },
                ),
                Center(
                  child: Text(
                    Lang.SCAN_LOGIN,
                    style: TextStyle(color: Colors.white, fontSize: Dimens.pt18),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: screen.paddingBottom + 40,
            left: 60,
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  svgAssets(
                    AssetsSvg.USER_IC_USER_SCAN_XC,
                    width: Dimens.pt30,
                    height: Dimens.pt30,
                  ),
                  Container(
                      margin: CustomEdgeInsets.only(top: 9),
                      child: Text(
                        Lang.PHOTO_ALBUM,
                        style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
                      )),
                  Container(
                    margin: CustomEdgeInsets.only(top: 12),
                    child: Text(
                      '',
                      style: TextStyle(color: Colors.white, fontSize: Dimens.pt12),
                    ),
                  ),
                ],
              ),
              onTap: () async {
                if (await canReadStorage()) {
                  var image = await ImagePickers.pickerPaths(
                    uiConfig: UIConfig(uiThemeColor: AppColors.primaryColor),
                    selectCount: 1,
                    showCamera: false,
                    cropConfig: CropConfig(enableCrop: true),
                  );
                  if (image != null) {
                    final result = await RScan.scanImagePath(image[0].path);
                    safePopPage(result);
                  }
                }
              },
            ),
          ),
          Positioned(
              bottom: screen.paddingBottom + 40,
              right: 60,
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    svgAssets(
                      AssetsSvg.USER_IC_USER_SCAN_PZ,
                      width: Dimens.pt30,
                      height: Dimens.pt30,
                    ),
                    Container(
                        margin: CustomEdgeInsets.only(top: 9),
                        child: Text(
                          Lang.MY_VOUCHER,
                          style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
                        )),
                    Container(
                      margin: CustomEdgeInsets.only(top: 12),
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.white, fontSize: Dimens.pt12),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return MineAccountProfilePage();
                  }));
                },
              ))
        ],
      ),
    );
  }

  Future<bool> canReadStorage() async {
    if (Platform.isIOS) return true;
    var status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<bool> getFlashMode() async {
    bool isOpen = false;
    try {
      isOpen = await _controller.getFlashMode();
    } catch (_) {}
    return isOpen;
  }

  Widget buildFlashBtn(BuildContext context, AsyncSnapshot<bool> snapshot) {
    return snapshot.hasData
        ? Padding(
            padding: EdgeInsets.only(bottom: 24 + MediaQuery.of(context).padding.bottom),
            child: IconButton(
                icon: Icon(snapshot.data ? Icons.flash_on : Icons.flash_off),
                color: Colors.white,
                iconSize: 46,
                onPressed: () {
                  if (snapshot.data) {
                    _controller.setFlashMode(false);
                  } else {
                    _controller.setFlashMode(true);
                  }
                  setState(() {});
                }),
          )
        : Container();
  }
}

class ScanImageView extends StatefulWidget {
  final Widget child;

  const ScanImageView({Key key, this.child}) : super(key: key);

  @override
  _ScanImageViewState createState() => _ScanImageViewState();
}

class _ScanImageViewState extends State<ScanImageView> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) => CustomPaint(
              foregroundPainter: _ScanPainter(controller.value, Colors.white, Colors.green),
              child: widget.child,
              willChange: true,
            ));
  }
}

class _ScanPainter extends CustomPainter {
  final double value;
  final Color borderColor;
  final Color scanColor;

  _ScanPainter(this.value, this.borderColor, this.scanColor);

  Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    if (_paint == null) {
      initPaint();
    }
    // canvas.drawColor(Color(0xFF000000), BlendMode.dst);
    double width = size.width;
    double height = size.height;

    double boxWidth = size.width * 2 / 3;
    double boxHeight = boxWidth;

    double left = (width - boxWidth) / 2;
    double top = (height - boxHeight) / 3;
    double bottom = boxHeight + top;
    double right = left + boxWidth;
    _paint.color = borderColor;
    // final rect = Rect.fromLTWH(left, top, boxWidth, boxHeight);
    // canvas.drawRect(rect, _paint);

    _paint.strokeWidth = 3;
    double linew = 20;
    Path path1 = Path()
      ..moveTo(left, top + linew)
      ..lineTo(left, top)
      ..lineTo(left + linew, top);
    canvas.drawPath(path1, _paint);
    Path path2 = Path()
      ..moveTo(left, bottom - linew)
      ..lineTo(left, bottom)
      ..lineTo(left + linew, bottom);
    canvas.drawPath(path2, _paint);
    Path path3 = Path()
      ..moveTo(right, bottom - linew)
      ..lineTo(right, bottom)
      ..lineTo(right - linew, bottom);
    canvas.drawPath(path3, _paint);
    Path path4 = Path()
      ..moveTo(right, top + linew)
      ..lineTo(right, top)
      ..lineTo(right - linew, top);
    canvas.drawPath(path4, _paint);

    _paint.color = scanColor;
    // _paint.strokeWidth = 1;

    final scanRect = Rect.fromLTWH(left + 30, top + 10 + (value * (boxHeight - 60)), boxWidth - 60, 1);

    _paint.shader = LinearGradient(colors: <Color>[
      Colors.white10,
      Colors.white,
      Colors.white10,
    ], stops: [
      0.0,
      0.5,
      1,
    ]).createShader(scanRect);

    canvas.drawRect(scanRect, _paint);
    ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center,
      fontWeight: FontWeight.w300,
      fontStyle: FontStyle.normal,
      fontSize: 15.0,
    ));
    pb.pushStyle(ui.TextStyle(color: Colors.white));
    pb.addText("对准二维码，即可自动识别");

// 设置文本的宽度约束
    ParagraphConstraints pc = ParagraphConstraints(width: 200);
// 这里需要先layout,将宽度约束填入，否则无法绘制
    Paragraph paragraph = pb.build()..layout(pc);
    // print(paragraph.width);
    Offset offset = Offset((size.width - paragraph.width) / 2, boxHeight + top + 30);
    _paint.color = Color(0xFFededed);
    canvas.drawParagraph(paragraph, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  void initPaint() {
    _paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }
}
