import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/wallet/user_income_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/new_page/recharge/withdraw_page.dart';
import 'package:flutter_app/new_page/welfare/share_income_page.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/log.dart';

///推广明细
class ShareHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShareHomePageState();
  }
}

class _ShareHomePageState extends State<ShareHomePage> {
  UserInfoModel meInfo;
  WalletModelEntity wallet;

  BaseRequestController requestController = BaseRequestController();

  List<IncomeData> incomeList = [];
  UserIncomeModel record;

  @override
  void initState() {
    super.initState();
    meInfo = GlobalStore.getMe();
    wallet = GlobalStore.getWallet();
    _loadShareContent();
  }

  void _loadShareContent() async {
    try {
      record = await netManager.client.getUserAllIncomeInfo();
      requestController.requestSuccess();

      incomeList.add(IncomeData("当月收益（元）", record.monthIncomeAmount));
      incomeList.add(IncomeData("当月推广数", record.monthInviteUserCount));
      incomeList.add(IncomeData("今日收益（元）", record.todayIncomeAmount));
      incomeList.add(IncomeData("今日推广数", record.todayInviteUserCount));
      setState(() {});
    } catch (e) {
      requestController.requestFail();
      l.d('getProxyBindRecord', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
        child: Scaffold(
      appBar: CustomAppbar(
        title: "推广数据",
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return ShareIncomePage();
              }));
            },
            child: Text(
              "收益明细",
              style: const TextStyle(
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w400,
                fontSize: 12.0,
              ),
            ),
          )
        ],
      ),
      body: BaseRequestView(
        controller: requestController,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/hj_share_top_bg.png"), fit: BoxFit.fill)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "可提现金额",
                                style: const TextStyle(
                                    color: const Color(0xff663800),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12.0),
                              ),
                              Text(
                                "${record?.totalAmount}",
                                style: const TextStyle(
                                    color: const Color(0xff663800),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18.0),
                              )
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "总收益",
                                style: const TextStyle(
                                    color: const Color(0xff663800),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12.0),
                              ),
                              Text(
                                "${record?.totalAmount}",
                                style: const TextStyle(
                                    color: const Color(0xff663800),
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18.0),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                          return WithdrawPage();
                        }));
                      },
                      child: Container(
                        width: 276,
                        height: 36,
                        margin: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          border: Border.all(color: const Color(0xffffefef), width: 0.5),
                          gradient: LinearGradient(colors: [
                            const Color(0xffe3c791),
                            const Color(0xfff8ecc6),
                            const Color(0xffeedaaf)
                          ]),
                        ),
                        child: Center(
                          child: Text(
                            "立即提现",
                            style: const TextStyle(
                                color: const Color(0xff663800), fontWeight: FontWeight.w900, fontSize: 12.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)), color: const Color(0xff202733)),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 5 / 3,
                  children: incomeList.map((e) => _buildIncomeGItem(e)).toList(),
                ),
              ),
              SizedBox(height: 15),
              Text(
                "推广总统计",
                style: const TextStyle(
                    color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: 16.0),
              ),
              SizedBox(height: 15),
              _buildTGItem("累计推广用户", record== null ? "0":record.totalInviteUserCount),
              _buildTGItem("累计付费用户", record== null ? "0":record.totalPayUserCount),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildIncomeGItem(IncomeData item) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${item.value}",
            style:
                const TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w900, fontSize: 18.0),
          ),
          Text(
            item.title,
            style:
                const TextStyle(color: const Color(0xfff5e5bf), fontWeight: FontWeight.w400, fontSize: 12.0),
          )
        ],
      ),
    );
  }

  Widget _buildTGItem(String title, String value) {
    return Container(
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                const TextStyle(color: const Color(0xfff5e5bf), fontWeight: FontWeight.w400, fontSize: 12.0),
          ),
          Text(
            "$value",
            style:
                const TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w900, fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}

class IncomeData {
  String value;
  String title;

  IncomeData(this.title, this.value);
}
