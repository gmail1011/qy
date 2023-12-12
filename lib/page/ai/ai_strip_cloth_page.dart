import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/tasks/multi_image_upload_task.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/a_i_face_data.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/ai/AiChangeFaceMod.dart';
import 'package:flutter_app/model/ai/AiChangeFaceVideoMod.dart';
import 'package:flutter_app/model/ai/AiModList.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/page/ai/pay_for_ticket_view.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/video/video_publish/state.dart';
import 'package:flutter_app/page/video/video_publish/upload_video_model.dart';
import 'package:flutter_app/widget/common_widget/LoadingWidget.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/custom_picture_management.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_app/widget/dialog/vip_level_dialog.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:image_pickers/image_pickers.dart';

import '../../utils/EventBusUtils.dart';
import '../setting/you_hui_juan/you_hui_juan_entity.dart';
import 'AIVideoChangeFaceModelDetail.dart';
import 'AIVideoPage.dart';
import 'ai_total_page.dart';

class AiStripClothPage extends StatefulWidget {
  const AiStripClothPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AiStripClothPageState();
  }
}

class _AiStripClothPageState extends State<AiStripClothPage> {
  String selectedImagePath;

  WalletModelEntity get wallet => GlobalStore.getWallet();

  UploadType uploadType = UploadType.UPLOAD_IMG;

  UploadVideoModel uploadModel = UploadVideoModel();

  UploadVideoModel uploadModelAiFace = UploadVideoModel();

  AiModList aiModList;

  TabController tabController = TabController(
    length: 3,
    vsync: ScrollableState(),
  );

  Map<int, bool> selectedRadioButton = new Map();

  int selectedRadioIndex = 0;

  YouHuiJuanData yhjData;
  int selectIndex = 0;
  final List<AdsInfoBean> models = [];

