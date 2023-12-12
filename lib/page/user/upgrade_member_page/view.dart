import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/page/home/mine/view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    UpgradeMemberState state, Dispatch dispatch, ViewService viewService) {
  return Material(
      child: Container(
          width: screen.screenWidth,
          height: screen.screenHeight,
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         fit: BoxFit.cover,
          //         image: AssetImage(AssetsImages.BG_UPGRADE_VIP))),
          child: Scaffold(
            appBar: getCommonAppBar(""),
            body: SingleChildScrollView(
                child: Column(children: [
              // ImageLoader.withP(ImageType.IMAGE_SVG,
              //         address: AssetsSvg.BG_UPGRADE_VIP_TIP)
              //     .load(),
              SizedBox(height: AppPaddings.padding16),
              // SizedBox(height: AppPaddings.padding16),
              _getCardView(),
              // SizedBox(height: AppPaddings.padding16),
              // SizedBox(height: AppPaddings.padding16),
              Container(
                  margin: EdgeInsets.symmetric(
                      vertical: AppPaddings.appMargin, horizontal: 32),
                  child: _getUpgradeBtn(state.upgradeInfo?.vipUpPrice ?? 0,
                      state.upgradeInfo?.vipUpCheapPrice ?? 0, dispatch)),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 16),
              //   child: ImageLoader.withP(ImageType.IMAGE_ASSETS,
              //           address: AssetsImages.BG_PERMANENT_VIP_PRIVILEGE)
              //       .load(),
              // ),
            ])),
          )));
}

/// 获取当前用户卡片
Widget _getCardView() {
  var me = GlobalStore.getMe();
  if (null == me) return Container();
  bool isRechargeVip = GlobalStore.isRechargeVIP();
  var vipYear = DateTime.parse(me?.vipExpireDate ?? "").year;
  if ((vipYear - netManager.getFixedCurTime().year).abs() >= 20) {
    return Container();
  }
  if (isRechargeVip && me.vipLevel == 1) {
    // vip 升级
    return Stack(
      children: [
        // ImageLoader.withP(ImageType.IMAGE_ASSETS,
        //         address: AssetsImages.BG_UPGRADE_VIP_CARD)
        //     .load(),
        Positioned(
            top: Dimens.pt36,
            left: Dimens.pt38,
            child: Text(
              getVipStringFromTime(
                  me.vipExpireDate, netManager.getFixedCurTime()),
              style: TextStyle(color: Color(0xFF8E8FA2), fontSize: Dimens.pt11),
            )),
        Positioned(
          bottom: Dimens.pt24,
          left: Dimens.pt34,
          child: HeaderWidget(
            headPath: me.portrait,
            level: 0,
            headWidth: Dimens.pt34,
            headHeight: Dimens.pt34,
          ),
        ),
        Positioned(
            bottom: Dimens.pt32,
            left: Dimens.pt72,
            child: Text(
              me?.name ?? "游客",
              style: TextStyle(color: Color(0xFF6F7194), fontSize: Dimens.pt12),
            ))
      ],
    );
  } else if (isRechargeVip && me.vipLevel == 2) {
    // svip 升级
    return Stack(
      children: [
        // ImageLoader.withP(ImageType.IMAGE_ASSETS,
        //         address: AssetsImages.BG_UPGRADE_SVIP_CARD)
        //     .load(),
        Positioned(
             top: Dimens.pt36,
            left: Dimens.pt38,
            child: Text(
              getVipStringFromTime(
                  me.vipExpireDate, netManager.getFixedCurTime()),
              style: TextStyle(color: Color(0xFF9A866C), fontSize: Dimens.pt11),
            )),
        Positioned(
          bottom: Dimens.pt24,
          left: Dimens.pt34,
          child: HeaderWidget(
            headPath: me.portrait,
            level: 0,
             headWidth: Dimens.pt34,
            headHeight: Dimens.pt34,
          ),
        ),
        Positioned(
             bottom: Dimens.pt32,
            left: Dimens.pt72,
            child: Text(
              me?.name ?? "游客",
              style: TextStyle(color: Color(0xFF604F37), fontSize: Dimens.pt12),
            ))
      ],
    );
  } else {
    return Container();
    // return Stack(
    //   children: [
    //     ImageLoader.withP(ImageType.IMAGE_ASSETS,
    //             address: AssetsImages.BG_UPGRADE_VIP_CARD)
    //         .load(),
    //     Positioned(
    //         top: Dimens.pt32,
    //         left: Dimens.pt30,
    //         child: Text(
    //           getVipStringFromTime(
    //               me.vipExpireDate, netManager.getFixedCurTime()),
    //           style: TextStyle(color: Color(0xFF8E8FA2), fontSize: Dimens.pt11),
    //         )),
    //     Positioned(
    //       bottom: Dimens.pt30,
    //       left: Dimens.pt30,
    //       child: HeaderWidget(
    //         headPath: me.portrait,
    //         level: 0,
    //         headWidth: Dimens.pt25,
    //         headHeight: Dimens.pt25,
    //       ),
    //     ),
    //     Positioned(
    //         bottom: Dimens.pt32,
    //         left: Dimens.pt60,
    //         child: Text(
    //           me?.name ?? "游客",
    //           style: TextStyle(color: Color(0xFF6F7194), fontSize: Dimens.pt12),
    //         ))
    //   ],
    // );
  }
}

Widget _getUpgradeBtn(int cost, int save, Dispatch dispatch) {
  return GestureDetector(
    onTap: () {
      dispatch(UpgradeMemberActionCreator.onUpgrade());
    },
    child: Stack(alignment: Alignment.bottomCenter, children: [
      // ImageLoader.withP(ImageType.IMAGE_ASSETS,
      //         address: AssetsImages.BG_UPGRADE_VIP_BTN)
      //     .load(),
      Positioned(
          right: Dimens.pt245,
          top: Dimens.pt7,
          child: Text(cost?.toString() ?? "0",
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 26,
                  fontWeight: FontWeight.w600))),
      Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: Dimens.pt10),
                // width: Dimens.pt380,
                padding: EdgeInsets.symmetric(
                    horizontal: Dimens.pt12, vertical: Dimens.pt1),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    // image: DecorationImage(
                    //     image: AssetImage(AssetsImages.BG_UPGRADE_VIP_SAVE)),
                    borderRadius: BorderRadius.circular(Dimens.pt20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          offset: Offset(0, 4),
                          blurRadius: 9)
                    ],
                    gradient:
                        LinearGradient(colors: AppColors.primaryRaisedGolds)),
                // child: Text(((save ?? 0) ~/ 10).toString(),
                //     style: TextStyle(
                //         color: Colors.red,
                //         fontSize: 18,
                //         fontWeight: FontWeight.w600)

                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                        text: "••• 节省 ",
                        style:
                            TextStyle(color: Color(0xFF500223), fontSize: 14)),
                    TextSpan(
                        text: ((save ?? 0) ~/ 10).toString(),
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: " 元 •••",
                        style:
                            TextStyle(color: Color(0xFF500223), fontSize: 14)),
                  ]),
                )),
          ],
        ),
      )
    ]),
  );
}
