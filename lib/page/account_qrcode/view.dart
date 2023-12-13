import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    AccountQrCodeState state, Dispatch dispatch, ViewService viewService) {
  return Stack(
    children: [
      _saveView(state, dispatch, viewService),
      _showView(state, dispatch, viewService),
    ],
  );
}

Widget _saveView(
    AccountQrCodeState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    body: RepaintBoundary(
      key: state.boundaryKey,
      child: Container(
        width: screen.screenWidth,
        height: screen.screenHeight,
        padding: EdgeInsets.only(top: screen.paddingTop + kToolbarHeight),
        color: AppColors.primaryColor,
        child: Column(
          children: [_codeView(state, dispatch, viewService)],
        ),
      ),
    ),
  );
}

Widget _showView(
    AccountQrCodeState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    width: screen.screenWidth,
    height: screen.screenHeight,
    // decoration: BoxDecoration(
    //   image: DecorationImage(
    //     image: AssetImage(AssetsImages.BG_ACCOUNT),
    //     fit: BoxFit.fitHeight,
    //   ),
    // ),
    child: Scaffold(
      appBar: getCommonAppBar(Lang.ACCOUNT_CREDIT),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _codeView(state, dispatch, viewService),
              SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: commonSubmitButton("保存账号凭证到手机",
                    width: screen.screenWidth, onTap: () {
                  dispatch(AccountQrCodeActionCreator.onSaveQrCode());
                }),
              ),
              Container(
                margin: EdgeInsets.all(35),
                child: Column(
                  children: [
                    Text("账号丢失不用愁，保存凭证解君优",
                        style: TextStyle(
                            color: AppColors.accountTextColor,
                            fontSize: Dimens.pt16)),
                    const SizedBox(height: 12),
                    Text(
                      "由于行业特殊性，当app无法使用需要下载新的安装包，以及系统升级等原因，用户进入app后自动生成了新的账号从而导致账号丢失。",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: Dimens.pt14,
                          height: 1.5),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      "对此，账号丢失的用户可在我的-个人资料-账号凭证找回或扫码上传该凭证二维码，即可找回升级更新前的原账号而原账号的VIP等级等全套资料也将得到恢复。",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: Dimens.pt14,
                          height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _codeView(
    AccountQrCodeState state, Dispatch dispatch, ViewService viewService) {
  return Stack(
    // alignment: Alignment.center,
    children: [
      Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 16, right: 16),
              height: Dimens.pt430,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetsImages.BG_ACCOUNT),
                  fit: BoxFit.contain,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // HeaderWidget(
                      //     headPath: GlobalStore.getMe().portrait ?? '',
                      //     level: GlobalStore.getMe().vipLevel,
                      //     headWidth: Dimens.pt45,
                      //     headHeight: Dimens.pt45),

                      Image(
                        image: AssetImage(AssetsImages.ICON_APP_LOGO),
                        width: Dimens.pt45,
                        height: Dimens.pt45,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("海角社区",
                              style: TextStyle(
                                  color:
                                      Color(0xff333333),
                                  fontSize: Dimens.pt16, fontWeight: FontWeight.w600)),
                          Text("吃瓜爆料就看海角社区",
                              style: TextStyle(
                                  color:
                                      AppColors.primaryColor.withOpacity(0.6),
                                  fontSize: Dimens.pt14)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: Dimens.pt164,
                    height: Dimens.pt164,
                    margin: EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 0.5),
                    ),
                    child: state.qrCode == ''
                        ? Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : QrImage(
                            backgroundColor: Colors.white,
                            data: state.qrCode,
                            size: Dimens.pt164,
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "ID：${GlobalStore.getMe()?.uid ?? ""}",
                    style: TextStyle(
                        fontSize: Dimens.pt15,
                        color: AppColors.primaryColor.withOpacity(0.6)),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    "官网地址：${Address.landUrl}",
                    style: TextStyle(
                        fontSize: Dimens.pt15,
                        color: AppColors.primaryColor.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 28),
                  Text("如果账号丢失，请到设置-账号凭证找回，\n上传凭证或扫码凭证",
                      style: TextStyle(
                          fontSize: Dimens.pt15,
                          color: AppColors.primaryColor.withOpacity(0.6))),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
