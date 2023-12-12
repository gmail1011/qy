import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/common/net/code.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/alipay_bank_list_model.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/wallet/alipay_ccdcapi_model.dart';
import 'package:flutter_app/model/wallet/withdraw_config_data.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/new_page/recharge/bank_card_home_page.dart';
import 'package:flutter_app/new_page/recharge/withdraw_record_page.dart';
import 'package:flutter_app/page/alert/vip_rank_alert.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:get/route_manager.dart' as Gets;

///提现
class WithdrawPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WithdrawPageState();
  }
}

class _WithdrawPageState extends State<WithdrawPage> {
  WithdrawConfig configData;
  UserInfoModel meInfo;
  WalletModelEntity wallet;
  int withdrawType = 1; // 0支付宝 1银行卡

  num handlingFee = 0; //手续费
  num actualAmount = 0; //实际到账金额

  AccountInfoModel bankCard;

  TextEditingController moneyController = TextEditingController();


  TextEditingController usdtController = TextEditingController();

  BaseRequestController requestController = BaseRequestController();

  Map<String, int> selectMap = {};

  @override
  void initState() {
    super.initState();

    selectMap["alipay"] = 0;

    selectMap["usdt"] = 1;

    _initData();
  }

  void _initData() async {
    try {
      await GlobalStore.refreshWallet();

      meInfo = GlobalStore.getMe();
      wallet = GlobalStore.getWallet();
      await _withdrawConfigReq();

      requestController.requestSuccess();
      setState(() {});
    } catch (e) {
      l.e("_initData", e);
      requestController.requestFail();
    }
  }

  ///计算提现手续费、实际到账金额
  void _calcWithdrawAmount(String withdrawAmount) {
    try {
      if ((withdrawAmount ?? "").isEmpty) {
        handlingFee = 0;
        actualAmount = 0;
      } else {
        num withdrawAmoutNum = num.parse(withdrawAmount);
        int gameTax = configData?.gameTax ?? 0;
        if (gameTax == 0) {
          handlingFee = 0;
          actualAmount = withdrawAmoutNum;
        } else {
          handlingFee = withdrawAmoutNum * (gameTax / 100);
          actualAmount = withdrawAmoutNum - handlingFee;
        }
      }
    } catch (e) {
      l.e("计算提现手续费、实际到账金额", "$e");
    }
  }

  ///获取提现金额范围
  String _getPayMoneyRange() {
    try {
      int minMoney = configData?.channels[withdrawType]?.minMoney ?? 0;
      int maxMoney = configData?.channels[withdrawType]?.maxMoney ?? 0;
      return "${minMoney / 100}-${maxMoney / 100}";
    } catch (e) {}
    return "0";
  }

  ///提现配置请求
  Future<void> _withdrawConfigReq() async {
    try {
      configData = await netManager.client.withdrawConfig();
      if (configData != null) {
        if ((configData?.channels?.length ?? 0) > 1) {
          withdrawType = 1;
        } else {
          withdrawType = 0;
        }
      }
    } catch (e) {
      l.e("configData-e->", "$e");
    }
  }

  ///提交提现
  void _submitWithdraw() async {
    try {
      if (!GlobalStore.isVIP()) {
        VipRankAlert.show(context, type: VipAlertType.vipWithdraw);
        return;
      }

      Channel channel = configData?.channels[withdrawType];
      if ("bankcard" == channel?.payType) {
        //检验银行卡信息
        _bankNumberVerifyReq();
      } else if ("alipay" == channel?.payType || "usdt" == channel?.payType) {
        _commonWithdrawReq(false);
      }
    } catch (e) {
      showToast(msg: "提现错误:$e");
    }
  }



  ///提交提现
  void _submitWithdrawForUsdt() async {
    try {

      if (!GlobalStore.isVIP()) {
        VipRankAlert.show(context, type: VipAlertType.vipWithdraw);
        return;
      }

      _commonWithdrawReqForUsdt(false);

    } catch (e) {
      showToast(msg: "提现错误:$e");
    }
  }

