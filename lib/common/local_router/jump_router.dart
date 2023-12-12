//子页面的index的key
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/new_page/mine/mine_share_page.dart';
import 'package:flutter_app/new_page/recharge/recharge_gold_page.dart';
import 'package:flutter_app/new_page/recharge/recharge_vip_page.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/video/video_publish/page.dart';
import 'package:flutter_app/page/video/video_publish/state.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/community_recommend/detail/community_detail_page.dart';
import 'package:flutter_app/weibo_page/message/AnnouncePage.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:get/route_manager.dart' as Gets;

const String KEY_SUB_PAGE = "sub_page";

class JRouter {
  Future go(String url, {bool needPop = false, Map<String, dynamic> arguments}) async {
    if (url.contains("memberLongVideo")) {
      safePopPage();
    }

    bus.emit(EventBusUtils.closeActivityFloating);

    if (TextUtil.isEmpty(url)) return;
    Uri uri;
    try {
      uri = Uri.parse(url);
    } catch (e) {
      l.e("go func", e.toString());
    }
    if (null == arguments) arguments = Map<String, dynamic>();
    arguments.addAll(uri.queryParameters);
    if (null != uri) {
      if (uri.scheme == "yinseinner") {
        if (arguments.containsKey("uid")) {
          ///传入的uid是string 的 需要转换为int
          arguments["uid"] = int.parse(arguments["uid"]);
        }
        if (arguments.containsKey(KEY_SUB_PAGE)) {
          ///传入的uid是string 的 需要转换为int
          arguments[KEY_SUB_PAGE] = int.parse(arguments[KEY_SUB_PAGE]);
        } else {
          arguments[KEY_SUB_PAGE] = 0;
        }
        return jumpPage(uri.host, args: arguments, needPop: needPop);
      } else if (uri.scheme.startsWith("http")) {
        //外部跳转http https
        if (needPop) {
          Navigator.of(FlutterBase.appContext).pop();
        }
        return launchUrl(url);
      } else if (uri.scheme.startsWith("yinselink")) {
        //内部webview跳转http https
        if (uri.scheme == "yinselink") {
          uri = uri.replace(scheme: "http");
        } else if (uri.scheme == "yinselinks") {
          uri = uri.replace(scheme: "https");
        }

        if (uri.host == "default") {
          Uri pathUri = Uri.tryParse(Address.baseApiPath);
          uri = uri.replace(host: pathUri.host, port: pathUri.port);
        }
        var title = arguments.remove("__title__");
        //如果包含token则取出其值
        if (arguments.containsKey("token")) {
          arguments["token"] = GlobalStore.getMe()?.webToken;
        }
        if (arguments.containsKey("apihost")) {
          arguments["apihost"] = Address.baseHost;
        }
        if (arguments.containsKey("userName")) {
          arguments["userName"] = GlobalStore.getMe()?.name ?? '';
        }
        if (arguments.containsKey("userPhone")) {
          arguments["userPhone"] = GlobalStore.getMe()?.mobile ?? '';
        }
        if (arguments.containsKey("appid")) {
          arguments["appid"] = Config.DISC_APP_ID;
        }
        if (arguments.containsKey("userId")) {
          arguments["userId"] = (GlobalStore.getMe()?.uid ?? 0).toString();
        }
        String params = uri.replace(queryParameters: arguments).toString();
        return jumpPage(PAGE_WEB, args: {"title": title, "url": params}, needPop: needPop).then((value) {
          bus.emit(EventBusUtils.showActivityFloating);
        });
      }
    }
    return jumpPage(url, needPop: needPop, args: arguments).then((value) {
      bus.emit(EventBusUtils.showActivityFloating);
    });
  }

  ///统一处理广告跳转，并埋点
  ///[id] 广告id
  Future handleAdsInfo(String url, {String id}) async {
    await go(url);
    AnalyticsEvent.clickToBannerEvent(url, id);
    if (id != null && id.isNotEmpty) {
      try {
        await netManager.client.clickAdEvent(id);
      } catch (e) {
        // showToast(msg: '${uri.host} 路由不存在');
      }
    }
  }

