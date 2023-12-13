import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net/dio_slice_downloader.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/new_page/mine/mine_account_profile_page.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:install_plugin/install_plugin.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:get/route_manager.dart' as Gets;

///更新对话框
class UpdateDialog extends StatefulWidget {
  final CheckVersionBean updateInfo;

  UpdateDialog({Key key, @required this.updateInfo});

  @override
  State<UpdateDialog> createState() => _UpdateDialog();
}

class _UpdateDialog extends State<UpdateDialog> {
  bool isUpdate;
  bool isReDownload;
  var progress = .0;

  String apkPath;

  @override
  void initState() {
    super.initState();
    this.isUpdate = false;
    this.isReDownload = false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimens.pt10),
        topRight: Radius.circular(Dimens.pt10),
        bottomLeft: Radius.circular(Dimens.pt10),
        bottomRight: Radius.circular(Dimens.pt10),
      )),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Container(
          width: 340.w,
          height: 400.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryTextColor,
                  Color.fromRGBO(255, 255, 255, 1),
                ]),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 21.w, left: 23.w, right: 23.w),
            child: Column(
              children: [


                Text(
                  "系统升级",
                  style: TextStyle(fontSize: 20.nsp, color: Colors.black),
                ),

                SizedBox(height: 10,),

                Image.asset("assets/images/line_grident.png"),

                SizedBox(height: 10,),

                Row(
                  children: [
                    Text(
                      "更新版本",
                      style: TextStyle(fontSize: 14.nsp, color: Colors.black),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 8.w,
                        right: 8.w,
                        top: 4.w,
                        bottom: 4.w,
                      ),
                      child: Text(
                        "V${widget.updateInfo.verName}",
                        style: TextStyle(fontSize: 14.w, color: AppColors.primaryTextColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 32.w,
                ),
                Expanded(child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child:Row(
                    children: [
                      Text(
                        widget.updateInfo == null
                            ? ""
                            : widget.updateInfo.description.replaceAll("|", "\n"),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            height: 1.6),
                      ),
                    ],
                  ),
                ),),



                GestureDetector(
                  onTap: (){

                    Gets.Get.to(MineAccountProfilePage(),opaque: false);

                  },
                  child: Text(
                    "保存账号凭证 >",
                    style: TextStyle(fontSize: 14.nsp, color: Colors.black),
                  ),
                ),

                SizedBox(
                  height: 18.w,
                ),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [


                        Visibility(
                          visible: widget.updateInfo.forcedUpdate ? false : isUpdate ? false : true,
                          child: GestureDetector(
                            onTap: () {
                              safePopPage(false);
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 16,right: 16,top: 6,bottom: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: Color.fromRGBO(190, 190, 190, 1),
                              ),
                              child: Text(
                                "暂不升级",
                                style: TextStyle(
                                    color: Color.fromRGBO(66, 84, 83, 1),
                                    fontSize: 16.w),
                              ),
                            ),
                          ),
                        ),

                        Visibility(
                          visible: isUpdate || progress == 1.0 ? false : true,
                          child: commonSubmitButton("立即升级", height: 38.w,width: 136,
                              onTap: () async {
                                Gets.Get.to(
                                    MineAccountProfilePage(
                                      isNeedAutoSaveCer: true,
                                    ),
                                    opaque: false)
                                    ?.then((value) async {
                                  if (Platform.isAndroid) {
                                    if (progress == 1.0) {
                                      await installApk();
                                      return;
                                    }
                                    if (isUpdate) {
                                      return;
                                    }
                                    //开始更新
                                    setState(() {
                                      //开始下载
                                      isUpdate = true;
                                      _downloadApp(widget.updateInfo.url);
                                    });
                                  } else {
                                    //ios：直接跳到外部浏览器，地址为落地页地址
                                    launchUrl(widget.updateInfo.url);
                                  }
                                });
                              }),
                        ),
                      ],
                    ),

                    ///进度条
                    isUpdate && progress <= 1.0
                        ? Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        width: screen.screenWidth,
                        child: LinearPercentIndicator(
                          lineHeight: 2,
                          percent: progress,
                          animationDuration: 1200,
                          trailing: Text(
                            "${((progress * 100).toInt())}%",
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: AppColors.weiboColor,
                            ),
                          ),
                          backgroundColor: Colors.grey,
                          progressColor: AppColors.weiboColor,
                        ),
                      ),
                    )
                        : Container(),

                   /* SizedBox(
                      height: 6.w,
                    ),*/
                    SizedBox(
                      height: 30.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _downloadBtnText() {
    if (isUpdate) return Lang.DOWNLOADING;
    if (isReDownload) return Lang.RE_DOWNLOAD;
    return Platform.isAndroid ? Lang.DOWNLOAD_NOW : Lang.UPDATE_TEXT;
    //      isUpdate
    //          ? Lang.downloading
    //          : (Platform.isAndroid ? Lang.download_right_now : Lang.update_text),
    //      ,
  }

  ///下载app
  _downloadApp(String url) async {
    final saveDirectory =
        path.join((await getExternalStorageDirectory()).path, "apk");
    DioSliceRetryDownloader(DioCli(), url, null, saveDirectory, "paofu.apk",
        onReceiveProgress: (count, total) {
      progress = (count / total);
      setState(() {});
    }, onRetry: (int retryCount) {
      showToast(msg: "下载发生错误正在自动重试中...($retryCount)");
    }).download().then((String savePath) async {
      apkPath = savePath;
      await installApk();
    }).catchError((e) {
      showToast(msg: "下载发生错误,点击重新进行下载.");
      setState(() {
        isReDownload = true;
        isUpdate = false;
      });
    });
  }

  ///安装apk
  // 安装
  Future<bool> installApk() async {
    //    String savePath = (await getExternalStorageDirectory()).path + "/yinse.apk";
    bool exit = await File(apkPath).exists();
    if (!exit) {
      return Future.value(false);
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    InstallPlugin.installApk(apkPath, packageInfo.packageName).then((result) {
//      showToast(msg: result);
//      safePopPage(false);
    }).catchError((error) {});
    return Future.value(true);
  }
}
