import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/weibo_page/message/in_come_entity.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///收益明细
class IncomeRecordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IncomeRecordPageState();
  }
}

class _IncomeRecordPageState extends State<IncomeRecordPage> {
  var page = 1;

  List<InComeEntity> dataList = [];

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
      var messageDetail = await netManager.client.getInCome(page, Config.PAGE_SIZE);
      var model = InComeEntityModel.fromJson(messageDetail);
      print("_loadData:" + model.toString());

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
      appBar: CustomAppbar(title: "收益明细"),
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

  Widget _buildItemView(int index, InComeEntity item) {
    print("_buildItemView_${item.toJson()}");
    return Container(
        height: 140,
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: CustomNetworkImage(
                    imageUrl: item.rechargeUser.portrait,
                    type: ImgType.avatar,
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover),
              ),
              SizedBox(width: 10),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        "${item.tranType}",
                        style: const TextStyle(
                            color: const Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: 18.0),
                      ),
                      Text(
                        "\t\t\t${item.rechargeUser.name}",
                        style: const TextStyle(
                            color: const Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: 12.0),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      item.desc ?? "",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateTimeUtil.utc2iso(item.createdAt ?? ''),
                        style: const TextStyle(
                            color: const Color(0xff989898), fontWeight: FontWeight.w500, fontSize: 12.0),
                      ),
                      Text("收益+${(item.amount ?? 0) ~/ 10}元",
                          style: const TextStyle(
                              color: const Color(0xfff4b669), fontWeight: FontWeight.w400, fontSize: 14.0),
                          textAlign: TextAlign.left)
                    ],
                  )),
                  // Rectangle 2609
                ],
              ))
            ],
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
              height: 2,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                const Color(0x00a49d9d),
                const Color(0xff303030),
                const Color(0x00a49d9d),
              ])))
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
