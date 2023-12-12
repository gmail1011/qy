import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_base/utils/misc_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

Widget pullYsRefresh({
  Color textColors = AppColors.userPayTextColor,
  Widget child,
  VoidCallback onRefresh,
  VoidCallback onLoading,
  VoidCallback onTwoLevel,
  RefreshController refreshController,
  Widget cusFooter,
  bool enablePullDown = true,
  bool enablePullUp = true,
  bool enableTwoLevel = false,
  String canTwoLevelText = "",

}) {
  return SmartRefresher(
    enablePullDown: enablePullDown,
    enablePullUp: enablePullUp,
    header: ClassicHeader(
      releaseText: Lang.RELEASE_REFRESH,
      failedText: Lang.REFRESH_FAILED,
      refreshingText: Lang.LOADING,
     canTwoLevelText: canTwoLevelText,
        textStyle: TextStyle(
          color: textColors,
          fontSize: AppFontSize.fontSize14,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal),
      completeText: Lang.REFRESH_SUCCESS,
      idleText: Lang.PULL_DOWN_REFRESH,
    ),
    /*WaterDropHeader(
      waterDropColor: AppColors.userPayTextColor,
      complete: Text(Lang.REFRESH_SUCCESS,
          style:
              TextStyle(color: textColors, fontSize: AppFontSize.fontSize14)),
      failed: Text(Lang.REFRESH_FAILED,
          style:
              TextStyle(color: textColors, fontSize: AppFontSize.fontSize14)),
    ),*/
    footer: cusFooter ?? ClassicFooter(
      loadingText: Lang.LOADING,
      canLoadingText: Lang.RELEASE_LOAD_MORE,
      noDataText: Lang.NO_MORE_DATA,
      idleText: Lang.PULL_UP_LOAD_MORE,
      failedText: Lang.LOADING_FAILED,
      textStyle: TextStyle(
          color: textColors,
          fontSize: AppFontSize.fontSize14,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal),
    ),
    controller: refreshController,
    onRefresh: () {
      MiscUtil.vibrate();
      onRefresh?.call();
    },
    onLoading: () {
      MiscUtil.vibrate();
      onLoading?.call();
    },
    enableTwoLevel: enableTwoLevel,
    onTwoLevel: (){
      onTwoLevel?.call();
    },
    child: child,
  );
}
