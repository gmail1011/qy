import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animation_set/animation_set.dart';
import 'package:flutter_animation_set/animator.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/manager/event_manager.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/msg_count_model.dart';
import 'package:flutter_app/model/message/NewMessageTip.dart';
import 'package:flutter_app/page/anwang_trade/widget/sw_switch_view.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/shadow_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'EventBusUtils.dart';
import 'global_variable.dart';

class CNavigationBarItem extends StatefulWidget {
  final Size screenSize;
  final double navBarH;
  final ValueChanged<int> onTap;
  final int currentIndex;

  CNavigationBarItem({Key key, this.screenSize, this.navBarH, this.onTap, this.currentIndex = 0})
      : super(key: key);

  _CNavigationBarItemState createState() => new _CNavigationBarItemState();
}

class _CNavigationBarItemState extends State<CNavigationBarItem> {
  int currentIndex = 0;
  bool isLoadOrigin = false;
  bool isPostLoadOrigin = false;
  bool isVisible = false;
  StreamSubscription loadOriginEventID;
  StreamSubscription postLoadOriginEventID;
  StreamSubscription homeChangePageEventID;
  StreamSubscription homeMinePageEventID;

  initState() {
    currentIndex = widget.currentIndex;

    /// 订阅消息
    loadOriginEventID = GlobalVariable.eventBus.on<LoadOriginEvent>().listen((event) {
      if (event.type == 2) {
        setState(() {
          isLoadOrigin = false;
        });
      }
    });

    /// 订阅消息
    postLoadOriginEventID = GlobalVariable.eventBus.on<PostLoadOriginEvent>().listen((event) {
      if (event.type == 2) {
        setState(() {
          isPostLoadOrigin = false;
        });
      }
    });

    homeChangePageEventID = GlobalVariable.eventBus.on<HomeBottomTagChange>().listen((event) {
      onTap(event.index);
    });

    homeMinePageEventID = GlobalVariable.eventBus.on<HomeMineUnReadChange>().listen((event) {
      setState(() {});
    });

    super.initState();

    bus.on(EventBusUtils.souye, (arg) {
      Config.isSouYe = arg;
    });

    bus.on(EventBusUtils.sheQu, (arg) {
      onTap(1);
    });

    bus.on(EventBusUtils.flPage1, (arg) {
      onTap(2);
    });

    bus.on(EventBusUtils.avCommentary, (arg) {
      onTap(navigationBarList.length - 2);
    });

    bus.on(EventBusUtils.gamePage, (arg) {
      onTap(2);
    });

    bus.on(EventBusUtils.memberlongvideo, (arg) {
      onTap(3);
    });

    bus.on(EventBusUtils.louFengPage, (arg) {
      onTap((Config.playGame == true) ? 3 : 2);
    });
  }

  getMessageTip() async {
    try {
      Config.newMessageTip = await netManager.client.checkMessageTip();
      setState(() {});
    } catch (e) {}
  }

  @override
  void dispose() {
    homeChangePageEventID.cancel();
    loadOriginEventID.cancel();
    postLoadOriginEventID.cancel();
    super.dispose();
  }

