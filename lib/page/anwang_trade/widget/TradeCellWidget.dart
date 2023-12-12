import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/trade/Medias.dart';
import 'package:flutter_app/model/trade/TradeItemModel.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:get/route_manager.dart' as Gets;

import '../TradeDetailPage.dart';
import 'double_btn_view.dart';

class TradeCellWidget extends StatefulWidget {
  final TradeItemModel tradeItemModel;
  int viewerLimit;
  int pageType;
  VoidCallback buttonCallback;
  bool isMine = false;
  String verifyStatus = "0";  // 0 审核中 1 通过 2 拒绝通过
  TradeCellWidget({Key key, this.tradeItemModel,this.pageType,this.buttonCallback,this.isMine,this.verifyStatus,this.viewerLimit}) : super(key: key);

  @override
  State<TradeCellWidget> createState() => _TradeCellWidgetState();
}

class _TradeCellWidgetState extends State<TradeCellWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        InkResponse(
          highlightColor: Colors.transparent,
          radius: 0.0,
          child:( widget.tradeItemModel?.type!=null && widget.tradeItemModel?.type == 'adv')
              ? advView(widget.tradeItemModel) :
              Stack(
                children: [
                  (widget.viewerLimit!=null && widget.viewerLimit>GlobalStore.getWallet().consumption)?
                  Container(
                    child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: 2.6,
                          sigmaY: 2.6,
                        ),
                        child: Stack(
                          children: [
                            _getTradeInfoWidget(widget.tradeItemModel,widget.isMine,widget.verifyStatus,context),
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                color: Color.fromRGBO(0, 0, 0, 0.7),
                              )
                            )
                          ],
                        )
                    ),
                  ):_getTradeInfoWidget(widget.tradeItemModel,widget.isMine,widget.verifyStatus,context),
                  (widget.viewerLimit!=null && widget.viewerLimit>GlobalStore.getWallet().consumption)?
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("累计充值${widget.viewerLimit==null?"0":widget.viewerLimit}元可见",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),),
                          ],
                        ),
                      )
                  ):Container(),
                ],
              ),
            onTap: () {
              if(widget.pageType==1){
                if((widget.viewerLimit!=null && widget.viewerLimit>GlobalStore.getWallet().consumption)){
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return DoubleBtnDialogView(
                          title:"注意",
                          content:"累计充值达${widget.viewerLimit}元即可查看该交易",
                          leftBtnText:"购买VIP",
                          rightBtnText: "充值金币",
                          leftCallback: () async {
                            Gets.Get.to(MemberCentrePage().buildPage({"position": "0"}));
                          },
                          rightCallback: (){
                            Gets.Get.to(MemberCentrePage().buildPage({"position": "1"}));
                          },
                        );
                      });
                  return;
                }
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return TradeDetailPage(tradeItemModel:widget.tradeItemModel);
                  },
                ));
              }
            },
        ),

        // Container(
        //   width: screen.screenWidth,
        //   height: 10,
        //   color: Colors.transparent,
        // ),
      ],
    );
  }
}

String  playCountDesc(int viewCount){
  if(viewCount != null && viewCount > 10000) {
    return (viewCount / 10000).toStringAsFixed(1) + "w";
  }else {
    return viewCount?.toString() ?? "0";
  }
}

Widget advView(TradeItemModel tradeItemModel) {
  return Container(
    width:192,
    child: GestureDetector(
      onTap: () {
        JRouter().handleAdsInfo(tradeItemModel.advInfo.href, id: tradeItemModel.advInfo.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.pt10),
        child: CustomNetworkImage(
          imageUrl: tradeItemModel.advInfo?.cover,
          fit: BoxFit.cover,
          height:192,
        ),
      ),
    ),
  );
}

Widget getHeaderView(TradeItemModel tradeItemModel,bool isMine,String verifyStatus,BuildContext context){
  return Container(
    child: Row(
      children: [
       ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.pt22),
          child: CustomNetworkImage(
            imageUrl: tradeItemModel.publisher?.portrait??"",
            fit: BoxFit.cover,
            height: Dimens.pt44,
            width: Dimens.pt44,
          ),
        ),
        Expanded(child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 12,),
                Text(tradeItemModel.publisher.name,style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: Dimens.pt16),),
                tradeItemModel.tradeType=="buy"?Container(  // buy 求购/sell 售卖
                  margin: EdgeInsets.only(left: 12),
                  padding: EdgeInsets.only(left: 4,right: 4,top: 0,bottom: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Color.fromRGBO(0, 156, 255, 1),
                  ),
                  child: Text("买方",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),),
                ):
                Container(
                  margin: EdgeInsets.only(left: 12),
                  padding: EdgeInsets.only(left: 4,right: 4,top: 0,bottom: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Color.fromRGBO(255, 26, 21, 1),
                  ),
                  child: Text("卖方",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1),fontSize: 12),),
                ),
              ],
            ),
            SizedBox(height: 5,),
            Container(
              margin: EdgeInsets.only(left: Dimens.pt12),
              child: Text(DateTimeUtil.utc2iso(tradeItemModel?.createAt),style: TextStyle(color: Color.fromRGBO(204, 204, 204, 1),fontSize: Dimens.pt12),),
            ),

          ],
        ),),

      ],
    ),
  );
}

