import 'package:app_settings/app_settings.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/screen.dart';

import 'state.dart';

Widget buildView(NoNetState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
      child: Material(
          color: Colors.black,
          child: Stack(
            children: [
              ImageLoader.withP(ImageType.IMAGE_ASSETS,
                      address: AssetsImages.NO_NET_CONTENT,
                      width: screen.screenWidth,
                      height: screen.screenHeight,
                      fit: BoxFit.fitHeight)
                  .load(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: Dimens.pt40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AppSettings.openWIFISettings();
                        },
                        child: ImageLoader.withP(ImageType.IMAGE_ASSETS,
                                address: AssetsImages.NO_NET_BTN2,
                                fit: BoxFit.contain,
                                width: screen.screenWidth / 2.5)
                            .load(),
                      ),
                      GestureDetector(
                        onTap: () {
                          safePopPage(2);
                        },
                        child: ImageLoader.withP(ImageType.IMAGE_ASSETS,
                                address: AssetsImages.NO_NET_BTN1,
                                fit: BoxFit.contain,
                                width: screen.screenWidth / 2.5)
                            .load(),
                      ),
                      // getCommonBtn(Lang.NETWORK_SETTING,
                      //     enableColor: Colors.red[900], width: Dimens.pt120, onTap: () {
                      //   AppSettings.openWIFISettings();
                      // }),
                      // getCommonBtn(Lang.RECONNECT,
                      //     enableColor: Colors.red[900],
                      //     width: Dimens.pt120,
                      //     onTap: () => safePopPage(2)),
                    ],
                  ),
                ),
              )
            ],
          )));
}
