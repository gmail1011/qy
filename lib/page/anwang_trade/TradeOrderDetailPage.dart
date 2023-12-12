import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/trade/TradeItemModel.dart';
import 'package:flutter_app/page/anwang_trade/widget/single_btn_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'TradeUtils.dart';


class TradePayOrderDetailPage extends StatefulWidget {



  GlobalKey rightKey = GlobalKey();

  TradeItemModel tradeItemModel;



  TradePayOrderDetailPage({Key key,this.tradeItemModel}) : super(key: key);
  @override
  State<TradePayOrderDetailPage> createState() => TradePayOrderDetailPageState();
}

class TradePayOrderDetailPageState extends State<TradePayOrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: getCommonAppBar("订单详情"),
      body: Container(
        child:    Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 16,right: 16),
              child:   getTradeOrderCellWidget(widget.tradeItemModel,context,isOrderDetail:true,buttonCallback:(){
                _loadTradeInfo();
              }),
            ),
            Expanded(
              child: SizedBox(),
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
                    child: Text("联系卖家",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 16),),
                  ),
                  onTap: () async {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return SingleBtnDialogView(
                            title:"卖家联系方式",
                            content:"${widget.tradeItemModel.contact}",
                            btnText:"复制",
                            callback: (){
                              String content = widget.tradeItemModel.contact;
                              Clipboard.setData(ClipboardData(text: content));
                              showToast(msg: "复制成功");
                            },
                          );
                        });
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
    _loadTradeInfo();
  }

  _loadTradeInfo() async {
    TradeItemModel tradeItemModel = await netManager.client.tradeInfo(widget.tradeItemModel.id??0);
    if(tradeItemModel!=null){
      widget.tradeItemModel = tradeItemModel;
    }
    setState(() {

    });
  }

}
