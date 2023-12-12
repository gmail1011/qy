import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/trade/TradeItemModel.dart';
import 'package:flutter_app/page/anwang_trade/widget/single_btn_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:get/route_manager.dart' as Gets;
import 'MyTradeListPage.dart';
import 'TradeOrderDetailPage.dart';
import 'TradeUtils.dart';


class TradePayOrderPage extends StatefulWidget {

   // orderUsrOperate:0 20代表是已经取消交易  50代表是已经确认收货

  GlobalKey rightKey = GlobalKey();

  TradeItemModel tradeItemModel;

  TextEditingController textControllerName = TextEditingController();
  TextEditingController textControllerPhone = TextEditingController();
  TextEditingController textControllerAddress = TextEditingController();
  TextEditingController textControllerEmail = TextEditingController();


  TradePayOrderPage({Key key,this.tradeItemModel}) : super(key: key);
  @override
  State<TradePayOrderPage> createState() => TradePayOrderPageState();
}

class TradePayOrderPageState extends State<TradePayOrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar("订单详情"),
      body: Container(
        padding: EdgeInsets.only(left: 16,right: 16),
        child:    Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTradeOrderCellWidget(widget.tradeItemModel,context),
            SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Text("收货人:",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14),),
                ),
                Expanded(
                  child:Container(
                    height: 40,
                    padding: EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(30, 30, 30, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextField(
                      controller: widget.textControllerName,
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: Dimens.pt12,
                      ),
                      // maxLength: 200,
                      maxLines: 7,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: "名字",
                        hintMaxLines: 10,
                        border: InputBorder.none,
                        counterText: "",
                        counterStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: Dimens.pt12),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Text("手机号:",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14),),
                ),
                Expanded(child:  Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(30, 30, 30, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: TextField(
                    controller: widget.textControllerPhone,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: Dimens.pt12,
                    ),
                    // maxLength: 200,
                    maxLines: 7,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "+86",
                      hintMaxLines: 20,
                      border: InputBorder.none,
                      counterText: "",
                      counterStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: Dimens.pt12),
                    ),
                  ),
                ))
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Text("详细地址:",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14),),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 16),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(30, 30, 30, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                      constraints: BoxConstraints(maxHeight: 88.0, minHeight: 88.0),
                      child: TextField(
                        controller: widget.textControllerAddress,
                        style: TextStyle(
                          color:Color.fromRGBO(255, 255, 255, 1),
                          fontSize: Dimens.pt12,
                        ),
                        // maxLength: 200,
                        maxLines: 7,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: "省，市，区，街道",
                          hintMaxLines: 100,
                          border: InputBorder.none,
                          counterText: "",
                          counterStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(153, 153, 153, 1),
                              fontSize: Dimens.pt12),
                        ),
                      ),
                    )
                  )
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Text("邮箱地址:",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14),),
                ),
                Expanded(child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  padding: EdgeInsets.only(left: 16),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(30, 30, 30, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: TextField(
                    controller: widget.textControllerEmail,
                    style: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: Dimens.pt12,
                    ),
                    // maxLength: 200,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "@***.com",
                      hintMaxLines: 20,
                      border: InputBorder.none,
                      counterText: "",
                      counterStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          fontSize: Dimens.pt12),
                    ),
                  ),
                )
                )
              ],
            ),
            SizedBox(height: 10,),
            Expanded(
              child:   Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("温馨提示:",style: TextStyle(color: Color.fromRGBO(124, 135, 159, 1),fontSize: 13),),
                  SizedBox(width: 9,),
                  Expanded(child: Text("建议使用代收点电话和收货地址，请勿使用真实姓名和电话。",style: TextStyle(color: Color.fromRGBO(124, 135, 159, 1),fontSize: 13)),)
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(254, 127, 15, 1),
                      borderRadius: BorderRadius.all(Radius.circular(22))
                    ),
                    width: 228,
                    height: 46,
                    child: Text("立即支付",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 16),),
                  ),
                  onTap: () async {
                    if(TextUtil.isEmpty(widget.textControllerName.text)){
                      showToast(msg: "收货人不能为空！");
                        return;
                    }
                    if(TextUtil.isEmpty(widget.textControllerPhone.text)){
                      showToast(msg: "手机号不能为空！");
                      return;
                    }
                    if(TextUtil.isEmpty(widget.textControllerPhone.text)){
                      showToast(msg: "详细地址不能为空！");
                      return;
                    }
                    if(TextUtil.isEmpty(widget.textControllerPhone.text)){
                      showToast(msg: "邮箱地址不能为空！");
                      return;
                    }
                    String name = "{"+widget.textControllerName.text+"}";
                    String phone = "{"+widget.textControllerPhone.text+"}";
                    String address = "{"+widget.textControllerAddress.text+"}";
                    String email = "{"+widget.textControllerEmail.text+"}";
                    StringBuffer buffer = new StringBuffer();
                    buffer.write(name);
                    buffer.write(phone);
                    buffer.write(address);
                    buffer.write(email);
                    try {
                      await netManager.client.orderTrade(widget.tradeItemModel.id,buffer.toString());
                      showToast(msg: "操作成功！");
                      GlobalStore.refreshWallet(true);
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return SingleBtnDialogView(
                              title:"温馨提示",
                              content:"您交易进度，同步到您的邮箱哦",
                              btnText:"确认",
                              callback: (){
                                // Gets.Get.to(TradePayOrderDetailPage(tradeItemModel:widget.tradeItemModel));
                                Gets.Get.to(MyTradeListPage());
                              },
                            );
                          });
                    } catch (e) {
                      showToast(msg: "操作失败！");
                    }
                  },
                )
              ],
            ),
            SizedBox(height: 35,),
          ],
        )
      )
    );
  }
  @override
  void initState() {

  }

}
