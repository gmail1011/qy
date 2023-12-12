import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/trade/FreezeAmount.dart';
import 'package:flutter_app/model/trade/TradeItemModel.dart';
import 'package:flutter_app/model/trade/TradeList.dart';
import 'package:flutter_app/model/trade/TradeTopic.dart';
import 'package:flutter_app/page/anwang_trade/CommonTradeListPage.dart';
import 'package:flutter_app/page/video/video_publish/state.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart' as extended;
import 'package:get/route_manager.dart' as Gets;

import 'CustomDrawer.dart';
import 'MyTradeListPage.dart';

class AnWangTradePage extends StatefulWidget {
  List<AdsInfoBean> adsList = [];
  List<TradeTopic> tradeTopicList = [];
  String announce;
  int selectedIndex = 0;
  TradeTopic selectTradeTopic;
  TabController  tabController;
  EasyRefreshController controller = EasyRefreshController();
  List<TradeItemModel> listData = [];
  TradeList tradeList;
  int pageNumber = 1;
  int pageSize = 10;
  String sellType = "new"; //new  buy  sell  mine
  int currentTypeIndex = 0;
  bool showMenu = false;
  bool loading = true;
  int jumpPostion = 0;
  String freezeAmount  = "";  //冻结金额
  ScrollController scrollController = ScrollController();
  List<Widget> widgets = [];
  @override
  State<AnWangTradePage> createState() => _AnWangTradePageState();
}

