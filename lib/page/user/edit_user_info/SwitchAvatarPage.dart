import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/tasks/image_upload_task.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/page/user/switch_avatar_entity.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/common_widget/wb_loading.dart';
import 'package:flutter_app/widget/dialog/vip_level_dialog.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:lottie/lottie.dart';

class SwitchAvatarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SwitchAvatarPageState();
  }
}

class SwitchAvatarPageState extends State<SwitchAvatarPage> {
  TabController tabController = new TabController(length: 1, vsync: ScrollableState());

  SwitchAvatarData switchBackgroundData;
  int selectedBackground = -1;
  List<String> localHeadPathList = [];
  bool isLocalHead = false;
  bool isChangeHead = false;

  // UserInfoModel userInfo;

  @override
  void initState() {
    super.initState();
    GlobalStore.updateUserInfo(null);
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    localHeadPathList?.clear();
    isLocalHead = false;
  }

  void getData() async {
    try {
      // userInfo = await netManager.client.getUserInfo();
      dynamic videoss = await netManager.client.getBloggerBackground(
        1,
        20,
        "avatar",
      );

      switchBackgroundData = SwitchAvatarData().fromJson(videoss);

      setState(() {});
    } catch (e) {
      //l.e("loadUser", "_onLoadUserInfo()...error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getCommonAppBar("头像", actions: [
        GestureDetector(
            onTap: () async {
              if ((GlobalStore.store?.getState()?.meInfo?.urrPortraitStatus ?? 0) == 1) {
                showToast(msg: "头像审核中~");
                return;
              }
              if (selectedBackground == -1) {
                showToast(msg: "请选择头像再上传～");
                return;
              }
              List<String> lists = [];
              lists.add(switchBackgroundData.xList[selectedBackground].resource);
              try {
                WBLoadingDialog.show(context);

                await netManager.client.setBackground(lists, "portrait", true);
                await GlobalStore.updateUserInfo(null);
                WBLoadingDialog.dismiss(context);
                showToast(msg: "上传头像成功~");
                safePopPage();
              } catch (e) {
                WBLoadingDialog.dismiss(context);
                showToast(msg: "上传头像失败~");
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  "保存",
                  style: const TextStyle(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                ),
              ),
            )),
      ]),
      body: switchBackgroundData == null
          ? LoadingWidget()
          : switchBackgroundData?.xList == null || switchBackgroundData?.xList?.length == 0
              ? CErrorWidget("这里空空如也~")
              : Container(
                  margin: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.w,
                      ),
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            height: 175.w,
                            width: screen.screenWidth,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/weibo/avatar_background.webp")),
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                if ((GlobalStore.store?.getState()?.meInfo?.urrPortraitStatus ?? 0) == 1) {
                                  showToast(msg: "头像审核中~");
                                  return;
                                }
                                _selectHeadImage(context);
                              },
                              child: Column(
                                children: [
                                  _buildHeadPhotoUI(),
                                  const SizedBox(height: 4),
                                  Text(
                                    "点击头像上传图片",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18.w,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          isScrollable: true,
                          controller: tabController,
                          tabs: Lang.SWITCH_TABS
                              .map(
                                (e) => Text(
                                  e,
                                  style: TextStyle(fontSize: 18.nsp),
                                ),
                              )
                              .toList(),
                          indicator: RoundUnderlineTabIndicator(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(238, 174, 25, 1),
                              width: 3,
                            ),
                          ),
                          indicatorWeight: 4,
                          unselectedLabelColor: Color.fromRGBO(157, 157, 157, 1),
                          labelColor: Color.fromRGBO(238, 174, 25, 1),
                          labelStyle: TextStyle(fontSize: 18.nsp),
                          unselectedLabelStyle: TextStyle(fontSize: 16.nsp),
                          labelPadding: EdgeInsets.symmetric(horizontal: 20.w),
                        ),
                      ),
                      SizedBox(
                        height: 14.w,
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            Container(
                              color: Colors.transparent,
                              child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: 95.w / 95.w),
                                  itemCount: switchBackgroundData?.xList?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        isChangeHead = true;
                                        isLocalHead = false;
                                        selectedBackground = index;
                                        setState(() {});
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        child: Stack(
                                          alignment: AlignmentDirectional.center,
                                          children: [
                                            CustomNetworkImage(
                                              fit: BoxFit.cover,
                                              width: 95.w,
                                              height: 95.w,
                                              imageUrl: switchBackgroundData.xList[index].resource,
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Visibility(
                                                visible: selectedBackground == index ? true : false,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  ///判断本人VIP等级
  int _getVIPLevel() => (GlobalStore.getMe()?.superUser??false)  ? 1 : 0;

  ///设置头像UI
  Widget _buildHeadPhotoUI() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        _buildHeadUI(),
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(Dimens.pt40),
                bottomRight: Radius.circular(Dimens.pt40),
              ),
            ),
            child: (GlobalStore.store?.getState()?.meInfo?.urrPortraitStatus ?? 0) == 1
                ? Image(
                    image: AssetImage(AssetsImages.IC_USER_UNDER_REVIEW),
                    width: 94.w,
                    height: 27.w,
                  )
                : Image(
                    image: AssetImage(AssetsImages.IC_USER_TAKE_PHOTO),
                    width: 94.w,
                    height: 27.w,
                  ),
          ),
        ),
      ],
    );
  }

  ///设置头像UI
  Widget _buildHeadUI() {
    return isLocalHead && ((localHeadPathList ?? []).isNotEmpty)
        ? Stack(
            alignment: AlignmentDirectional.center,
            children: [
              ClipOval(
                child: ImageLoader.withP(ImageType.IMAGE_FILE,
                        address: localHeadPathList[0], width: 107.w, height: 107.w)
                    .load(),
              ),
              _getVIPLevel() > 0
                  ? Positioned(
                      bottom: 2,
                      right: 2,
                      child: ClipOval(
                        child: Stack(
                          children: [
                            assetsImg(
                              "assets/weibo/images/img_0.png",
                              width: Dimens.pt16,
                              height: Dimens.pt16,
                            ),
                            Lottie.asset(
                              "assets/dh.json",
                              width: Dimens.pt16,
                              height: Dimens.pt16,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          )
        : HeaderWidget(
            headPath: isChangeHead && selectedBackground != -1
                ? (switchBackgroundData?.xList[selectedBackground]?.resource ?? "")
                : GlobalStore.getMe()?.portrait ?? "",
            level: _getVIPLevel(),
            headWidth: 107.w,
            headHeight: 107.w,
            defaultHead: Image.asset(
              "assets/weibo/loading_normal.png",
              width: 107.w,
              height: 107.w,
              fit: BoxFit.cover,
            ),
          );
  }

  ///选择头像
  _selectHeadImage(BuildContext context) async {
    if (!GlobalStore.isRechargeVIP()) {
      showVipLevelDialog(context, Lang.VIP_LEVEL_DIALOG_MSG3);
      return;
    }
    List<Media> mediaList = await ImagePickers.pickerPaths(
      uiConfig: UIConfig(uiThemeColor: AppColors.primaryColor),
      selectCount: 1,
      showCamera: false,
      cropConfig: CropConfig(enableCrop: true),
    );

    l.e("_selectImage-mediaList", "$mediaList");
    List<String> imagePaths = [];
    for (Media media in mediaList) {
      imagePaths.add(media.path);
    }
    localHeadPathList?.clear();
    localHeadPathList?.addAll(imagePaths);
    isLocalHead = true;
    isChangeHead = false;
    selectedBackground = -1;
    setState(() {});

    ///开始上传头像
    if ((localHeadPathList ?? []).isNotEmpty) {
      _editAvatar(context, localHeadPathList[0]);
    }
  }

  ///编辑头像
  void _editAvatar(BuildContext context, var filePathNew) async {
    try {
      var file = File(filePathNew);
      var size = await file.readAsBytes();
      if ((size.length / 1024) > 100) {
        showToast(msg: "请选择100KB内的图片", gravity: ToastGravity.CENTER);
        return;
      }
      WBLoadingDialog.show(context);
      var result = await uploadAvatar(filePathNew, {});
      var result1 = await _setAvatar(result);
      WBLoadingDialog.dismiss(context);
      if (result1 == null) {
        showToast(msg: "上传头像失败～");
      }
      setState(() {});
    } catch (e) {
      WBLoadingDialog.dismiss(context);
      showToast(msg: "上传头像失败～");
    }
  }

  ///上传头像
  Future<Map<String, dynamic>> uploadAvatar(String localPath, Map<String, dynamic> params) async {
    if (!Platform.isAndroid) {
      var file = File(localPath);
      var size = await file.readAsBytes();
      if ((size.length / 1024) > 300) {
        var compressFile = await FlutterNativeImage.compressImage(localPath, percentage: 40, quality: 50);
        localPath = compressFile.path;
      }
    }
    var model = await taskManager.addTaskToQueue(ImageUploadTask(localPath));

    if (model != null) {
      params['cover'] = model.coverImg;
      params['coverThumb'] = model.coverImg;
    } else {
      showToast(msg: "上传头像失败");
    }
    return params;
  }

  /// 修改用户头像
  _setAvatar(Map<String, dynamic> params) async {
    Map<String, dynamic> editInfo = {'portrait': params['cover'], 'isDefaultSource': false};
    var userInfo = await GlobalStore.updateUserInfo(editInfo);
    if (null != userInfo) {
      showToast(msg: "上传头像成功~");
    }
    return userInfo;
  }
}
