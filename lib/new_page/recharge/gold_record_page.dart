import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/wallet/mine_bill/model/bill_item_model.dart';
import 'package:flutter_app/page/wallet/mine_bill/model/mine_bill_section_model.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///金币明细
class GoldRecordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GoldRecordPageState();
  }
}

class _GoldRecordPageState extends State<GoldRecordPage> {
  var page = 1;

  List<BillItemModel> dataList = [];

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
      var year = DateTime.now().year;
      var month = DateTime.now().month;

      MineBillSectionModel model =
          await netManager.client.getMineBillList(page, Config.PAGE_SIZE, year, month);

      if (page == 1) {
        dataList.clear();
        dataList.addAll(model.mineBillModel);
        setReqControllerState(false, dataList.isEmpty, model.hasNext);
      } else {
        dataList.addAll(model.mineBillModel);
        setReqControllerState(false, false, model.hasNext);
      }
      setState(() {});
    } catch (e) {
      l.e('getIncomeList', e.toString());
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
      appBar: CustomAppbar(title: "金币明细"),
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

  Widget _buildItemView(int index, BillItemModel item) {
    return Container(
        height:97,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: const Color(0xff202733)),
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${item.desc}",
                style: const TextStyle(
                    color: const Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: 16.0),
              ),
              Text(
                "${item.actualAmount}",
                style: const TextStyle(
                    color: const Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: 16.0),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${DateTimeUtil.utc2iso(item.createdAt)}",
                style: const TextStyle(
                    color: const Color(0xffacbabf), fontWeight: FontWeight.w500, fontSize: 14.0),
              ),
              Text(
                "余额：${item.realAmount}",
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 14.0),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "${item.tranType}",
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 14.0),
          ),
        ]));
  }

  ///截取视频名称长度
  String getVideoName(String name) {
    if (name.isEmpty) {
      return "";
    } else if (name.length > 12) {
      return name.substring(0, 12) + "..";
    } else {
      return name;
    }
  }
}
