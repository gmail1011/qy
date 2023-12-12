import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/alert/coin_post_alert.dart';
import 'package:flutter_app/page/alert/vip_rank_alert.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/page/video/player_util.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';

import 'gesture_zoom_box.dart';

/// 图片轮播
class BannerRecommendWidget extends StatefulWidget {
  final List<String> models;

  final double width;

  final double height;

  final bool isGauss;

  final int selectIndex;

  final bool tabDismiss;

  final VideoModel videoModel;

  BannerRecommendWidget(
    this.models, {
    Key key,
    this.width,
    this.height,
    this.isGauss = false,
    this.selectIndex = 0,
    this.tabDismiss = false,
    this.videoModel,
  }) : super(key: key);

  @override
  _BannerRecommendWidgetState createState() => _BannerRecommendWidgetState();
}

class _BannerRecommendWidgetState extends State<BannerRecommendWidget> {
  SwiperController _controller;
  int selectIndex;
  bool hasPaid = false;
  bool _limitChange = false; //是否禁止滑动
  int get _maxLimitIndex => 4;

  @override
  void initState() {
    selectIndex = widget.selectIndex;
    _controller = SwiperController();
    super.initState();

    //没有购买过
    if (Config.videoId.indexOf(widget.videoModel?.id) == -1) {
      hasPaid = widget.videoModel?.vidStatus?.hasPaid;
    } else {
      hasPaid = true;
    }
  }

  void _showBuyCoin() async {
    _controller.move(_maxLimitIndex);
    var result = await showDialog(
        context: context,
        builder: (context) {
          return CoinPostAlert(videoModel: widget.videoModel);
        });

    ///true表示支付成功
    if (result != null && result is bool && result) {
      hasPaid = true;
      widget.videoModel?.vidStatus?.hasPaid = true;
      Config.videoId.add(widget.videoModel.id);
      showToast(msg: "购买成功!");
      setState(() {});
      await GlobalStore.updateUserInfo(null);
      setState(() {});
    } else {
      hasPaid = false;
      setState(() {});
    }
  }

  void _showBuyVip() async {
    _controller.move(_maxLimitIndex);
    VipRankAlert.show(context, type: VipAlertType.vipPostImg);
  }

  Widget build(BuildContext context) {
    double moduleW = widget.width ?? screen.screenWidth;
    double moduleH = widget.height ?? screen.screenHeight;

    var wd = Swiper(
      index: selectIndex,
      controller: _controller,
      loop: false,
      physics: widget.models?.length == 1 || _limitChange
          ? NeverScrollableScrollPhysics()
          : ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        var cover = widget.models[index];
        return Container(
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
              isGauss: widget.isGauss,
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
        );
      },
      onTap: (index) {
        if (widget.tabDismiss) {
          safePopPage();
        }
      },
      onIndexChanged: (int index) {
        setState(() {
          selectIndex = index;
        });
        if (index > _maxLimitIndex) {
          if (widget.videoModel.isCoinVideo()) {
            if (needBuyVideo(widget.videoModel)) {
              _showBuyCoin();
            }
          } else {
            if (!GlobalStore.isVIP()) {
              _showBuyVip();
            }
          }
        }
      },
      itemCount: widget.models.length,
    );
    return Container(
      width: moduleW,
      height: moduleH,
      child: Stack(
        children: <Widget>[
          wd,
          Positioned(
            bottom: Dimens.pt12,
            right: Dimens.pt16,
            child: Text(
              "${selectIndex + 1}/${widget.models.length ?? 0}",
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
