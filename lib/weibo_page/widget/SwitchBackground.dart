import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/tasks/image_upload_task.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/upload/image_upload_result_model.dart';
import 'package:flutter_app/page/alert/vip_rank_alert.dart';
import 'package:flutter_app/weibo_page/widget/switch_background_entity.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_pickers/image_pickers.dart';

class SwitchBackgroundPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SwitchBackgroundPageState();
  }
}

class SwitchBackgroundPageState extends State<SwitchBackgroundPage> {
  SwitchBackgroundData switchBackgroundData;

  int selectedBackground = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      dynamic videoss = await netManager.client.getBloggerBackground(
        1,
        20,
        "bg",
      );
      switchBackgroundData = SwitchBackgroundData().fromJson(videoss);
      setState(() {});
    } catch (e) {
      //l.e("loadUser", "_onLoadUserInfo()...error:$e");
    }
  }

  void _selectImagePicker() async{
    if(GlobalStore.isVIP() != true){
      VipRankAlert.show(
        context,
        type: VipAlertType.background,
      );
      return;
    }
    List<Media> mediaList = await ImagePickers.pickerPaths(
      uiConfig: UIConfig(uiThemeColor: AppColors.primaryColor),
      selectCount: 1,
      showCamera: true,
    );
    if(mediaList.isNotEmpty == true){
      updateFile(mediaList.first.path);
    }
  }

  void updateFile(String filePath) async{
    WBLoadingDialog.show(context);
    int maxSize = 100*1024;
    try {
      var imagePath = await compressImage(maxSize, filePath);
      ImageUploadResultModel imageModel = await taskManager
          .addTaskToQueue(ImageUploadTask(imagePath),
              (progress, {msg, isSuccess}) {
            l.e("progress", "$progress");
          });
     // showToast(msg: "上传成功～");
      if(imageModel.coverImg?.isNotEmpty == true){
        _exchangeBgImage(filePath: imageModel.coverImg);
      }else {
        showToast(msg: "上传失败～");
        WBLoadingDialog.dismiss(context);
      }
    }catch(e){
      showToast(msg: "上传失败～");
      WBLoadingDialog.dismiss(context);
    }
   // picList = multiImageModel?.filePath ?? [];
  }

  Future<String> compressImage(int maxSize, String filePath) async{
    var file = File(filePath);
    var size = await file.readAsBytes();
    if (size.length > maxSize) {
      var compressFile = await FlutterNativeImage.compressImage(filePath,
          percentage: 40, quality: 50);
      filePath = compressFile.path;
      return compressImage(maxSize, filePath);
    }else {
      return filePath;
    }

  }

  void _exchangeBgImage({String filePath}) async{
    List<String> lists = [];
    bool isDefaultSource = true;
    if(filePath != null){
      lists.add(filePath);
      isDefaultSource = false;
    }else {
      lists.add(switchBackgroundData.xList[selectedBackground].resource);
    }
    try {
      dynamic videoss = await netManager.client
          .setBackground(lists, "background", isDefaultSource);
      if(filePath != null){
        WBLoadingDialog.dismiss(context);
      }
      if(isDefaultSource) {
        safePopPage(true);
      }else {
        safePopPage(filePath);
      }
    } catch (e) {
      if(filePath != null){
        WBLoadingDialog.dismiss(context);
      }
      //l.e("loadUser", "_onLoadUserInfo()...error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "更换主页背景",
          style: TextStyle(color: Colors.white, fontSize: 20.nsp),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () async {
                _exchangeBgImage();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: AppColors.buttonWeiBo,
                      ),
                    ),
                    child: Text(
                      "确认",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
              // child: Image.asset(
              //   "assets/weibo/images/icon_personal_save.png",
              //   width: 80.w,
              //   height: 100.w,
              // ),
            ),
          ),
        ],
      ),
      body: switchBackgroundData == null
          ? LoadingWidget()
          : switchBackgroundData.xList == null ||
                  switchBackgroundData.xList.length == 0
              ? CErrorWidget("暂无数据")
              : Padding(
                  padding: EdgeInsets.only(top: 16.w, left: 12, right: 12),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1),
                      itemCount: switchBackgroundData.xList.length + 1,
                      itemBuilder: (context, index) {
                        if(index == 0){
                          return _buildAlbumButton();
                        }
                        int imageIndex = index - 1;
                        var model = switchBackgroundData.xList[imageIndex];
                        return GestureDetector(
                          onTap: () async {
                            //safePopPage(switchBackgroundData.xList[index].resource);
                            selectedBackground = imageIndex;
                            setState(() {});
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                CustomNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: model.resource,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Visibility(
                                    visible: selectedBackground == imageIndex
                                        ? true
                                        : false,
                                    child: Image.asset(
                                      "assets/weibo/select_background.png",
                                      width: 20.w,
                                      height: 20.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
    );
  }

  Widget _buildAlbumButton() {
    return InkWell(
      onTap: (){
        _selectImagePicker();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xff1e1e1e),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Color(0xff313131),width: 1),
        ),
        child: Image(
          width: 28,
          height: 21,
          image: AssetImage("assets/images/album_small.png"),
        ),
      ),
    );
  }

}
