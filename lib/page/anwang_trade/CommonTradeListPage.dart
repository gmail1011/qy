import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/trade/TradeItemModel.dart';
import 'package:flutter_app/model/trade/TradeList.dart';
import 'package:flutter_app/page/anwang_trade/widget/TradeCellWidget.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/empty_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommonTradeListPage extends StatefulWidget {

  bool loading = true;
  int  pageNumber = 1;
  int  pageSize = 10;
  String typeid = "";
  bool hasNext = true;
  List<TradeItemModel> listData = [];
  RefreshController refreshController = RefreshController();

  CommonTradeListPage(this.typeid);

  @override
  State<CommonTradeListPage> createState() => _CommonTradeListPageState();
}

class _CommonTradeListPageState extends State<CommonTradeListPage> {


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
        child:  (widget.listData == null || widget.listData.length==0)?Container(child: EmptyWidget("mine",3),):pullYsRefresh(
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
          child: GridView.builder(
            itemCount: widget.listData.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,      //横向数量
              crossAxisSpacing: 10,   //间距
              mainAxisSpacing: 16,    //行距
              childAspectRatio: 192 / 290,
            ),
            itemBuilder: (context, index) {
              var tradeItemModel = widget.listData[index];
              return  TradeCellWidget(tradeItemModel:tradeItemModel,pageType: 1,isMine:false,viewerLimit:tradeItemModel.viewerLimit);
            },
          ),
        ),
      );
  }



 _loadData() async{
   TradeList tradeList = await netManager.client.getTradeList(widget.pageNumber, widget.pageSize,widget.typeid);

    if(tradeList==null || tradeList.list == null){
      widget.hasNext = false;
      widget.refreshController.refreshCompleted();
      widget.refreshController.loadComplete();
      if(widget.pageNumber==1){
        widget.listData = [];
      }else{
        widget.refreshController.loadNoData();
      }

    }else{
      widget.hasNext = tradeList.hasNext;
      if(widget.pageNumber==1){
          widget.listData = tradeList.list;
          widget.refreshController.refreshCompleted();
      }else{
        widget.listData.addAll(tradeList.list);
        widget.refreshController.loadComplete();
      }
    }
    widget.loading = false;
    setState(() {
    });
  }
}
