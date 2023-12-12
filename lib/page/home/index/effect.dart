import 'dart:convert';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter/services.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/page/game_surface/overlay/overlay_tool_wrapper.dart';
import 'package:flutter_app/page/home/index/action.dart';
import 'package:flutter_app/page/search/search_default_page.dart';
import 'package:flutter_app/page/user/video_user_center/action.dart';
import 'package:flutter_app/page/user/video_user_center/model/refresh_model.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/video_list_model/recommend_list_model.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_page.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_app/widget/dialog/newDialog/system_image_dialog.dart';
import 'package:flutter_app/widget/dialog/newDialog/system_word_dialog.dart';
import 'package:flutter_base/task_manager/dialog_manager.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_app/page/video/player_manager.dart';
import 'package:flutter_base/utils/log.dart';
import 'state.dart';
import 'package:get/route_manager.dart' as Gets;

Effect<IndexState> buildEffect() {
  return combineEffects(<Object, Effect<IndexState>>{
    Lifecycle.initState: _initState,
    IndexAction.onChangeToUserCenter: _onChangeToUserCenter,
    IndexAction.onChangeToRecommend: _onChangeToRecommend,
    IndexAction.onChangeIndex: _onChangeIndex,
    IndexAction.onSearch: _onSearch,
    Lifecycle.dispose: _dispose,
  });
}

Future _onGetTagsList(Action action, Context<IndexState> ctx) async {
  try {
    dynamic specialModel = await netManager.client.getTagsMarkList();

    dynamic tags = await netManager.client.getTagsList();


  } catch (e) {
    l.e("getGroup", e);
  }
}

void _initState(Action action, Context<IndexState> ctx) {
  ctx.state.pageController = TabController(
    initialIndex:1,
    length: ctx.state.tabList.length,
    vsync: ScrollableState(),
  );
  ctx.state.pageController.addListener(() {
    if (ctx.state.pageController.indexIsChanging) return;

    if (ctx.state.pageController.index == 0) {
      // 关注
      autoPlayModel.registVideoListType(ExtVideoListType(VideoListType.FOLLOW));
      // autoPlayModel.disposeAll();
      autoPlayModel.startAvailblePlayer();
      PlayerManager.canShowFollowDialog = true;
    } else if (ctx.state.pageController.index == 1) {
      // 推荐
      autoPlayModel
          .registVideoListType(ExtVideoListType(VideoListType.RECOMMEND));
      // autoPlayModel.disposeAll();
      autoPlayModel.startAvailblePlayer();
      PlayerManager.canShowRecommendDialog = true;
    } else if (ctx.state.pageController.index == 2) {
      // 搜索/个人中心
      autoPlayModel.registVideoListType(ExtVideoListType(VideoListType.NONE));
      autoPlayModel.pauseAll();

      PlayerManager.canShowFollowDialog = false;
      PlayerManager.canShowRecommendDialog = false;
      // RefreshModel refreshModel = RefreshModel();
      // refreshModel.uniqueId = ctx.state.ucUniqueId;
      // refreshModel.videoModel = recommendListModel.curItem();
      // ctx.broadcast(VideoUserCenterActionCreator.onUpdateUid(refreshModel));
    }

    ctx.dispatch(
        IndexActionCreator.changeIndex(ctx.state.pageController.index));
  });

  ///客服签名信息
  // _getOnlineCustomerSign(ctx);
  /*///显示公告信息
  Future.delayed(Duration(milliseconds: 1000)).then((_) {
    _showWordDialog(action, ctx);
  });
  Future.delayed(Duration(milliseconds: 200)).then((_) {
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });

  */
  _onGetTagsList(action, ctx);

}


///显示公告信息
_showWordDialog(Action action, Context<IndexState> ctx) async {
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
_showImageDialog(Action action, Context<IndexState> ctx) async {
  /*List<AdsInfoBean> adsInfoList = await getAdsByType(AdsType.announcementType);
  if (adsInfoList.isEmpty) {
    return;
  }
  AdsInfoBean adsInfoBean = adsInfoList[0];
  *//*bool val = await dialogManager.addDialogToQueue(() {
    return showDialog(
        context: ctx.context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SystemImageDialog(
            cover: adsInfoBean.cover,
          );
        });
  }, uniqueId: "SystemImageDialog");*//*


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

/// 获取在线客服签名
// _getOnlineCustomerSign(Context<IndexState> ctx) async {
//   getOnlineCustomerSign().then((res) async {
//     if (res.code == 200) {
//       String sign = res.data;
//       if (sign != null) {
//         /// 保存到SP
//         lightKV.setString("sign", sign);
//       }
//     }
//   });
// }

///跳转到用户中心界面
_onChangeToUserCenter(Action action, Context<IndexState> ctx) async {
  ctx.state.pageController.animateTo(3);
  ctx.dispatch(IndexActionCreator.changeIndex(3));
}

///跳转到推荐界面
_onChangeToRecommend(Action action, Context<IndexState> ctx) async {
  ctx.state.pageController.animateTo(1);
  ctx.dispatch(IndexActionCreator.changeIndex(1));
}

_onChangeIndex(Action action, Context<IndexState> ctx) async {
  ctx.dispatch(IndexActionCreator.changeIndex(action.payload));
}

///进入搜索界面
_onSearch(Action action, Context<IndexState> ctx) async {
  autoPlayModel.pauseAll();
  //await JRouter().go(PAGE_SEARCH);
  Gets.Get.to(SearchPage().buildPage(null),opaque: false).then((value) {
    autoPlayModel.playAll();
  });

}

_dispose(Action action, Context<IndexState> ctx) {
  ctx.state.pageController.dispose();
}
