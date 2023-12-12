import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/page/setting/scan_qrcode/scan_camera_dialog.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:r_scan/r_scan.dart';

///账号安全
class AccountSafePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AccountSafePageState();
  }
}

class _AccountSafePageState extends State<AccountSafePage> {
  List<RScanCameraDescription> rScanCameras;

  UserInfoModel meInfo;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    meInfo = GlobalStore.getMe();
    setState(() {});
  }

  void _qrLogin(String qr) async {
    try {
      if (TextUtil.isEmpty(qr)) {
        showToast(msg: Lang.INVALID_QR_CODE);
        return;
      }
      // 清除旧的token
      netManager.setToken(null);
      // 生成新的ua
      netManager.userAgent(await getDeviceId());
      UserInfoModel userInfo = await GlobalStore.loginByQr(qr);
      if (null == userInfo) {
        return;
      }
      Navigator.pushNamedAndRemoveUntil(
        context,
        PAGE_HOME,
        (route) => route == null,
      );
    } catch (e) {
      l.e("_qrLogin", e);
    }
  }

  ///相册扫码
  // void _photoAlbumSelection() async {
  //   try {
  //     List<Media> image = await ImagePickers.pickerPaths(
  //       uiConfig: UIConfig(uiThemeColor: AppColors.primaryColor),
  //       selectCount: 1,
  //       showCamera: false,
  //       cropConfig: CropConfig(enableCrop: false),
  //     );
  //     if ((image ?? []).isNotEmpty) {
  //       RScanResult result = await RScan.scanImagePath(image[0].path);
  //       if (result?.message != null) {
  //         _qrLogin(result.message);
  //       }
  //     }
  //   } catch (e) {
  //     l.e("相册扫码失败：", "$e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppbar(
          title: "账号安全",
        ),
        body: Container(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 10),
                  _subItemView(
                    context: context,
                    title: "手机号绑定",
                    subTitle: meInfo?.mobile ?? "",
                    onTap: () {
                      if (TextUtil.isNotEmpty(meInfo?.mobile)) {
                        JRouter().go(PAGE_REBIND_PHONE);
                      } else {
                        JRouter().go(PAGE_INITIAL_BIND_PHONE);
                      }
                    },
                  ),
                  // _subItemView(
                  //   context: context,
                  //   title: "切换账号",
                  //   subTitle: "",
                  //   onTap: () {
                  //     JRouter().go(PAGE_SWITCH_ACCOUNT);
                  //   },
                  // ),
                  _subItemView(
                    context: context,
                    title: "扫码登录",
                    subTitle: "",
                    onTap: () async {
                      var qrCnt = await openScan(context);
                      print("扫码登录_$qrCnt");
                      _qrLogin(qrCnt);
                      // commonScannerDialog(context, onTapCallback: (selectType) async {
                      //   if (selectType == 0) {
                      //
                      //   } else if (selectType == 1) {
                      //     if (await canReadStorage()) {
                      //       _photoAlbumSelection();
                      //     }
                      //   }
                      // });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _subItemView({
    @required BuildContext context,
    String title = '',
    String subTitle = '',
    VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          subTitle,
                          style: TextStyle(
                            color: Color(0xFF999999),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 20),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> openScan(BuildContext context) async {
  if (await canStartCameraStorage()) {
    WidgetsFlutterBinding.ensureInitialized();
    rScanCameras = await availableRScanCameras();
    RScanResult result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => RScanCameraDialog()),
    );
    return result == null ? null : result?.message;
  }
  return null;
}

Future<bool> canReadStorage() async {
  var status = await Permission.storage.request();
  return status.isGranted;
}

Future<bool> canStartCameraStorage() async {
  var status = await Permission.camera.request();
  return status.isGranted;
}
