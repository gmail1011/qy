import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/game_page/bean/game_balance_entity.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'LoadingWidget.dart';

class TransferDialog extends StatefulWidget {
  String title;
  String content;
  String postiveText;
  String negativeText;
  Function negtiveMethod;
  Function postiveMethod;
  GameBalanceEntity gameBalanceEntity;

  TransferDialog({
    this.title,
    this.content,
    this.negativeText,
    this.postiveText,
    this.negtiveMethod,
    this.postiveMethod,
    this.gameBalanceEntity,
  });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CustomerDialogState();
  }
}

class _CustomerDialogState extends State<TransferDialog> {
  StreamController<String> streamGameBalanceController =
      StreamController.broadcast();
  StreamController<String> streamAppBalanceController =
      StreamController.broadcast();
  double _sliderValue = 5;
  double tempAmountValue;
  double tempStartAmountValue;
  double tempEndAmountValue;
  int totalMount;
  double defaultAmount;
  double defaultAmountPosition;
  int gameBalance;
  int appBalance;
  LoadingWidget loadingWidget;

  int currentCoinAmount;

  bool isTransferAppBalance = true;

  TextEditingController textEditingControllerGameBlance;
  TextEditingController textEditingControllerAppBlance;

  StreamController<bool> streamOffstageController =
      StreamController.broadcast();
  StreamController<int> streamOffstageSecondController =
      StreamController.broadcast();

  FocusNode zhuanRuFocus = FocusNode();
  FocusNode zhuanChuFocus = FocusNode();

  bool isZhuanChu = false;

  int transferTaxValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingControllerGameBlance = new TextEditingController();
    textEditingControllerAppBlance = new TextEditingController();

    transferTaxValue = 100 - Config.transferTax;

    ///首先把游戏钱包的余额加上App余额得到一个总额度
    ///App余额除以总额度得到一个游标初始化的比例
    ///初始化的比例位置乘以20得到游标的初始化的下标位置
    ///当游标移动的时候，每向左移动1个刻度，游戏余额便增加 1/20 * 总额度，App余额 = 总额 - 游戏余额
    ///每向右滑动，App余额
    loadingWidget = new LoadingWidget(
      title: "正在加载",
    );
    totalMount = widget.gameBalanceEntity.wlTransferable +
        widget.gameBalanceEntity.balance;
    defaultAmount = widget.gameBalanceEntity.balance / totalMount;

    ///游戏钱包和金币钱包余额都为0的情况下
    if (totalMount == 0) {
      _sliderValue = 10;
    } else {
      defaultAmountPosition = defaultAmount * 20;
      _sliderValue = 20 - defaultAmountPosition;
    }

    gameBalance = widget.gameBalanceEntity.wlTransferable;
    appBalance = widget.gameBalanceEntity.balance;

