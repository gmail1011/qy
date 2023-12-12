import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/page/video/video_publish/state.dart';
import 'package:flutter_app/widget/custom_picture_management.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_pickers/image_pickers.dart';

class ReportPage extends StatefulWidget {
  final UserInfoModel userInfo;

  ReportPage(this.userInfo);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ReportPageState();
  }
}

class ReportPageState extends State<ReportPage> {
  ///封面本地地址
  List<String> localPicList = [];

  TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  ///选择图片
  Future<List<String>> _pickImg() async {
    List<String> ret = [];
    var listMedia = await ImagePickers.pickerPaths(
      uiConfig: UIConfig(uiThemeColor: AppColors.primaryColor),
      galleryMode: GalleryMode.image,
      selectCount: 9,
      showCamera: false,
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
        /*if ((size.length / 1024) > 300) {
        var compressFile = await FlutterNativeImage.compressImage(path,
            percentage: 40, quality: 50);
        path = compressFile.path;
      }*/
        if (path != null) {
          ret.add(path);
        } else {
          showToast(msg: "添加图片失败");
        }
      }
    }

    localPicList = ret;
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return KeyboardDismissOnTap(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "举报",
            style: TextStyle(color: Colors.white, fontSize: 20.nsp),
          ),
        ),
        bottomSheet: Theme(
          data: ThemeData(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            primaryColor: AppColors.weiboJianPrimaryBackground,
            backgroundColor: AppColors.weiboJianPrimaryBackground,
            buttonColor: AppColors.weiboJianPrimaryBackground,
            bottomSheetTheme: BottomSheetThemeData(
                backgroundColor: Colors.transparent),
          ),
          child: Container(
            height: 80.w,
            padding: EdgeInsets.only(left: 96.w, right: 96.w),
            width: screen.screenWidth,
            color: AppColors.weiboBackgroundColor,
            child: GestureDetector(
                onTap: () async {
                  try {
                    if (textEditingController.text == null ||
                        textEditingController.text == "") {
                      showToast(msg: "请输入内容");

                      return;
                    }

                    if (localPicList.length == 0) {
                      showToast(msg: "至少上传1张图片");

                      return;
                    }

                    await netManager.client.reportBlogger(
                        textEditingController.text,
                        localPicList,
                        "user",
                        widget.userInfo.uid,
                        "其他",
                        GlobalStore.getMe().uid);
                    showToast(msg: Lang.REPORT_SUCCESS);
                    textEditingController.clear();
                    localPicList.clear();

                    setState(() {});
                  } catch (e) {
                    //l.e('shareReport', e.toString());
                    showToast(msg: e.toString());
                  }
                },
                child: Image.asset(
                  "assets/weibo/report_button.png",
                  height: 44.w,
                  width: 228.w,
                )),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 16.w, right: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 26.w,
              ),
              Text(
                "详情描述（必填）",
                style: TextStyle(color: Colors.white, fontSize: 18.nsp),
              ),
              Container(
                height: 3.w,
                width: 68.w,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(1.5)),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(255, 127, 15, 1),
                    Color.fromRGBO(227, 136, 37, 1),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(30, 30, 30, 1),
                ),
                padding: EdgeInsets.only(
                  left: 14.w,
                  right: 14.w,
                ),
                width: screen.screenWidth,
                height: 200.w,
                child: TextField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
                  maxLength: 100,
                  maxLines: 7,
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: "请详细描述遇到的问题，以使我们及时为您解决问题（10～100）",
                    border: InputBorder.none,
                    // counterText: '500', //隐藏最大显示
                    counterStyle:
                        TextStyle(color: Color.fromRGBO(93, 100, 114, 1)),
                    hintStyle: TextStyle(
                      color: Color.fromRGBO(93, 100, 114, 1),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25.w,
              ),
              PictureMangeWidget(
                videoPath: "",
                picList: localPicList,
                uploadType: UploadType.UPLOAD_IMG,
                deleteItemCallback: (index) {
                  if (localPicList.isEmpty) return;
                  localPicList.removeAt(index);
                  setState(() {});
                },
                addItemCallback: () async {
                  var list = await _pickImg();
                  if (ArrayUtil.isEmpty(list) || list.length < 1) {
                    showToast(msg: "请至少选择1张图片", gravity: ToastGravity.CENTER);
                    return;
                  }
                  localPicList = list;
                  setState(() {});
                },
                onSelectCover: () {
                  // return dispatch(VideoPublishActionCreator.onSelectCover());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
