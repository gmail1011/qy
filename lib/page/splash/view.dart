import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../page/splash/action.dart';
import 'state.dart';


Widget buildView(
    SplashState state, Dispatch dispatch, ViewService viewService) {

  return Scaffold(
    //这使用主要是预加载背景图
    body: Stack(
      children: <Widget>[

        assetsImg(AssetsImages.IC_SPLASH_BG, width: 1.sw, height: 1.sh, fit: BoxFit.cover, scale: 1.0),

        GestureDetector(
          onTap: () {
            ///点击进入广告
            dispatch(SplashActionCreator.onAdvTag(state.adsBean));
          },
          child: CustomNetworkImage(
              //imageUrl: state.adsBean?.cover,
              imageUrl: !Config.isFirstStartApp ? Config.splashAds?.cover : state.adsBean?.cover,
              width: 1.sw,
              height: 1.sh,
              fit: BoxFit.fitWidth,
              placeholder: Container(color: Colors.transparent)),
        ),

        ///进入按钮
        Positioned(
          right: 30,
          top: 30,
          child: state.countdownTime > 3
              ? Container(width: 20, height: 20)
              : RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Color.fromARGB(60, 0, 0, 0),
                  textColor: Colors.white,
                  child: Text(
                      '${state.countdownTime == 0 ? (state.loginSuccess ? Lang.ENTER : "0s") : '${state.countdownTime}s'}'),
                  onPressed: () {
                    //进入首页
                    dispatch(SplashActionCreator.onJumpHomePage());
                  },
                ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Text(
            "V${Config.innerVersion}",
            style: TextStyle(
                color: Colors.red,
                fontSize: 8,
                decoration: TextDecoration.none),
          ),
        )
      ],
    ),
  );
}
