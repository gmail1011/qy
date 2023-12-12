import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/home/AVCommentary/bean/a_v_commentary_detail_entity.dart';
import 'package:flutter_app/page/home/AVCommentary/bean/a_v_commentary_entity.dart';
import 'package:flutter_app/page/home/AVCommentary/bean/buy_av_commentary_result_entity.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_app/widget/richTextParsing/html.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';

class AVCommentaryDetailPage extends StatefulWidget {
  int index;
  AVCommentaryDataList xList;
  AVCommentaryDetailPage({Key key, this.index,this.xList}) : super(key: key);

  @override
  _AVCommentaryDetailPageState createState() => _AVCommentaryDetailPageState();
}

class _AVCommentaryDetailPageState extends State<AVCommentaryDetailPage> {
  // InAppWebViewController _controller;
  double _htmlHeight = 500; // 目的是在回调完成直接先展示出200高度的内容, 提高用户体验

  static const String HANDLER_NAME = 'InAppWebView';

  SingleController singleController;


  AVCommentaryDetailEntity avCommentaryDetailEntity;


  bool isShowDialog = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    singleController = new SingleController(true);

    initData();
  }


  void initData() async{
    dynamic detail = await netManager.client.getAVCommentaryDetail(widget.xList.id);

    avCommentaryDetailEntity = AVCommentaryDetailEntity().fromJson(detail);

    if(avCommentaryDetailEntity != null){
       setState(() {

       });
    }


    bus.on(EventBusUtils.avCommentaryInsufficientBalance, (arg) {
    });
}

  @override
  void dispose() {
    super.dispose();
    // _controller?.removeJavaScriptHandler(HANDLER_NAME, 0);
    // _controller = null;
  }

  @override
  Widget build(BuildContext context) {
    String graphic = widget.xList.graphic;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: CustomAppbar(
        title: "AV解說",
      ),
      body: avCommentaryDetailEntity == null || avCommentaryDetailEntity.isBuy == null ? Center(child: LoadingWidget()) : ListView(
        shrinkWrap: true,
        children: [
          //影片信息
          Container(
            alignment: Alignment.centerLeft,
            //padding:  EdgeInsets.only(left: Dimens.pt16),
            child: Image.asset(
              "assets/images/video_info_image.png",
              width: Dimens.pt120,
              height: Dimens.pt40,
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: Dimens.pt16, right: Dimens.pt16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimens.pt10),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimens.pt8),
                      topRight: Radius.circular(Dimens.pt8)),
                  child: Container(
                    height: Dimens.pt220,
                    color: Colors.black,
                    child: SinglePlayer(
                      widget.xList.sourceURL,
                      widget.xList.sourceID,
                      singleController: singleController,
                      loop: true,
                      // 播放器回调更新

                      // onPrepared: (c) =>
                      //     dispatch(VideoItemActionCreator.onVideoInited(c)),
                      // 播放器生命周期初始化


                      updateCallBack: (c) async{
                          if(c.isPlayable()){

                            if(c.currentPos.inSeconds == 9){
                              if(!avCommentaryDetailEntity.isBuy && avCommentaryDetailEntity.price > 0){
                                c.pause();
                                c.seekTo(0);

                                if(!isShowDialog){
                                  isShowDialog = true;
                                  var val = await showConfirm(context,
                                      title: "需要花费${widget.xList.price ?? 0}金币观看", showCancelBtn: true);
                                  if (null == val || !val) return;

                                  ///点击了确定按钮后
                                  if(val){
                                    dynamic resultData = await netManager.client.postBuyAVCommentary(widget.xList.id, widget.xList.title, widget.xList.price, 11);
                                    BuyAvCommentaryResultEntity buyAvCommentaryResultEntity;
                                    if(resultData==""){
                                      buyAvCommentaryResultEntity = BuyAvCommentaryResultEntity();
                                      buyAvCommentaryResultEntity.msg = "success";
                                    }else{
                                      buyAvCommentaryResultEntity = BuyAvCommentaryResultEntity().fromJson(resultData);
                                    }

                                    if(buyAvCommentaryResultEntity != null && buyAvCommentaryResultEntity.msg == "success"){
                                      showToast(msg: '购买成功');
                                      avCommentaryDetailEntity.isBuy = true;
                                      c.start();
                                    }else{
                                      if(buyAvCommentaryResultEntity.msg != null){
                                        showToast(msg: buyAvCommentaryResultEntity.msg);
                                        avCommentaryDetailEntity.isBuy = false;

                                      }else{
                                        showToast(msg: "请求失败");
                                        avCommentaryDetailEntity.isBuy = false;
                                      }
                                    }
                                  }
                                }
                              }
                            }


                          }
                      },
                      playerBuilder: (c) => VPlayer(
                        controller: c,
                        resolutionWidth: 1280,
                        resolutionHeight: 720,
                        containerHeight: Dimens.pt220,
                        //dutationInSec: state.videoModel?.playTime ?? 0,
                        onTap: (c) async{
                          if(!avCommentaryDetailEntity.isBuy && avCommentaryDetailEntity.price > 0){
                            var val = await showConfirm(context,
                                title: "需要花费${widget.xList.price ?? 0}金币观看", showCancelBtn: true);
                            if (null == val || !val) return;

                            ///点击了确定按钮后
                            if(val){
                              dynamic resultData = await netManager.client.postBuyAVCommentary(widget.xList.id, widget.xList.title, widget.xList.price, 11);
                              BuyAvCommentaryResultEntity buyAvCommentaryResultEntity;
                              if(resultData==""){
                                 buyAvCommentaryResultEntity = BuyAvCommentaryResultEntity();
                                 buyAvCommentaryResultEntity.msg = "success";
                              }else{
                                 buyAvCommentaryResultEntity = BuyAvCommentaryResultEntity().fromJson(resultData);
                              }

                              if(buyAvCommentaryResultEntity != null && buyAvCommentaryResultEntity.msg == "success"){
                                showToast(msg: '购买成功');
                                avCommentaryDetailEntity.isBuy = true;
                                c.start();
                              }else{
                                if(buyAvCommentaryResultEntity.msg != null){
                                  showToast(msg: buyAvCommentaryResultEntity.msg);
                                  avCommentaryDetailEntity.isBuy = false;
                                }else{
                                  showToast(msg: "请求失败");
                                  avCommentaryDetailEntity.isBuy = false;
                                }
                              }
                            }
                          }else{
                            if(c.isPlaying){
                              c.pause();
                            }

                            if(c.isPause){
                              c.start();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ),



                Padding(
                  padding: EdgeInsets.only(
                      left: Dimens.pt8,
                      right: Dimens.pt8,
                      bottom: Dimens.pt18,
                      top: Dimens.pt10),
                  child: Text(
                    widget.xList.videoInfo,
                    style: TextStyle(
                        fontSize: Dimens.pt14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Dimens.pt21,
          ),
          //  图文解说
          Container(
            alignment: Alignment.centerLeft,
            //padding:  EdgeInsets.only(left: Dimens.pt16),
            child: Image.asset(
              "assets/images/video_commentary_image.png",
              width: Dimens.pt120,
              height: Dimens.pt40,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimens.pt10),
            ),
            padding: EdgeInsets.only(left: Dimens.pt16, right: Dimens.pt16),
            margin: EdgeInsets.only(left: Dimens.pt16, right: Dimens.pt16),
            child: Html(data: graphic,avCommentaryDetailEntity: avCommentaryDetailEntity,),
          )
        ],
      ),
    );
  }
}
