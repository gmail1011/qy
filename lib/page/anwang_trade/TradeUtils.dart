
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/trade/Medias.dart';
import 'package:flutter_app/model/trade/TradeItemModel.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/anwang_trade/widget/double_btn_view.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/toast_util.dart';

Widget commonTradeStatusText(TradeItemModel tradeItemModel,TextStyle textStyle){
  switch(tradeItemModel.tradeStatus){
    case 0:
      return Text("等待交易",style: textStyle==null?TextStyle(color: Color.fromRGBO(205, 26, 1, 1)):textStyle,);
      break;
    case 1:
      return Text("交易中...",style: textStyle==null?TextStyle(color: Color.fromRGBO(246, 196, 121, 1)):textStyle,);
      break;
    case 2:
      return Text("交易已取消",style: textStyle==null?TextStyle(color: Color.fromRGBO(0, 163, 255, 1)):textStyle,);
      break;
    case 5:
      return Text("交易完成",style: textStyle==null?TextStyle(color: Color.fromRGBO(0, 163, 255, 1)):textStyle,);
      break;
    case 7:
      return Text("交易异常",style: textStyle==null?TextStyle(color: Color.fromRGBO(0, 163, 255, 1)):textStyle,);
      break;
  }
}

//   0 // 待交易
//  1 // 交易中
//  2 // 交易已取消
//  5 // 交易完成
//  7 // 交易异常 被骗申诉状态
Widget getTradeStatusButton(TradeItemModel tradeItemModel,BuildContext context,{VoidCallback buttonCallback}){
  return
   (tradeItemModel.tradeStatus==1 && (tradeItemModel.orderUID == GlobalStore.getMe().uid || tradeItemModel.publisherUID == GlobalStore.getMe().uid))?GestureDetector(
            child: Container(
              child: Row(
                children: [
                  GestureDetector(
                    child: Container(
                      alignment:Alignment.center,
                      width: 80,
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
                      child: Text("取消订单" ,style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),),
                    ),
                    onTap: () async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return DoubleBtnDialogView(
                              title:"温馨提示",
                              content:"扣除手续费15% 依然继续吗?",
                              leftBtnText:"取消交易",
                              rightBtnText: "再想想",
                              leftCallback: () async {
                                try {
                                  await netManager.client.cancelTrade(tradeItemModel.id);
                                  showToast(msg: "操作成功！");
                                  buttonCallback?.call();
                                } catch (e) {
                                  showToast(msg: "操作失败！");
                                }
                              },
                              rightCallback: (){

                              },
                            );
                          });
                    },
                  ),
                  SizedBox(width: 10,),
                  GestureDetector(
                    child: Container(
                      alignment:Alignment.center,
                      width: 80,
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
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return DoubleBtnDialogView(
                              title:"温馨提示",
                              content:"是否确认收货？",
                              leftBtnText:"确认收货",
                              rightBtnText: "再想想",
                              leftCallback: () async {
                                try {
                                  await netManager.client.finishTrade(tradeItemModel.id);
                                  showToast(msg: "操作成功！");
                                  buttonCallback?.call();
                                } catch (e) {
                                  showToast(msg: "操作失败！");
                                }
                              },
                              rightCallback: (){

                              },
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
          )
   :Container();
}


Widget getTradeOrderCellWidget(TradeItemModel tradeItemModel,BuildContext context,{bool isOrderDetail = false,VoidCallback buttonCallback}){
  return Container(
    margin: EdgeInsets.only(top:10),
    width: screen.screenWidth,
    // height: isOrderDetail??false?274:119,
    decoration: BoxDecoration(
      color: Color.fromRGBO(34, 34, 34, 1),
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    child:Column(
      children: [
        Container(
          height: 119,
          child:  Row(
            children: [
              SizedBox(width: 13,),
              GestureDetector(
                child:ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  child: CustomNetworkImage(
                    fit: BoxFit.cover,
                    height: 86,
                    width: 86,
                    imageUrl: tradeItemModel.cover??"",
                  ),
                ),
                onTap: (){
                },
              ),
              SizedBox(width: 11,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15,),
                  Expanded(child: Text("${tradeItemModel.goodsName}",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 16),),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(child: Text("${tradeItemModel.publisherDeposit}金币",style: TextStyle(color: Color.fromRGBO(253, 212, 144, 1),fontSize: 14),),),
                      ( (isOrderDetail??false) && tradeItemModel.orderUsrOperate==0 && tradeItemModel.tradeStatus==1)?getTradeStatusButton(tradeItemModel,context,buttonCallback:buttonCallback):commonTradeStatusText(tradeItemModel,TextStyle(color: Color.fromRGBO(137, 137, 137, 1))),
                      SizedBox(width: 12,),
                    ],
                  ),
                  SizedBox(height: 24,),
                ],
              )),
            ],
          ),
        ),
        isOrderDetail??false?Column(
          children: [
            Row(
              children: [
                SizedBox(width: 15,),
                Text("收货人:",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14)),
                SizedBox(width: 10,),
                Expanded(child: Text("${tradeItemModel.leaveMsg.split("}{").length>0?tradeItemModel.leaveMsg.split("}{")[0].replaceAll("{", ""):""}",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14)),),
                SizedBox(width: 10,),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(width: 15,),
                Text("手机号:",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14)),
                SizedBox(width: 10,),
                Expanded(child: Text("${tradeItemModel.leaveMsg.split("}{").length>1?tradeItemModel.leaveMsg.split("}{")[1]:""}",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14)),),
                SizedBox(width: 10,),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(width: 15,),
                Text("详细地址:",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14)),
                SizedBox(width: 10,),
                Expanded(child: Text("${tradeItemModel.leaveMsg.split("}{").length>2?tradeItemModel.leaveMsg.split("}{")[2]:""}",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14)),),
                SizedBox(width: 10,),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                SizedBox(width: 15,),
                SizedBox(
                  width: 72,
                  child:  Text("邮箱地址:",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14)),
                ),
                SizedBox(width: 10,),
                Expanded(child: Text("${tradeItemModel.leaveMsg.split("}{").length>3?tradeItemModel.leaveMsg.split("}{")[3].replaceAll("}", ""):""}",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 14)),),
                SizedBox(width: 10,),
              ],
            ),
          ],
        ):SizedBox(),
        SizedBox(height: 16,),
      ],
    )

  );
}



