import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/wallet/RechargeRecordModel.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///充值记录
class RechargeRecordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RechargeRecordPageState();
  }
}

class _RechargeRecordPageState extends State<RechargeRecordPage> {
  var page = 1;

  List<RechargeRecordItem> dataList = [];

  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();

  @override
  void initState() {
    super.initState();
    _loadData(true);
  }

  void _loadData(bool isReload) async {
    if (isReload)
      page = 1;
    else
      page += 1;

    try {
      RechargeRecordModel model = await netManager.client.getMineTransaction(page, Config.PAGE_SIZE);

      if (page == 1) {
        dataList.clear();
        dataList.addAll(model.list);
        setReqControllerState(false, dataList.isEmpty, model.hasNext);
      } else {
        dataList.addAll(model.list);
        setReqControllerState(false, false, model.hasNext);
      }

      setState(() {});
    } catch (e) {
      showToast(msg: e.toString());
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
      if (page == 1 && dataIsEmpty) requestController.requestDataEmpty();
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
      appBar: CustomAppbar(title: "充值记录"),
      body: BaseRequestView(
        controller: requestController,
        child: Stack(children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: pullYsRefresh(
                  refreshController: refreshController,
                  onRefresh: () async {
                    Future.delayed(Duration(milliseconds: 1000), () {
                      _loadData(true);
                    });
                  },
                  onLoading: () => _loadData(false),
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: 0, bottom: 10),
                      shrinkWrap: true,
                      itemCount: dataList.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildItemView(dataList[index]);
                      })),
            ),
          ),
        ]),
      ),
    ));
  }

  Widget _buildItemView(RechargeRecordItem billModel) {
    return Container(
      margin: EdgeInsets.only(left: 18, right: 16),
      padding: EdgeInsets.only(top: 6, bottom: 11),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${billModel?.productName ?? ""}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: getStatusColor(billModel.status),
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                        child: Center(
                          child: Text(
                            getStatusStr(billModel.status),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        "¥",
                        style: TextStyle(
                          color: AppColors.primaryTextColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 20.0,
                        ),
                      ), //
                      SizedBox(width: 5), // 300
                      Text(
                        "${(billModel?.money ?? 0) ~/ 100}",
                        style: TextStyle(
                          color: AppColors.primaryTextColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 32.0,
                        ),
                      ),
                    ]),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "支付方式：${billModel?.payType}",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 2),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: billModel?.orderId));
              showToast(msg: "订单号复制成功");
            },
            child: Text(
              "订单编号：${billModel?.orderId}",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "交易时间：${DateTimeUtil.utc2iso(billModel.createdAt)}",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          Padding(padding: EdgeInsets.only(top: 16)),
          Image.asset(
            "assets/images/line_sepreate.png",
          )
        ],
      ),
    );
  }

  //status：3成功
  // status：1进行中
  // status：2失败
  String getStatusStr(int status) {
    var statusStr = "未知";
    switch (status) {
      case 1:
        statusStr = "进行中";
        break;
      case 2:
        statusStr = "失败";
        break;
      case 3:
        statusStr = "成功";
        break;
    }

    return statusStr;
  }

  Color getStatusColor(int status) {
    var statusStr = Color(0xffffd78b);
    switch (status) {
      case 2:
        statusStr = Colors.red;
        break;
      case 3:
        statusStr = Colors.green;
        break;
    }

    return statusStr;
  }
}
