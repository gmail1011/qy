import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_store/local_user_store.dart';
import 'package:flutter_app/new_page/mine/account_safe_page.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/click_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/model/user/local_user_info.dart';
import 'package:flutter_app/page/setting/scan_qrcode/scan_camera_dialog.dart';
import 'package:flutter_app/page/setting/switch_account/action.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:r_scan/r_scan.dart';

import 'state.dart';

Widget buildView(SwitchAccountState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              width: Dimens.pt360,
              height: Dimens.pt780,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: CustomEdgeInsets.only(top: 42),
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          safePopPage();
                        }),
                  ),
                  Padding(
                    padding: CustomEdgeInsets.only(top: Dimens.pt14),
                  ),
                  Center(
                    child: Image.asset(
                      "assets/images/hj_ic_launcher.webp",
                      height: Dimens.pt78,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: CustomEdgeInsets.only(top: 60),
                      child: Text(
                        Lang.TOUCH_HEAD_SWITCH_ACCOUNT,
                        style: TextStyle(color: Colors.white, fontSize: Dimens.pt20),
                      ),
                    ),
                  ),
                  userList(state, dispatch),
                  InkWell(
                    onTap: () async {
                      if (ClickUtil.isFastClick()) {
                        return;
                      }
                      dispatch(SwitchAccountActionCreator.onClearAccount());
                    },
                    child: Center(
                      child: Container(
                        padding: CustomEdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          Lang.CLEAR_LOGIN_RECORDER,
                          style: TextStyle(color: Color(0xffff7886), fontSize: Dimens.pt12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: screen.paddingBottom,
            left: 0,
            child: GestureDetector(
              onTap: () {
                dispatch(SwitchAccountActionCreator.onService());
              },
              child: svgAssets(
                AssetsSvg.VIP_MEMBER_CUSTOMER_SERVICE,
                width: Dimens.pt56,
                height: Dimens.pt56,
              ),
//            child: assetsImg(
//              ImgConfig.SERVICE_IMG,
//              width: Dimens.pt56,
//              height: Dimens.pt56,
//            ),
            ),
          ),
          Positioned(
            bottom: Dimens.pt10,
            right: Dimens.pt20,
            child: Text(
              "ver:${state.versionStr ?? ''}",
              style: TextStyle(color: Colors.red, fontSize: Dimens.pt16),
            ),
          ),
          state.showLoading
              ? Center(
                  child: LoadingWidget(),
                )
              : Container(),
        ],
      ),
    ),
  );
}

