import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_app/model/video_model.dart';
/// 广告轮播
class VipPopBannerWidget extends StatefulWidget {
  final List<PopsBean> models;

  final double width;

  final double height;

  final VideoModel videoInfo;

  final ValueChanged<int> onItemClick;

  final int autoPlayDuration;

  final BoxFit fit;

  VipPopBannerWidget(this.models,
      {Key key,
      this.width,
      this.height,
      this.fit,
      this.videoInfo,
      this.autoPlayDuration = 5000,
      this.onItemClick})
      : super(key: key);

  @override
  _VipPopBannerWidgetState createState() => new _VipPopBannerWidgetState();
}

class _VipPopBannerWidgetState extends State<VipPopBannerWidget> {
  int selectIndex;

  @override
  void initState() {
    selectIndex = 0;
    // 视频播放vip提示
    EventTrackingManager().addVideoDatas(widget.videoInfo.id,widget.videoInfo.title);
    super.initState();
  }

  Widget build(BuildContext context) {
    double moduleW = widget.width;
    double moduleH = widget.height;

    return Container(
      width: moduleW,
      height: moduleH,
      child: Stack(
        // alignment: Alignment.center,
        children: <Widget>[
          Swiper(
            index: selectIndex,
            autoplay: ((widget.models?.length ?? 0) > 1),
            autoplayDelay: widget.autoPlayDuration,
            loop: widget.models?.length == 1 ? false : true,
            itemBuilder: (BuildContext context, int index) {
              var cover = widget.models[index].popBackgroundImage;
              return Stack(
                alignment: Alignment.center,
                children: [
                  CustomNetworkImage(
                    fit: widget.fit ?? BoxFit.fill,
                    height: moduleH,
                    imageUrl: cover,
                  ),
                  Positioned(
                    bottom: Dimens.pt33,
                    // right: Dimens.pt10,
                    child: GestureDetector(
                      onTap: () {
                        Config.videoModel = widget.videoInfo;
                        Config.payFromType = PayFormType.video;
                        AnalyticsEvent.clickBuyMembership(widget.videoInfo.title,widget.videoInfo.id,(widget.videoInfo.tags ?? []).map((e)=> e.name).toList(),VipPopUpsType.vip);
                      },
                      child: Container(
                        width: Dimens.pt240,
                        height: Dimens.pt42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xFFf2bf71),
                            borderRadius: BorderRadius.circular(42)),
                        child: Text(
                          "立即开通",
                          style: TextStyle(
                            fontSize: Dimens.pt16,
                            color: Color(0xFF4d3208),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            onTap: widget.onItemClick,
            onIndexChanged: (int index) {
              setState(() {
                selectIndex = index;
              });
            },
            itemCount: widget.models?.length ?? 0,
          ),
          // Positioned(
          //   bottom: Dimens.pt10,
          //   right: Dimens.pt10,
          //   child: CIndicator(
          //     itemCount: widget.models?.length ?? 0,
          //     selectIndex: selectIndex,
          //   ),
          // ),
          // Align(
          //   child: Container(
          //     child: Text(
          //       "立即开通",
          //       style: TextStyle(
          //         fontSize: Dimens.pt16,
          //         color: Color(0xFF4d3208),
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ),
          // ),
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
