import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/model/wallet/recharge_list_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/new_page/recharge/recharge_record_page.dart';
import 'package:flutter_app/page/wallet/pay_for/model.dart';
import 'package:flutter_app/page/wallet/pay_for/state.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'gold_record_page.dart';

///充值金币
class RechargeGoldPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RechargeGoldPageState();
  }
}

class _RechargeGoldPageState extends State<RechargeGoldPage> {
  /// 金币
  List<RechargeTypeModel> rechargeType = [];
  bool paying = false; //是否处于支付中
  RechargeTypeModel selectItem;

  ///代充
  DCModel dcModel;

  WalletModelEntity wallet;
  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();

  @override
  void initState() {
    super.initState();
    wallet = GlobalStore.getWallet();
    _getRecharges();
  }

  /// 获取充值金币列表
  void _getRecharges() async {
    try {
      RechargeListModel model = await netManager.client.getNakeChatRechargeTypeList(1);
      if (null != model) {
        VariableConfig.rechargeType = model.list;
        rechargeType = model.list;
        for (int i = 0; i < (model.list?.length ?? 0); i++) {
          var rechargeModel = model.list[i];
          if (rechargeModel.hotStatus == true) {
            selectItem = rechargeModel;
            break;
          }
        }
        if (selectItem == null) selectItem = model.list?.first;
        if (model.daichong != null) {
          dcModel = model.daichong;
        }
        requestController.requestSuccess();
      } else {
        requestController.requestDataEmpty();
      }
      setState(() {});
    } catch (e) {
      requestController.requestFail();
    }
  }

  // /// 获取充值金币列表
  // void _getTickets() async {
  //   try {
  //     dynamic model = await netManager.client.getTickets(1,100,1);
  //     if (null != model) {
  //       VariableConfig.goldTickets = GoldTickets.fromJson(model);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        appBar: CustomAppbar(
          title: "金币充值",
          actions: [
            InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return RechargeRecordPage();
                  }));
                },
                child: Container(
                  child: Text(
                    "充值记录",
                    style: const TextStyle(
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                    ),
                  ),
                ))
          ],
        ),
        body: Column(children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 20),
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(24)),
              color: const Color.fromRGBO(32, 32, 32, 1),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Text(
                "金币余额",
                style: const TextStyle(
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: Color(0xff787878),
                margin: EdgeInsets.symmetric(horizontal: 10),
              ),
              // 0000
              Text(
                "${wallet?.amount ?? 0}",
                style: const TextStyle(
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w600,
                  fontSize: 32.0,
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return GoldRecordPage();
                  }));
                },
                child: Text(
                  "金币明细",
                  style: const TextStyle(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                ),
              )
            ]),
          ),
          SizedBox(
            height: 13,
          ),
          Expanded(
            child: Container(
              child: BaseRequestView(
                controller: requestController,
                child: Stack(children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: pullYsRefresh(
                      enablePullDown: false,
                      refreshController: refreshController,
                      onRefresh: () async {
                        Future.delayed(Duration(milliseconds: 1000), () {});
                      },
                      child: GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 128 / 152),
                          itemCount: rechargeType.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildGoldItemView(index, rechargeType[index]);
                          }),
                    ),
                  ),
                ]),
              ),
            ),
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(color: const Color.fromRGBO(27, 28, 33, 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (rechargeType == null && dcModel == null) {
                      return;
                    }
                    var arg = PayForArgs();
                    arg.dcModel = dcModel;
                    arg.rechargeModel = selectItem;
                    showPayListDialog(context, arg);
                  },
                  child: Container(
                    height: 47,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(90)),
                      gradient: AppColors.linearBackGround,
                    ),
                    child: Center(
                      child: // 立即支付 ¥****
                          Text(
                        "￥${selectItem == null ? 0 : selectItem.money ~/ 100} /立即支付",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // 支付问题反馈，点击联系在线客服
                InkWell(
                  onTap: () => csManager.openServices(context),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        style: const TextStyle(
                          color: const Color(0xffbfbfbf),
                          fontSize: 12.0,
                        ),
                        text: "支付问题反馈，点击联系在"),
                    TextSpan(
                        style: const TextStyle(
                          color: const Color(0xffe5c892),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                        ),
                        text: "在线客服"),
                  ])),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildGoldItemView(int index, RechargeTypeModel item) {
    bool isSelected = selectItem.id == item.id;
    var textColor = isSelected ? Color(0xff211211) : Color(0xffcccccc);
    return InkWell(
      onTap: () {
        setState(() {
          selectItem = item;
        });
      },
      child: Container(
        height: 151,
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          // border: Border.all(width: 1,color: item.id == selectItem.id ? AppColors.primaryTextColor : Color.fromRGBO(32, 32, 32, 1), ),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: item.id == selectItem.id
                  ? [
                      Color.fromRGBO(250, 227, 208, 1),
                      Color.fromRGBO(238, 199, 178, 1),
                      Color.fromRGBO(239, 202, 181, 1),
                    ]
                  : [
                      Color.fromRGBO(32, 32, 32, 1),
                      Color.fromRGBO(32, 32, 32, 1),
                    ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "${item.amount}金币",
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  "¥ ",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ), // 300
                Text(
                  "${item.money ~/ 100}",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
            Text(
              "${item.money ~/ 100 * 10}",
              style: TextStyle(
                color: isSelected ? Color(0xff783427) : Color(0xff999999),
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.lineThrough,
                decorationColor: textColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
