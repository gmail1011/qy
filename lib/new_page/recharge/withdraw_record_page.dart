import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/wallet/withdraw_details_model.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///提现记录
class WithdrawRecordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WithdrawRecordPageState();
  }
}

class _WithdrawRecordPageState extends State<WithdrawRecordPage> {
  var page = 1;

  List<ListBean> dataList = [];

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
      WithdrawDetailsModel model = await netManager.client.getWithdrawDetails(page, Config.PAGE_SIZE);
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
      l.e('getIncomeList', e.toString());
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
      appBar: CustomAppbar(title: "提现记录"),
      body: BaseRequestView(
        controller: requestController,
        child: Stack(children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: pullYsRefresh(
                refreshController: refreshController,
                onRefresh: () async {
                  Future.delayed(Duration(milliseconds: 1000), () {
                    _loadData(true);
                  });
                },
                onLoading: () => _loadData(false),
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    shrinkWrap: true,
                    itemCount: dataList.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildItemView(index, dataList[index]);
                    })),
          ),
        ]),
      ),
    ));
  }

  Widget _buildItemView(int index, ListBean item) {
    return InkWell(
      onTap: () async {
        if (item.status == 3 || item.status == 4 || item.status == 6) showReasonDialog(item);
      },
      child: Container(
        height: 140,
        // height: (item.status == 3 || item.status == 4 || item.status == 6) ? 150 : 140,
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${(item.money ?? 0) ~/ 100}元",
              style: const TextStyle(
                  color: const Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: 18.0),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () {
                  ///复制分享链接到剪切板
                  Clipboard.setData(ClipboardData(text: item.id));
                  showToast(msg: "复制成功");
                },
                child: Text(
                  '账单编号: ${item.id}',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
            // 状态：提现成功
            Text(
              "状态：${getStatus(item.status)}",
              style: TextStyle(
                  color: Color(getStatusColor(item.status)), fontWeight: FontWeight.w400, fontSize: 15.0),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                DateTimeUtil.utc2iso(item.createdAt ?? ''),
                style: const TextStyle(
                    color: const Color(0xff989898), fontWeight: FontWeight.w500, fontSize: 12.0),
              ),
            ),
            // if (item.status == 3 || item.status == 4 || item.status == 6)
            //   Text(
            //     "原因：${item.statusDesc}",
            //     style: TextStyle(
            //         color: Color(getStatusColor(item.status)), fontWeight: FontWeight.w400, fontSize: 15.0),
            //   ),
            Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: 2,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  const Color(0x00a49d9d),
                  const Color(0xff303030),
                  const Color(0x00a49d9d),
                ])))
          ],
        ),
      ),
    );
  }

  ///���据支��类型显示支付方式
  String getPayType(String payType) {
    if (payType?.endsWith("alipay") ?? false) {
      return Lang.ALIPAY_WITHDRAW;
    } else if (payType?.endsWith("usdt") ?? false) {
      return Lang.USDT_WITHDRAW;
    } else {
      return Lang.BANKCARD_WITHDRAW;
    }
  }

  ///支付状态
  String getStatus(int status) {
    switch (status) {
      case 1:
        return "审核中";
      case 2:
        return "审核通过，转账中";
      case 3:
        return "已拒绝";
      case 4:
        return "未知错误";
      case 5:
        return "提现成功";
      case 6:
        return Lang.WITHDRAW_ERROR;
    }
    return "";
  }

  ///支付状态颜色
  int getStatusColor(int status) {
    switch (status) {
      case 1:
        return 0xff45ade7;
      case 3:
      case 4:
        return 0xffe74f45;
      case 5:
        return 0xff45e772;
      case 6:
        return 0xffe74f45;
    }
    return 0xffffffff;
  }

  void showReasonDialog(ListBean item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: IntrinsicHeight(
            child: Container(
              width: 357,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)), color: const Color(0xff161e2c)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text(
                    "提现结果",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "${item.statusDesc}",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () => safePopPage(),
                    child: Container(
                      width: 166,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          gradient:
                              LinearGradient(colors: [const Color(0xff84a4f9), const Color(0xff2b5dde)])),
                      child: Center(
                        child: // 确定
                            Text(
                          "确定",
                          style: const TextStyle(
                              color: const Color(0xffffffff), fontWeight: FontWeight.w600, fontSize: 12.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
