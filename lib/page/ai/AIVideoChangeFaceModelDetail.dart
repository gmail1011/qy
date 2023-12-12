import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/tasks/multi_image_upload_task.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/page/ai/pay_for_ticket_view.dart';
import 'package:flutter_app/page/setting/you_hui_juan/you_hui_juan_entity.dart';
import 'package:flutter_app/page/video/video_publish/state.dart';
import 'package:flutter_app/page/video/video_publish/upload_video_model.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/custom_picture_management.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_app/widget/dialog/vip_level_dialog.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/task_manager/task_manager.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:image_pickers/image_pickers.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

import 'AIVideoPage.dart';

class AiVideoChangeFaceModelDetail extends StatefulWidget {

  String cover;
  String sourceURL;
  String modId;
  String title;
  int coin;
  int pageType; //0,视频换脸  1图片换脸

  AiVideoChangeFaceModelDetail(this.cover,this.modId,this.sourceURL,this.title,this.coin,{this.pageType = 0});

  @override
  State<AiVideoChangeFaceModelDetail> createState() => _AiVideoChangeFaceModelDetailState();
}

class _AiVideoChangeFaceModelDetailState extends State<AiVideoChangeFaceModelDetail> {

  WalletModelEntity get wallet => GlobalStore.getWallet();

  UploadVideoModel uploadModelAiFace = UploadVideoModel();

  YouHuiJuanData yhjData;


