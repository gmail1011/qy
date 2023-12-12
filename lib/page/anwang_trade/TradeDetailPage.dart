import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/trade/Medias.dart';
import 'package:flutter_app/model/trade/TradeItemModel.dart';
import 'package:flutter_app/page/anwang_trade/widget/single_btn_view.dart';
import 'package:flutter_app/page/home/post/common_banner_widget.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/page/user/member_centre_page/wallet/page.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:get/route_manager.dart' as Gets;

import 'TradePayOrderPage.dart';
import 'TradeUtils.dart';


class TradeDetailPage extends StatefulWidget {

  GlobalKey rightKey = GlobalKey();
  List<String> urlList = [];

  TradeItemModel tradeItemModel;

  TextEditingController textController = TextEditingController();


  TradeDetailPage({Key key,this.tradeItemModel}) : super(key: key);
  bool showMenu = false;
  @override
  State<TradeDetailPage> createState() => TradeDetailPageState();
}

class TradeDetailPageState extends State<TradeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // child:    Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Stack(
        //       children: [
        //         widget.tradeItemModel?.medias[0].type=='vid'? Container(
        //           alignment: Alignment.center,
        //           margin: EdgeInsets.only(top:50),
        //           child: createVideoLayout(widget.tradeItemModel.medias[0],widget.tradeItemModel?.cover,
        //               onItemClick: (){
        //                 onJumpToVideoPlayList(widget.tradeItemModel,context,isTrade:true);
        //               },
        //               onPlayClick:(){
        //                 onJumpToVideoPlayList(widget.tradeItemModel,context,isTrade:true);
        //               }
        //           ),
        //         ): CommonBannerWidget(
        //           widget.urlList,
        //           width: screen.screenWidth,
        //           height: 428,
        //           autoPlayDuration: 3000,
        //           radius:0,
        //         ),
        //         Positioned(
        //             top: 50,
        //             left: 10,
        //             child: GestureDetector(
        //           child: Image.asset("assets/weibo/back_arrow.png",width: 18,height: 16,),
        //           onTap: (){
        //             safePopPage();
        //           },
        //         ))
        //       ],
        //     ),
        //     Container(
        //       child: Text("${widget.tradeItemModel.goodsName}",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 17),),
        //       margin: EdgeInsets.only(left: 16,top: 20),
        //     ),
        //     SizedBox(height: 10,),
        //     Row(
        //       children: [
        //         SizedBox(width: 16,),
        //         Expanded(child: Text("${widget.tradeItemModel.publisherDeposit}金币",style: TextStyle(color: Color.fromRGBO(253, 212, 144, 1),fontSize: 20),),),
        //         Text("${widget.tradeItemModel.tradeCount}人购买",style: TextStyle(color: Color.fromRGBO(177, 177, 177, 1),fontSize: 12),),
        //         SizedBox(width: 19,),
        //       ],
        //     ),
        //     SizedBox(height: 8,),
        //     Row(
        //       children: [
        //         GestureDetector(
        //           child:ClipOval(
        //             child: CustomNetworkImage(
        //               fit: BoxFit.cover,
        //               height: 52,
        //               width: 52,
        //               placeholder: Image.asset(
        //                 "assets/weibo/loading_horizetol.png",
        //                 fit: BoxFit.cover,
        //                 height: 52,
        //                 width: 52 ,
        //               ),
        //               imageUrl: widget.tradeItemModel.publisher.portrait??"",
        //             ),
        //           ),
        //           onTap: (){
        //           },
        //         ),
        //         SizedBox(width: 7,),
        //         Text("${widget.tradeItemModel.publisher.name}",style: TextStyle(color: Color.fromRGBO(246, 197, 89, 1),fontSize: 17,),),
        //         SizedBox(width: 7,),
        //         Expanded(child:  widget.tradeItemModel.publisher.isSuperUser??false?Image.asset("assets/images/icon_user_super.png",width: 18,height: 18,):SizedBox(),),
        //         Text("${widget.tradeItemModel.publisher.upTag??""}",style: TextStyle(color: Color.fromRGBO(124, 135, 159, 1),fontSize: 13),),
        //         SizedBox(width: 16,),
        //       ],
        //     ),
        //     Expanded(child:   Container(
        //       margin: EdgeInsets.only(left: 16,right: 16,top: 12),
        //       color: Color.fromRGBO(30, 30, 30, 1),
        //       child:CustomScrollView(
        //         slivers: [
        //           SliverToBoxAdapter(
        //             child: SizedBox(height: 10,),
        //           ),
        //           SliverToBoxAdapter(
        //             child:  Row(
        //               children: [
        //                 Image.asset("assets/weibo/icon_trade_detail_tag.png",width: 7,height: 21,),
        //                 Text("商品简介",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),),
        //               ],
        //             ),
        //           ),
        //           SliverToBoxAdapter(
        //             child:   SizedBox(height: 10,),
        //           ),
        //           SliverToBoxAdapter(
        //               child:  Container(
        //                 child:Column(
        //                   children: [
        //                      ExpandableText(
        //                       widget.tradeItemModel.describe??"",
        //                       key: Key(widget.tradeItemModel.id),
        //                       expandText: '全文',
        //                       collapseText: '收起',
        //                       maxLines: 5,
        //                       linkColor: Colors.pinkAccent,
        //                       style: TextStyle(
        //                           color: Colors.white, fontSize: Dimens.pt14),
        //                     ),
        //                   ],
        //                 ),
        //                 margin: EdgeInsets.only(left: 12,right: 12),
        //               )
        //           ),
        //         ],
        //       ),
        //     ),),
        //     SizedBox(height: 10,),
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         GestureDetector(
        //           child: Container(
        //             width: 205,
        //             height: 44,
        //             alignment: Alignment.center,
        //             decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.all(Radius.circular(22)),
        //                 gradient: LinearGradient(
        //                     colors: [
        //                       Color.fromRGBO(209, 185, 156, 1),
        //                       Color.fromRGBO(232, 186, 132, 1),
        //                     ]
        //                 )
        //             ),
        //             child: Text("立即购买${widget.tradeItemModel.publisherDeposit}金币",style: TextStyle(color: Color.fromRGBO(128, 85, 34, 1),fontSize: 15,fontWeight: FontWeight.w600),),
        //           ),
        //           onTap: () async {
        //             if(GlobalStore.getWallet().amount<widget.tradeItemModel.publisherDeposit){
        //               showToast(msg: "金币不足，请先充值金币");
        //               Navigator.of(context).push(MaterialPageRoute(
        //                   builder: (BuildContext context) =>
        //                       MemberCentrePage().buildPage({"position": "1"})));
        //               return;
        //             }
        //             Gets.Get.to(TradePayOrderPage(tradeItemModel:widget.tradeItemModel));
        //           },
        //         ),
        //       ],
        //     ),
        //     SizedBox(height: 30,),
        //   ],
        // ),
        child: CustomScrollView(
            slivers:[
              SliverToBoxAdapter(
                child:    Stack(
                  children: [
                    widget.tradeItemModel?.medias[0].type=='vid'? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top:50),
                      child: createVideoLayout(widget.tradeItemModel.medias[0],widget.tradeItemModel?.cover,
                          onItemClick: (){
                            onJumpToVideoPlayList(widget.tradeItemModel,context,isTrade:true);
                          },
                          onPlayClick:(){
                            onJumpToVideoPlayList(widget.tradeItemModel,context,isTrade:true);
                          }
                      ),
                    ): CommonBannerWidget(
                      widget.urlList,
                      width: screen.screenWidth,
                      height: 428,
                      autoPlayDuration: 3000,
                      radius:0,
                    ),
                    Positioned(
                        top: 50,
                        left: 10,
                        child: GestureDetector(
                          child: Image.asset("assets/weibo/back_arrow.png",width: 18,height: 16,),
                          onTap: (){
                            safePopPage();
                          },
                        ))
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child:    Container(
                  child: Text("${widget.tradeItemModel.goodsName}",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 17),),
                  margin: EdgeInsets.only(left: 16,top: 20),
                ),
              ),
              SliverToBoxAdapter(
                child:    SizedBox(height: 10,),
              ),
              SliverToBoxAdapter(
                child:    Row(
                  children: [
                    SizedBox(width: 16,),
                    Expanded(child: Text("${widget.tradeItemModel.publisherDeposit}金币",style: TextStyle(color: Color.fromRGBO(253, 212, 144, 1),fontSize: 20),),),
                    Text("${widget.tradeItemModel.tradeCount}人购买",style: TextStyle(color: Color.fromRGBO(177, 177, 177, 1),fontSize: 12),),
                    SizedBox(width: 19,),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child:    SizedBox(height: 8,),
              ),
              SliverToBoxAdapter(
                child:     Row(
                  children: [
                    GestureDetector(
                      child:ClipOval(
                        child: CustomNetworkImage(
                          fit: BoxFit.cover,
                          height: 52,
                          width: 52,
                          imageUrl: widget.tradeItemModel.publisher.portrait??"",
                        ),
                      ),
                      onTap: (){
                      },
                    ),
                    SizedBox(width: 7,),
                    Text("${widget.tradeItemModel.publisher.name}",style: TextStyle(color: Color.fromRGBO(246, 197, 89, 1),fontSize: 17,),),
                    SizedBox(width: 7,),
                    Expanded(child:  widget.tradeItemModel.publisher.isSuperUser??false?Image.asset("assets/images/icon_user_super.png",width: 18,height: 18,):SizedBox(),),
                    Text("${widget.tradeItemModel.publisher.upTag??""}",style: TextStyle(color: Color.fromRGBO(124, 135, 159, 1),fontSize: 13),),
                    SizedBox(width: 16,),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 10,),
              ),
              SliverToBoxAdapter(
                child:  Row(
                  children: [
                    Image.asset("assets/weibo/icon_trade_detail_tag.png",width: 7,height: 21,),
                    Text("商品简介",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child:   SizedBox(height: 10,),
              ),
              SliverToBoxAdapter(
                  child:  Container(
                    child:Column(
                      children: [
                        ExpandableText(
                          widget.tradeItemModel.describe??"",
                          key: Key(widget.tradeItemModel.id),
                          expandText: '全文',
                          collapseText: '收起',
                          maxLines: 5,
                          linkColor: Colors.pinkAccent,
                          style: TextStyle(
                              color: Colors.white, fontSize: Dimens.pt14),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 12,right: 12),
                  )
              ),
              SliverToBoxAdapter(
                child:    SizedBox(height: 10,),
              ),
              SliverToBoxAdapter(
                child:   Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 205,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(22)),
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(209, 185, 156, 1),
                                  Color.fromRGBO(232, 186, 132, 1),
                                ]
                            )
                        ),
                        child: Text("立即购买${widget.tradeItemModel.publisherDeposit}金币",style: TextStyle(color: Color.fromRGBO(128, 85, 34, 1),fontSize: 15,fontWeight: FontWeight.w600),),
                      ),
                      onTap: () async {
                        if(GlobalStore.getWallet().amount<widget.tradeItemModel.publisherDeposit){
                          showToast(msg: "金币不足，请先充值金币");
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  MemberCentrePage().buildPage({"position": "1"})));
                          return;
                        }
                        Gets.Get.to(TradePayOrderPage(tradeItemModel:widget.tradeItemModel));
                      },
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 30,),
              )
            ]
        ),
      )
    );
  }
  @override
  void initState() {
    _loadTradeInfo();
  }

  _loadTradeInfo() async {
    TradeItemModel tradeItemModel = await netManager.client.tradeInfo(widget.tradeItemModel.id??0);
    if(tradeItemModel!=null){
      widget.tradeItemModel = tradeItemModel;
    }
    if(widget.tradeItemModel?.medias!=null){
      for(Medias media in widget.tradeItemModel.medias){
        widget.urlList?.add(media.src);
      }
    }

    setState(() {
    });
  }

  //   0 // 待交易
