import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/trade/TradeItemModel.dart';
import 'package:flutter_app/model/trade/TradeList.dart';
import 'package:flutter_app/page/anwang_trade/widget/TradeCellWidget.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/empty_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'TradeOrderDetailPage.dart';
import 'TradeUtils.dart';
import 'package:get/route_manager.dart' as Gets;

class CommonTradeOrderListPage extends StatefulWidget {

  bool loading = true;
  int  pageNumber = 1;
  int  pageSize = 10;
  bool hasNext = true;
  List<TradeItemModel> listData = [];
  TradeList tradeList;
  String verifyStatus = "0";  // 0 审核中 1 通过 2 拒绝通过

  RefreshController refreshController = RefreshController();

  CommonTradeOrderListPage(this.verifyStatus);

  @override
  State<CommonTradeOrderListPage> createState() => _CommonTradeOrderListPageState();
}

class _CommonTradeOrderListPageState extends State<CommonTradeOrderListPage> {


  @override
  void initState() {
    super.initState();
    widget.pageNumber=1;
    _loadData();

  }

  @override
  Widget build(BuildContext context) {
    return
      widget.loading?Container(
        child: LoadingWidget(title: "加载中..."),
      ):FullBg(
        child:  (widget.listData==null|| widget.listData.length==0)?Container(
          child: EmptyWidget('mine', 3),
        ):pullYsRefresh(
          refreshController: widget.refreshController,
          enablePullUp: widget.hasNext,
          onRefresh: () {
            widget.pageNumber=1;
            _loadData();
          },
          onLoading: () {
            widget.pageNumber+=1;
            _loadData();
          },
          child: ListView.builder(
            itemCount: widget.listData.length,
            itemBuilder: (context, index) {
              var tradeItemModel = widget.listData[index];
              return  Container(
                margin: EdgeInsets.only(left: 12,right: 12),
                child:  GestureDetector(
                  child: getTradeOrderCellWidget(tradeItemModel,context),
                  onTap: (){
                    Gets.Get.to(TradePayOrderDetailPage(tradeItemModel:tradeItemModel));
                  },
                )
              );
            },
          ),
        ),
      );
  }

  _loadData() async {
    widget.tradeList  =  await netManager.client.getMyTradeList(widget.pageNumber, widget.pageSize,widget.verifyStatus);
    if(widget.tradeList==null || widget.tradeList.list == null){
      widget.hasNext = false;
      widget.refreshController.refreshCompleted();
      widget.refreshController.loadComplete();
      if(widget.pageNumber==1){
        widget.listData = [];
      }else{
        widget.refreshController.loadNoData();
      }

    }else{
      widget.hasNext = widget.tradeList.hasNext;
      if(widget.pageNumber==1){
        widget.listData = widget.tradeList.list;
        widget.refreshController.refreshCompleted();
      }else{
        widget.listData.addAll(widget.tradeList.list);
        widget.refreshController.loadComplete();
      }
    }
    widget.loading = false;
    setState(() {

    });
  }
}