  @override
  void initState() {
    super.initState();
    GlobalStore.refreshWallet();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: .0,
        title:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.title??"",
              style: TextStyle(
                fontSize: AppFontSize.fontSize18,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ],
        ),
        leading: GestureDetector(
          onTap: (){
            safePopPage();
          } ,
          child: Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 13,right: 13,top: 6,bottom: 6),
            child: Image.asset("assets/weibo/back_arrow.png"),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10,right: 10),
        child:   Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment:
              AlignmentDirectional.center,
              children: [
                CachedNetworkImage(
                  imageUrl: path.join(Address.baseImagePath ?? '', widget.cover,),
                  fit: BoxFit.cover,
                  cacheManager: ImageCacheManager(),
                ),
                widget.pageType==0? Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      Gets.Get.to(
                          AiVideoPage(
                            widget.sourceURL,
                            widget.title,
                            isTemple: true,
                          ),);
                    },
                    child: SvgPicture.asset(
                      "assets/svg/video_play.svg",
                      width: 36,
                      height: 36,
                    ),
                  ),
                ):SizedBox(),
              ],
            ),
            SizedBox(height: 18,),
            Text(
                "注意事项:",
                style: const TextStyle(
                    color:  const Color(0xffffffff),
                    fontWeight: FontWeight.w500,
                    fontStyle:  FontStyle.normal,
                    fontSize: 16.0
                ),
                textAlign: TextAlign.center
            ),
            SizedBox(height: 8,),
            Text("1.选择一张人脸清晰，不得有任何遮挡的照片上传（注意：只含一个人物和脸部，图片不能过暗）\n2.选择一个心仪的视频或图片模板，点击生成，生成时间需要3-5分钟，耐心等待。（图片模板可自行上传）\n3.在右上角记录查看生成进度，生成成功后可以点击进行下载，也可以在线观看。\n4.按照上方操作，有问题随时联系在线客服进行处理。\n5.不支持多人图片，禁止未成年人图片",
                style: const TextStyle(
                    color:  const Color(0xff999999),
                    fontWeight: FontWeight.w400,
                    fontStyle:  FontStyle.normal,
                    fontSize: 14.0
                ),
                textAlign: TextAlign.justify
            ),
            SizedBox(height: 22,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image.asset("assets/images/hjll_ai_changeface_right.png",width: 100,height: 100,),
                    SizedBox(height: 14,),
                    new Text("正面无遮挡",
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )
                    )
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  children: [
                    Image.asset("assets/images/hjll_ai_changeface_wrong_1.png",width: 100,height: 100,),
                    SizedBox(height: 14,),
                    new Text("正面无遮挡",
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )
                    )
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  children: [
                    Image.asset("assets/images/hjll_ai_changeface_wrong_2.png",width: 100,height: 100,),
                    SizedBox(height: 14,),
                    new Text("正面无遮挡",
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 22,),
            PictureMangeWidget(
              videoPath: uploadModelAiFace.videoLocalPath,
              picList: uploadModelAiFace.localPicList,
              uploadType: UploadType.UPLOAD_IMG,
              isAi:true,
              mainAixCount:3,
              showTextValue:Text(
                  "上传脸部信息",
                  style: const TextStyle(
                      color:  const Color(0xffffffff),
                      fontWeight: FontWeight.w500,
                      fontStyle:  FontStyle.normal,
                      fontSize: 16.0
                  ),
                  textAlign: TextAlign.center
              ),
              deleteItemCallback: (index) {
                if (uploadModelAiFace.localPicList.isNotEmpty){
                  uploadModelAiFace.localPicList.removeAt(index);
                }
                setState(() {});
              },
              addItemCallback: () async {
                var list = await _pickImg(1);
                if (ArrayUtil.isEmpty(list) ||
                    list.length < 1) {
                  showToast(
                      msg: Lang.PLEASE_THREE_UP_PHOTO,
                      gravity: ToastGravity.CENTER);
                  return;
                }
                uploadModelAiFace.localPicList = list;

                setState(() {});
              },
              onSelectCover: () async {
                var list = await _pickImg(1);

                if (ArrayUtil.isEmpty(list)) return;
                uploadModelAiFace.localPicList?.clear();
                uploadModelAiFace.localPicList.add(list[0]);

                setState(() {});
              },
            ),
            Row(
              children: [
                Text(
                    "消耗金币:${widget.coin}",
                    style: const TextStyle(
                        color:  const Color(0xffffffff),
                        fontWeight: FontWeight.w400,
                        fontStyle:  FontStyle.normal,
                        fontSize: 16.0
                    ),
                    textAlign: TextAlign.center
                ),
                Expanded(child: SizedBox()),
                widget.pageType==0?SizedBox():Text("免费次数:${wallet.aiUndressFreeTimes}",
                    style: TextStyle(
                      color: Color(0xffffffff),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )
                ),
                Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: _submitAiChangeFaceWithVideo,
                  child: Container(
                    margin: EdgeInsets.only(right: 28),
                    height: 40,
                    width: 114,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(22)),
                      gradient: AppColors.linearBackGround,
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 0),
                    child:Text(
                        "生成",
                        style: const TextStyle(
                            color:  Colors.black,
                            fontWeight: FontWeight.w600,
                            fontStyle:  FontStyle.normal,
                            fontSize: 14.0
                        ),
                        textAlign: TextAlign.center
                    )

                  ),
                ),
              ],
            ),
            SizedBox(height: 10,)
          ],
        ),
      )
    );
  }


  void _submitAiChangeFaceWithVideo() async {
    if (!GlobalStore.isVIP()) {
      showVipLevelDialog(context, "您还不是充值VIP无法使用AI换脸");
      return;
    }

    if (uploadModelAiFace.localPicList.length == 0) {
      showConfirm(context, title: "提示", content: "请选择图片");
      return;
    }

    LoadingWidget loadingWidget = LoadingWidget();
    int price = 0;

    try {
      price = int.tryParse(Config.aiUndressPrice ?? "0") ?? 0;
    } catch (e) {}

    if (wallet.amount < price) {}

    List<String> picList = uploadModelAiFace.localPicList;
    loadingWidget.show(context);

    try {
      var multiImageModel = await taskManager.addTaskToQueue(
          MultiImageUploadTask(picList), (progress, {msg, isSuccess}) {
            l.e("progress", "$progress");
      });
      picList = multiImageModel?.filePath ?? [];
      var result;
      if(widget.pageType==0){
        result = await netManager.client.aiFaceGenerate(
          picList,
          widget.modId,
          discount: yhjData == null ? null : [yhjData.id],
        );
      }else{
        result = await netManager.client.aiFacegenerateByPicture(
          picList[0],
          widget.modId,
          discount: yhjData == null ? null : [yhjData.id],
        );
      }
      loadingWidget.cancel();
      if (result != null && result == "success") {
        showToast(msg: "提交成功～");
        uploadModelAiFace.localPicList.clear();
        uploadModelAiFace.selectedTagIdList.clear();
        setState(() {});
        GlobalStore.refreshWallet();
      } else {
        showToast(msg: "提交失败:$result");
      }
    } on DioError catch (e) {
      loadingWidget.cancel();
      var error = e.error;
      showToast(msg: error.message);
    } catch (e) {
      loadingWidget.cancel();
      showToast(msg: e.toString());
    }
  }

  ///选择图片
  Future<List<String>> _pickImg(int needCount) async {
    List<String> ret = [];
    var listMedia = await ImagePickers.pickerPaths(
      uiConfig: UIConfig(uiThemeColor: AppColors.primaryColor),
      galleryMode: GalleryMode.image,
      selectCount: needCount,
      showCamera: true,
    );
    if (ArrayUtil.isEmpty(listMedia)) return ret;

    if (Platform.isAndroid) {
      for (var index = 0; index < listMedia.length; index++) {
        var path = listMedia[index].path;
        if (path != null) {
          ret.add(path);
        }
      }
    } else {
      for (var index = 0; index < listMedia.length; index++) {
        var path = listMedia[index].path;
        var file = File(path);
        var size = await file.readAsBytes();
        //大于300kb的图需要压缩
        if ((size.length / 1024) > 300) {
          var compressFile = await FlutterNativeImage.compressImage(path,
              percentage: 40, quality: 50);
          path = compressFile.path;
        }
        if (path != null) {
          ret.add(path);
        } else {
          showToast(msg: "添加图片失败");
        }
      }
    }
    return ret;
  }

  ///显示优惠券弹窗
  Future showYHQDialog(BuildContext context) {
    var wd = PayForTicketView((item) {
      yhjData = item;
      l.d("showYHQDialog", yhjData.toJson());
    });

    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular( 17),
              topRight: Radius.circular( 17),
            )),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return GestureDetector(
              onVerticalDragUpdate: (e) => false,
              child: SizedBox(
                height: screen.screenHeight * 0.6,
                child: wd,
              ));
        });
  }
}
