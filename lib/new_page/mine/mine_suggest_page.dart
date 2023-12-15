import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/tasks/multi_image_upload_task.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/new_page/mine/floating_cs_view.dart';
import 'package:flutter_app/widget/LoadingWidget.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_pickers/image_pickers.dart';
///帮助反馈
class MineSuggestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MineHelpPageState();
  }
}

class _MineHelpPageState extends State<MineSuggestPage> {
  TextEditingController controller;
  List<String> list = [];
  List<TextEditingController> controllerList = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];
  List questionTitleList = [
    {"question": "充值提现问题？", "index": "0"},
    {"question": "观看使用问题", "index": "1"},
    {"question": "收货地址信息", "index": "2"},
  ];
  List questionList = [
    {"question": "所在地区", "hitText": " 例:浙江杭州", "index": "0"},
    {"question": "设备信息", "hitText": " 例:苹果14", "index": "1"},
    {"question": "网络运营山", "hitText": " 例:电信/联通/移动", "index": "2"},
    {"question": "联系方式", "hitText": " QQ/微信/邮箱等", "index": "3"},
  ];
  TextEditingController _controller = TextEditingController();
  int selectTabIndex = 0;
  var inputText = '';
  bool isClear = false;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    print("=========> ${list.isNotEmpty}");
    return FullBg(
      child: Scaffold(
          appBar: CustomAppbar(title: "意见反馈"),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.only(bottom: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "我遇到的问题",
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 35,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: questionTitleList
                                .map((e) => InkWell(
                                      onTap: () {
                                        selectTabIndex =
                                            int.parse(e["index"] ?? 0);
                                        setState(() {});
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(right: 7),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        height: 33,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            color:
                                                "$selectTabIndex" == e["index"]
                                                    ? Color(0xFF0387FE)
                                                    : Color.fromARGB(
                                                        255, 51, 51, 51)),
                                        child: Text(
                                          e["question"] ?? "",
                                          style: TextStyle(
                                              color: "$selectTabIndex" ==
                                                      e["index"]
                                                  ? Colors.white
                                                  : Colors.white),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "问题描述(必填)",
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 270,
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color.fromARGB(255, 38, 38, 38)),
                        child: TextField(
                          maxLines: 100,
                          keyboardType: TextInputType.text,
                          autofocus: true,
                          autocorrect: true,
                          textInputAction: TextInputAction.search,
                          cursorColor: Colors.white,
                          textAlign: TextAlign.left,
                          controller: controller,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          onChanged: (text) {
                            inputText = text;
                          },
                          onSubmitted: (text) {
                            // _onExChangeCode();
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 10),
                              hintText:
                                  "充值提现问题：请在此处描述具体情况，并且提交图片处提交订单截图/扣款截图\n\n观看使用问题：请在此处描述具体操作情况，并且提交图片处提交出现问题的APP界面截图\n收货地址信息：请按照以下格式在此处填写收货地址，缺少信息将导致无法发\n\n姓名：张三\n电话：18888888\n地址：北京市朝阳区望京666小区6号楼6单元666",
                              hintStyle: TextStyle(color: Color(0xff434c55))),
                        ),
                      ),
                      SizedBox(height: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: questionList
                            .map((e) => _getItem(context, e))
                            .toList(),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "选择图片/视频",
                        style: const TextStyle(
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w300,
                            fontSize: 14.0),
                      ),
                      SizedBox(height: 12),
                      Container(
                        height: 111,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                             if(list.isNotEmpty)
                               Row(
                                   children:list.map((e) =>
                                       Container(
                                         width: 111,
                                         height: 111,
                                         child:ImageLoader.withP(
                                             ImageType.IMAGE_FILE,
                                             address: e,
                                             width: 111,
                                             height: 111)
                                             .load(),
                                       )).toList()),

                              InkWell(
                                onTap: () {
                                  _selectImage();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 51, 51, 51)),
                                  width: 111,
                                  height: 111,
                                  child: Icon(
                                    Icons.add,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "以方便我们给您回复,有效的改进建议,有惊喜赠送哟!",
                        style: const TextStyle(
                            color: const Color(0xff808080),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0),
                      ),
                      SizedBox(height: 59),
                      InkWell(
                        onTap: () {
                          _submitAiImage(list);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 45),
                          decoration: BoxDecoration(
                              color: AppColors.primaryTextColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          width: double.maxFinite,
                          height: 44,
                          alignment: Alignment.center,
                          child: Text(
                            "提交意见",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
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

  Widget _getItem(context, item) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 110,
                child: Text(
                  item["question"],
                  style: const TextStyle(
                      color: const Color(0xffc6c6c6),
                      fontWeight: FontWeight.w700,
                      fontSize: 16.0),
                ),
              ),
              Container(
                width: 100,
                height: 35,
                child: TextField(
                  maxLines: 1,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  autocorrect: true,
                  textInputAction: TextInputAction.search,
                  cursorColor: Colors.white,
                  textAlign: TextAlign.left,
                  controller: controllerList[int.parse(item["index"])],
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  onChanged: (text) {

                  },
                  onSubmitted: (text) {
                    // _onExChangeCode();
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 10),
                      hintText: item["hitText"] ?? "",
                      hintStyle: TextStyle(color: Color(0xff434c55))),
                ),
              )
            ]),
            SizedBox(
              height: 9,
            ),
            Divider(
              height: 1,
              color: Colors.white.withOpacity(0.2),
            )
          ],
        ));
  }

  Container buildText(Map<String, String> data) {
    return Container(
      height: 47,
      width: 200,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                data["question"],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Divider(
            height: 0.5,
            color: Color.fromARGB(125, 102, 102, 102),
          )
        ],
      ),
    );
  }

  Future<List<String>> _selectImage() async {
    list.addAll(await _pickImg(1));
    if (ArrayUtil.isEmpty(list) || list.length < 1) {
      showToast(msg: Lang.PLEASE_THREE_UP_PHOTO, gravity: ToastGravity.CENTER);
      return [];
    }
    setState(() {});
  }

  Future<List<String>> _submitAiImage(List<String> path) async {
    if (path.isEmpty) {
      showConfirm(context, title: "提示", content: "请选择图片");
      //VipRankAlert.show(context, type: VipAlertType.ai);
      return [];
    }
    LoadingWidget loadingWidget = LoadingWidget();
    List<String> picList = [];
    if (controller.text.isEmpty) {
      showToast(msg: "请填写反馈内容");
    }
    loadingWidget.show(context);
    try {
      var multiImageModel = await taskManager.addTaskToQueue(
          MultiImageUploadTask(path), (progress, {msg, isSuccess}) {
        l.e("progress", "$progress");
      });
      //   showToast(msg: "图片上传成功～");
      picList = multiImageModel?.filePath ?? [];
      String content = controller.text ?? "";
      String location = controllerList[0].text ?? "";
      String device = controllerList[1].text ?? "";
      String carrier = controllerList[2].text ?? "";
      List<String> img = picList;
      String contact = controllerList[3].text ?? "";
      String fType = "img";
      var result = await netManager.client.feedbackMutil(
          content, location, device, carrier, img, contact, fType);
      loadingWidget.cancel();
      if (result != null && result["msg"] == "success") {
        showToast(msg: "提交成功～");
        list.clear();
        for(TextEditingController controller in controllerList){
          controller.clear();
        }
        controller.clear();
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
}
