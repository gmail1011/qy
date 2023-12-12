import 'dart:convert';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/announce_liao_ba_entity.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/page/game_surface/overlay/overlay_tool_wrapper.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/dialog/newdialog/system_image_dialog.dart';
import 'package:flutter_app/widget/dialog/newdialog/system_word_dialog.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/home/post/page/common_post/action.dart';
import 'package:flutter_app/page/search/hot_search_list/hot_search_business.dart';
import 'package:flutter_app/page/tag/special_topic/page.dart';
import 'package:flutter_app/common/manager/event_manager.dart';
import 'package:flutter_app/utils/global_variable.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'action.dart';
import 'state.dart';

Effect<PostState> buildEffect() {
  return combineEffects(<Object, Effect<PostState>>{
    Lifecycle.initState: onInitAds,
    Lifecycle.dispose: _dispose,
    PostAction.onFeatured: _onFeatured,
    PostAction.onRank: _onRank,
    PostAction.onActivity: _onActivity,
    PostAction.onTag: _onTag,
    PostAction.onSearch: _onSearch,
    PostAction.onIsShowTopBtn: _onIsShowTopBtn,
    PostAction.onRefreshAllData: _onRefreshAllData,
    PostAction.onSelectUploadType: _onSelectUploadType,
    PostAction.onGetTaskId: _onGetTaskId,
  });
}

///销毁订阅
void _dispose(Action action, Context<PostState> ctx) {
  ctx.state.postLoadOriginEventID.cancel();
  ctx.state.payTabController.dispose();
  ctx.state.scrollController.dispose();
}

///刷新聊吧所有数据 下个版本使用
void _onRefreshAllData(Action action, Context<PostState> ctx) async {
  //获取广告数据
 // var list = await getAdsByType(AdsType.hotType);
 // ctx.dispatch(PostActionCreator.getAdsSuccess(list ?? []));
  if (ctx.state.scrollController.hasClients) {
    ctx.state.scrollController?.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }
  ctx.broadcast(
      CommonPostActionCreator.onListenerRefreshData(ctx.state.currentIndex));
}

void _onGetTaskId(Action action, Context<PostState> ctx) async {
  //这个函数从发布页面过来，只调用一次
  ctx.state.taskId = action.payload;
  ctx.state.uploadRetryCnt = 0;
  await taskManager.configUpdateCallback(ctx.state.taskId, (progress,
      {msg, isSuccess}) {
    // l.i("posteffect",
    //     "post update progress:$progress msg:$msg retryCnt:${ctx.state.uploadRetryCnt}");
    ctx.state.uploadProgress = progress;
    if (progress < 0 && ctx.state.uploadRetryCnt >= 3) {
      //失败
      showToast(msg: "抱歉，失败次数太多！");
      taskManager.configUpdateCallback(ctx.state.taskId, null);
      ctx.state.taskId = null;
    }
    ctx.dispatch(PostActionCreator.refreshUI());
    // 成功
  });
  if (ctx.state.uploadProgress >= 1) {
    showToast(msg: "上传成功!");
    taskManager.configUpdateCallback(ctx.state.taskId, null);
    ctx.state.taskId = null;
    // ctx.broadcast(MineWorkActionCreator.onGetWorkData());
  }
}

void _onIsShowTopBtn(Action action, Context<PostState> ctx) {
  if (ctx.state.showToTopBtn == action.payload) {
    return;
  }
  ctx.dispatch(PostActionCreator.setIsShowTopBtn(action.payload));
}

///选择图片或视频
void _onSelectUploadType(Action action, Context<PostState> ctx) async {
  var uploadType = await showUploadType(ctx.context);
  if (uploadType == null) {
    return;
  }
  bool isEntry = await lightKV.getBool(Config.VIEW_UPLOAD_RULE);
  if (!isEntry) {
    var agree = await JRouter().go(PAGE_UPLOAD_RULE);
    if(agree == null) {
      agree = await lightKV.getBool(Config.VIEW_UPLOAD_RULE);
    }
    if (!(null != agree && agree is bool && agree)) return;
  }

  l.i("post", "_onSelectUploadType()...choose okay:$uploadType");
  Map<String, dynamic> map = {'type': uploadType};
  await JRouter().go(VIDEO_PUBLISH, arguments: map);
}

void _onSearch(Action action, Context<PostState> ctx) async {
  autoPlayModel.disposeAll();
  await JRouter().go(PAGE_SPECIAL);
  autoPlayModel.startAvailblePlayer();
}