Widget userList(SwitchAccountState state, Dispatch dispatch) {
  return Container(
    height: Dimens.pt300,
    child: Padding(
      padding: const EdgeInsets.only(left: 0, right: 0), //边缘间距（插图）
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //横向数量
          crossAxisSpacing: 4, //间距
          mainAxisSpacing: 3, //行距
          childAspectRatio: 1.3,
        ),
        itemCount: (state.localUserInfoList?.length ?? 0) + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index < (state.localUserInfoList?.length ?? 0)) {
            return Container(
              child: GestureDetector(
                onTap: () async {
                  if (ClickUtil.isFastClick()) {
                    return;
                  }
                  LocalUserInfo localUserInfo = state.localUserInfoList[index];
                  if (isCurrentAccount(localUserInfo)) return;
                  // 如果已经存在账号，优先设备>二维码>手机
                  // 主要是解决deviceId可能不存在的情况
                  if (localUserInfo.loginType == 0 && TextUtil.isNotEmpty(await getDeviceId())) {
                    dispatch(SwitchAccountActionCreator.onShowLoading(true));
                    showToast(msg: Lang.SWITCHING);
                    dispatch(SwitchAccountActionCreator.devLogin());
                  } else if (localUserInfo.loginType == 3 && TextUtil.isNotEmpty(localUserInfo.qr)) {
                    showToast(msg: Lang.SWITCHING);
                    dispatch(SwitchAccountActionCreator.onShowLoading(true));
                    dispatch(SwitchAccountActionCreator.qrLogin(localUserInfo.qr));
                  } else if (localUserInfo.loginType == 2 && TextUtil.isNotEmpty(localUserInfo.mobile)) {
                    Map<String, dynamic> arguments = {'mobile': localUserInfo.mobile};
                    await JRouter().go(PAGE_MOBILE_LOGIN, arguments: arguments);
                    var localUserInfoList = await LocalUserStore().getUserList();
                    SwitchAccountActionCreator.onLocalUserGetOkay(localUserInfoList);
                  } else {
                    dispatch(SwitchAccountActionCreator.onShowLoading(true));
                    showToast(msg: Lang.SWITCHING);
                    dispatch(SwitchAccountActionCreator.devLogin());
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: CustomNetworkImage(
                        imageUrl: state.localUserInfoList[index].portrait ?? '',
                        type: ImgType.avatar,
                        width: Dimens.pt48,
                        height: Dimens.pt48,
                      ),
                    ),
                    Container(
                      margin: CustomEdgeInsets.only(top: 9),
                      child: Text(
                        truncate(state.localUserInfoList[index]),
                        style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
                      ),
                    ),
                    Container(
                      margin: CustomEdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Offstage(
                              offstage: !isCurrentAccount(state.localUserInfoList[index]),
                              child: Container(
                                margin: CustomEdgeInsets.only(right: 5),
                                child: ClipOval(
                                  child: Container(
                                    width: Dimens.pt9,
                                    height: Dimens.pt9,
                                    color: Color(0xff00ff11),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              )),
                          Text(
                            isCurrentAccount(state.localUserInfoList[index]) ? Lang.CURRENT_ACCOUNT : '',
                            style: TextStyle(color: Colors.white, fontSize: Dimens.pt12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            if (index == state.localUserInfoList.length) {
              return Container(
                child: GestureDetector(
                  onTap: () async {
                    await JRouter().go(PAGE_MOBILE_LOGIN);
                    var localUserInfoList = await LocalUserStore().getUserList();
                    SwitchAccountActionCreator.onLocalUserGetOkay(localUserInfoList);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      svgAssets(
                        AssetsSvg.USER_IC_ADD_USER,
                        width: Dimens.pt48,
                        height: Dimens.pt48,
                      ),
                      Container(
                          margin: CustomEdgeInsets.only(top: 9),
                          child: Text(
                            Lang.ADD_ACCOUNT,
                            style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
                          )),
                      Container(
                        margin: CustomEdgeInsets.only(top: 12),
                        child: Text(
                          '',
                          style: TextStyle(color: Colors.white, fontSize: Dimens.pt12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                child: GestureDetector(
                  onTap: () async {
                    if (await canStartCameraStorage()) {
                      var qrCnt = await openScan(context);
                      if (qrCnt != null) {
                        dispatch(SwitchAccountActionCreator.onShowLoading(true));
                        showToast(msg: Lang.LOGIN_ING);
                        dispatch(SwitchAccountActionCreator.qrLogin(qrCnt));
                      }
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      svgAssets(
                        AssetsSvg.USER_IC_USER_SCAN,
                        width: Dimens.pt40,
                        height: Dimens.pt40,
                      ),
                      Container(
                          margin: CustomEdgeInsets.only(top: 9),
                          child: Text(
                            Lang.SCAN_LOGIN,
                            style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
                          )),
                      Container(
                        margin: CustomEdgeInsets.only(top: 12),
                        child: Text(
                          '',
                          style: TextStyle(color: Colors.white, fontSize: Dimens.pt12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    ),
  );
}

bool isCurrentAccount(LocalUserInfo localUserInfo) {
  return GlobalStore.isMe(localUserInfo.uid);
}

///字符串截断
String truncate(LocalUserInfo localUserInfo) {
  String value = localUserInfo.nickName ?? '';
  if (localUserInfo.mobile != null && localUserInfo.mobile.isNotEmpty) value = localUserInfo.mobile;
  return ((value ?? '').length >= 7) ? (value.substring(0, 7) + '...') : value ?? '';
}
