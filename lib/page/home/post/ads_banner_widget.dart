import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/custom_network_image_new.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

/// 广告轮播
class AdsBannerWidget extends StatefulWidget {
  final List<AdsInfoBean> models;

  final double width;

  final double height;

  final ValueChanged<int> onItemClick;

  final int autoPlayDuration;

  final BoxFit fit;
  final MainAxisAlignment mainAxisAlignment;
  AdsBannerWidget(this.models,
      {Key key,
      this.width,
      this.height,
      this.fit,
      this.autoPlayDuration = 5000,
      this.onItemClick,
      this.mainAxisAlignment,})
      : super(key: key);

  @override
  _AdsBannerWidgetState createState() => new _AdsBannerWidgetState();
}

class _AdsBannerWidgetState extends State<AdsBannerWidget> {
  int selectIndex;
  SwiperController swiperController;

  @override
  void initState() {
    selectIndex = 0;

    super.initState();

    swiperController = SwiperController();


  }

  @override
  Widget build(BuildContext context) {
    double moduleW = widget.width;
    double moduleH = widget.height;
    if(widget.models?.isNotEmpty != true){
      return SizedBox();
    }
    return Container(
      width: moduleW,
      height: moduleH,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[

          CarouselSlider.builder(
            itemCount: widget.models?.length ?? 0,

          options: CarouselOptions(
            height: moduleH,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: widget.models?.length == 1 ? false : true,
            autoPlayInterval: Duration(seconds: widget.autoPlayDuration,),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeIn,
            enlargeCenterPage: false,
            viewportFraction: 1,
            onPageChanged: (int index, CarouselPageChangedReason reason){
              setState(() {
                selectIndex = index;
              });
            },
            scrollDirection: Axis.horizontal,
          ),

            itemBuilder: (BuildContext context, int index, int realIndex) {
              var cover = widget.models[index].cover;
              return GestureDetector(
                onTap: (){
                  widget.onItemClick?.call(index);
                },
                child: CustomNetworkImageNew(
                  fit: widget.fit ?? BoxFit.fill,
                  height: moduleH,
                  imageUrl: cover,
                ),
              );
            },
          ),



         /* Swiper(
            index: selectIndex,
            controller: swiperController,
            autoplay: widget.models?.length == 1 ? false : true,
            autoplayDelay: widget.autoPlayDuration,
            loop: widget.models?.length == 1 ? false : true,
           // loop: true,
           // autoplay: true,
            itemBuilder: (BuildContext context, int index) {
              var cover = widget.models[index].cover;
              return CustomNetworkImageNew(
                fit: widget.fit ?? BoxFit.fill,
                height: moduleH,
                imageUrl: cover,
              );
            },
            onTap: widget.onItemClick,
            onIndexChanged: (int index) {
              setState(() {
                selectIndex = index;
              });
            },
            itemCount: widget.models?.length ?? 0,
          ),*/


          Positioned(
            bottom: Dimens.pt10,
            right: Dimens.pt10,
            left:Dimens.pt10,
            child: CIndicator(
              itemCount: widget.models?.length ?? 0,
              selectIndex: selectIndex,
              mainAxisAlignment: widget.mainAxisAlignment,
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
      this.callBack,
      this.mainAxisAlignment,})
      : super(key: key);

  ///
  final int itemCount;
  final int selectIndex;
  final double space;
  final Function(int) callBack;
  final MainAxisAlignment mainAxisAlignment;
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
          width: 6,
          height: 6,
          color: Color(0xffd2d2d2),
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //       colors: AppColors.linearColorPrimaryOpacity,
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter),
          // ),
        ),
      ),
    );
    var selectBall = Padding(
        padding: EdgeInsets.only(left: widget.space),
        child: ClipOval(
          child: Container(
            width: 8,
            height: 8,
            color: Colors.white,
            // decoration: BoxDecoration(
            //   gradient: LinearGradient(
            //       colors: AppColors.linearColorPrimary,
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter),
            // ),
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
        mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.center,
        children: list,
      ),
    );
    return wd;
  }
}
