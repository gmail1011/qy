import 'package:flutter/material.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

/// 网络 图片 轮播
class NetImageCycleWidget extends StatefulWidget {
  final List<String> models;

  final double width;

  final double height;

  final int autoPlayDuration;

  final ValueChanged<int> indexClick;

  final ValueChanged<int> onIndexChanged;

  NetImageCycleWidget(this.models,
      {Key key,
      this.width,
      this.height,
      this.autoPlayDuration = 0,
      this.indexClick,
      this.onIndexChanged})
      : super(key: key);

  @override
  _NetImageCycleWidgetState createState() => new _NetImageCycleWidgetState();
}

class _NetImageCycleWidgetState extends State<NetImageCycleWidget> {
  SwiperController _controller;
  int selectIndex;

  @override
  void initState() {
    selectIndex = 0;
    _controller = SwiperController();
    if (widget.models.length > 1 && widget.autoPlayDuration != 0) {
      _controller.startAutoplay();
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    double moduleW = widget.width;
    double moduleH = widget.height;

    var wd = Swiper(
      index: selectIndex,
      controller: _controller,
      autoplayDelay:
          widget.autoPlayDuration == 0 ? 3000 : widget.autoPlayDuration,
      itemBuilder: (BuildContext context, int index) {
        var cover = widget.models[index];
        return GestureDetector(
            child: Container(
              width: screen.screenWidth,
              child: AspectRatio(
                aspectRatio: (widget.width ?? 360) / (widget.height ?? 250),
                child: CustomNetworkImage(
                  fit: BoxFit.cover,
                  placeholder: Container(
                    color: Color(0x0),
                  ),
                  imageUrl: cover,
                ),
              ),
            ),
            onTap: () {
              if (widget.indexClick != null) {
                widget.indexClick(index);
              }
            });
      },
      onIndexChanged: (int index) {
        if (widget.onIndexChanged != null) {
          widget.onIndexChanged(index);
        }
        setState(() {
          selectIndex = index;
        });
      },
      itemCount: widget.models.length,
    );
    return Container(
      width: moduleW,
      height: moduleH,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          wd,
          Positioned(
            bottom: Dimens.pt10,
            // right: Dimens.pt10,
            child: CIndicator(
              itemCount: widget.models.length,
              selectIndex: selectIndex,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// 分页指示器
class CIndicator extends StatefulWidget {
  CIndicator(
      {Key key,
      this.itemCount,
      this.selectIndex,
      this.space = 5.0,
      this.callBack})
      : super(key: key);

  ///
  final int itemCount;
  final int selectIndex;
  final double space;
  final Function(int) callBack;

  @override
  _CIndicatorState createState() => new _CIndicatorState();
}

class _CIndicatorState extends State<CIndicator> {
  @override
  void initState() {
    super.initState();
  }

  Widget _getBall(int index) {
    var normalBall = Padding(
      padding: EdgeInsets.only(left: widget.space),
      child: ClipOval(
        child: Container(
          width: 5,
          height: 5,
          color: Colors.white,
        ),
      ),
    );
    var selectBall = Padding(
        padding: EdgeInsets.only(left: widget.space),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            width: 15,
            height: 5,
            //        color: Color(0xFFFBD120),
            color: Colors.yellow,
          ),
        ));
    return (widget.selectIndex == index) ? selectBall : normalBall;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < widget.itemCount; ++i) {
      list.add(_getBall(i));
    }
    var wd = Container(
      child: Row(
        children: list,
      ),
    );
    return wd;
  }
}
