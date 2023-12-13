import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/task_detail_entity.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/task_entity.dart';
import 'package:flutter_app/page/game_wallet/wallet_main/page.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/widget/OvalBottomBorderClipper.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/dialog/payfor_confirm_dialog.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'ren_wu_action.dart';
import 'ren_wu_state.dart';

Widget buildView(RenWuState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: state.taskData == null
        ? Center(child: LoadingWidget())
        : Container(
            margin: EdgeInsets.only(
              top: Dimens.pt20,
            ),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  // Image.asset(
                  //   "assets/images/fuli_background.png",
                  //   height: Dimens.pt134,
                  //   fit: BoxFit.cover,
                  //   width: MediaQuery.of(viewService.context).size.width,
                  // ),
                  Positioned(
                    top: Dimens.pt30,
                    left: Dimens.pt20,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Dimens.pt13,
                        ),
                        Image.asset(
                          "assets/images/huoyue_bai.png",
                          height: Dimens.pt26,
                          width: Dimens.pt26,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: Dimens.pt10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: Dimens.pt6),
                          child: Text(
                            "累计活跃值${state.taskData == null ? 0 : state.taskData.jewelBoxDetails.value}",
                            style: TextStyle(
                                fontSize: Dimens.pt12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: Dimens.pt33,
                    right: Dimens.pt16,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: viewService.context,
                            builder: (contexts) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                //backgroundColor: Colors.transparent,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Image.asset(
                                    //   "assets/images/shuoming_dialog.png",
                                    //   height: Dimens.pt76,
                                    // ),
                                    Container(
                                      //margin: EdgeInsets.only(top: Dimens.pt46),
                                      padding: EdgeInsets.only(
                                          top: Dimens.pt10,
                                          left: Dimens.pt16,
                                          right: Dimens.pt16,
                                          bottom: Dimens.pt20),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(Dimens.pt10))),
                                      //height: Dimens.pt385,
                                      child: Text(
                                        "1.用户可通过签到及做任务获得活跃值，活跃值可开启宝箱。每七个自然日至多只能开启三个宝箱，开启后可获得相应奖励。\n\n"
                                        "2.本活动与2021年8月10号上线生效，活动期间，用户每七个自然日内达到相应的活跃值后即可开启对应宝箱。\n\n"
                                        "3.本活动周期为七个自然日，每七个自然日的最后一日23:59:59会清空所有活跃值，请用户尽快领取奖励。\n\n"
                                        "4.同一台设备，同一个用户，七个自然日内只能领取1次奖励。\n\n"
                                        "5.本活动所获得的优惠券会在购买相应商品时作出提示。可前往我的-设置-优惠券查看，请一定在有效期内使用，避免过期失效。\n\n"
                                        "6.本活动最终解释权归海角社区官方所有。",
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            fontWeight: FontWeight.w600,
                                            fontSize: Dimens.pt12),
                                      ),
                                    ),
                                    /*Positioned(
                                      child: Image.asset(
                                        "assets/images/shuoming_dialog.png",
                                        height: Dimens.pt76,
                                      ),
                                    ),*/
                                  ],
                                ),
                              );
                            });
                      },
                      child: Container(
                        width: Dimens.pt42,
                        height: Dimens.pt20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.all(Radius.circular(Dimens.pt10)),
                        ),
                        child: Text(
                          "说明",
                          style: TextStyle(
                              fontSize: Dimens.pt12,
                              fontWeight: FontWeight.w600,
                              color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: Dimens.pt16,
                      right: Dimens.pt16,
                      top: Dimens.pt63,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: Dimens.pt150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(Dimens.pt8)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: state.taskData.jewelBoxDetails.xList
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (e.value.status == 1) {
                                        showDialog(
                                            context: viewService.context,
                                            builder: (contexts) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(10)),
                                                child: Container(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        height: Dimens.pt16,
                                                      ),
                                                      Text(
                                                        "内含:",
                                                        style: TextStyle(
                                                            fontSize:
                                                                Dimens.pt18,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      SizedBox(
                                                        height: Dimens.pt16,
                                                      ),
                                                      Column(
                                                        children: e.value.prizes
                                                            .asMap()
                                                            .entries
                                                            .map((e) {
                                                          return Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: Dimens
                                                                        .pt6),
                                                            child: Text(
                                                                e.value.name.contains("优惠卷") ? e.value.name + "*" + e.value.count.toString() : e.value.name,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      Dimens
                                                                          .pt18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          183,
                                                                          0,
                                                                          0,
                                                                          1)),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      ),
                                                      SizedBox(
                                                        height: Dimens.pt20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });

                                        ///可领取
                                      } else if (e.value.status == 2) {
                                        dynamic result = await netManager.client
                                            .getBox(e.value.id, 2);
                                        if (result == "success") {
                                          showDialog(
                                              context: viewService.context,
                                              builder: (contexts) {
                                                return Dialog(
                                                  child: Container(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: Dimens.pt16,
                                                        ),
                                                        Text(
                                                          "已领取:",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  Dimens.pt18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        SizedBox(
                                                          height: Dimens.pt16,
                                                        ),
                                                        Column(
                                                          children: e
                                                              .value.prizes
                                                              .asMap()
                                                              .entries
                                                              .map((e) {
                                                            return Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: Dimens
                                                                          .pt6),
                                                              child: Text(
                                                                e.value.name,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        Dimens
                                                                            .pt18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Color
                                                                        .fromRGBO(
                                                                            183,
                                                                            0,
                                                                            0,
                                                                            1)),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                        SizedBox(
                                                          height: Dimens.pt20,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }).then((value) async {
                                            dynamic result = await netManager
                                                .client
                                                .getTask();
                                            TaskData taskData =
                                                TaskData().fromJson(result);
                                            dispatch(RenWuActionCreator.onTask(
                                                taskData));
                                          });
                                        }
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          getBoxImage(state, e.value),
                                          width: Dimens.pt56,
                                          height: Dimens.pt56,
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(
                                                bottom: Dimens.pt11),
                                            padding: EdgeInsets.only(
                                              left: Dimens.pt6,
                                              right: Dimens.pt6,
                                              top: Dimens.pt4,
                                              bottom: Dimens.pt4,
                                            ),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(Dimens.pt10)),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Color.fromRGBO(
                                                        236, 150, 62, 1),
                                                    Color.fromRGBO(
                                                        243, 66, 56, 1),
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight),
                                              boxShadow: [
                                                BoxShadow(
                                                  //阴影
                                                  color: Color.fromRGBO(
                                                      255, 200, 79, 1),
                                                  offset: Offset(0.0, 2.0),
                                                  blurRadius: 4.0,
                                                  spreadRadius: 0.0,
                                                ),
                                              ],
                                            ),
                                            child: Text(
                                              state.taskData == null
                                                  ? ""
                                                  : e.value.prizes[0].name,
                                              style: TextStyle(
                                                  fontSize: Dimens.pt10,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            )),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              LinearPercentIndicator(
                                lineHeight: Dimens.pt8,
                                animateFromLastPercent: true,
                                percent: (state.taskData.jewelBoxDetails.value >= state.taskData.jewelBoxDetails.totalValue) ?
                                1.0 : state.taskData.jewelBoxDetails.value /
                                    state.taskData.jewelBoxDetails.totalValue,
                                padding: EdgeInsets.only(
                                    left: Dimens.pt21, right: Dimens.pt21),
                                backgroundColor:
                                    Color.fromRGBO(216, 216, 216, 1),
                                progressColor: Colors.red,
                              ),
                              SizedBox(
                                height: Dimens.pt8,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: state.taskData.jewelBoxDetails.xList
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  return Text(
                                    "${e.value.finishCondition}活跃值",
                                    style: TextStyle(
                                        fontSize: Dimens.pt12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.5)),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        ListView.builder(
                          itemCount: state.taskData.taskList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                await taskOnClick(state, index, viewService,dispatch);
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: Dimens.pt16,
                                ),
                                height: Dimens.pt90,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimens.pt8)),
                                ),
                                padding: EdgeInsets.only(
                                  left: Dimens.pt16,
                                  right: Dimens.pt10,
                                  top: Dimens.pt10,
                                  bottom: Dimens.pt6,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          state.taskData.taskList[index].title,
                                          style: TextStyle(
                                              fontSize: Dimens.pt16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),

                                        ///任务的领取按钮
                                        GestureDetector(
                                          onTap: () async{
                                            ///可以领取
                                            if (state.taskData.taskList[index]
                                                .status ==
                                                2) {
                                              await taskOnClick(state, index, viewService,dispatch);
                                              ///未完成
                                            }else if(state.taskData.taskList[index]
                                                .status ==
                                                1){
                                              if(state.taskData.taskList[index].boonType == 3){
                                                //Navigator.of(context).pop();
                                                //bus.emit(EventBusUtils.louFengPage);
                                                await taskOnClick(state, index, viewService,dispatch);
                                              }else if(state.taskData.taskList[index].boonType == 4){
                                                /*Navigator.of(context).pop();
                                                Navigator.of(context).push(MaterialPageRoute(
                                                  builder: (context) {
                                                    return GameWalletPage().buildPage(null);
                                                  },
                                                )).then((value) {

                                                });*/
                                                await taskOnClick(state, index, viewService,dispatch);
                                              }
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(Dimens.pt10)),
                                              gradient: state
                                                          .taskData
                                                          .taskList[index]
                                                          .status ==
                                                      3
                                                  ? LinearGradient(
                                                  colors: [
                                                    Colors.grey,
                                                    Colors.grey,
                                                  ],
                                                  begin:
                                                  Alignment.topCenter,
                                                  end: Alignment
                                                      .bottomCenter)
                                                  : LinearGradient(
                                            colors: [
                                            Color.fromRGBO(
                                            245, 22, 78, 1),
                                              Color.fromRGBO(
                                                  255, 101, 56, 1),
                                              Color.fromRGBO(
                                                  245, 68, 4, 1),
                                              ],
                                          begin:
                                          Alignment.topCenter,
                                          end: Alignment
                                              .bottomCenter),
                                              boxShadow: [
                                                BoxShadow(
                                                  //阴影
                                                  color: state
                                                              .taskData
                                                              .taskList[index]
                                                              .status ==
                                                          2
                                                      ? Color.fromRGBO(
                                                          248, 44, 44, 0.4)
                                                      : Colors.grey,
                                                  offset: Offset(0.0, 1.0),
                                                  blurRadius: 8.0,
                                                  spreadRadius: 0.0,
                                                ),
                                              ],
                                            ),
                                            height: Dimens.pt20,
                                            width: Dimens.pt50,
                                            child: Text(
                                              state
                                                  .taskData
                                                  .taskList[index]
                                                  .status ==
                                                  1 ? "去完成" : state
                                                  .taskData
                                                  .taskList[index]
                                                  .status ==
                                                  2 ? "领取" : "已领取",
                                              style: TextStyle(
                                                  fontSize: Dimens.pt12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    ///SizedBox(height: Dimens.pt8,),

                                    Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          state.taskData.taskList[index].desc,
                                          style: TextStyle(
                                              fontSize: Dimens.pt12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        )),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svg/icon_gold_coin.svg",
                                          height: Dimens.pt16,
                                          width: Dimens.pt16,
                                        ),
                                        SizedBox(
                                          width: Dimens.pt3,
                                        ),
                                        Text(
                                          state.taskData.taskList[index]
                                              .prizes[1].name,
                                          style: TextStyle(
                                              fontSize: Dimens.pt12,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  253, 147, 0, 1)),
                                        ),
                                        SizedBox(
                                          width: Dimens.pt13,
                                        ),
                                        Image.asset(
                                          "assets/images/huoyue.png",
                                          height: Dimens.pt13,
                                          width: Dimens.pt13,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: Dimens.pt8,
                                        ),
                                        Text(
                                          state.taskData.taskList[index]
                                              .prizes[0].name,
                                          style: TextStyle(
                                              fontSize: Dimens.pt12,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromRGBO(
                                                  255, 141, 208, 1)),
                                        ),
                                      ],
                                    ),

                                    Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "${state.taskData.taskList[index].finishValue}/${state.taskData.taskList[index].finishCondition}",
                                          style: TextStyle(
                                              fontSize: Dimens.pt12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        )),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
  );
}

