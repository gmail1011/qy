import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../widget/gesture_zoom_box.dart';

class AiNewImageView extends StatefulWidget {
  final List<String> imageUrls;

  const AiNewImageView({Key key, this.imageUrls}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AiNewImageViewState();
  }
}

class _AiNewImageViewState extends State<AiNewImageView> {
  SwiperController _controller;
  int selectIndex = 0;
  bool _limitChange = false; //是否禁止滑动
  List<GlobalKey> _globalKeys = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.imageUrls.length; i++) {
      _globalKeys.add(GlobalKey());
    }
  }

  void _saveEvent() async {
    Future.delayed(Duration(milliseconds: 20), () async {
      RenderRepaintBoundary boundary =
          _globalKeys[selectIndex].currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      bool suc = await savePngDataToAblumn(byteData.buffer.asUint8List());
      if (suc) {
        //showToast(msg: Lang.SAVE_PHOTO_ALBUM);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double moduleW = screen.screenWidth;
    double moduleH = screen.screenHeight;

    var wd = Swiper(
      index: selectIndex,
      controller: _controller,
      loop: false,
      physics: widget.imageUrls?.length == 1 || _limitChange
          ? NeverScrollableScrollPhysics()
          : ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        var cover = widget.imageUrls[index];
        return RepaintBoundary(
          key: _globalKeys[index],
          child: Container(
            width: screen.screenWidth,
            child: GestureZoomBox(
              onPressed: () => safePopPage(),
              maxScale: 5.0,
              doubleTapScale: 2.0,
              limitCallback: (limit) {
                setState(() {
                  _limitChange = limit;
                });
              },
              child: CustomNetworkImage(
                fit: BoxFit.contain,
                width: moduleW,
                height: moduleH,
                type: ImgType.cover,
                fullImg: true,
                placeholder: Center(
                  child: Container(
                    padding: EdgeInsets.all(Dimens.pt10),
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: CupertinoActivityIndicator(),
                  ),
                ),
                imageUrl: cover,
              ),
            ),
          ),
        );
      },
      onIndexChanged: (int index) {
        setState(() {
          selectIndex = index;
        });
      },
      itemCount: widget.imageUrls.length,
    );
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Container(
        width: moduleW,
        height: moduleH,
        child: Stack(
          children: <Widget>[
            wd,
            Positioned(
              bottom: Dimens.pt12,
              right: Dimens.pt16,
              child: Text(
                "${selectIndex + 1}/${widget.imageUrls.length ?? 0}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.pt12,
                  decoration: TextDecoration.none,
                ),
              ),
              /* CIndicator(
              itemCount: widget.models.length,
              selectIndex: selectIndex,
            ),*/
            ),
            Positioned(
              left: 16,
              top: 16,
              child: InkWell(
                onTap: () => safePopPage(),
                child: Image.asset(
                  "assets/images/alert_white_close.png",
                  height: 28,
                  width: 28,
                ),
              ),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: InkWell(
                onTap: () {
                  _saveEvent();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: AppColors.linearBackGround,
                  ),
                  child: Text(
                    "保存到相册",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
