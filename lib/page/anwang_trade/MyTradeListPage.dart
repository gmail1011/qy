import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/trade/TradeItemModel.dart';
import 'package:flutter_app/model/trade/TradeList.dart';
import 'package:flutter_app/page/anwang_trade/CommonTradeOrderListPage.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class MyTradeListPage extends StatefulWidget {
  List<String> tabs = ["全部","交易中","已完成","已取消"];
  TabController tabController = TabController(initialIndex: 0, length: 4, vsync: ScrollableState());
  EasyRefreshController controller = EasyRefreshController();
  List<TradeItemModel> listData = [];
  TradeList tradeList;
  int pageNumber = 1;
  int pageSize = 10;
  String verifyStatus = "1";  //1交易中 2交易取消 5交易完成
  @override
  State<MyTradeListPage> createState() => _MyTradeListPageState();
}

class _MyTradeListPageState extends State<MyTradeListPage> {
  @override
  Widget build(BuildContext context) {
    return
      FullBg(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: getCommonAppBar("我的订单"),
            body: Container(
                       child: Column(children: [
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 12,bottom: 12),
                              child: TabBar(
                                isScrollable: true,
                                tabs: widget.tabs.map((e) {
                                  return Text(
                                    e,
                                  );
                                }).toList(),
                                labelStyle: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255,1),
                                    fontSize: 16),
                                unselectedLabelStyle: TextStyle(
                                    color: Color.fromRGBO(115, 122, 139,1),
                                    fontSize: 16),
                                controller: widget.tabController,
                                indicatorPadding: EdgeInsets.only(bottom: 2),
                                indicatorWeight: 4,
                                indicator: RoundUnderlineTabIndicator(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(255, 127, 15, 1),
                                    width: 4,
                                  ),
                                ),
                              ),
                            ),
                         Expanded(
                           child: ExtendedTabBarView(
                             controller:widget.tabController,
                             children: [
                               //1交易中 2交易取消 5交易完成
                               CommonTradeOrderListPage("0"),
                               CommonTradeOrderListPage("1"),
                               CommonTradeOrderListPage("5"),
                               CommonTradeOrderListPage("2"),
                             ],
                             linkWithAncestor: true,
                           ),
                         ),
                            ],
                       ),
                  ),
          ),
    );
  }
  @override
  void initState(){
    super.initState();
    widget.tabController.addListener(() {
    });
  }




}