Widget getContentView(TradeItemModel tradeItemModel){
  var medias  =  tradeItemModel.medias[0];
  if(medias.type=='vid'){

  }
}

//post video layout
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
      //32 为左右边距
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
                    // width: videoResolution.videoWidth,
                    // height: videoResolution.videoHeight,
                    width:192,
                    height: 192,
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
                        height: Dimens.pt50)
                            .load(),
                      ),
                    ),
                  ),
              ),
        ],
     ),
  );
}


Widget createImageLayout(TradeItemModel tradeItemModel,BuildContext context,{VoidCallback needPay}) {
  List<String> urlList = [];
  for(Medias media in tradeItemModel.medias){
    urlList?.add(media.src);
  }
  return urlList.isNotEmpty ?? false ? Container(
    child:  CustomNetworkImage(
      imageUrl:urlList[0] ?? "",
      fit: BoxFit.contain,
      width: 192,
      height: 192,
      placeholder: Container(
        color: Colors.transparent,
        width: 192,
        height: 192,
      ),
    ),
  ) : Container();
}



//   0 // 待交易
//  1 // 交易中
//  2 // 交易已取消
//  5 // 交易完成
//  7 // 交易异常 被骗申诉状态
Widget getTradeStatusText(TradeItemModel tradeItemModel){
  switch(tradeItemModel.tradeStatus){
    case 0:
      return Text("等待交易",style: TextStyle(color: Color.fromRGBO(205, 26, 1, 1)),);
      break;
    case 1:
      return Text("交易中...",style: TextStyle(color: Color.fromRGBO(246, 196, 121, 1)),);
      break;
    case 2:
      return Text("交易已取消",style: TextStyle(color: Color.fromRGBO(0, 163, 255, 1)),);
      break;
    case 5:
      return Text("交易完成",style: TextStyle(color: Color.fromRGBO(0, 163, 255, 1)),);
      break;
    case 7:
      return Text("交易异常",style: TextStyle(color: Color.fromRGBO(0, 163, 255, 1)),);
      break;
  }
}


Widget _getTradeInfoWidget(TradeItemModel tradeItemModel,bool isMine,String verifyStatus,BuildContext context){
  return   Container(
    color: Color.fromRGBO(26, 26, 26, 0.6),
    child:  Stack(
      children: [
        Column(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child:CustomNetworkImage(
                      imageUrl: tradeItemModel.cover,
                      fit: BoxFit.cover,
                      height:192,
                    ),
                  ),
                  Container(
                    color: Color.fromRGBO(15, 5, 43, 1),
                    padding: EdgeInsets.only(left: 8,top: 11,right: 11,bottom: 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child:  Text(
                                tradeItemModel.goodsName??"",
                                maxLines:1,
                                style: TextStyle(
                                    color: Colors.white, fontSize: Dimens.pt12)
                            )),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Expanded(child: Text("¥${tradeItemModel.publisherDeposit==null?"0":tradeItemModel.publisherDeposit/10}",style: TextStyle(color: Color.fromRGBO(253, 212, 144, 1),fontSize: Dimens.pt14),),),
                            Text("${tradeItemModel.tradeCount}人购买",style: TextStyle(color: Color.fromRGBO(177, 177, 177, 1),fontSize: 12),)
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: Dimens.pt12,),
                ],
              ),
            ),
          ],
        ),
        isMine?
        Positioned(
            bottom:32,
            right: 10,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                width: Dimens.pt68,
                height: Dimens.pt20,
                decoration: verifyStatus=="2"?BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(51, 51, 51, 1),
                          Color.fromRGBO(51, 51, 51, 1),
                        ]
                    )
                ):BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(253, 239, 165, 1),
                          Color.fromRGBO(249, 180, 91, 1),
                        ]
                    )
                ),
                child: Text(verifyStatus=="0"?"审核中...":verifyStatus=="1"?"审核通过": verifyStatus=="2"?"未过审":"",style: TextStyle(color: verifyStatus=="2"?Color.fromRGBO(255, 255, 255, 1):Color.fromRGBO(0, 0, 0, 1),fontSize: 12),),
              ),
              onTap: (){
                if(verifyStatus == "2"){
                  // showDialog(
                  //     context: context,
                  //     barrierDismissible: false,
                  //     builder: (BuildContext context) {
                  //       return SingleBtnDialogView(
                  //         title:"未过审原因",
                  //         content:tradeItemModel.reason,
                  //         btnText:"我知道了",
                  //       );
                  //     });
                  showToast(msg: "未过审原因:${tradeItemModel.reason}");
                }
              },
            )) :Container(),
      ],
    ),
  );
}

//点击进入
void _onJumpToVideoPlayList(TradeItemModel tradeItemModel, BuildContext context) {
  l.i("post", "_onJumpToVideoPlayList()...UC");
  List<Medias> medias = tradeItemModel.medias;
  List<VideoModel> listVideo =  [] ;
  for(Medias medias in medias){
    if(medias.type=="vid"){
      VideoModel videoModel = new VideoModel();
      videoModel.sourceID = medias.sourceID;
      videoModel.sourceURL = medias.src;
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

  Navigator.of(context).push(MaterialPageRoute(
    builder: (BuildContext context) => SubPlayListPage().buildPage(map),
  ));
}