//点击进入
void onJumpToVideoPlayList(TradeItemModel tradeItemModel, BuildContext context,{bool isTrade}) {
  l.i("post", "_onJumpToVideoPlayList()...UC");
  List<Medias> medias = tradeItemModel.medias;
  List<VideoModel> listVideo =  [] ;
  for(Medias medias in medias){
    if(medias.type=="vid"){
      VideoModel videoModel = new VideoModel();
      videoModel.sourceID = medias.sourceID;
      videoModel.sourceURL = medias.src;
      videoModel.freeArea = true;
      videoModel.freeTime = 10000*100;
      listVideo.add(videoModel);
    }
  }
  Map<String, dynamic> map = Map();
  map['playType'] = VideoPlayConfig.VIDEO_TYPE_WORKS;
  map['pageNumber'] = 1;
  map['uid'] = tradeItemModel.publisherUID;
  map['pageSize'] = 10;
  map["apiAddress"] = Address.MINE_WORKS;
  map['currentPosition'] =0;
  map['videoList'] = listVideo;
  map['isTrade'] = isTrade;

  Navigator.of(context).push(MaterialPageRoute(
    builder: (BuildContext context) => SubPlayListPage().buildPage(map),
  ));
}


Widget createVideoLayout(Medias medias,String corver, {VoidCallback onItemClick, VoidCallback onPlayClick, VoidCallback needPay}) {
  var vWidth = 0;
  var  vHeight = 0;
  VideoResolution videoResolution;
  if (null == medias) return Container();
  vWidth = medias.width;
  vHeight = medias.height;
  //横屏
  if (vWidth > vHeight) {
    videoResolution = configVideoSize(Dimens.pt328, Dimens.pt328 * 9 / 16, double.parse(vWidth.toString()), double.parse(vHeight.toString()), true);
    if (videoResolution.videoWidth > screen.screenWidth) {
      //32  为左右边距
      videoResolution.videoWidth = screen.screenWidth - 32;
    }
  } else {
    //竖屏
    videoResolution = configVideoSize(Dimens.pt250, Dimens.pt360, double.parse(vWidth.toString()), double.parse(vHeight.toString()), true);
    if (videoResolution.videoHeight > Dimens.pt360) {
      videoResolution.videoHeight = Dimens.pt360;
    }
  }
  return Container(
    child: Stack(
      children: <Widget>[
        GestureDetector(
          child: Container(
            width: videoResolution.videoWidth,
            height: videoResolution.videoHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimens.pt5),
              child: CustomNetworkImage(
                width: videoResolution.videoWidth,
                height: videoResolution.videoHeight,
                imageUrl: corver,
                placeholder: Container(
                  color: Color(0xff000000),
                ),
                fit: vWidth > vHeight ? BoxFit.cover : BoxFit.fitWidth,
              ),
            ),
          ),
          onTap: onItemClick,
        ),
        Positioned(
          left: 0,
          width: videoResolution.videoWidth,
          height: videoResolution.videoHeight,
          child: GestureDetector(
            onTap: onPlayClick,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(Dimens.pt5),
                child: ImageLoader.withP(ImageType.IMAGE_SVG,
                    address: AssetsSvg.VIDEO_PAUSE_TIP,
                    width: Dimens.pt50,
                    height: Dimens.pt50).load(),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}