import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/wallet/recharge_list_model.dart';
import 'package:flutter_app/page/wallet/pay_for/state.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/page/wallet/pay_for/model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'dialog/dialog_entry.dart';

/// 显示金币充值对话框
Future<int> showGoldCoinRechargeDialog(BuildContext ctx) async {
  return showModalBottomSheet(
    context: ctx,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
        child: Container(
          height: Dimens.pt330,
          color: AppColors.primaryColor,
          child: Column(
            children: <Widget>[
              Expanded(child: GoldCoinRechargeListView()),
            ],
          ),
        ),
      );
    },
  );
}

class GoldCoinRechargeListView extends StatefulWidget {
  @override
  _GoldCoinRechargeListViewState createState() =>
      _GoldCoinRechargeListViewState();
}

class _GoldCoinRechargeListViewState extends State<GoldCoinRechargeListView> {
  WalletModelEntity entity;

  /// 金币
  List<RechargeTypeModel> rechargeList = [];
  // 总model
  DCModel dcModel;
  bool isRefreshing = false;
  @override
  void initState() {
    super.initState();

    /*if (VariableConfig.rechargeType != null &&
        VariableConfig.rechargeType.isNotEmpty) {
      rechargeList = VariableConfig.rechargeType;
      setState(() {});
    } else {
      loadRechargeListData();
    }*/

    ///每次都重新加载，不使用以前的临时变量，坑
    loadRechargeListData();
    entity = GlobalStore.getWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(children: [
      Padding(
          padding: EdgeInsets.only(top: Dimens.pt20, bottom: Dimens.pt20),
          child: Text("購買金幣",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.pt20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none))),
      Padding(
        padding: EdgeInsets.only(bottom: Dimens.pt5),
        child: Container(
          color: Colors.black38.withOpacity(0.1),
          height: 1,
        ),
      ),
      (this.rechargeList != null && this.rechargeList.length > 0)
          ? Expanded(
              child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: Dimens.pt30,
                  ),
                  child: Column(
                    children: getRechargeList(),
                  )))
          : Expanded(child: Center(child: LoadingWidget()))
    ])));
  }

  ///load data
  loadRechargeListData() async {
    this.isRefreshing = true;
    RechargeListModel model;
    try {
      model = await netManager.client.getRechargeTypeList();
    } catch (e) {
      l.e("error", "_getRecharges()...error:$e");
    }
    if (null != model) {
      VariableConfig.rechargeType = model.list;
      this.dcModel = model.daichong;
      this.rechargeList = model.list;
    }
    this.isRefreshing = false;
    setState(() {});
  }

  /// pay widget list
  List<Widget> getRechargeList() {
    List<Widget> rechargeList = [];
    if (this.rechargeList != null && this.rechargeList.isNotEmpty) {
      var length = this.rechargeList?.length ?? 0;
      for (var i = 0; i < length; i++) {
        Widget row = InkWell(
          onTap: () => _showBottomSheet(this.rechargeList[i]),
          child: Container(
            width: screen.screenWidth,
            height: Dimens.pt70,
            margin: EdgeInsets.only(left: Dimens.pt16, right: Dimens.pt16),
            // margin: CustomEdgeInsets.only(left: 0, right: 16),
            padding: EdgeInsets.only(top: Dimens.pt5),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SvgPicture.asset(AssetsSvg.VIP_MEMBER_WALLET,
                            width: Dimens.pt44, height: Dimens.pt44),
                        Container(
                          margin: EdgeInsets.only(left: Dimens.pt10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                this.rechargeList != null
                                    ? (this.rechargeList[i].money ~/ 100)
                                            .toString() +
                                        Lang.GOLD_COINS
                                    : "",
                                style: TextStyle(
                                    fontSize: Dimens.pt16, color: Colors.white),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  svgAssets(
                                    AssetsSvg.IC_GOLD,
                                    width: Dimens.pt13,
                                    height: Dimens.pt13,
                                  ),
                                  Text(
                                    this.rechargeList != null
                                        ? "\t" +
                                            this
                                                .rechargeList[i]
                                                .amount
                                                .toString() +
                                            Lang.GOLD_COIN
                                        : '',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: Dimens.pt12,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(AssetsSvg.VIP_MEMBER_TOP_UP_NOW,
                        width: Dimens.pt74, height: Dimens.pt28),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: Dimens.pt5),
                  child: Container(
                    color: Colors.black38.withOpacity(0.1),
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        );
        rechargeList.add(row);
      }
    }
    return rechargeList;
  }

  ///pay dialog
  _showBottomSheet(RechargeTypeModel model) {
    if (this.isRefreshing == true) {
      showToast(msg: Lang.PAY_FOR_LOADING ?? '');
    } else {
      var arg = PayForArgs();
      arg.dcModel = this.dcModel;
      arg.rechargeModel = model;
      showPayListDialog(this.context, arg);
    }
  }
}