///获取广告列表
void onInitAds(Action action, Context<PostState> ctx) async {

  ///显示公告信息
  Future.delayed(Duration(milliseconds: 1000)).then((_) {
    _showWordDialog(action, ctx);
    _showImageDialog(action, ctx);
  });
  Future.delayed(Duration(milliseconds: 200)).then((_) {
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });

  //var list = await getAdsByType(AdsType.hotType);
  //ctx.dispatch(PostActionCreator.getAdsSuccess(list ?? []));
  _onGetAnnounce(action,ctx);
  ctx.state.postLoadOriginEventID =
      GlobalVariable.eventBus.on<PostLoadOriginEvent>().listen((event) async {
    if (event.type == 1) {
      ctx.dispatch(PostActionCreator.onRefreshAllData());
    }
  });

  ctx.state.primaryTC.addListener(() {
    if(ctx.state.primaryTC.index != ctx.state.primaryTC.length - 1){
      bus.emit(EventBusUtils.hideAudioBook,true);
    }else{
      bus.emit(EventBusUtils.hideAudioBook,false);
    }

  });


  WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp){
    OverlayToolWrapper.of(ctx.context).showActivityFloating();
  });
}

///显示公告信息
_showWordDialog(Action action, Context<PostState> ctx) async {
  ///若已显示则不再弹出
  if (ctx.state.isOnceSystemDialog) return;
  String aInfo = await lightKV.getString(Config.ANNOUNCEMENT_INFO);
  // if (aInfo == null || aInfo.isEmpty) {
  //   _showImageDialog(action, ctx);
  //   return;
  // }
  List<dynamic> tempList = jsonDecode(aInfo);
  int totalIndex = -1;

  for (int i = 0; i < tempList.length; i++) {
    totalIndex = i;
    AnnounceInfoBean wordBean = AnnounceInfoBean.fromJson(tempList[i]);

    if (wordBean.type == 0) {
      showDialog(
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
      });
    } else if (wordBean.type == 1) {

      showDialog(
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
      });
    } else if (wordBean.type == 2 || wordBean.type == 3) {
      Config.announceInfoBeanList.add(wordBean);
    }
  }

  /*if(totalIndex == tempList.length){
    _showImageDialog(action, ctx);
  }*/

  /*AnnounceInfoBean wordBean =AnnounceInfoBean.fromJson(tempList[0]);
  var val;
  if (wordBean == null) {
    _showImageDialog(action, ctx);
    return;
  }
  switch (wordBean.type) {
    case 0:
      {
        val = await dialogManager.addDialogToQueue(
            () => showDialog(
                context: ctx.context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return SystemWordDialog(
                    content: wordBean.content,
                    // addr: Config.SOURCE_URL + "/" + wordBean.cover,
                  );
                }),
            uniqueId: "SystemWordDialog");
      }
      break;
    case 1:
      {
        val = await dialogManager.addDialogToQueue(() {
          return showDialog(
              context: ctx.context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return SystemImageDialog(
                  cover: wordBean.cover,
                );
              });
        }, uniqueId: "SystemImageDialog");
      }
      break;
  }

  if (val != null &&
      val is bool &&
      val &&
      wordBean != null &&
      wordBean.href != "") {
    JRouter().handleAdsInfo(wordBean.href);
  }
  _showImageDialog(action, ctx);*/
}

///显示图片公告
_showImageDialog(Action action, Context<PostState> ctx) async {
 List<AdsInfoBean> adsInfoList = await getAdvByType(2);
 if (adsInfoList.isEmpty) {
   return;
 }
  AdsInfoBean adsInfoBean = adsInfoList[0];
    return showDialog(
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
    });
  }


  /*showDialog(
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


void _onFeatured(Action action, Context<PostState> ctx) {
  JRouter().go(PAGE_DISCOVERY);
}

void _onRank(Action action, Context<PostState> ctx) {
  Map<String, dynamic> mapParams = Map();
  mapParams['index'] = 0;
  mapParams['userInvite'] = [];
  mapParams['userUpload'] = [];
  mapParams['userIncome'] = [];
  JRouter().go(PAGE_RANKING, arguments: mapParams);
}

void _onActivity(Action action, Context<PostState> ctx) {
  // 活动页面TODO
  if (TextUtil.isNotEmpty(Address.activityUrl)) {
    JRouter().handleAdsInfo(Address.activityUrl);
  } else {
    showToast(msg: Lang.STAY_TUNED);
  }
}

void _onTag(Action action, Context<PostState> ctx) {
  Navigator.push(ctx.context,
      new MaterialPageRoute(builder: (BuildContext context) {
    return Scaffold(
      backgroundColor: HotSearchMgr.instance.backColor,
      appBar: AppBar(
        backgroundColor: HotSearchMgr.instance.backColor,
        title: Text(
          Lang.THEMATIC,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: Dimens.pt20),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            safePopPage();
          },
        ),
      ),
      body: SpecialTopicPage().buildPage(null),
    );
  }));
}


Future _onGetAnnounce(Action action, Context<PostState> ctx) async {
  try {
    AnnounceLiaoBaData specialModel = await netManager.client.getAnnounce();
    StringBuffer stringBuffer = new StringBuffer();
    specialModel.announcement.forEach((element) {
      stringBuffer.write(element);
    });
    ctx.dispatch(PostActionCreator.onAnnounce(stringBuffer.toString()));
  } catch (e) {
    l.e("getGroup", e);
  }
}

