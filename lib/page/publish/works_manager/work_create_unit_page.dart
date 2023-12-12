import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/net2/api_exception.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/tasks/image_upload_task.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/upload/image_upload_result_model.dart';
import 'package:flutter_app/page/alert/coin_recharge_alert.dart';
import 'package:flutter_app/page/alert/vip_rank_alert.dart';
import 'package:flutter_app/page/publish/works_manager/work_rule_detail_page.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/task_manager/task_manager.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart' as Gets;

class WorkCreateUnitPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WorkCreateUnitPageState();
  }
}

class _WorkCreateUnitPageState extends State<WorkCreateUnitPage> {
  TextEditingController textEditingController = TextEditingController();

  Media imageInfo;

  void _selectImagePicker() async {
    if (GlobalStore.isVIP() != true) {
      VipRankAlert.show(
        context,
        type: VipAlertType.createUnit,
      );
      return;
    }
    List<Media> mediaList = await ImagePickers.pickerPaths(
      uiConfig: UIConfig(uiThemeColor: AppColors.primaryColor),
      selectCount: 1,
      showCamera: true,
    );
    if (mediaList.isNotEmpty == true) {
      imageInfo = mediaList.first;
    }
    setState(() {});
  }

  Future<ImageUploadResultModel> updateFile(String filePath) async {
    try {
      ImageUploadResultModel imageModel = await taskManager.addTaskToQueue(
          ImageUploadTask(filePath), (progress, {msg, isSuccess}) {
        l.e("progress", "$progress");
      });
      return imageModel;
    } catch (e) {
      return null;
    }
  }

  void _submitEvent() async {
    if (textEditingController.text.isEmpty) {
      showToast(msg: "请输入标题");
      return;
    }
    if (imageInfo == null) {
      showToast(msg: "请选择封面");
      return;
    }
    WBLoadingDialog.show(context);
    var imageUpdateModel = await updateFile(imageInfo.path);
    if (imageUpdateModel.coverImg?.isNotEmpty == true) {
      try {
        var responseData = await netManager.client.postWorkUnitAdd(
            textEditingController.text, "", imageUpdateModel.coverImg, 1000,0);
        debugLog(responseData);
        FocusScope.of(context).unfocus();
        safePopPage(true);
      } on DioError catch (e) {
        var error = e.error;
        if (error is ApiException) {
          if (error.code == 8000) {
            CoinRechargeAlert.show(
              context,
              coinCount: VariableConfig.videoCollectionPrice,
            );
          } else {
            showToast(msg: "合集创建失败～");
          }
        } else {
          showToast(msg: "合集创建失败～");
        }
      } catch (e) {
        showToast(msg: "合集创建失败～");
      }
    } else {
      showToast(msg: "上传失败～");
    }
    WBLoadingDialog.dismiss(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              FocusScope.of(context).unfocus();
              safePopPage();
            },
          ),
          title: Text(
            "创建合集",
            style: TextStyle(fontSize: AppFontSize.fontSize18),
          ),
          actions: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  child: Visibility(
                    visible: true,
                    child: GestureDetector(
                      onTap: () {
                        Gets.Get.to(() => WorkRuleDetailPage(), opaque: false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: svgAssets(AssetsSvg.ICON_HELP,
                            width: 16, height: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(16, 10, 16, 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "标题",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "（*标题要与上传的合辑视频内容相符）",
                    style: TextStyle(
                      color: Color(0xff626262),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                height: 46,
                padding: EdgeInsets.only(left: 14),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Color(0xff202020),
                ),
                child: TextField(
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  autofocus: true,
                  cursorColor: Colors.blue,
                  cursorHeight: 18,
                  cursorWidth: 2,
                  maxLength: 7,
                  // inputFormatters: [
                  //   LengthLimitingTextInputFormatter(7),
                  // ],
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "请输入最多7个字",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Color(0xff626262),
                    ),
                    border: InputBorder.none,
                  ),
                  controller: textEditingController,
                  // buildCounter: (context, {int currentLength, int maxLength, bool isFocused}) {
                  //   return SizedBox();
                  // },
                ),
              ),
              SizedBox(height: 20),
              Text(
                "封面",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              InkWell(
                onTap: _selectImagePicker,
                child: Container(
                  width: 140,
                  height: 84,
                  decoration: BoxDecoration(
                    color: Color(0xff1e1e1e),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Color(0xff2d3039), width: 1),
                  ),
                  child: imageInfo == null
                      ? Center(
                          child: Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        )
                      : Image.file(
                          File(imageInfo.thumbPath),
                        ),
                ),
              ),
              Spacer(),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    InkWell(
                      onTap: (){
                        Gets.Get.to(() => WorkRuleDetailPage(), opaque: false);
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          "什么是合集？创建规则 »",
                          style: TextStyle(
                            color: Color(0xffd9d9d9),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: _submitEvent,
                      child: Container(
                        height: 44,
                        width: 252,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: LinearGradient(
                              colors: AppColors.buttonWeiBo,
                            )),
                        child: Text(
                          "确定",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