  /// 构建img按钮
  Widget buildImgBtn(int index, String title, String defImage, String activeImage) {
    Color color = Color(0xff95949a);
    if (currentIndex == index) {
      color = Color(0xffca452e);

    }

    return Container(
      child: Center(
        child: GestureDetector(
          onTap: () {
            onTap(index);
          },
          child: Container(
          //  color: Color.fromRGBO(31, 31, 31, 1),
            alignment: Alignment.center,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Image(
                        image: AssetImage(currentIndex == index ? activeImage : defImage),
                        width: 24,
                        height: 24,
                        fit: BoxFit.fitWidth,
                      ),
                      if (Config.newMessageTip != null &&
                          (Config.newMessageTip.newsTip ?? false) &&
                          title == "我的")
                        Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: BoxDecoration(
                                  color: Color(0xfff74f49),
                                  borderRadius: BorderRadius.all(Radius.circular(5.w))),
                            ))
                    ],
                  ),
                  SizedBox(
                    height: 2.w,
                  ),
                  Text(title, style: TextStyle(color: color, fontSize: 10)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建文字按钮
  Widget buildTextBtn(int index, String title) {
    var curType = autoPlayModel.extVideoListType;
    if (index == 0 && isLoadOrigin && curType.type == VideoListType.RECOMMEND) {
      return GestureDetector(
        onTap: () {
          onTap(index);
        },
        child: AnimatorSet(
          child: svgAssets(AssetsSvg.RECD_LOAD_ORIGIN),
          animatorSet: [
            RZ(from: 0, to: 2 * pi, duration: 800, delay: 0, curve: Curves.ease),
          ],
        ),
      );
    }
    if (index == 1 && isPostLoadOrigin) {
      return GestureDetector(
        onTap: () {
          onTap(index);
        },
        child: AnimatorSet(
          child: svgAssets(AssetsSvg.RECD_LOAD_ORIGIN),
          animatorSet: [
            RZ(from: 0, to: 2 * pi, duration: 800, delay: 0, curve: Curves.ease),
          ],
        ),
      );
    }
    Color color = Color.fromRGBO(255, 255, 255, 0.5);
    if (currentIndex == index) {
      color = Color.fromRGBO(233, 233, 234, 1);
    }
    var con = Container(
    //  color: Color.fromRGBO(31, 31, 31, 1),
      child: Center(
        child: ShadowText(
          title,
          color: color,
          shadow: false,
          fontSize: 10.w,
        ),
      ),
    );

    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      child: con,
    );
  }

  void onTap(int index) {
    // switch (index) {
    //   case 1:
    //     if(currentIndex==index){
    //       return;
    //     }
    //     showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (BuildContext context) {
    //           return SWSwitchDialogView(
    //             callback: () {
    //               currentIndex = index;
    //               widget.onTap(index);
    //             },
    //             cancelCallback: () {
    //             },
    //           );
    //         });
    //     break;
    //   default:
    //     currentIndex = index;
    //     widget.onTap(index);
    //     break;
    // }
    currentIndex = index;
    widget.onTap(index);
    setState(() {
    });
  }

  List<Widget> navigationBarList = [];

  Widget build(BuildContext context) {
    if (isVisible == true) {
      return Container(
        color: Color(0),
      );
    }

    navigationBarList = [];
    int menuIndex = 0;
    navigationBarList.add(
      Expanded(
        child: GestureDetector(
          onTap: (){
             onTap(menuIndex);
          },
          child: Container(
            width: 56,
            child: buildImgBtn(
                menuIndex, "首页", "assets/images/hj_home_icon_1.png", "assets/images/hj_home_icon_1_select.png"),
          ),
        ),
      ),
    );
    menuIndex++;
    navigationBarList.add(
      Expanded(
        child: GestureDetector(
          onTap: () {
            onTap(menuIndex);
           },
          child: Container(
            width: 56,
            child: buildImgBtn(
                menuIndex, "猎奇", "assets/images/hj_home_icon_anwang.png", "assets/images/hj_home_icon_anwang_select.png"),
          ),
        ),
      ),
    );
    // if (Config.playGame == true) {
    //   menuIndex++;
    //   navigationBarList.add(
    //     Expanded(
    //       child: buildImgBtn(menuIndex, "游戏", AssetsImages.IC_HOME_GAME,
    //           AssetsImages.IC_HOME_GAME_ACTIVCE),
    //     ),
    //   );
    // }
    // if (VariableConfig.louFengH5 != null && VariableConfig.louFengH5 != "") {
    //   menuIndex++;
    //   navigationBarList.add(
    //     Expanded(
    //       child: buildImgBtn(menuIndex, "娱乐", AssetsImages.IC_HOME_LOUFENG,
    //           AssetsImages.IC_HOME_LOUFENG_ACTIVE),
    //     ),
    //   );
    // }
    menuIndex++;
    navigationBarList.add(
      Expanded(
        child: GestureDetector(
          onTap: (){
            onTap(menuIndex);
          },
          child: Container(
            width: 56,
            child: buildImgBtn(
                menuIndex, "社区", "assets/images/hj_home_icon_2.png", "assets/images/hj_home_icon_2_select.png"),
          ),
        ),
      ),
    );
    menuIndex++;
    navigationBarList.add(
      Expanded(
        child: GestureDetector(
          onTap: (){
            onTap(menuIndex);
          },
          child: Container(
            width: 56,
            child: buildImgBtn(menuIndex, Lang.NAV_MINE, "assets/images/hj_home_icon_4.png",
                "assets/images/hj_home_icon_4_select.png"),
          ),
        ),
      ),
    );
    /// 导航按钮
    var navigationBar = Container(
      decoration: BoxDecoration(
        //  border: Border(top: BorderSide(color: const Color(0xff4f4f4f), width: 0.5)),
          color:  AppColors.primaryColor,
      ),
      width: widget.screenSize.width,
      height: widget.navBarH,
      child: Center(
        child: Flex(
          direction: Axis.horizontal,
          children: navigationBarList,
        ),
      ),
    );
    return navigationBar;
  }
}