Future taskOnClick(RenWuState state, int index, ViewService viewService,Dispatch dispatch) async {
  dynamic result = await netManager.client
      .getTaskDetail(state
          .taskData.taskList[index].boonType);
  TaskDetailData taskDetail =
      TaskDetailData().fromJson(result);

  showDialog(
      context: viewService.context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10)),
          child: StatefulBuilder(
            builder: (context, states) {
              return Container(
                height: Dimens.pt450,
                margin: EdgeInsets.only(
                  left: Dimens.pt8,
                  right: Dimens.pt8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: Dimens.pt16,
                    ),
                    Container(
                        child: Text(
                      state.taskData
                          .taskList[index].title,
                      style: TextStyle(
                          fontSize: Dimens.pt22,
                          fontWeight:
                              FontWeight.w600,
                          color: Colors.black),
                    )),
                    SizedBox(
                      height: Dimens.pt20,
                    ),
                    Container(
                        alignment:
                            Alignment.centerLeft,
                        child: Text(
                          state
                                      .taskData
                                      .taskList[
                                          index]
                                      .boonType ==
                                  3
                              ? "今日累计消费(金币)：${taskDetail.value}"
                              : state
                                          .taskData
                                          .taskList[
                                              index]
                                          .boonType ==
                                      4
                                  ? "昨日累计充值(¥)：${taskDetail.value}"
                                  : "",
                          style: TextStyle(
                              fontSize:
                                  Dimens.pt16,
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  Colors.black),
                        )),
                    SizedBox(
                      height: Dimens.pt22,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: taskDetail
                            .taskList.length,
                        itemBuilder:
                            (context, indexs) {

                          return Container(
                            height: Dimens.pt49,
                            margin:
                                EdgeInsets.only(
                                    bottom: Dimens
                                        .pt20),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(
                                        0xFFFF0000),
                                    width: 1),
                                color:
                                    Colors.white,
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            (6))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromRGBO(
                                              255,
                                              0,
                                              0,
                                              1),
                                          width:
                                              1),
                                      color: Colors
                                          .white,
                                      borderRadius:
                                          BorderRadius.all(
                                              Radius.circular(12))),
                                  margin:
                                      EdgeInsets
                                          .only(
                                    left: Dimens
                                        .pt2,
                                  ),
                                  padding: EdgeInsets.only(
                                      left: Dimens
                                          .pt9,
                                      right: Dimens
                                          .pt9,
                                      top: Dimens
                                          .pt4,
                                      bottom: Dimens
                                          .pt4),
                                  child: Text(
                                    state.taskData.taskList[index]
                                                .boonType ==
                                            3
                                        ? "消费${taskDetail.taskList[indexs].finishCondition}金币"
                                        : state.taskData.taskList[index].boonType == 4
                                            ? "¥ ${taskDetail.taskList[indexs].finishCondition}"
                                            : "",
                                    style: TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                        color: Colors
                                            .black,
                                        fontSize:
                                            Dimens
                                                .pt10),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      Dimens.pt8,
                                ),
                                Text(
                                  "奖励",
                                  style: TextStyle(
                                      color: Colors
                                          .black,
                                      fontSize:
                                          Dimens
                                              .pt12,
                                      fontWeight:
                                          FontWeight
                                              .w600),
                                ),
                                SizedBox(
                                  width:
                                      Dimens.pt6,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture
                                            .asset(
                                          "assets/svg/icon_gold_coin.svg",
                                          height:
                                              Dimens.pt16,
                                          width: Dimens
                                              .pt16,
                                        ),
                                        SizedBox(
                                          width: Dimens
                                              .pt3,
                                        ),
                                        Text(
                                          taskDetail
                                              .taskList[indexs]
                                              .prizes[1]
                                              .name,
                                          style: TextStyle(
                                              fontSize: Dimens
                                                  .pt12,
                                              fontWeight: FontWeight
                                                  .w600,
                                              color: Color.fromRGBO(
                                                  253,
                                                  147,
                                                  0,
                                                  1)),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Image
                                            .asset(
                                          "assets/images/huoyue.png",
                                          height:
                                              Dimens.pt13,
                                          width: Dimens
                                              .pt13,
                                          fit: BoxFit
                                              .cover,
                                        ),
                                        SizedBox(
                                          width: Dimens
                                              .pt8,
                                        ),
                                        Text(
                                          taskDetail
                                              .taskList[indexs]
                                              .prizes[0]
                                              .name,
                                          style: TextStyle(
                                              fontSize: Dimens
                                                  .pt12,
                                              fontWeight: FontWeight
                                                  .w600,
                                              color: Color.fromRGBO(
                                                  255,
                                                  141,
                                                  208,
                                                  1)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap:
                                      () async {

                                    ///站群
                                    if(state.taskData.taskList[index].boonType == 3){
                                      ///去完成
                                      if(taskDetail.taskList[indexs].status == 1){
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        bus.emit(EventBusUtils.louFengPage);
                                      }else if(taskDetail.taskList[indexs].status == 2){
                                        dynamic result = await netManager.client.getBox(
                                            taskDetail
                                                .taskList[
                                            indexs]
                                                .id,
                                            state.taskData.taskList[index].boonType ==
                                                3
                                                ? 3
                                                : 4);

                                        if(result == "success"){
                                          // 注意不是调用老页面的setState，而是要调用builder中的setState。
                                          //在这里为了区分，在构建builder的时候将setState方法命名为了state。

                                          dynamic results = await netManager.client
                                              .getTaskDetail(state
                                              .taskData.taskList[index].boonType);


                                          taskDetail = TaskDetailData().fromJson(results);

                                          states(() {});
                                        }
                                      }
                                      ///棋牌
                                    }else if(state.taskData.taskList[index].boonType == 4){
                                      ///去完成
                                      if(taskDetail.taskList[indexs].status == 1){
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        //
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) {
                                            return GameWalletPage().buildPage(null);
                                          },
                                        )).then((value) {

                                        });
                                      }else if(taskDetail.taskList[indexs].status == 2){
                                        dynamic result = await netManager.client.getBox(
                                            taskDetail
                                                .taskList[
                                            indexs]
                                                .id,
                                            state.taskData.taskList[index].boonType ==
                                                3
                                                ? 3
                                                : 4);

                                        if(result == "success"){
                                          // 注意不是调用老页面的setState，而是要调用builder中的setState。
                                          //在这里为了区分，在构建builder的时候将setState方法命名为了state。

                                          dynamic results = await netManager.client
                                              .getTaskDetail(state
                                              .taskData.taskList[index].boonType);


                                          taskDetail = TaskDetailData().fromJson(results);

                                          states(() {});
                                        }
                                      }
                                    }
                                  },
                                  child:
                                      Container(
                                    alignment:
                                        Alignment
                                            .center,
                                    //margin: EdgeInsets.only(right: Dimens.pt4),
                                    decoration:
                                        BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(
                                              Radius.circular(Dimens.pt10)),
                                      gradient: taskDetail.taskList[indexs].status ==
                                          1 ||  taskDetail.taskList[indexs].status ==
                                              2
                                          ? LinearGradient(
                                              colors: [
                                                  Color.fromRGBO(245, 22, 78, 1),
                                                  Color.fromRGBO(255, 101, 56, 1),
                                                  Color.fromRGBO(245, 68, 4, 1),
                                                ],
                                              begin: Alignment
                                                  .topCenter,
                                              end: Alignment
                                                  .bottomCenter)
                                          : LinearGradient(
                                              colors: [
                                                  Colors.grey,
                                                  Colors.grey,
                                                ],
                                              begin:
                                                  Alignment.topCenter,
                                              end: Alignment.bottomCenter),
                                      boxShadow: [
                                        BoxShadow(
                                          //阴影
                                          color: taskDetail.taskList[indexs].status ==
                                              1 || taskDetail.taskList[indexs].status ==
                                                  2
                                              ? Color.fromRGBO(
                                                  248,
                                                  44,
                                                  44,
                                                  0.4)
                                              : Colors.grey,
                                          offset: Offset(
                                              0.0,
                                              1.0),
                                          blurRadius:
                                              8.0,
                                          spreadRadius:
                                              0.0,
                                        ),
                                      ],
                                    ),
                                    height: Dimens
                                        .pt20,
                                    width: Dimens
                                        .pt50,
                                    child: Text(
                                      taskDetail.taskList[indexs].status == 1  ? "去完成" : taskDetail.taskList[indexs].status == 2 ? "领取" : "已领取",
                                      style: TextStyle(
                                          fontSize:
                                              Dimens
                                                  .pt12,
                                          fontWeight:
                                              FontWeight
                                                  .w600,
                                          color: Colors
                                              .white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }).then((value) {
         dispatch(RenWuActionCreator.onAction());
      });
}

getBoxImage(
    RenWuState state, TaskDataJewelBoxDetailsList taskDataJewelBoxDetailsList) {
  if (state.taskData == null) {
    return "assets/images/bao_xiang_hui.png";
  } else {
    switch (taskDataJewelBoxDetailsList.status) {
      case 1:
        return "assets/images/bao_xiang_hui.png";
        break;
      case 2:
        return "assets/images/bao_xiang_liang.png";
        break;
      case 3:
        return "assets/images/bao_xiang_open.png";
        break;
    }
  }
}
