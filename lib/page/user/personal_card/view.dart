import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/page/user/personal_card/action.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'state.dart';

Widget buildView(
    PersonalCardState state, Dispatch dispatch, ViewService viewService) {
  return Stack(
    children: [
      _saveView(state, dispatch, viewService),
      _showView(state, dispatch, viewService),
    ],
  );
}

Widget _saveView(
    PersonalCardState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    body: RepaintBoundary(
      key: state.boundaryKey,
      child: Container(
        width: screen.screenWidth,
        padding: EdgeInsets.only(top: screen.paddingTop + kToolbarHeight),
        color: AppColors.primaryColor,
        child: _codeView(state, dispatch),
      ),
    ),
  );
}

Widget _showView(
    PersonalCardState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    width: screen.screenWidth,
    height: screen.screenHeight,
    color: AppColors.primaryColor,
    child: Scaffold(
      appBar: getCommonAppBar("分享推广"),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 16),
            _codeView(state, dispatch),
            SizedBox(height: 28),
            Container(
              margin: EdgeInsets.all(16),
              child: ImageLoader.withP(ImageType.IMAGE_ASSETS,
                      address: AssetsImages.PERSONAL_RULE2)
                  .load(),
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _codeView(PersonalCardState state, Dispatch dispatch) {
  return Container(
    width: screen.screenWidth,
    height: Dimens.pt360 + (Dimens.pt74 / 2),
    child: Container(
      width: screen.screenWidth - Dimens.pt16 * 2,
      height: Dimens.pt360,
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AssetsImages.PERSONAL_CODE_BG2),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image(
                image: AssetImage(AssetsImages.ICON_APP_LOGO),
                width: Dimens.pt45,
                height: Dimens.pt45,
              ),

              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("网黄Up的分享平台",
                      style: TextStyle(
                          color: AppColors.primaryColor.withOpacity(0.6),
                          fontSize: Dimens.pt14)),
                  Text("一款边吃瓜边赚钱的APP",
                      style: TextStyle(
                          color: AppColors.primaryColor.withOpacity(0.6),
                          fontSize: Dimens.pt14)),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 18),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.5),
            ),
            child: QrImage(
              data: state.meInfo?.promoteURL,
              version: QrVersions.auto,
              size: Dimens.pt160,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            "分享好友立赠送91猎奇专属会员",
            style: TextStyle(
              color: AppColors.primaryColor.withOpacity(0.6),
              fontSize: Dimens.pt16,
              height: 1.4,
            ),
          ),
          Text(
            "官网地址：${state.meInfo?.promoteURL ?? (Address.landUrl ?? '')}",
            maxLines: 1,
            style: TextStyle(
              color: AppColors.primaryColor.withOpacity(0.6),
              fontSize: Dimens.pt12,
              height: 1.4,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: Dimens.pt33, right: Dimens.pt33, top: Dimens.pt28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getLinearGradientBtn(
                  "保存图片",
                  width: Dimens.pt120,
                  textColor: AppColors.primaryColor,
                  enableColors: AppColors.shareButtonBgColors,
                  onTap: () {
                    ///保存图片分享
                    eagleClick(state.selfId(),
                        sourceId: state.selfId(), label: "保存分享图片");
                    dispatch(PersonalCardActionCreator.onSaveImage());
                    AnalyticsEvent.clickToSharePromotionInSaveImageEvent();
                  },
                ),
                getLinearGradientBtn(
                  "复制链接",
                  width: Dimens.pt120,
                  textColor: AppColors.primaryColor,
                  enableColors: AppColors.shareButtonBgColors,
                  onTap: () {
                    ///复制分享链接到剪切板
                    eagleClick(state.selfId(),
                        sourceId: state.selfId(), label: "保存分享链接");
                    Clipboard.setData(
                        ClipboardData(text: state.meInfo?.promoteURL));
                    showToast(msg: Lang.SHARE_TIP);
                    AnalyticsEvent.clickToSharePromotionInCopyLink();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _codeView2(PersonalCardState state) {
  return Column(
    children: <Widget>[
      Container(
        width: screen.screenWidth,
        height: Dimens.pt360 + (Dimens.pt74 / 2),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: Dimens.pt74 / 2,
              child: Container(
                width: screen.screenWidth - Dimens.pt16 * 2,
                height: Dimens.pt360,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AssetsImages.PERSONAL_CODE_BG2),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                        top: Dimens.pt57,
                        child: Column(
                          children: [
                            Text(
                              Lang.MY_PROMOTION_CODE,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Dimens.pt14,
                                height: 1.4,
                              ),
                            ),
                            Text(
                              state.meInfo?.promotionCode ?? "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Dimens.pt36,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                            )
                          ],
                        )),
                    Positioned(
                      // top: Dimens.pt30,
                      bottom: Dimens.pt60,
                      left: Dimens.pt70,
                      right: Dimens.pt70,
                      //根据链接生成的二维码
                      child: QrImage(
                        data: state.meInfo?.promoteURL,
                        version: QrVersions.auto,
                        size: Dimens.pt150,
                      ),
                    ),
                    Positioned(
                      bottom: Dimens.pt34,
                      child: Text(
                        state.meInfo?.promoteURL ?? (Address.landUrl ?? ''),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: Dimens.pt14,
                          height: 1.4,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: HeaderWidget(
                  headPath: GlobalStore.getMe().portrait ?? '',
                  level: (GlobalStore.getMe().superUser ?? false) ? 1: 0,
                  headWidth: Dimens.pt74,
                  headHeight: Dimens.pt74),
            ),
          ],
        ),
      ),
    ],
  );
}
