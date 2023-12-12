import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

/// 轮播
class CommonBannerWidget extends StatefulWidget {
  final List<String> imageUrl;

  final double width;

  final double height;

  final ValueChanged<int> onItemClick;

  final int autoPlayDuration;

  final BoxFit fit;

  final double radius;

  CommonBannerWidget(this.imageUrl,
      {Key key,
      this.width,
      this.height,
      this.fit,
      this.autoPlayDuration = 3000,
      this.radius,
      this.onItemClick})
      : super(key: key);

  @override
  _CommonBannerWidgetState createState() => new _CommonBannerWidgetState();
}

class _CommonBannerWidgetState extends State<CommonBannerWidget> {
  int selectIndex;

  @override
  void initState() {
    selectIndex = 0;

    super.initState();
  }

  Widget build(BuildContext context) {
    double moduleW = widget.width;
    double moduleH = widget.height;

    return Container(
      width: moduleW,
      height: moduleH,
      child: Stack(
        children: <Widget>[
          Swiper(
            index: selectIndex,
            autoplay: ((widget.imageUrl?.length ?? 0) > 1),
            autoplayDelay: widget.autoPlayDuration,
            loop: widget.imageUrl?.length == 1 ? false : true,
            itemBuilder: (BuildContext context, int index) {
              var cover = widget.imageUrl[index];
              return CustomNetworkImage(
                fit: widget.fit ?? BoxFit.fill,
                height: moduleH,
                imageUrl: cover,
                borderRadius: widget.radius,
              );
            },
            onTap: widget.onItemClick,
            onIndexChanged: (int index) {
              setState(() {
                selectIndex = index;
              });
            },
            itemCount: widget.imageUrl?.length ?? 0,
          ),
          Positioned(
            bottom: Dimens.pt10,
            right: Dimens.pt10,
            child: CIndicator(
              itemCount: widget.imageUrl?.length ?? 0,
              selectIndex: selectIndex,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: AppColors.linearColorPrimaryOpacity,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
        ),
      ),
    );
    var selectBall = Padding(
        padding: EdgeInsets.only(left: widget.space),
        child: ClipOval(
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: AppColors.linearColorPrimary,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
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