//  1 // 交易中
//  2 // 交易已取消
//  5 // 交易完成
//  7 // 交易异常 被骗申诉状态
  Widget getTradeStatusButton(TradeItemModel tradeItemModel,BuildContext context,{VoidCallback buttonCallback}){
    return (tradeItemModel.tradeStatus==0 && tradeItemModel.publisherUID!=GlobalStore.getMe().uid)?
    GestureDetector(
      child: Container(
        width: 205,
        height: 44,
        alignment:Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          gradient: LinearGradient(
              colors: [
                Color.fromRGBO(209, 185, 156, 1),
                Color.fromRGBO(232, 186, 132, 1),
              ]
          ),
        ),
        child: Text("立即购买${tradeItemModel.publisherDeposit}"),
      ),
      onTap: () async{
        if(GlobalStore.getWallet().amount<tradeItemModel.publisherDeposit){
          showToast(msg: "金币不足，请先充值金币");
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => WalletPage().buildPage(null)));
          return;
        }
      },
    )
    //买家
    :(tradeItemModel.tradeStatus==1 && (tradeItemModel.orderUID == GlobalStore.getMe().uid))?GestureDetector(
      child: Container(
        child: Row(
          children: [
            GestureDetector(
              child: Container(
                alignment:Alignment.center,
                width: 88,
                height: 28,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(254, 127, 15, 1),
                          Color.fromRGBO(234, 139, 37, 1),
                        ]
                    )
                ),
                child: Text("联系卖家" ,style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),),
              ),
              onTap: () async {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return SingleBtnDialogView(
                          title:"卖家联系方式",
                          content:"${tradeItemModel.contact}",
                          btnText:"复制",
                          callback: (){
                            String content = tradeItemModel.contact;
                            Clipboard.setData(ClipboardData(text: content));
                            showToast(msg: "复制成功");
                          },
                      );
                    });
              },
            ),
            SizedBox(width: 10,),
            GestureDetector(
              child: Container(
                alignment:Alignment.center,
                width: 88,
                height: 28,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(254, 127, 15, 1),
                          Color.fromRGBO(234, 139, 37, 1),
                        ]
                    )
                ),
                child: Text("确认收货" ,style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),),
              ),
              onTap: () async {

              },
            )
          ],
        ),
      ),
    )

    // :(tradeItemModel.tradeStatus==0 && tradeItemModel.publisherUID!=GlobalStore.getMe().uid)?
    // GestureDetector(
    //   child: Container(
    //     width: 88,
    //     height: 28,
    //     alignment:Alignment.center,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.all(Radius.circular(14)),
    //       gradient: LinearGradient(
    //           colors: [
    //             Color.fromRGBO(253, 239, 165, 1),
    //             Color.fromRGBO(249, 180, 91, 1),
    //           ]
    //       ),
    //     ),
    //     child: Text("联系客服"),
    //   ),
    //   onTap: (){
    //     CSManager().openServices(context);
    //   },
    // )
    :Container();
  }



}