class _AnWangTradePageState extends State<AnWangTradePage> {
  @override
  Widget build(BuildContext context) {
    return
      widget.loading?Container(
        child: LoadingWidget(title: "加载中..."),
      ):Scaffold(
          body:Builder(
            builder: (BuildContext  context){
              return  
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(65, 0, 40, 1),
                        Color.fromRGBO(15, 5, 43, 1),
                        Color.fromRGBO(15, 5, 43, 1),
                        Color.fromRGBO(15, 5, 43, 1),
                      ]
                    )
                  ),
                  child:  Column(
                    children: [
                      SizedBox(height: 50,),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 30,
                            padding: EdgeInsets.only(left: 20,right: 12),
                            child:   GestureDetector(
                              child: Image.asset("assets/weibo/back_arrow.png",width: 18,height: 16,),
                              onTap: (){
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Expanded(child:Container(
                            alignment: Alignment.center,
                            child:  Text("暗网交易",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 18),),
                          )),
                          Container(
                            width: 50,
                            height: 30,
                            padding: EdgeInsets.only(left: 1,right: 19),
                            child:   GestureDetector(
                              child:ClipOval(
                                child: CustomNetworkImage(
                                  fit: BoxFit.cover,
                                  height: 30,
                                  width: 30,
                                  imageUrl: GlobalStore.getMe().portrait??"",
                                ),
                              ),
                              onTap: (){
                                Scaffold.of(context).openEndDrawer();
                              },
                            ),
                          )
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(24),topRight: Radius.circular(24)),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 255, 255, 0.5),
                              Color.fromRGBO(255, 255, 255, 0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                          )
                        ),
                        margin: EdgeInsets.only(top: 14,bottom: 4),
                        padding: EdgeInsets.only(top: 17,bottom: 6),
                        child: TabBar(
                          isScrollable: true,
                          tabs: widget.tradeTopicList.map((e) {
                            return Text(
                              e.name,
                              style: TextStyle(
                                fontSize: Dimens.pt16,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                          labelStyle: TextStyle(
                              color: Color.fromRGBO(255, 255, 255,1),
                              fontSize: Dimens.pt16),
                          unselectedLabelStyle: TextStyle(
                              color: Color.fromRGBO(255, 255, 255,1),
                              fontSize: Dimens.pt16),
                          controller: widget.tabController,
                          indicatorPadding: EdgeInsets.only(left: 10,right: 10),
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
                          children: widget.widgets,
                          linkWithAncestor: true,
                        ),
                      ),
                    ],
                  ),
                );
            },
          ),
          endDrawer: CustomDrawer(
            widthPercent: 0.6,//这里控制抽屉的弯度，不能小于0，不能大于1
            child: Container(
              width: 200,
              color: Color.fromRGBO(34, 34, 34, 1),
              child:    Column(
                children: <Widget>[
                  SizedBox(height: 50,),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 16,
                        padding: EdgeInsets.only(left: 11,right: 11),
                        child:   GestureDetector(
                          child: Image.asset("assets/weibo/back_arrow.png",width: 18,height: 16,),
                          onTap: (){
                            safePopPage();
                          },
                        ),
                      ),
                      Expanded(child:Container(
                        alignment: Alignment.center,
                        child:  Text(GlobalStore.getMe().name,style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14),),
                      )),
                      Container(
                        width: 50,
                        height: 30,
                        padding: EdgeInsets.only(left: 4,right: 16),
                        child:   GestureDetector(
                          child:ClipOval(
                            child: CustomNetworkImage(
                              fit: BoxFit.cover,
                              height: 30,
                              width: 30,
                              imageUrl: GlobalStore.getMe().portrait??"",
                            ),
                          ),
                          onTap: (){
                            Scaffold.of(context).openEndDrawer();
                          },
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 19,left: 11,right: 16),
                    padding: EdgeInsets.only(top: 19),
                    height: 89,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/weibo/images/bg_trade_drawer_top.png"),
                        fit: BoxFit.contain,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(16))
                    ),
                    child:Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 22,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("全部金币",style: TextStyle(color: Color.fromRGBO(177, 177, 177, 1),fontSize: 12),),
                            Image.asset("assets/weibo/trade_amount_underline.png",width: 23,height: 4,),
                            SizedBox(height: 9,),
                            Text(GlobalStore.getWallet().amount.toString(),style: TextStyle(color: Color.fromRGBO(253, 212, 144, 1),fontSize: 20),),
                          ],
                        ),
                        SizedBox(width: 50,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("冻结金币",style: TextStyle(color: Color.fromRGBO(177, 177, 177, 1),fontSize: 12),),
                            Image.asset("assets/weibo/trade_amount_underline.png",width: 23,height: 4,),
                            SizedBox(height: 9,),
                            Text(widget.freezeAmount,style: TextStyle(color: Color.fromRGBO(253, 212, 144, 1),fontSize: 20),),
                          ],
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 2,),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.1),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      height: 41,
                      margin: EdgeInsets.only(left: 11,right: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 9,),
                          Expanded(child: Text("我的订单",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),),),
                          Image.asset("assets/images/right_arrow.png",width: 16,height: 16,),
                          SizedBox(width: 18,),
                        ],
                      ),
                    ),
                    onTap: (){
                      Gets.Get.to(MyTradeListPage());
                    },
                  ),
                  SizedBox(height: 10,),
                  // GestureDetector(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Color.fromRGBO(255, 255, 255, 0.1),
                  //       borderRadius: BorderRadius.all(Radius.circular(4)),
                  //     ),
                  //     height: 41,
                  //     margin: EdgeInsets.only(left: 11,right: 16),
                  //     child: Row(
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         SizedBox(width: 9,),
                  //         Expanded(child: Text("我的地址",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),),),
                  //         Image.asset("assets/images/right_arrow.png",width: 16,height: 16,),
                  //         SizedBox(width: 18,),
                  //       ],
                  //     ),
                  //   ),
                  //   onTap: (){
                  //
                  //   },
                  // )

                ],
              ),
            ),
          ),
    );
  }


  @override
  void initState(){
    super.initState();
    _initData();
  }

  _jumpPublish(UploadType type) async {
    // bool isEntry = await lightKV.getBool(Config.VIEW_UPLOAD_RULE);
    // if (!isEntry) {
    //   showDialog(
    //       context: context,
    //       builder: (context) {
    //         return ReleaseRuleDialogView(callback:() async {
    //           await lightKV.setBool(Config.VIEW_UPLOAD_RULE, true);
    //           Map<String, dynamic> map =  {'type': type};
    //           map =
    //           await JRouter().go(VIDEO_PUBLISH, arguments: map);
    //         });
    //       });
    //   return;
    // }else{
    //   Map<String, dynamic> map =  {'type': type};
    //   map =
    //   await JRouter().go(VIDEO_PUBLISH, arguments: map);
    // }
  }


  _initData() async {
    widget.loading = true;
    GlobalStore.refreshWallet();
    try {
      widget.tradeTopicList = await netManager.client.getTradeTopicList();
    } catch (e) {
      widget.tradeTopicList = [];
    }
    // widget.tabController.addListener(() {
    //   int index = widget.tabController.index;
    //   if (widget.currentTypeIndex != index) {
    //     widget.currentTypeIndex = index;
    //     _refreshTradeList();
    //   }
    // });
    if(widget.tradeTopicList.length>0){
      widget.selectTradeTopic = widget.tradeTopicList[0];
    }
    try {
      if(widget.selectTradeTopic!=null){
        widget.tradeList  =  await netManager.client.getTradeList(widget.pageNumber, widget.pageSize,widget.selectTradeTopic?.id);
      }
    } catch (e) {
    }

    if(widget.tradeList!=null && widget.tradeList.list != null){
      widget.listData = widget.tradeList.list;
    }
    widget.loading = false;

    FreezeAmount freezeAmount =  await netManager.client.freezeAmount();
    widget.freezeAmount = freezeAmount.freezeAmount.toString();
    widget.tradeTopicList.insert(0, TradeTopic("全部","全部"));

    for (int i = 0; i < widget.tradeTopicList.length; i++) {
      widget.widgets.add(extended.NestedScrollViewInnerScrollPositionKeyWidget(
        Key(i.toString()),
        CommonTradeListPage(widget.tradeTopicList[i].id),
        ));
    }
    widget.tabController = TabController(initialIndex: 0, length: widget.widgets.length, vsync: ScrollableState());
    setState(() {
    });
  }
  //new  buy  sell  mine
   _refreshTradeList() async {
    widget.pageNumber =1;
    if(widget.currentTypeIndex==0){
      widget.sellType = "new";
    }else  if(widget.currentTypeIndex==1){
      widget.sellType = "buy";
    }
    else  if(widget.currentTypeIndex==2){
      widget.sellType = "sell";
    }else  if(widget.currentTypeIndex==3){
      widget.sellType = "mine";
    }
    widget.tradeList  =  await netManager.client.getTradeList(widget.pageNumber, widget.pageSize,widget.selectTradeTopic.id
    );
    if(widget.tradeList.list==null){
      widget.listData = [];
    }else{
      widget.listData = widget.tradeList.list;
    }
    setState(() {

    });
  }

  _loadMoreTradeList() async {
    widget.pageNumber +=1;
    widget.tradeList  =  await netManager.client.getTradeList(widget.pageNumber, widget.pageSize, widget.selectTradeTopic.id
    );
    if(widget.tradeList!=null && widget.tradeList.list!=null){
      widget.listData.addAll(widget.tradeList.list);
    }
    setState(() {

    });
  }

}


