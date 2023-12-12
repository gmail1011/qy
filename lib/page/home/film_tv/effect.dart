import 'dart:convert';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/utils/cache_util.dart';
import 'package:flutter_app/widget/dialog/newdialog/recommendApplications.dart';
import 'package:flutter_app/widget/dialog/newdialog/system_image_dialog.dart';
import 'package:flutter_app/widget/dialog/newdialog/system_word_dialog.dart';
import 'package:flutter_base/task_manager/dialog_task_manager.dart';
import 'package:flutter_base/utils/light_model.dart';

import 'action.dart';
import 'state.dart';

Effect<FilmTelevisionState> buildEffect() {
  return combineEffects(<Object, Effect<FilmTelevisionState>>{
    FilmTelevisionAction.action: _onAction,
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
  });
}

void _onAction(Action action, Context<FilmTelevisionState> ctx) {}

void _initState(Action action, Context<FilmTelevisionState> ctx) async {

  ctx.state.tabController = TabController(length: ctx.state.dataType==0?Config.homeDataTags.length:Config.deepWeb.length, vsync: ScrollableState());

  if(ctx.state.dataType==0){
    ///显示公告信息
    Future.delayed(Duration(milliseconds: 1000)).then((_) async {
      if(!(ctx.state.isAlreadyShow ??false)){

        List<AdsInfoBean> AppList = await  getAdvByType(5) ;
        if(AppList.length > 0){
          List<AdsInfoBean> bannerList_301 =await  getAdvByType(6);
          var result = await newDialogTaskManager.addDialogNewTaskToQueue(() {
            return showDialog(
                context: ctx.context,
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.9),
                builder: (BuildContext context) {
                  return RecommendApplication(officeConfigList: AppList,adsList:bannerList_301);
                });
          }, uniqueId: "RecommendApplication");
          newDialogTaskManager.remove("RecommendApplication");
        }
        ctx.state.isAlreadyShow = true;
      }
      await _showImageDialog(action, ctx);
      _showWordDialog(action, ctx);
    });
  }



  ctx.state.tabController.addListener(() {

    clearAllCache();

  });

}


 _showImageDialog(Action action, Context<FilmTelevisionState> ctx) async {
  List<AdsInfoBean> adsInfoList = await getAdvByType(2);
  if (adsInfoList.isEmpty) {
    return;
  }

  for (int i = 0; i < adsInfoList.length; i++) {
    await showDialog(
        context: ctx.context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SystemImageDialog(
            cover: adsInfoList[i].cover.toString(),
          );
        }).then((value) {
      if (value != null && value) {
        JRouter().handleAdsInfo(adsInfoList[i].href, id: adsInfoList[i].id);
      }
    });
    // var result = await newDialogTaskManager.addDialogNewTaskToQueue(() {
    //   return showDialog(
    //       context: ctx.context,
    //       barrierDismissible: true,
    //       builder: (BuildContext context) {
    //         return SystemImageDialog(
    //           cover: adsInfoList[i].cover.toString(),
    //         );
    //       })
    //       .then((value) async {
    //         if (value != null && value) {
    //           JRouter().handleAdsInfo(adsInfoList[i].href, id: adsInfoList[i].id);
    //         }
    //   })
    //   ;
    // }, uniqueId: "SystemImageDialog"+i.toString());
    // newDialogTaskManager.remove("SystemImageDialog"+i.toString());
  }


}


///显示公告信息
_showWordDialog(Action action, Context<FilmTelevisionState> ctx) async {
  ///若已显示则不再弹出
  String aInfo = await lightKV.getString(Config.ANNOUNCEMENT_INFO);
  if (aInfo == null || aInfo.isEmpty) {
    return;
  }
  List<dynamic> tempList = jsonDecode(aInfo);
  int totalIndex = -1;

  for (int i = 0; i < tempList.length; i++) {
    totalIndex = i;
    AnnounceInfoBean wordBean = AnnounceInfoBean.fromJson(tempList[i]);

    if (wordBean.type == 0) {
      var result = await newDialogTaskManager.addDialogNewTaskToQueue(() {
        return showDialog(
        context: ctx.context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SystemWordDialog(
            content: wordBean.content,
            // addr: Config.SOURCE_URL + "/" + wordBean.cover,
          );
        })
          .then((value) async {
          if (value != null &&
              value is bool &&
              value &&
              wordBean != null &&
              wordBean.href != "") {
            await JRouter().handleAdsInfo(wordBean.href);
          }
          })
        ;
      }, uniqueId: "SystemWordDialog");
      newDialogTaskManager.remove("SystemWordDialog");
    } else if (wordBean.type == 1) {
    } else if (wordBean.type == 2 || wordBean.type == 3) {
      Config.announceInfoBeanList.add(wordBean);
    }
  }
}


void _dispose(Action action, Context<FilmTelevisionState> ctx) {
  ctx.state.tabController?.dispose();
}