    currentCoinAmount = widget.gameBalanceEntity.balance;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          StreamBuilder<Object>(
              initialData: 0,
              stream: streamOffstageSecondController.stream,
              builder: (context, snapshot) {
                String title;
                if (snapshot.data == 0) {
                  title = "余额划拨";
                } else if (snapshot.data == 1) {
                  title = "转入至游戏钱包";
                } else if (snapshot.data == 2) {
                  title = "转出至金币钱包";
                }
                return Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                );
              }),
          SizedBox(
            height: 6,
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text(
                      "金币余额 : ",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    Text(
                      Config.gameBalanceEntity.balance.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "游戏余额 : ",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    Text(
                      Config.gameBalanceEntity.wlTransferable.toString(),
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StreamBuilder<Object>(
              initialData: true,
              stream: streamOffstageSecondController.stream,
              builder: (context, snapshot) {
                return Offstage(
                  offstage: snapshot.data == 1 ? false : true,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 15,
                      top: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("转入",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            SizedBox(
                              width: 6,
                            ),
                            Container(
                              width: 75,
                              child: TextField(
                                maxLines: 1,
                                focusNode: zhuanRuFocus,
                                controller: textEditingControllerAppBlance,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onChanged: (value) {
                                  streamAppBalanceController.add(value);
                                  if (value == null || value == "") {
                                    streamGameBalanceController.add(null);
                                  } else {
                                    textEditingControllerGameBlance.clear();
                                    streamGameBalanceController.add(null);
                                  }
                                },
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    hintText: "",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(fontSize: 12)),
                                cursorColor: Colors.black,
                              ),
                            ),
                            StreamBuilder<String>(
                                initialData: "0",
                                stream: streamAppBalanceController.stream,
                                builder: (context, snapshot) {
                                  double value;
                                  if (TextUtil.isEmpty(snapshot.data)) {
                                    value = 0;
                                  } else {
                                    value = (int.parse(snapshot.data) *
                                            (transferTaxValue / 100)) /
                                        10;
                                  }
                                  return Text(
                                    " ≈ " + value.toStringAsFixed(2) + "人民币",
                                    style: TextStyle(color: Colors.black),
                                  );
                                }),
                          ],
                        ),
                        Text(
                          "注意:金币钱包转入游戏钱包需扣除${Config.transferTax == 0 ? 0 : Config.transferTax}%手续费哦",
                          style: TextStyle(color: Colors.black, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          StreamBuilder<Object>(
              initialData: true,
              stream: streamOffstageSecondController.stream,
              builder: (context, snapshot) {
                return Offstage(
                  offstage: snapshot.data == 2 ? false : true,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 25,
                    ),
                    child: Row(
                      children: [
                        Text(
                          "转出",
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Container(
                          width: 75,
                          child: TextField(
                            maxLines: 1,
                            controller: textEditingControllerGameBlance,
                            focusNode: zhuanChuFocus,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              streamGameBalanceController.add(value);
                              if (value == null || value == "") {
                                streamAppBalanceController.add(null);
                              } else {
                                textEditingControllerAppBlance.clear();
                                streamAppBalanceController.add(null);
                              }
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                hintText: "",
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 12)),
                            cursorColor: Colors.black,
                          ),
                        ),
                        StreamBuilder<String>(
                            initialData: "0",
                            stream: streamGameBalanceController.stream,
                            builder: (context, snapshot) {
                              int value;
                              if (TextUtil.isEmpty(snapshot.data)) {
                                value = 0;
                              } else {
                                value = int.parse(snapshot.data) * 10;
                              }

                              return Text(
                                " ≈ " + value.toString() + "金币",
                                style: TextStyle(color: Colors.black),
                              );
                            }),
                      ],
                    ),
                  ),
                );
              }),
          Padding(
            padding: EdgeInsets.only(top: 25),
            child: StreamBuilder<Object>(
                initialData: false,
                stream: streamOffstageController.stream,
                builder: (context, snapshot) {
                  return Offstage(
                    offstage: snapshot.data,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            isZhuanChu = false;
                            streamOffstageController.add(true);
                            streamOffstageSecondController.add(1);

                            zhuanChuFocus.unfocus();
                            FocusScope.of(context).requestFocus(zhuanRuFocus);
                          },
                          child: Container(
                            width: 150,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22)),
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xfff5164e),
                                    Color(0xffff6538),
                                    Color(0xfff54404),
                                  ],
                                  stops: [
                                    0,
                                    1,
                                    1
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xfff82c2c).withOpacity(0.4),
                                    offset: Offset(0.0, 6),
                                    blurRadius: 8,
                                    spreadRadius: 0)
                              ],
                            ),
                            child: Text(
                              "转入至游戏钱包",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        GestureDetector(
                          onTap: () async {
                            isZhuanChu = true;
                            streamOffstageController.add(true);
                            streamOffstageSecondController.add(2);

                            zhuanRuFocus.unfocus();
                            FocusScope.of(context).requestFocus(zhuanChuFocus);
                          },
                          child: Container(
                            width: 150,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(22)),
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xfff5164e),
                                    Color(0xffff6538),
                                    Color(0xfff54404),
                                  ],
                                  stops: [
                                    0,
                                    1,
                                    1
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xfff82c2c).withOpacity(0.4),
                                    offset: Offset(0.0, 6),
                                    blurRadius: 8,
                                    spreadRadius: 0)
                              ],
                            ),
                            child: Text(
                              "转出至金币钱包",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
          Spacer(),
          StreamBuilder<Object>(
              initialData: false,
              stream: streamOffstageController.stream,
              builder: (context, snapshot) {
                return Offstage(
                  offstage: !snapshot.data,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          widget.negtiveMethod();
                        },
                        child: Container(
                          width: 107,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(22)),
                            color: Color.fromRGBO(199, 199, 199, 1),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                  offset: Offset(0.0, 6),
                                  blurRadius: 8,
                                  spreadRadius: 0)
                            ],
                          ),
                          child: Text(
                            widget.negativeText,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (currentCoinAmount == 0 &&
                              widget.gameBalanceEntity.wlTransferable == 0) {
                            showToast(msg: "请先充值");

                            return;
                          }

                          if (TextUtil.isEmpty(
                                  textEditingControllerGameBlance.text) &&
                              TextUtil.isEmpty(
                                  textEditingControllerAppBlance.text)) {
                            showToast(msg: "请输入金额");
                            return;
                          }

                          int transferAMount;

                          if (TextUtil.isEmpty(
                              textEditingControllerAppBlance.text)) {
                            transferAMount = int.parse(
                                    textEditingControllerGameBlance.text
                                        .toString()) *
                                10;
                          }

                          if (TextUtil.isEmpty(
                              textEditingControllerGameBlance.text)) {
                            transferAMount = -(int.parse(
                                textEditingControllerAppBlance.text));
                          }

                          loadingWidget.show(context);
                          await netManager.client
                              .transfer(transferAMount)
                              .catchError((onError) {
                            //showToast(msg: Config.transferResultEntity.tip == "" ? "划转失败" : Config.transferResultEntity.tip);
                            loadingWidget.cancel();
                          });

                          if (Config.transferResultEntity.code == 200) {
                            showToast(msg: "划转成功");
                            Navigator.of(context).pop(true);
                            loadingWidget.cancel();
                          } else {
                            //showToast(msg: Config.transferResultEntity.tip == "" ? "划转失败" : Config.transferResultEntity.tip);
                            loadingWidget.cancel();
                            return;
                          }
                        },
                        child: Container(
                          width: 107,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(22)),
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xfff5164e),
                                  Color(0xffff6538),
                                  Color(0xfff54404),
                                ],
                                stops: [
                                  0,
                                  1,
                                  1
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xfff82c2c).withOpacity(0.4),
                                  offset: Offset(0.0, 6),
                                  blurRadius: 8,
                                  spreadRadius: 0)
                            ],
                          ),
                          child: Text(
                            widget.postiveText,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