  ///公用提现方法
  void _commonWithdrawReq(bool isbankType, {String bank}) async {
    try {
      Channel channel = configData?.channels[withdrawType];
      String money = moneyController?.text?.trim() ?? "";

      if (money.isEmpty) {
        showToast(msg: "提现金额不能为空");
        return;
      }

      if (bankCard == null) {
        showToast(msg: "请选择提现账号");
        return;
      }

      double incomeMoneyYuan = (wallet?.income ?? 0) / 10;
      int withdrawMoneyYuan = int.parse(money);
      if (withdrawMoneyYuan > incomeMoneyYuan) {
        showToast(msg: "提现金额不能大于余额");
        return;
      }

      int minMoneyFen = configData?.channels[withdrawType].minMoney ?? 0;
      double minMoneyYuan = minMoneyFen / 100;
      if (withdrawMoneyYuan < minMoneyYuan) {
        showToast(msg: "单笔提现金额不小于$minMoneyYuan元");
        return;
      }
      int maxMoneyFen = configData?.channels[withdrawType].maxMoney ?? 0;
      double maxMoneyYuan = maxMoneyFen / 100;
      if (withdrawMoneyYuan > maxMoneyYuan) {
        showToast(msg: "单笔提现金额不大于$maxMoneyYuan元");
        return;
      }

      WBLoadingDialog.show(context);

      String deviceId = await getDeviceId();
      String payType = channel?.payType;
      //payType 提现方式，alipay，bankcard，usdt
      //money  提现金额
      //name 用户名
      //withdrawType 提现类型，0，代理提现； 1，金币提现
      //actName 交易账户持有人
      //act 交易账户
      //devID 设备id
      //productType 产品类型 0站群 1棋牌
      var result = await netManager.client.withdraw(
        payType,
        bankCard?.act,
        withdrawMoneyYuan * 100,
        GlobalStore.getMe()?.name ?? "",
        bankCard.actName ?? "",
        deviceId,
        bankCard.bankCode ?? "",
        1,
        0,
      );
      WBLoadingDialog.dismiss(context);

      l.e("withdraw-提现结果：", "$result");
      await GlobalStore.refreshWallet(true);

      showToast(msg: "提现提交成功～");

      moneyController.clear();

      setState(() {});
    } catch (e) {
      l.e("withdraw-e：", "$e");
      WBLoadingDialog.dismiss(context);
      showToast(msg: "提现失败～");
    }
  }






  void _commonWithdrawReqForUsdt(bool isbankType, {String bank}) async {
    try {
      String money = moneyController?.text?.trim() ?? "";

      if (money.isEmpty) {
        showToast(msg: "提现金额不能为空");
        return;
      }

      if (usdtController.text.trim() == null || usdtController.text.trim() == "" ) {
        showToast(msg: "请选择提现账号");
        return;
      }

      double incomeMoneyYuan = (wallet?.income ?? 0) / 10;
      int withdrawMoneyYuan = int.parse(money);
      if (withdrawMoneyYuan > incomeMoneyYuan) {
        showToast(msg: "提现金额不能大于余额");
        return;
      }

      int minMoneyFen = configData?.channels[withdrawType].minMoney ?? 0;
      double minMoneyYuan = minMoneyFen / 100;
      if (withdrawMoneyYuan < minMoneyYuan) {
        showToast(msg: "单笔提现金额不小于$minMoneyYuan元");
        return;
      }
      int maxMoneyFen = configData?.channels[withdrawType].maxMoney ?? 0;
      double maxMoneyYuan = maxMoneyFen / 100;
      if (withdrawMoneyYuan > maxMoneyYuan) {
        showToast(msg: "单笔提现金额不大于$maxMoneyYuan元");
        return;
      }

      WBLoadingDialog.show(context);

      String deviceId = await getDeviceId();
      String payType = "usdt";
      //payType 提现方式，alipay，bankcard，usdt
      //money  提现金额
      //name 用户名
      //withdrawType 提现类型，0，代理提现； 1，金币提现
      //actName 交易账户持有人
      //act 交易账户
      //devID 设备id
      //productType 产品类型 0站群 1棋牌
      var result = await netManager.client.withdraw(
        payType,
        usdtController.text.trim(),
        withdrawMoneyYuan * 100,
        GlobalStore.getMe()?.name ?? "",
        "",
        deviceId,
        "",
        1,
        0,
      );
      WBLoadingDialog.dismiss(context);

      l.e("withdraw-提现结果：", "$result");
      await GlobalStore.refreshWallet(true);

      showToast(msg: "提现提交成功～");

      moneyController.clear();

      usdtController.clear();

      setState(() {});
    } catch (e) {
      l.e("withdraw-e：", "$e");
      WBLoadingDialog.dismiss(context);
      showToast(msg: "提现失败～");
    }
  }





