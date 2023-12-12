import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/new_page/mine/account_safe_page.dart';
import 'package:flutter_app/page/setting/scan_qrcode/scan_camera_dialog.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:r_scan/r_scan.dart';

import 'action.dart';
import 'state.dart';

///账号找回UI
Widget buildView(RecoverAccountState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
      child: Scaffold(
    appBar: getCommonAppBar("账号找回"),
    body: Container(
      child: Column(
        children: [
          _createAccountItem("账号凭证找回", onTap: () async {
            commonScannerDialog(viewService.context, onTapCallback: (selectType) async {
              if (selectType == 0) {
                WidgetsFlutterBinding.ensureInitialized();
                // rScanCameras = await availableRScanCameras();
                RScanResult result = await Navigator.of(viewService.context)
                    .push(MaterialPageRoute(builder: (BuildContext context) => RScanCameraDialog()));
                if (result?.message != null) {
                  // 执行登录
                  //state.isShowLoading = true;
                  dispatch(RecoverAccountActionCreator.refreshUI());
                  dispatch(RecoverAccountActionCreator.qrLogin(result.message));
                }
              } else if (selectType == 1) {
                if (await canReadStorage()) {
                  dispatch(RecoverAccountActionCreator.photoAlbumSelection());
                }
              }
            });
          }),
          _createLine(),
          _createAccountItem("手机号码找回", onTap: () {
            JRouter().go(PAGE_INITIAL_BIND_PHONE, arguments: {
              "bindMobileTitle": "账号找回",
              "bindMobileType": 2,
              "mobileNum": "",
            });
          }),
          _createLine(),
          _createAccountItem("联系客服找回", onTap: () {
            commonNotifyDialog(viewService.context, "确认匹配客服？", onTapCallback: () {
              csManager.openServices(viewService.context);
            });
          }),
          _createLine(),
        ],
      ),
    ),
  ));
}


Widget _createAccountItem(String title, {Function onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      color: Colors.transparent,
      height: Dimens.pt60,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: Dimens.pt14, color: Colors.white),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: Dimens.pt12,
          ),
        ],
      ),
    ),
  );
}

Widget _createLine() {
  return Container(
    height: 0.5,
    width: screen.screenWidth,
    margin: EdgeInsets.only(left: 20, right: 20),
    color: Colors.white.withOpacity(0.16),
  );
}

///公用弹出框
void commonScannerDialog(BuildContext context, {Function onTapCallback}) async {
  int _selectType = 0;

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: Dimens.pt140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          child: Text("扫描账号凭证",
                              style: TextStyle(
                                  color: _selectType == 0 ? Color(0xFFFF7F0F) : Color(0xFF151515),
                                  fontSize: 16)),
                        ),
                        Radio(
                          value: 0,
                          activeColor: Color(0xFFFF7F0F),
                          focusColor: Color(0xFF4F515A),
                          onChanged: (value) {
                            setState(() => _selectType = value);
                          },
                          groupValue: _selectType,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text("相册选择账号凭证",
                              style: TextStyle(
                                  color: _selectType == 1 ? Color(0xFFFF7F0F) : Color(0xFF151515),
                                  fontSize: 16)),
                        ),
                        Radio(
                          value: 1,
                          activeColor: Color(0xFFFF7F0F),
                          focusColor: Color(0xFF4F515A),
                          onChanged: (value) {
                            setState(() => _selectType = value);
                          },
                          groupValue: _selectType,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton(
                          padding: EdgeInsets.all(1),
                          child: Text(
                            "取消",
                            style: TextStyle(
                              color: Color(0xff262626),
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          padding: EdgeInsets.all(1),
                          child: Text(
                            "确定",
                            style: TextStyle(
                              color: Color(0xffff7600),
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            onTapCallback(_selectType);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      });
}