  /// 跳转本地路由页面
  Future jumpPage(String host, {Map<String, dynamic> args, bool needPop = false}) async {
    if (TextUtil.isEmail(host)) return;
    if (needPop) {
      return Navigator.of(FlutterBase.appContext).popAndPushNamed(host, arguments: args);
    }

    if (routerMap.containsKey(host)) {
      return await Navigator.of(FlutterBase.appContext).pushNamed(host, arguments: args);
    }
    try {
      host = host.toLowerCase();
      host = host.replaceAll("=", "");
      if (host == "horizontalvideo") {
        //id 跳转视频详情
        String vodeoId = args["id"];
        Map<String, dynamic> maps = Map();
        maps["videoId"] = vodeoId;
        await JRouter().go(FILM_TV_VIDEO_DETAIL_PAGE, arguments: maps);
      }else if(host == "video"){
        Map<String, dynamic> maps = Map();
        maps["videoId"] = args["id"];
        Gets.Get.to(FilmTvVideoDetailPage().buildPage(maps), opaque: false);
      }else if(host == "postinfo"){
        String id = args["id"];
        Gets.Get.to(CommunityDetailPage().buildPage({"videoId": id}), opaque: false);
      } else if (host == "sharepromote") {
        //分享推广
        await JRouter().jumpPage(PAGE_PERSONAL_CARD);
      } else if (host == "membercentre") {
        //会员中心页面
        Config.payFromType = PayFormType.banner;
        Config.payBuyType = 1;
        Gets.Get.to(() =>RechargeVipPage(""),opaque: false);
      } else if (host == "incomecenter") {
      } else if (host == "taskhall") {
        //任务中心
        await JRouter().jumpPage(TASK_CENTER_PAGE);
      } else if (host == "taskdetails") {

      } else if (host == "wishlist") {
        //心愿工单
        await JRouter().jumpPage(WISH_LIST_PAGE);
      } else if (host == "creationcenter") {
        //创作中心
        await JRouter().jumpPage(MAKE_VIDEO_PAGE);
      } else if (host == "mycertification") {
        //我的认证
        await JRouter().jumpPage(MY_CERTIFICATION_PAGE);
      } else if (host == "announcement") {
        //公告主界面
        await Gets.Get.to(AnnouncePage(), opaque: false);
      } else if (host == "kefu") {
        //在线客服页面
        csManager.openServices(FlutterBase.appContext);
      } else if (host == "memberlongvideo") {
        bus.emit(EventBusUtils.memberlongvideo);
      } else if (host == "userhomepage") {
        //uid  跳转博主
        int uid = args["uid"] ?? 0;
        if (uid == 0) {
          return;
        }
        Map<String, dynamic> arguments = {
          'uid': uid,
          'uniqueId': DateTime.now().toIso8601String(),
        };
        await Gets.Get.to(() => BloggerPage(arguments), opaque: false);
      } else if (host == "gamewallet") {
        // JRouter().jumpPage(MY_CERTIFICATION_PAGE);
        await JRouter().jumpPage(GAME_WALLET);
      }else if(host == "community_page"){
        bus.emit(EventBusUtils.sheQu);
      }else if(host == "universal_agent"){
        Gets.Get.to(() => MineSharePage(), opaque: false);
      }else if(host == "vip_page"){
        //会员中心页面
        Config.payFromType = PayFormType.banner;
        Config.payBuyType = 1;
        Gets.Get.to(() =>RechargeVipPage(""),opaque: false);
      }else if(host == "wallet_page"){
        Gets.Get.to(() =>RechargeGoldPage());
      }else if(host == "publish_page"){
        Map<String, dynamic> map = {
          'type': UploadType.UPLOAD_IMG,
          'pageType': 0,
        };
        Gets.Get.to(VideoAndPicturePublishPage().buildPage(map), opaque: false);
      }else if(host == "binding_page"){
        JRouter().go(PAGE_INITIAL_BIND_PHONE);
      } else {
        showToast(msg: '$host 路由不存在');
        l.e("路由-host:", "$host");
      }
    } catch (e) {
      l.e("调整路由-error:", "$e");
    }
  }
}