  @override
  void initState() {
    super.initState();

    tabController.addListener(() {
      selectIndex = tabController.index;
      setState(() {});
    });

    GlobalStore.refreshWallet();
    getAIModel();

    bus.on(EventBusUtils.changeAITemple, (arg) {
      for (int i = 0; i < selectedRadioButton.length; i++) {
        if (arg == i) {
          selectedRadioButton[i] = true;
          selectedRadioIndex = i;
        } else {
          selectedRadioButton[i] = false;
        }
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    bus.off(EventBusUtils.changeAITemple);
  }

  void getAIModel() async {
    var result = await netManager.client.getAIModelList();

    aiModList = AiModList.fromJson(result);

    for (int i = 0; i < aiModList.aiChangeFaceVideoMod.length; i++) {
      if (i == 0) {
        selectedRadioButton[0] = true;
      } else {
        selectedRadioButton[i] = false;
      }
    }
    for (int i = 0; i < aiModList.aiUndressMod.length; i++) {
      AdsInfoBean adsInfoBean = AdsInfoBean();
      adsInfoBean.cover = aiModList.aiUndressMod[i].cover;
      models.add(adsInfoBean);
    }
    setState(() {});
  }

  void _selectImage() async {
    if (!GlobalStore.isRechargeVIPNew()) {
      showVipLevelDialog(context, "您还不是VIP无法使用AI脱衣");
      // VipRankAlert.show(context, type: VipAlertType.ai);
      return;
    }
    List<Media> mediaList = await ImagePickers.pickerPaths(
      uiConfig: UIConfig(uiThemeColor: AppColors.primaryColor),
      selectCount: 9,
      showCamera: false,
    );
    l.e("_selectImage-mediaList", "$mediaList");
    if (mediaList.isNotEmpty == true) {
      selectedImagePath = mediaList.first.path;
    }
    setState(() {});
  }

  void _submitAiImage() async {
    if (!GlobalStore.isRechargeVIP()) {
      showVipLevelDialog(context, "您还不是充值VIP无法使用AI脱衣");
      // VipRankAlert.show(context, type: VipAlertType.ai);
      return;
    }

    if (uploadModel.localPicList.length == 0) {
      showConfirm(context, title: "提示", content: "请选择图片");
      //VipRankAlert.show(context, type: VipAlertType.ai);
      return;
    }

    LoadingWidget loadingWidget = LoadingWidget();
    int price = 0;
    try {
      price = int.tryParse(Config.aiUndressPrice ?? "0") ?? 0;
    } catch (e) {}
    if (wallet.amount < price) {}
    List<String> picList = uploadModel.localPicList;
    loadingWidget.show(context);
    try {
      var multiImageModel = await taskManager.addTaskToQueue(MultiImageUploadTask(picList), (progress, {msg, isSuccess}) {
        l.e("progress", "$progress");
      });

      //   showToast(msg: "图片上传成功～");
      picList = multiImageModel?.filePath ?? [];
      var result = await netManager.client.aiGenerate(picList);
      loadingWidget.cancel();
      if (result != null && result == "success") {
        showToast(msg: "提交成功～");
        uploadModel.localPicList.clear();
        uploadModel.selectedTagIdList.clear();
        selectedImagePath = null;
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

  void _submitAiFaceImage() async {
    if (!GlobalStore.isRechargeVIPNew()) {
      showVipLevelDialog(context, "您还不是充值VIP无法使用AI换脸");
      // VipRankAlert.show(context, type: VipAlertType.ai);
      return;
    }

    if (uploadModelAiFace.localPicList.length == 0) {
      showConfirm(context, title: "提示", content: "请选择图片");
      //VipRankAlert.show(context, type: VipAlertType.ai);
      return;
    }

    if (selectedRadioIndex == -1) {
      showConfirm(context, title: "提示", content: "请选择模版");
      //VipRankAlert.show(context, type: VipAlertType.ai);
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
      var multiImageModel = await taskManager.addTaskToQueue(MultiImageUploadTask(picList), (progress, {msg, isSuccess}) {
        l.e("progress", "$progress");
      });

      //   showToast(msg: "图片上传成功～");
      picList = multiImageModel?.filePath ?? [];

      var result = await netManager.client.aiFaceGenerate(
        picList,
        aiModList.aiChangeFaceVideoMod[selectedRadioIndex].id,
        discount: yhjData == null ? null : [yhjData.id],
      );

      loadingWidget.cancel();
      if (result != null && result == "success") {
        showToast(msg: "提交成功～");
        uploadModelAiFace.localPicList.clear();
        uploadModelAiFace.selectedTagIdList.clear();
        selectedImagePath = null;
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
          var compressFile = await FlutterNativeImage.compressImage(path, percentage: 40, quality: 50);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar(
        "AI科技",
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AITotalPage(tabController.index)));
            },
            child: Container(
              padding: EdgeInsets.only(right: 12),
              alignment: Alignment.center,
              child: Text(
                "生成记录",
                style: TextStyle(
                  color: Color.fromRGBO(136, 139, 150, 1),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 4, top: 8),
            alignment: Alignment.bottomCenter,
            height: 36,
            width: screen.screenWidth,
            color: Colors.black,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                bool isSelected = selectIndex == index;
                return Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  child: GestureDetector(
                    onTap: () {
                      if (selectIndex != index) {
                        selectIndex = index;
                        tabController.animateTo(index);
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 8, right: 8),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            index == 0
                                ? "AI脱衣"
                                : index == 1
                                    ? "视频换脸"
                                    : "图片换脸",
                            style: TextStyle(
                              color: isSelected ? Colors.white : Color(0xff999999),
                            ),
                          ),
                          SizedBox(height: 2),
                          Container(
                            height: 2,
                            width: 18,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryTextColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 2),
                          height: 120,
                          child: Row(
                            children: [
                              Container(
                                height: 110,
                                width: 110,
                                child: PictureMangeWidget(
                                  videoPath: uploadModel.videoLocalPath,
                                  picList: uploadModel.localPicList,
                                  uploadType: UploadType.UPLOAD_IMG,
                                  showText: false,
                                  isAi: true,
                                  deleteItemCallback: (index) {
                                    if (uploadType == UploadType.UPLOAD_VIDEO) {
                                      uploadModel = UploadVideoModel();
                                    } else if (uploadType == UploadType.UPLOAD_IMG) {
                                      if (uploadModel.localPicList.isEmpty) return;
                                      uploadModel.localPicList.removeAt(index);
                                    }

                                    setState(() {});
                                  },
                                  addItemCallback: () async {
                                    if (uploadType == UploadType.UPLOAD_IMG) {
                                      var list = await _pickImg(1);
                                      if (ArrayUtil.isEmpty(list) || list.length < 1) {
                                        showToast(msg: Lang.PLEASE_THREE_UP_PHOTO, gravity: ToastGravity.CENTER);
                                        return;
                                      }
                                      uploadModel.localPicList = list;
                                    }
                                    setState(() {});
                                  },
                                  onSelectCover: () async {
                                    var list = await _pickImg(1);
                                    if (ArrayUtil.isEmpty(list)) return;
                                    uploadModel.localPicList?.clear();
                                    uploadModel.localPicList.add(list[0]);

                                    setState(() {});
                                  },
                                ),
                              ),
                              SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 8),
                                    Text(
                                      "注意事项：",
                                      style: TextStyle(color: Color(0xe6ffffff), fontSize: 14),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "1.照片只含一名人物\n2.照片不能过暗\n3.照片尽量清晰\n4.不支持多人图片禁止未成年人图片\n5. 上传图片需间隔60s",
                                      style: TextStyle(
                                        color: Color(0xff999999),
                                        fontSize: 12,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 18),
                        Container(
                          height: 310,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.center,
                          child: AspectRatio(
                            aspectRatio: 408 / 310,
                            child: AdsBannerWidget(models, width: 408, height: 310, onItemClick: (index) {}),
                          ),
                        ),
                        Container(
                          width: screen.screenWidth,
                          child: Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (wallet.aiUndressFreeTimes > 0)
                                      ? Text("免费次数${wallet.aiUndressFreeTimes}",
                                          style: TextStyle(
                                            color: Color(0xffffffff),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                          ))
                                      : Text("你当前没有免费体验次数",
                                          style: TextStyle(
                                            color: Color(0xffffffff),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                          )),
                                  SizedBox(height: 6),
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        style: const TextStyle(
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                        text: "处理一张照片的费用是 "),
                                    TextSpan(
                                        style: const TextStyle(
                                            color: const Color(0xffef8649),
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                        text: "${Config.aiUndressPrice ?? 0}金币")
                                  ]))
                                ],
                              ),
                              SizedBox(height: 30),
                              GestureDetector(
                                onTap: _submitAiImage,
                                child: Container(
                                  height: 47,
                                  width: 290,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(90)),
                                    color: AppColors.primaryTextColor,
                                  ),
                                  child: Text(
                                    "确认提交",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        aiModList == null || aiModList.aiChangeFaceVideoMod == null || (aiModList.aiChangeFaceVideoMod.length ?? 0) == 0
                            ? Container()
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: (aiModList.aiChangeFaceVideoMod.length / 2) * 120,
                                  ),
                                  child: MediaQuery.removePadding(
                                    context: FlutterBase.appContext,
                                    removeTop: true,
                                    child: GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 200 / 115,
                                      ),
                                      itemCount: aiModList.aiChangeFaceVideoMod.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            AiChangeFaceVideoMod aiChangeFaceVideoMod = aiModList.aiChangeFaceVideoMod[index];
                                            Gets.Get.to(
                                                () => AiVideoChangeFaceModelDetail(
                                                      aiChangeFaceVideoMod.cover,
                                                      aiChangeFaceVideoMod.id,
                                                      aiChangeFaceVideoMod.sourceURL,
                                                      aiChangeFaceVideoMod.title,
                                                      aiChangeFaceVideoMod.realCoin,
                                                    ),
                                                opaque: false);
                                          },
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: AlignmentDirectional.center,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: CustomNetworkImage(
                                                      width: (screen.screenWidth - 28) / 2,
                                                      height: ((screen.screenWidth - 28) / 2) * (113 / 200),
                                                      fit: BoxFit.cover,
                                                      borderRadius: 8,
                                                      imageUrl: aiModList.aiChangeFaceVideoMod[index].cover,
                                                    ),
                                                  ),
                                                  (aiModList == null ||
                                                          aiModList.aiChangeFaceVideoMod[index].hotMark == null ||
                                                          aiModList.aiChangeFaceVideoMod[index].hotMark == "")
                                                      ? SizedBox()
                                                      : Positioned(
                                                          top: 0,
                                                          left: 0,
                                                          child: Container(
                                                            padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                                            decoration: BoxDecoration(
                                                              gradient: AppColors.linearBackGround,
                                                              borderRadius: BorderRadius.only(
                                                                bottomRight: Radius.circular(8),
                                                                topLeft: Radius.circular(8),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              "${aiModList.aiChangeFaceVideoMod[index].hotMark}",
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  (aiModList.aiChangeFaceVideoMod[index].hotValue > 0)
                                                      ? Positioned(
                                                          bottom: 0,
                                                          left: 0,
                                                          child: Container(
                                                            width: (screen.screenWidth - 28) / 2,
                                                            alignment: Alignment.bottomRight,
                                                            height: 30,
                                                            decoration: BoxDecoration(
                                                                gradient: LinearGradient(colors: [
                                                              Color.fromRGBO(0, 0, 0, 0.8),
                                                              Color.fromRGBO(0, 0, 0, 0.5),
                                                              Color.fromRGBO(0, 0, 0, 0),
                                                            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  "assets/images/hjll_mod_hot_tag.png",
                                                                  width: 14,
                                                                  height: 14,
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(aiModList.aiChangeFaceVideoMod[index].hotValue.toString(),
                                                                    style: TextStyle(
                                                                      color: Color(0xffffffff),
                                                                      fontWeight: FontWeight.w400,
                                                                      fontStyle: FontStyle.normal,
                                                                      fontSize: 10,
                                                                    ),
                                                                    textAlign: TextAlign.center),
                                                                SizedBox(width: 4)
                                                              ],
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                            ),
                                                            padding: EdgeInsets.only(bottom: 2),
                                                          ),
                                                        )
                                                      : SizedBox()
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        aiModList == null || aiModList.aiChangeFaceMod == null || (aiModList.aiChangeFaceMod.length ?? 0) == 0
                            ? Container()
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: (aiModList.aiChangeFaceMod.length / 2) * 380,
                                  ),
                                  child: MediaQuery.removePadding(
                                    context: FlutterBase.appContext,
                                    removeTop: true,
                                    child: GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 200 / 340,
                                      ),
                                      itemCount: aiModList.aiChangeFaceMod.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            AiChangeFaceMod aiChangeFaceMod = aiModList.aiChangeFaceMod[index];
                                            Gets.Get.to(
                                                () => AiVideoChangeFaceModelDetail(
                                                      aiChangeFaceMod.cover,
                                                      aiChangeFaceMod.id,
                                                      "",
                                                      aiChangeFaceMod.title,
                                                      aiChangeFaceMod.vipCoin,
                                                      pageType: 1,
                                                    ),
                                                opaque: false);
                                          },
                                          child: Column(
                                            children: [
                                              Stack(
                                                alignment: AlignmentDirectional.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(8),
                                                        child: CustomNetworkImage(
                                                          width: (screen.screenWidth - 28) / 2,
                                                          height: ((screen.screenWidth - 28) / 2) * (300 / 200),
                                                          fit: BoxFit.cover,
                                                          borderRadius: 4,
                                                          imageUrl: aiModList.aiChangeFaceMod[index].cover,
                                                        ),
                                                      ),
                                                      Container(
                                                        width: (screen.screenWidth - 28) / 2,
                                                        height: ((screen.screenWidth - 28) / 2) * (34 / 200),
                                                        child: Text(
                                                          aiModList.aiChangeFaceMod[index].title ?? "",
                                                          style: TextStyle(
                                                            color: Color(0xffffffff),
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                        alignment: Alignment.bottomLeft,
                                                      )
                                                    ],
                                                  ),
                                                  (aiModList == null ||
                                                          aiModList.aiChangeFaceMod[index].hotMark == null ||
                                                          aiModList.aiChangeFaceMod[index].hotMark == "")
                                                      ? SizedBox()
                                                      : Positioned(
                                                          top: 0,
                                                          left: 0,
                                                          child: Container(
                                                            padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                                            decoration: BoxDecoration(
                                                              gradient: AppColors.linearBackGround,
                                                              borderRadius: BorderRadius.only(
                                                                bottomRight: Radius.circular(8),
                                                                topLeft: Radius.circular(8),
                                                              ),
                                                            ),
                                                            child: Text(
                                                              aiModList.aiChangeFaceMod[index].hotMark ?? "",
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 10,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                  (aiModList.aiChangeFaceMod[index].hotValue > 0)
                                                      ? Positioned(
                                                          bottom: ((screen.screenWidth - 28) / 2) * (34 / 200),
                                                          left: 0,
                                                          child: Container(
                                                            width: (screen.screenWidth - 28) / 2,
                                                            alignment: Alignment.bottomRight,
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                              gradient: LinearGradient(
                                                                colors: [
                                                                  Color.fromRGBO(0, 0, 0, 0.8),
                                                                  Color.fromRGBO(0, 0, 0, 0.5),
                                                                  Color.fromRGBO(0, 0, 0, 0),
                                                                ],
                                                                begin: Alignment.bottomCenter,
                                                                end: Alignment.topCenter,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  "assets/images/hjll_mod_hot_tag.png",
                                                                  width: 14,
                                                                  height: 14,
                                                                ),
                                                                SizedBox(width: 4),
                                                                Text(
                                                                  aiModList.aiChangeFaceMod[index].hotValue.toString(),
                                                                  style: TextStyle(
                                                                    color: Color(0xffffffff),
                                                                    fontSize: 10,
                                                                  ),
                                                                ),
                                                                SizedBox(width: 4),
                                                              ],
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                            ),
                                                            padding: EdgeInsets.only(bottom: 2),
                                                          ),
                                                        )
                                                      : SizedBox()
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
          topLeft: Radius.circular(Dimens.pt17),
          topRight: Radius.circular(Dimens.pt17),
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
