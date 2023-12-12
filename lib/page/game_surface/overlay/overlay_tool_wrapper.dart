import 'dart:async';
import 'dart:math';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/page/game_wallet/wallet_main/page.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_base/flutter_base.dart';

import 'burst_flow.dart';
import 'color_wrapper.dart';
import 'feedback_widget.dart';

/// create by 张风捷特烈 on 2020/10/21
/// contact me by email 1981462002@qq.com
/// 说明:

class OverlayToolWrapper extends StatefulWidget {
  final Widget child;

  OverlayToolWrapper({Key key, this.child}) : super(key: key);

  @override
  OverlayToolWrapperState createState() => OverlayToolWrapperState();

  static OverlayToolWrapperState of(BuildContext context,
      {bool nullOk = false}) {
    assert(nullOk != null);
    assert(context != null);
    final OverlayToolWrapperState result =
        context.findAncestorStateOfType<OverlayToolWrapperState>();
    if (nullOk || result != null) return result;
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
          'OverlayToolWrapper.of() called with a context that does not contain a OverlayToolWrapper.'),
    ]);
  }
}

class OverlayToolWrapperState extends State<OverlayToolWrapper>
    with SingleTickerProviderStateMixin {
  bool show = false;
  bool activityShow = false;
  Offset offset = Offset(200, 200);
  Offset activityOffset = Offset(200, 200);

  AnimationController _ctrl;
  AnimationController _activityCtrl;

  final double width = 200;
  final double height = 30;
  final double outWidth = 35;
  final double boxHeight = 110;

  final double radius = 60;
  OverlayEntry entry;
  OverlayEntry activityEntry;
  double showWidth = 0;

  bool out = false;

  StreamController<bool> _streamController = StreamController.broadcast();

  bool draggable = false;

  //静止状态下的offset
  Offset idleOffset = Offset(0, 0);
  //本次移动的offset
  Offset moveOffset = Offset(0, 0);
  //最后一次down事件的offset
  Offset lastStartOffset = Offset(0, 0);

  int count = 0;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    )..addListener(_listenAnimate);

    /*_activityCtrl = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    )..addListener(_listenActivityAnimate);*/

    WidgetsBinding.instance.addPostFrameCallback((callback) {
      var px = MediaQuery.of(context).size.width - 100;
      var py = 250.0;
      offset = Offset(1, 50);

      entry = OverlayEntry(
          builder: (context) => Stack(
                children: <Widget>[
                  Positioned(
                    left: offset.dx,
                    top: offset.dy,
                    child: _buildFloating(),
                  ),
                ],
              ));
    });

    WidgetsBinding.instance.addPostFrameCallback((callback) async{

      // List<AdsInfoBean> list = await getAdsByType(AdsType.homeFloating);
      //
      // var px = MediaQuery.of(context).size.width - 90;
      // var py = MediaQuery.of(context).size.height - 150;
      // activityOffset = Offset(px, py);
      //
      // activityEntry = OverlayEntry(builder: (context) {
      //
      //   final size = MediaQuery.of(context).size;
      //   return list == null || list.length == 0 ? Container() :  Positioned(
      //     left: activityOffset.dx,
      //     top: activityOffset.dy,
      //     child: _buildActivityFloating(size,list),
      //   );
      // });


    });

    bus.on(EventBusUtils.isClose, (arg) {
      if (arg != null) {
        _streamController.add(arg);
      }
    });

    bus.on(EventBusUtils.showFloating, (arg) {
      if (arg != null) {
        showFloating();
      }
    });

    bus.on(EventBusUtils.closeFloating, (arg) {
      if (arg != null) {
        hideFloating();
      }
    });
  }

  final double circleRadius = 80;
  final double menuSize = 44;

  GlobalKey<BurstFlowState> burstFlowKey = GlobalKey<BurstFlowState>();

  GlobalKey<BurstFlowState> burstActivityFlowKey = GlobalKey<BurstFlowState>();

  _buildFloating() {
    //Color wrapColor = Colors.blue.withOpacity(0.6);
    Color wrapColor = Colors.white;

    bool left = offset.dx < 100;

    return Container(
      width: circleRadius * 2,
      height: circleRadius * 2,
      //width: 40,
      //height: 40,
      alignment: Alignment.center,
      // color: Colors.orangeAccent,
      child: IconTheme(
        data: IconTheme.of(context).copyWith(color: Colors.white, size: 18),
        child: BurstFlow(
            key: burstFlowKey,
            startAngle: !left ? 90.0 + 15 : -90 + 15.0,
            //startAngle: 200,
            swapAngle: !left ? 180.0 - 15 * 2 : 180.0 - 15 * 2.0,
            menu: GestureDetector(
              onPanEnd: _onPanEnd,
              onPanDown: _onPanDown,
              onPanUpdate: _updatePosition,
              child: Opacity(
                opacity: 1,
                child: Container(
                  //width: menuSize,
                  //height: menuSize,
                  width: 44,
                  height: 44,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            //阴影
                            color: Colors.grey.withOpacity(0.3),
                            offset: Offset(0.0, 0.0), blurRadius: 3.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                        /*image: DecorationImage(
                            image: AssetImage('assets/images/icon_head.webp')),*/
                        borderRadius: BorderRadius.circular(30)),
                    child: StreamBuilder<bool>(
                        initialData: true,
                        stream: _streamController.stream,
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data ? "菜单" : "隐藏",
                            style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.none,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          );
                        }),
                  ),
                ),
              ),
            ),
            children: _buildMenuItems(wrapColor)),
      ),
    );
  }

  _buildActivityFloating(final size, List<AdsInfoBean> list) {

    return Container(
      width: Dimens.pt80,
      height: Dimens.pt80,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: (){
          hideActivityFloating();
          JRouter().go(FU_LI_GUANG_CHANG_PAGE).then((value) {
             hideActivityFloating();
          });
        },
        onPanEnd: _onActivityPanEnd,
        onPanDown: _onPanDown,
        onPanUpdate: _updateActivityPosition,
        //child: Image.asset("assets/images/bcbm.png"),
        child: GestureDetector(
          onTap: (){

            bus.emit(EventBusUtils.closeActivityFloating);

            var ad = list[0];
            if (ad.href.contains("game_page")) {
              Navigator.of(FlutterBase.appContext).pop();
              bus.emit(EventBusUtils.gamePage);
            } else {
              JRouter().handleAdsInfo(ad.href, id: ad.id).then((value) {
                bus.emit(EventBusUtils.showActivityFloating);
              });
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: CustomNetworkImage(
              imageUrl: list[0]?.cover ?? "",
              width: Dimens.pt80,
              height: Dimens.pt80,
              fit: BoxFit.cover,
              type: ImgType.cover,
            ),
          ),
        ),
      ),
    );
  }

  // 构建 菜单 item
  List<Widget> _buildMenuItems(Color wrapColor) => [
        FeedbackWidget(
            onPressed: _toGold,
            child: Circled(
                color: wrapColor,
                child: Circled(
                    color: wrapColor,
                    child: Text(
                      "充值",
                      style: TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.none,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold),
                    )))),
        FeedbackWidget(
            onPressed: _toRefresh,
            child: Circled(
                color: wrapColor,
                child: Text(
                  "刷新",
                  style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ))),
        FeedbackWidget(
            onPressed: _contactCustomer,
            child: Circled(
                color: wrapColor,
                child: Text(
                  "客服",
                  style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ))),
        FeedbackWidget(
            onPressed: _doClose,
            child: Circled(
                color: wrapColor,
                child: Text(
                  "关闭",
                  style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ))),
      ];

  void _toRefresh() {
    Config.webView.reload();
    burstFlowKey.currentState.toggle();
  }

  void _contactCustomer() {
    hideFloating();
    if (Config.webView != null) {
      Config.webView.android.pause();
    }
    AutoOrientation.portraitAutoMode();
    CSManager().openServices(context);
  }

  void _toGold() {
    hideFloating();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return GameWalletPage().buildPage(null);
    })).then((value) {
      Config.webView.android.resume();
      AutoOrientation.landscapeAutoMode();
      showFloating();
    });
  }

  void _doClose() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    burstFlowKey.currentState.toggle();
  }

  double endx;

  void _onPanEnd(details) {
    endx = offset.dx;
    _ctrl.reset();
    _ctrl.forward();

    // offset = Offset(x, y);
    // entry.markNeedsBuild();
  }

  double activityEndx;
  void _onActivityPanEnd(details) {
    activityEndx = activityOffset.dx;

    // offset = Offset(x, y);
    // entry.markNeedsBuild();
  }

  void _listenAnimate() {
    // var px = MediaQuery.of(context).size.width - (outWidth);
    // offset = Offset(px - (_ctrl.value), offset.dy);
    double px;
    // print(offset.dx);
    if (offset.dx > MediaQuery.of(context).size.width / 2 - circleRadius) {
      double begin = endx;
      double end =
          MediaQuery.of(context).size.width - menuSize / 2 - circleRadius;
      double t = _ctrl.value;
      px = begin + (end - begin) * t; // x = menuSize / 2 - circleRadius;

    } else {
      double begin = endx;
      double end = menuSize / 2 - circleRadius;
      double t = _ctrl.value;
      px = begin + (end - begin) * t; // x = menuSize / 2 - circleRadius;
    }

    offset = Offset(px, offset.dy);
    entry.markNeedsBuild();
  }

  void _listenActivityAnimate() {
    // var px = MediaQuery.of(context).size.width - (outWidth);
    // offset = Offset(px - (_ctrl.value), offset.dy);
    double px;
    // print(offset.dx);
    if (activityOffset.dx >
        MediaQuery.of(context).size.width / 2 - circleRadius) {
      double begin = activityEndx;
      double end =
          MediaQuery.of(context).size.width - menuSize / 2 - circleRadius;
      double t = _activityCtrl.value;
      px = begin + (end - begin) * t; // x = menuSize / 2 - circleRadius;

    } else {
      double begin = activityEndx;
      double end = menuSize / 2 - circleRadius;
      double t = _activityCtrl.value;
      px = begin + (end - begin) * t; // x = menuSize / 2 - circleRadius;
    }

    activityOffset = Offset(px, activityOffset.dy);
    activityEntry.markNeedsBuild();
  }

  void _updatePosition(DragUpdateDetails details) {
    double y = details.globalPosition.dy - circleRadius;
    double x = details.globalPosition.dx - circleRadius;
    if (x < menuSize / 2 - circleRadius) {
      x = menuSize / 2 - circleRadius;
    }

    if (y < menuSize / 2 - circleRadius) {
      y = menuSize / 2 - circleRadius;
    }

    if (x > MediaQuery.of(context).size.width - menuSize / 2 - circleRadius) {
      x = MediaQuery.of(context).size.width - menuSize / 2 - circleRadius;
    }

    if (y > MediaQuery.of(context).size.height - menuSize / 2 - circleRadius) {
      y = MediaQuery.of(context).size.height - menuSize / 2 - circleRadius;
    }
    offset = Offset(x, y);
    entry.markNeedsBuild();
  }

  void _updateActivityPosition(DragUpdateDetails details) {
    double y = details.globalPosition.dy - circleRadius;
    double x = details.globalPosition.dx - circleRadius;
    if (x < menuSize / 2 - circleRadius) {
      x = menuSize / 2 - circleRadius;
    }

    if (y < menuSize / 2 - circleRadius) {
      y = menuSize / 2 - circleRadius;
    }

    if (x > MediaQuery.of(context).size.width - menuSize / 2 - circleRadius) {
      x = MediaQuery.of(context).size.width - menuSize / 2 - circleRadius;
    }

    if (y > MediaQuery.of(context).size.height - menuSize / 2 - circleRadius) {
      y = MediaQuery.of(context).size.height - menuSize / 2 - circleRadius;
    }
    activityOffset = Offset(x, y);
    activityEntry.markNeedsBuild();
  }

  showFloating() {
    if (!show) {
      Overlay.of(context).insert(entry);
      show = true;
    }
  }

  //
  hideFloating() {
    if (show) {
      entry.remove();
      show = false;
    }
  }

  showActivityFloating() {
    if (!activityShow && activityEntry != null ) {
      Overlay.of(context).insert(activityEntry);
      activityShow = true;
    }
  }

  hideActivityFloating() {
    if (activityShow) {
      activityEntry.remove();
      activityShow = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _onPanDown(DragDownDetails details) {}
}
