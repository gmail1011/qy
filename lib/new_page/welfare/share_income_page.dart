import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/invite_model.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/wallet/user_income_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///推广明细
class ShareIncomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ShareIncomePageState();
  }
}

class _ShareIncomePageState extends State<ShareIncomePage> {
  UserInfoModel meInfo;
  WalletModelEntity wallet;

  BaseRequestController requestController = BaseRequestController();
  RefreshController refreshController = RefreshController();

  List<IncomeData> incomeList = [];
  UserIncomeModel record;
  List<InviteItem> recordList = [];
  int page = 1;

  @override
  void initState() {
    super.initState();
    meInfo = GlobalStore.getMe();
    wallet = GlobalStore.getWallet();
    _loadShareContent();
    _loadRecordList(page);
  }

  void _loadShareContent() async {
    try {
      record = await netManager.client.getUserAllIncomeInfo();
      requestController.requestSuccess();

      incomeList.add(IncomeData("总推广人数", record.totalInviteUserCount));
      incomeList.add(IncomeData("总推广收益", record.totalIncomeAmount));
      incomeList.add(IncomeData("今日推广人数", record.todayInviteUserCount));
      incomeList.add(IncomeData("今日推广收益", record.todayIncomeAmount));
      setState(() {});
    } catch (e) {
      requestController.requestFail();
      l.d('getProxyBindRecord', e.toString());
    }
  }

  void _loadRecordList(int page) async {
    try {
      InviteIncomeModel income = await netManager.client.getInviteIncomeList(Config.PAGE_SIZE, page);

      setReqControllerState(false, (income.inviteItemList ?? []).isEmpty, income.hasNext);
      if (page == 1) recordList.clear();
      recordList.addAll(income.inviteItemList);
      setState(() {});
    } catch (e) {
      l.e("_loadRecordList", e);
      setReqControllerState(true, false, false);
    }
  }

  void setReqControllerState(bool isCatch, bool dataIsEmpty, bool hasNext) {
    if (isCatch) {
      if (page == 1) {
        refreshController.refreshFailed();
      } else {
        refreshController.loadFailed();
      }
      requestController.requestFail();
    } else {
      requestController.requestSuccess();
      if (page == 1)
        refreshController.refreshCompleted();
      else {
        refreshController.loadComplete();
        if (dataIsEmpty) refreshController.loadNoData();
      }
      if (!hasNext) refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        appBar: CustomAppbar(title: "推广明细"),
        body: BaseRequestView(
          controller: requestController,
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4))),
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: incomeList.map((e) => _buildIncomeItem(e)).toList(),
                    ),
                  ),
                  SizedBox(height: 15),
                  // 收益明细
                  Text(
                    "收益明细",
                    style: const TextStyle(
                        color: const Color(0xffbec4d6), fontWeight: FontWeight.w500, fontSize: 12.0),
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    child: pullYsRefresh(
                      refreshController: refreshController,
                      onRefresh: () {
                        page = 1;
                        _loadRecordList(page);
                      },
                      onLoading: () {
                        page += 1;
                        _loadRecordList(page);
                      },
                      child: ListView.builder(
                        itemCount: recordList.length,
                        itemBuilder: (context, index) {
                          var item = recordList[index];
                          return _buildRecordItem(item.userName, item.incomeAmount);
                        },
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildIncomeItem(IncomeData item) {
    return Container(
      height: 60,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: const Color(0xff202733)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.title,
            style:
                const TextStyle(color: const Color(0xffb9b9b9), fontWeight: FontWeight.w400, fontSize: 12.0),
          ),
          Text(
            "${item.value}",
            style:
                const TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w900, fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordItem(String title, int value) {
    return Container(
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:
                const TextStyle(color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 14.0),
          ),
          Text(
            "收益+$value元",
            style:
                const TextStyle(color: const Color(0xfff4b669), fontWeight: FontWeight.w400, fontSize: 14.0),
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
