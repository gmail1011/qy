import 'dart:convert';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/countdown_update_model.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/list_announ_info.dart';
import 'package:flutter_app/page/game_surface/overlay/overlay_tool_wrapper.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/weibo_page/community_action.dart';
import 'package:flutter_app/weibo_page/community_state.dart';
import 'package:flutter_app/widget/dialog/newdialog/recommendApplications.dart';
import 'package:flutter_app/widget/dialog/newdialog/system_image_dialog.dart';
import 'package:flutter_app/widget/dialog/newdialog/system_word_dialog.dart';
import 'package:flutter_base/task_manager/dialog_manager.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:provider/provider.dart';

Effect<CommunityState> buildEffect() {
  return combineEffects(<Object, Effect<CommunityState>>{
    CommunityAction.action: _onAction,
    Lifecycle.initState: _onAction,
    Lifecycle.dispose: _dispose,
  });
}

void _onAction(Action action, Context<CommunityState> ctx) async {


  ///显示公告信息
  Future.delayed(Duration(milliseconds: 2000)).then((_) async{


    // await _showWordDialog(action, ctx);

    ListAnnounInfo lai;
    try {
      lai = await netManager.client.getVipAnnoun();
    } catch (e) {
      l.e("home_effect", "ERROR:$e");
    }
    await Future.forEach(lai?.list?? [],(it) async {
      bool val = await dialogManager.addDialogToQueue(() {
        return showDialog(
            context: ctx.context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return SystemImageDialog(
                cover: it.cover,
              );
            });
      }, uniqueId: "SystemImageDialog2");

      if (val != null && val) {
        await JRouter().go(it.href);
      }
    });
    //首页弹窗小广告
    List<AdsInfoBean> adsList = await getAdsByType(AdsType.homeAdsImg);
    await Future.forEach(adsList,(it) async {
      bool val = await dialogManager.addDialogToQueue(() {
        return showDialog(
            context: ctx.context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return SystemImageDialog(
                cover: it.cover,
                aspectRatio: 3/4,
              );
            });
      }, uniqueId: "SystemImageDialog2");

      if (val != null && val) {
        await  JRouter().go(it.href);
        AnalyticsEvent.clickToAdvEvent(it.href, it.id);
      }
    });

  });



  _getCutDown(ctx);



}
/// 获取新人倒计时
void _getCutDown(Context<CommunityState> ctx) async {
  try {
    Countdown countdown = await netManager.client.getCutDown();
    Provider.of<CountdwonUpdate>(ctx.context, listen: false)
        .setCountdown(countdown);
    if((countdown?.countdownSec ?? 0) > 0) {

      ctx.dispatch(CommunityActionCreator.showNewPersonCutDownTime(true));

    } else {

      ctx.dispatch(CommunityActionCreator.showNewPersonCutDownTime(false));



      Future.delayed(Duration(milliseconds: 1600),(){


        WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp){

          OverlayToolWrapper.of(ctx.context).showActivityFloating();

        });


      });


      bus.on(EventBusUtils.showActivityFloating, (arg) {

        OverlayToolWrapper.of(ctx.context).showActivityFloating();

      });


      bus.on(EventBusUtils.closeActivityFloating, (arg) {

        OverlayToolWrapper.of(ctx.context).hideActivityFloating();

      });


    }
  } catch (e) {
    l.d('getCutDown==', e.toString());
  }
}
///显示公告信息
_showWordDialog(Action action, Context<CommunityState> ctx) async {
  ///若已显示则不再弹出
  if (ctx.state.isOnceSystemDialog) return;
  String aInfo = await lightKV.getString(Config.ANNOUNCEMENT_INFO);
  if (aInfo == null || aInfo.isEmpty) {
    _showImageDialog(action, ctx);
    return;
  }
  List<dynamic> tempList = jsonDecode(aInfo);
  int totalIndex = -1;

  for (int i = 0; i < tempList.length; i++) {
    totalIndex = i;
    AnnounceInfoBean wordBean = AnnounceInfoBean.fromJson(tempList[i]);

    if (wordBean.type == 0) {
      /*showDialog(
          context: ctx.context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return SystemWordDialog(
              content: wordBean.content,
              // addr: Config.SOURCE_URL + "/" + wordBean.cover,
            );
          }).then((value) {
        if (value != null &&
            value is bool && value &&
            wordBean != null &&
            wordBean.href != "") {
          JRouter().handleAdsInfo(wordBean.href);
        }
      });*/
      await showDialog(
          context: ctx.context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return SystemWordDialog(
              content: wordBean.content,
              // addr: Config.SOURCE_URL + "/" + wordBean.cover,
            );
          }).then((value) async {
        if (value != null &&
            value is bool &&
            value &&
            wordBean != null &&
            wordBean.href != "") {
         await JRouter().handleAdsInfo(wordBean.href);
        }
      });
    } else if (wordBean.type == 1) {
      /*showDialog(
          context: ctx.context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return SystemImageDialog(
              cover: wordBean.cover,
            );
          }).then((value) {
        if (value != null &&
            value is bool && value &&
            wordBean != null &&
            wordBean.href != "") {
          JRouter().handleAdsInfo(wordBean.href);
        }
      });*/

    } else if (wordBean.type == 2 || wordBean.type == 3) {
      Config.announceInfoBeanList.add(wordBean);
    }
  }
}

///显示图片公告
_showImageDialog(Action action, Context<CommunityState> ctx) async {
  /*List<AdsInfoBean> adsInfoList = await getAdsByType(AdsType.announcementType);
  if (adsInfoList.isEmpty) {
    return;
  }
  AdsInfoBean adsInfoBean = adsInfoList[0];
  */ /*bool val = await dialogManager.addDialogToQueue(() {
    return showDialog(
        context: ctx.context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SystemImageDialog(
            cover: adsInfoBean.cover,
          );
        });
  }, uniqueId: "SystemImageDialog");*/ /*


  showDialog(
      context: ctx.context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SystemImageDialog(
          cover: adsInfoBean.cover,
        );
      }).then((value) {
    if (value != null && value) {
      JRouter().handleAdsInfo(adsInfoBean.href, id: adsInfoBean.id);
    }
  });*/

  ///显示推荐界面的小广告
}

void _dispose(Action action, Context<CommunityState> ctx) async {
  ctx.state.tabController?.dispose();
}