  ///校验银行卡信息
  void _bankNumberVerifyReq() async {
    String bankNum = bankCard.act;
    if (bankNum.isEmpty || bankNum.length < 13) {
      showToast(msg: "银行卡号错误");
      return;
    }
    DioCli().getJSON(Address.ALI_CCD_API + bankNum).then((ret) {
      // dispatch(WithDrawActionCreator.refreshUI());
      if (ret.err != null) {
        showToast(msg: "银行卡验证失败.");
        return;
      }
      final res = ret.data;
      if (res.statusCode == Code.SUCCESS) {
        ApcApiModel model = ApcApiModel.fromMap(res.data);
        if (model.validated) {
          // model.bank, model.cardType
          l.e("model.bank-->", "${model.bank}");
          l.e("model.cardType-->", "${model.cardType}");
          _commonWithdrawReq(true, bank: model?.bank);
        } else {
          showToast(msg: "银行卡验证失败");
        }
      } else {
        showToast(msg: "银行卡验证失败");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        appBar: CustomAppbar(
          title: "立即提现",
          actions: [
            InkWell(
                onTap: () {
                  Gets.Get.to(() => WithdrawRecordPage(), opaque: false);
                }, // 提现记录
                child: Text(
                  "提现记录",
                  style: const TextStyle(
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0),
                ))
          ],
        ),
        body: BaseRequestView(
          controller: requestController,
          retryOnTap: () => _initData(),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Container(
                        width: 343,
                        height: 102,
                        color: Color.fromRGBO(255, 255, 255, 0.1),
                      ),
                      Positioned(
                        top: 12,
                        left: 0,
                        child: Container(
                          width: 8,
                          height: 22,
                          decoration: BoxDecoration(
                            color: AppColors.primaryTextColor,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(4), bottomRight: Radius.circular(4)),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 14,
                          left: 18,
                          child: Text(
                            "余额(元)",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          )),
                      Positioned(
                          top: 45,
                          left: 26,
                          child: Text(
                            GlobalStore.getWallet().income == null
                                ? 0
                                : "${GlobalStore.getWallet().income ~/ 10}",
                            style: TextStyle(color: Colors.white, fontSize: 32),
                          )),
                    ],
                  ),

                  /*Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Text(
                            "可提金额（元）：",
                            style: const TextStyle(
                                color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 12.0),
                          ),
                          Text(
                            "${(wallet?.income ?? 0) ~/ 10}",
                            style: const TextStyle(
                                color: const Color(0xffca452e), fontWeight: FontWeight.w900, fontSize: 20.0),
                          )
                        ],
                      ),
                    ),*/

                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "提现币类 :  ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "人民币",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "提现金额 :  ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        height: 36,
                        width: 250,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                            color: const Color(0xff242424)),
                        child: TextField(
                          controller: moneyController,
                          maxLines: 1,
                          autocorrect: true,
                          autofocus: false,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              textBaseline: TextBaseline.alphabetic),
                          decoration: InputDecoration(
                            hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                            hintText: "请输入${_getPayMoneyRange()}范围内的值",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) => _calcWithdrawAmount(value),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "提现方式 :  ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/yinlian.png",
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "银行卡",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Radio(
                            value: selectMap["alipay"],
                            activeColor: Color(0xffca452e),
                            focusColor: Color(0xFF4F515A),
                            onChanged: (value) {

                              selectMap["alipay"] = 0;

                              selectMap["usdt"] = 1;

                              setState(() {

                              });

                            },
                            groupValue: 0,
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            "assets/images/usdt.png",
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 6),
                          Text(
                            "USDT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Radio(
                            value: selectMap["usdt"],
                            activeColor: Color(0xffca452e),
                            focusColor: Color(0xFF4F515A),
                            onChanged: (value) {

                              selectMap["alipay"] = 1;

                              selectMap["usdt"] = 0;

                              setState(() {

                              });

                            },
                            groupValue: 0,
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 16),


                  Offstage(
                    offstage: selectMap["alipay"] == 0 ? false : true,
                    child: Row(
                      children: [
                        Text(
                          "银行卡号 :  ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await Gets.Get.to(() => BankCardHomePage(true),
                                opaque: false)
                                .then((value) => setState(() {
                              bankCard = value;
                            }));
                          },
                          child: Container(
                            height: 36,
                            width: 250,
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(2)),
                                color: const Color(0xff242424)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  bankCard == null
                                      ? "请选择提现账号"
                                      : "${bankCard.act}-${bankCard.actName}",
                                  style: TextStyle(
                                      color: bankCard == null
                                          ?  Colors.white.withOpacity(0.6)
                                          : Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0),
                                ),
                                Icon(Icons.keyboard_arrow_right,
                                    color: Colors.white.withOpacity(0.6), size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),




                  Offstage(
                    offstage: selectMap["usdt"] == 0 ? false : true,
                    child: Row(
                      children: [
                        Text(
                          "USDT地址 :  ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          height: 36,
                          width: 240,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(2)),
                              color: const Color(0xff242424)),
                          child: TextField(
                            controller: usdtController,
                            maxLines: 1,
                            autocorrect: true,
                            autofocus: false,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                textBaseline: TextBaseline.alphabetic),
                            decoration: InputDecoration(
                              hintStyle:
                              TextStyle(color:  Colors.white.withOpacity(0.6), fontSize: 14),
                              hintText: "请输入USDT地址",
                              border: InputBorder.none,
                            ),
                            /*onChanged: (value) => _calcWithdrawAmount(value),*/
                          ),
                        ),
                      ],
                    ),
                  ),





                  SizedBox(height: 20),
                  RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            style: const TextStyle(
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w900,
                                fontSize: 12.0),
                            text: "合计扣除"),
                        TextSpan(
                            style: const TextStyle(
                                color: const Color(0xffca452e),
                                fontWeight: FontWeight.w900,
                                fontSize: 12.0),
                            text: "$handlingFee元"),
                        TextSpan(
                            style: const TextStyle(
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w900,
                                fontSize: 12.0),
                            text: "\t实际到账:"),
                        TextSpan(
                            style: const TextStyle(
                                color: const Color(0xffca452e),
                                fontWeight: FontWeight.w900,
                                fontSize: 12.0),
                            text: "$actualAmount元")
                      ])),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                  Text(
                    "提现规则：",
                    style: const TextStyle(
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.w900,
                        fontSize: 12.0),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "1、每次提现金额最低${(configData?.channels == null ? 0 : configData?.channels[withdrawType].minMoney ?? 0) ~/ 100}元起，"
                        "单笔提现最大${(configData?.channels == null ? 0 : configData?.channels[withdrawType].maxMoney ?? 0) ~/ 100}元，且为整数。\n"
                        "2、每次提现收取15%手续费。\n"
                        "3、收款账户卡号和姓名必须一致,为避免恶意刷单,到账时间为T+15天 \n"
                        "4、银行卡每次提现最低200元起,USDT每次提现最低2000元起 \n",
                    style: const TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1),
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                        height: 1.7),
                  ),

                  SizedBox(height: 46,),

                  InkWell(
                    onTap: () => selectMap["alipay"] == 0 ? _submitWithdraw() : _submitWithdrawForUsdt(),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      height: 47,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(26)),
                          gradient: AppColors.linearBackGround),
                      child: Center(
                        child: // 确定
                        Text(
                          "确定提现",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),



                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "提现将在15个工作日内到账，如未收到，请联系",
                        style: const TextStyle(
                            color: Color.fromRGBO(227, 227, 227, 1),
                            fontSize: 12.0),
                      ),


                      SizedBox(width: 6,),


                      GestureDetector(
                        onTap: (){
                          csManager.openServices(context);
                        },
                        child: Text(
                          "在线客服",
                          style: const TextStyle(
                              color: Color(0xffca452e),
                              fontSize: 12.0),
                        ),
                      ),


                    ],
                  ),


                  SizedBox(height: 20,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
