import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/user/promotion_record.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///邀请记录
class MineShareRecordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineShareRecordPageState();
  }
}

class _MineShareRecordPageState extends State<MineShareRecordPage> {
  var page = 1;

  List<Promotion> dataList = [];

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
      var record = await netManager.client.getProxyBindRecord(Config.PAGE_SIZE, page);
      if (page == 1) {
        dataList.clear();
        dataList.addAll(record.promotionList);
        setReqControllerState(false, dataList.isEmpty, record.hasNext);
      } else {
        dataList.addAll(record.promotionList);
        setReqControllerState(false, false, record.hasNext);
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
      appBar: CustomAppbar(
        title: "推广记录",
        actions: [
          InkWell(
            onTap: () => csManager.openServices(context),
            child: Text(
              "联系客服",
              style: const TextStyle(
                  color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 12.0),
            ),
          )
        ],
      ),
      body: BaseRequestView(
        controller: requestController,
        child: Column(children: [
          Expanded(
            child: Container(
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
          ),
        ]),
      ),
    ));
  }

  Widget _buildItemView(int index, Promotion item) {
    return Container(
      height: 20,
      child: Row(
        children: [
          HeaderWidget(
            headPath: item?.coverImg ?? "",
            level: 0,
            headWidth: 38,
            headHeight: 38,
            levelSize: 14,
            positionedSize: 0,
            defaultHead: Image.asset(
              "assets/weibo/loading_normal.png",
              width: 38,
              height: 38,
              fit: BoxFit.cover,
            ),
          ),
          _buildT2View(1, item.name),
          // _buildT2View(1, "已激活"),
          _buildT2View(1, "注册时间:  ${DateTimeUtil.utc2isoYMD(item.createAt)}"),
        ],
      ),
    );
  }

  Widget _buildT1View(int flex, String text) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 14.0),
        ),
      ),
    );
  }

  Widget _buildT2View(int flex, String text) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Color(0xffacbabf), fontWeight: FontWeight.w400, fontSize: 12.0),
        ),
      ),
    );
  }
}
