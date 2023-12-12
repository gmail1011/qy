import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/page/fuli_guangchang/fu_li_ying_yong/AppCenterPage.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'qian_dao_action.dart';
import 'qian_dao_state.dart';

Widget buildView(
    qian_daoState state, Dispatch dispatch, ViewService viewService) {
  String getId() {
    switch (state.dayMarkData.value) {
      case 0:
        return state.dayMarkData.xList[0].id;
        break;
      case 1:
        return state.dayMarkData.xList[1].id;
        break;
      case 2:
        return state.dayMarkData.xList[2].id;
        break;
      case 3:
        return state.dayMarkData.xList[3].id;
        break;
      case 4:
        return state.dayMarkData.xList[4].id;
        break;
      case 5:
        return state.dayMarkData.xList[5].id;
        break;
      case 6:
        return state.dayMarkData.xList[6].id;
        break;
      case 7:
        return state.dayMarkData.xList[7].id;
        break;
    }

    return "";
  }

  return SingleChildScrollView(
      child: Container(
        child: Column(children: <Widget>[
          Offstage(
            offstage: state.resultList.length == 0 ? true : false,
            child: SizedBox(
              height: Dimens.pt18,
            ),
          ),
          Offstage(
            offstage: state.resultList.length == 0 ? true : false,
            child: Container(
              margin: EdgeInsets.only(
                left: Dimens.pt16,
                right: Dimens.pt16,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                child: Container(
                  height: Dimens.pt160,
                  //margin: EdgeInsets.only(left: Dimens.pt16,right: Dimens.pt16,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: AdsBannerWidget(
                    state.resultList,
                    width: Dimens.pt360,
                    height: Dimens.pt154,
                    onItemClick: (index) {
                      var ad = state.resultList[index];
                      if(ad.href.contains("game_page")){
                        Navigator.of(FlutterBase.appContext).pop();
                        bus.emit(EventBusUtils.gamePage);
                      }else{
                        JRouter().handleAdsInfo(ad.href, id: ad.id);
                      }

                      /*eagleClick(selfId(),
                                sourceId: state.eagleId(context),
                                label: "banner(${ad?.id ?? ""})");*/
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Dimens.pt16,
          ),
          Container(
            height: Dimens.pt72,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (){
                    JRouter().go(Address.activityUrl);
                  },
                  child:  Column(
                    children: [
                      Image.asset(
                        "assets/images/fuli_reward.png",
                        width: Dimens.pt46,
                        height: Dimens.pt46,
                      ),
                      SizedBox(
                        height: Dimens.pt6,
                      ),
                      Text(
                        "免费抽奖",
                        style: TextStyle(color: Colors.white, fontSize: Dimens.pt13),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (GlobalStore.isRechargeVIP() &&
                            (GlobalStore.getMe()?.vipLevel == 1 ||
                                GlobalStore.getMe()?.vipLevel == 2) &&
                            (DateTime.parse(GlobalStore.getMe()?.vipExpireDate ??
                                "")
                                .year -
                                netManager.getFixedCurTime().year)
                                .abs() <
                                20) {
                          JRouter().go(PAGE_UPGRADE_VIP);
                        } else {
                          Config.payFromType = PayFormType.user;
                        }
                      },
                      child: Image.asset(
                        "assets/images/fuli_huiyuan.png",
                        width: Dimens.pt46,
                        height: Dimens.pt46,
                      ),
                    ),
                    SizedBox(
                      height: Dimens.pt6,
                    ),
                    Text(
                      "会员中心",
                      style: TextStyle(color: Colors.white, fontSize: Dimens.pt13),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(viewService.context).pop();
                        bus.emit(EventBusUtils.gamePage);
                      },
                      child: Image.asset(
                        "assets/images/fuli_game.png",
                        width: Dimens.pt46,
                        height: Dimens.pt46,
                      ),
                    ),
                    SizedBox(
                      height: Dimens.pt6,
                    ),
                    Text(
                      "游戏畅玩",
                      style: TextStyle(color: Colors.white, fontSize: Dimens.pt13),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {

                    showDialog(
                        context: viewService.context,
                        builder: (context) {
                          return Dialog(
                            child: Container(
                              height: Dimens.pt200,
                              child: Stack(
                                alignment: AlignmentDirectional.bottomCenter,
                                children: [
                                  // Image.asset("assets/images/fulitanchuang.png"),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: Dimens.pt60, bottom: Dimens.pt16),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          "取消",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  102, 102, 102, 0.5),
                                              fontWeight: FontWeight.w500,
                                              fontSize: Dimens.pt14),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){

                                      Navigator.of(context).pop();

                                      Clipboard.setData(ClipboardData(text: GlobalStore.getMe().appStoreCode));

                                      /*Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                        return AppCenterPage(

                                        );
                                      }));*/
                                      JRouter().go(Address.appCenterUrl);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: Dimens.pt50, bottom: Dimens.pt16),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "去下载",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: Dimens.pt14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/fuli_yingyong.png",
                        width: Dimens.pt46,
                        height: Dimens.pt46,
                      ),
                      SizedBox(
                        height: Dimens.pt6,
                      ),
                      Text(
                        "应用福利站",
                        style:
                        TextStyle(color: Colors.white, fontSize: Dimens.pt13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: Dimens.pt16, right: Dimens.pt16),
            child: Stack(
              children: [
                Container(
                  height: Dimens.pt333,
                  margin: EdgeInsets.only(
                    top: Dimens.pt104,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                    Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: Dimens.pt18),
                    child: Text(
                      "已连续签到：${state.dayMarkData == null ? 0 : state.dayMarkData.value}天",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimens.pt18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: Dimens.pt16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: Dimens.pt80,
                            width: Dimens.pt60,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(Dimens.pt6)),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(58, 211, 246, 1),
                                  Color.fromRGBO(0, 163, 253, 1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  state.dayMarkData == null
                                      ? ""
                                      : state.dayMarkData.xList[0].status == 2
                                      ? "今天"
                                      : "第一天",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt12),
                                ),
                                Container(
                                  height: Dimens.pt40,
                                  margin: EdgeInsets.only(
                                    left: Dimens.pt4,
                                    right: Dimens.pt4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.pt4)),
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "APP",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimens.pt10,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SvgPicture.asset(
                                            "assets/svg/icon_gold_coin.svg",
                                            width: Dimens.pt15,
                                            height: Dimens.pt15,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${state.dayMarkData == null ? "" : state.dayMarkData.xList[0].prizes[1].name}",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 244, 145, 1),
                                            fontSize: Dimens.pt10,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  state.dayMarkData == null
                                      ? ""
                                      : state
                                      .dayMarkData.xList[0].prizes[0].name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt10),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: state.dayMarkData == null
                                ? false
                                : state.dayMarkData.value == 1 ||
                                state.dayMarkData.value > 1
                                ? true
                                : false,
                            child: Container(
                              height: Dimens.pt80,
                              width: Dimens.pt60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.pt6)),
                                color: Color.fromRGBO(155, 155, 155, 1)
                                    .withOpacity(0.7),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/qiandao.png",
                                    height: Dimens.pt24,
                                    width: Dimens.pt24,
                                  ),
                                  SizedBox(
                                    height: Dimens.pt8,
                                  ),
                                  Text(
                                    "已签到",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: Dimens.pt12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            height: Dimens.pt80,
                            width: Dimens.pt60,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(Dimens.pt6)),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(58, 211, 246, 1),
                                  Color.fromRGBO(0, 163, 253, 1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  state.dayMarkData == null
                                      ? ""
                                      : state.dayMarkData.xList[1].status == 2
                                      ? "今天"
                                      : "第二天",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt12),
                                ),
                                Container(
                                  height: Dimens.pt40,
                                  margin: EdgeInsets.only(
                                    left: Dimens.pt4,
                                    right: Dimens.pt4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.pt4)),
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "APP",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimens.pt10,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SvgPicture.asset(
                                            "assets/svg/icon_gold_coin.svg",
                                            width: Dimens.pt15,
                                            height: Dimens.pt15,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${state.dayMarkData == null ? "" : state.dayMarkData.xList[1].prizes[1].name}",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 244, 145, 1),
                                            fontSize: Dimens.pt10,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  state.dayMarkData == null
                                      ? ""
                                      : state
                                      .dayMarkData.xList[1].prizes[0].name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt10),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: state.dayMarkData == null
                                ? false
                                : state.dayMarkData.value == 2 ||
                                state.dayMarkData.value > 2
                                ? true
                                : false,
                            child: Container(
                              height: Dimens.pt80,
                              width: Dimens.pt60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.pt6)),
                                color: Color.fromRGBO(155, 155, 155, 1)
                                    .withOpacity(0.7),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/qiandao.png",
                                    height: Dimens.pt24,
                                    width: Dimens.pt24,
                                  ),
                                  SizedBox(
                                    height: Dimens.pt8,
                                  ),
                                  Text(
                                    "已签到",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: Dimens.pt12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            height: Dimens.pt80,
                            width: Dimens.pt60,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(Dimens.pt6)),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(58, 211, 246, 1),
                                  Color.fromRGBO(0, 163, 253, 1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  state.dayMarkData == null
                                      ? ""
                                      : state.dayMarkData.xList[2].status == 2
                                      ? "今天"
                                      : "第三天",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt12),
                                ),
                                Container(
                                  height: Dimens.pt40,
                                  margin: EdgeInsets.only(
                                    left: Dimens.pt4,
                                    right: Dimens.pt4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.pt4)),
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "APP",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimens.pt10,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SvgPicture.asset(
                                            "assets/svg/icon_gold_coin.svg",
                                            width: Dimens.pt15,
                                            height: Dimens.pt15,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${state.dayMarkData == null ? "" : state.dayMarkData.xList[2].prizes[1].name}",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 244, 145, 1),
                                            fontSize: Dimens.pt10,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  state.dayMarkData == null
                                      ? ""
                                      : state
                                      .dayMarkData.xList[2].prizes[0].name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt10),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: state.dayMarkData == null
                                ? false
                                : state.dayMarkData.value == 3 ||
                                state.dayMarkData.value > 3
                                ? true
                                : false,
                            child: Container(
                              height: Dimens.pt80,
                              width: Dimens.pt60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.pt6)),
                                color: Color.fromRGBO(155, 155, 155, 1)
                                    .withOpacity(0.7),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/qiandao.png",
                                    height: Dimens.pt24,
                                    width: Dimens.pt24,
                                  ),
                                  SizedBox(
                                    height: Dimens.pt8,
                                  ),
                                  Text(
                                    "已签到",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: Dimens.pt12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            height: Dimens.pt80,
                            width: Dimens.pt60,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(Dimens.pt6)),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(58, 211, 246, 1),
                                  Color.fromRGBO(0, 163, 253, 1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  state.dayMarkData == null
                                      ? ""
                                      : state.dayMarkData.xList[3].status == 2
                                      ? "今天"
                                      : "第四天",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt12),
                                ),
                                Container(
                                  height: Dimens.pt40,
                                  margin: EdgeInsets.only(
                                    left: Dimens.pt4,
                                    right: Dimens.pt4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.pt4)),
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "APP",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimens.pt10,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SvgPicture.asset(
                                            "assets/svg/icon_gold_coin.svg",
                                            width: Dimens.pt15,
                                            height: Dimens.pt15,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${state.dayMarkData == null ? "" : state.dayMarkData.xList[3].prizes[1].name}",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 244, 145, 1),
                                            fontSize: Dimens.pt10,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  state.dayMarkData == null
                                      ? ""
                                      : state
                                      .dayMarkData.xList[3].prizes[0].name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt10),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: state.dayMarkData == null
                                ? false
                                : state.dayMarkData.value == 4 ||
                                state.dayMarkData.value > 4
                                ? true
                                : false,
                            child: Container(
                              height: Dimens.pt80,
                              width: Dimens.pt60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.pt6)),
                                color: Color.fromRGBO(155, 155, 155, 1)
                                    .withOpacity(0.7),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/qiandao.png",
                                    height: Dimens.pt24,
                                    width: Dimens.pt24,
                                  ),
                                  SizedBox(
                                    height: Dimens.pt8,
                                  ),
                                  Text(
                                    "已签到",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: Dimens.pt12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimens.pt16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: Dimens.pt80,
                            width: Dimens.pt60,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(Dimens.pt6)),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(255, 157, 95, 1),
                                  Color.fromRGBO(255, 76, 160, 1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  state.dayMarkData == null
                                      ? ""
                                      : state.dayMarkData.xList[4].status == 2
                                      ? "今天"
                                      : "第五天",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt12),
                                ),
                                Container(
                                  height: Dimens.pt40,
                                  margin: EdgeInsets.only(
                                    left: Dimens.pt4,
                                    right: Dimens.pt4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.pt4)),
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "APP",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimens.pt10,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SvgPicture.asset(
                                            "assets/svg/icon_gold_coin.svg",
                                            width: Dimens.pt15,
                                            height: Dimens.pt15,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${state.dayMarkData == null ? "" : state.dayMarkData.xList[4].prizes[1].name}",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 244, 145, 1),
                                            fontSize: Dimens.pt10,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  state.dayMarkData == null
                                      ? ""
                                      : state
                                      .dayMarkData.xList[4].prizes[0].name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt10),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: state.dayMarkData == null
                                ? false
                                : state.dayMarkData.value == 5 ||
                                state.dayMarkData.value > 5
                                ? true
                                : false,
                            child: Container(
                              height: Dimens.pt80,
                              width: Dimens.pt60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.pt6)),
                                color: Color.fromRGBO(155, 155, 155, 1)
                                    .withOpacity(0.7),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/qiandao.png",
                                    height: Dimens.pt24,
                                    width: Dimens.pt24,
                                  ),
                                  SizedBox(
                                    height: Dimens.pt8,
                                  ),
                                  Text(
                                    "已签到",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: Dimens.pt12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            height: Dimens.pt80,
                            width: Dimens.pt60,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(Dimens.pt6)),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(255, 157, 95, 1),
                                  Color.fromRGBO(255, 76, 160, 1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  state.dayMarkData == null
                                      ? ""
                                      : state.dayMarkData.xList[5].status == 2
                                      ? "今天"
                                      : "第六天",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt12),
                                ),
                                Container(
                                  height: Dimens.pt40,
                                  margin: EdgeInsets.only(
                                    left: Dimens.pt4,
                                    right: Dimens.pt4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.pt4)),
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "APP",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimens.pt10,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SvgPicture.asset(
                                            "assets/svg/icon_gold_coin.svg",
                                            width: Dimens.pt15,
                                            height: Dimens.pt15,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${state.dayMarkData == null ? "" : state.dayMarkData.xList[5].prizes[1].name}",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 244, 145, 1),
                                            fontSize: Dimens.pt10,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  state.dayMarkData == null
                                      ? ""
                                      : state
                                      .dayMarkData.xList[5].prizes[0].name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt10),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: state.dayMarkData == null
                                ? false
                                : state.dayMarkData.value == 6 ||
                                state.dayMarkData.value > 6
                                ? true
                                : false,
                            child: Container(
                              height: Dimens.pt80,
                              width: Dimens.pt60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.pt6)),
                                color: Color.fromRGBO(155, 155, 155, 1)
                                    .withOpacity(0.7),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/qiandao.png",
                                    height: Dimens.pt24,
                                    width: Dimens.pt24,
                                  ),
                                  SizedBox(
                                    height: Dimens.pt8,
                                  ),
                                  Text(
                                    "已签到",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: Dimens.pt12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Container(
                            height: Dimens.pt80,
                            width: Dimens.pt60,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(Dimens.pt6)),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(255, 157, 95, 1),
                                  Color.fromRGBO(255, 76, 160, 1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  state.dayMarkData == null
                                      ? ""
                                      : state.dayMarkData.xList[6].status == 2
                                      ? "今天"
                                      : "第七天",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt12),
                                ),
                                Container(
                                  height: Dimens.pt40,
                                  margin: EdgeInsets.only(
                                    left: Dimens.pt4,
                                    right: Dimens.pt4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.pt4)),
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "APP",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: Dimens.pt10,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SvgPicture.asset(
                                            "assets/svg/icon_gold_coin.svg",
                                            width: Dimens.pt15,
                                            height: Dimens.pt15,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${state.dayMarkData == null ? "" : state.dayMarkData.xList[6].prizes[1].name}",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 244, 145, 1),
                                            fontSize: Dimens.pt10,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  state.dayMarkData == null
                                      ? ""
                                      : state
                                      .dayMarkData.xList[6].prizes[0].name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt10),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: state.dayMarkData == null
                                ? false
                                : state.dayMarkData.value == 7 ||
                                state.dayMarkData.value > 7
                                ? true
                                : false,
                            child: Container(
                              height: Dimens.pt80,
                              width: Dimens.pt60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.pt6)),
                                color: Color.fromRGBO(155, 155, 155, 1)
                                    .withOpacity(0.7),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/qiandao.png",
                                    height: Dimens.pt24,
                                    width: Dimens.pt24,
                                  ),
                                  SizedBox(
                                    height: Dimens.pt8,
                                  ),
                                  Text(
                                    "已签到",
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: Dimens.pt12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      if (state.isSign == null ? false : state.isSign) {
                      } else {
                        dispatch(qian_daoActionCreator.postDayMark(getId()));
                      }

                      //dispatch(qian_daoActionCreator.postDayMark(getId()));
                    },
                    child: Container(
                      width: Dimens.pt166,
                      height: Dimens.pt40,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: Dimens.pt20),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(Dimens.pt20)),
                        gradient: LinearGradient(
                            colors: state?.isSign == null
                            ? [
                            Colors.grey,
                            Colors.grey,
                            ]
                                : state.isSign
                            ? [
                            Colors.grey,
                            Colors.grey,
                            ]
                                : [
                            Color.fromRGBO(252, 68, 120, 1),
                        Color.fromRGBO(255, 101, 56, 1),
                        Color.fromRGBO(245, 68, 4, 1),
                        ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          //阴影
                          color: state.isSign == null
                              ? Colors.grey
                              : state.isSign
                              ? Colors.grey
                              : Color.fromRGBO(248, 44, 44, 0.4),
                          offset: Offset(0.0, 6.0), blurRadius: 8.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                    ),
                    child: Text(
                      "点击签到",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimens.pt24,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            // child: Image.asset(
            //   "assets/images/fuli_qiandao.png",
            //   height: Dimens.pt146,
            // ),
          ),
          Positioned(
            top: 12,
            right: 10,
            child: ClipOval(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: viewService.context,
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          height: Dimens.pt238,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                  top: Dimens.pt26,
                                ),
                                child: Text(
                                  "签到规则",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: Dimens.pt26,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Dimens.pt20,
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: Dimens.pt20,
                                  right: Dimens.pt16,
                                  bottom: Dimens.pt20,
                                ),
                                child: Text(
                                  "1. 需要每天登陆连续签到，若未连续签到则重新从第一天开始。\n\n2. 活跃值可开启宝箱，每周最多开启3个宝箱，开启后可获得相应奖励。\n\n3. 签到日开始7个自然日后的0点，活跃值清零。",
                                  style: TextStyle(
                                    color: Color.fromRGBO(209, 0, 0, 1),
                                    fontSize: Dimens.pt14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: Dimens.pt25,
                  height: Dimens.pt25,
                  color: Colors.red,
                  child: Text(
                    "?",
                    style:
                    TextStyle(color: Colors.white, fontSize: Dimens.pt18),
                  ),
                ),
              ),
            ),
          ),
        ],
        ),
      ),
      ])),
  );
}
