import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
//import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

/// 有盟埋点数据类
/// 这里就叫鹰眼吧
// enum EagleType {
//   /// 点击类型
//   CLICK,

//   /// 视频播放
//   VID,

//   /// 页面停留以及其他
//   PAGE,
// }
String _androidKey;
void umengInit(String androidKey, String iosKey) {
  if (TextUtil.isEmpty(androidKey)) return;
  _androidKey = androidKey;
  //UmengAnalyticsPlugin.init(androidKey: androidKey, iosKey: iosKey);
}

/// 基础埋点
void eagle(String id, {String label}) {
  if (TextUtil.isEmpty(_androidKey) || TextUtil.isEmpty(id)) return;
 // UmengAnalyticsPlugin.event(id, label: label);
}

/// 基础埋点-点击
/// [id] 特征id
/// [sourceId] 点击的原始来源或者父
/// [label] 点击的内容
void eagleClick(String id, {String sourceId, String label}) {
  /*if (TextUtil.isEmpty(id)) return;
  var clickId = 'CLICK_$id';
  var ls = "${sourceId ?? ""}(${label ?? ""})";
  l.i(clickId, "eagleClick()...id:$clickId  ls:$ls");
  if (TextUtil.isEmpty(sourceId) && TextUtil.isEmpty(label)) {
    eagle(clickId);
  } else {
    eagle(clickId, label: ls);
  }*/
}

/// 基础埋点-视频播放
void eagleVid(String id, {String label}) {
  if (TextUtil.isEmpty(id)) return;
  eagle('VID_$id', label: label);
}

/// 如果是需要流程的，是需要一系列的流程id和祖先id的
/// 业务埋点 -支付
/// 点击支付
void eaglePay(String label) {
  eagleClick("pay");
}

/// 基础埋点-页面
/// [id] 特征id
/// [sourceId] 点击的原始来源或者父
/// [label] 点击的内容
void eaglePage(String id, {String sourceId, String label}) {
  if (TextUtil.isEmpty(id)) return;
  var pageId = 'PAGE_$id';
  var ls = "${sourceId ?? ""}(${label ?? ""})";
  l.i(pageId, "eagleClick()...id:$pageId  ls:$ls");
  if (TextUtil.isEmpty(sourceId) && TextUtil.isEmpty(label)) {
    eagle(pageId);
  } else {
    eagle(pageId, label: ls);
  }
}

/// 推出页面路由
void umengDidPush(Route newRoute, Route oldRoute) {
  if (TextUtil.isNotEmpty(oldRoute?.settings?.name)) {
    //UmengAnalyticsPlugin.pageEnd(oldRoute?.settings?.name);
  }

  if (TextUtil.isNotEmpty(newRoute?.settings?.name)) {
    //UmengAnalyticsPlugin.pageStart(newRoute?.settings?.name);
  }
  if (TextUtil.isNotEmpty(oldRoute?.settings?.name) &&
      TextUtil.isNotEmpty(newRoute?.settings?.name)) {
    if (null != newRoute?.settings?.arguments &&
        newRoute.settings.arguments is Map) {
      var originId =
          (newRoute.settings.arguments as Map)[KEY_ORIGIN_ID] as String;
      if (TextUtil.isEmpty(originId)) {
        originId = oldRoute.settings.name;
        if (null != oldRoute?.settings?.arguments &&
            oldRoute.settings.arguments is Map) {
          var oOriginId =
              (oldRoute.settings.arguments as Map)[KEY_ORIGIN_ID] as String;
          if (TextUtil.isNotEmpty(oOriginId) && !oOriginId.contains(originId)) {
            originId = "$oOriginId->$originId";
          }
        }
        l.i("router",
            "didPush()...n:${newRoute?.settings?.name} 设置新的originId:$originId");
        (newRoute.settings.arguments as Map)[KEY_ORIGIN_ID] = originId;
        (newRoute.settings.arguments as Map)[KEY_SELF_ID] =
            newRoute?.settings?.name;
      } else {
        l.i("router",
            "didPush()...n:${newRoute?.settings?.name} 存在originId:$originId 不再设置");
      }
    } else {
      l.e("router",
          "didPush()...${newRoute?.settings?.name} args is not a map");
    }
  }
}

/// 友盟pop页面
void umengDidPop(Route route, Route previousRoute) {
  if (TextUtil.isNotEmpty(route?.settings?.name)) {
    //UmengAnalyticsPlugin.pageEnd(route?.settings?.name);
  }

  if (TextUtil.isNotEmpty(previousRoute?.settings?.name)) {
   // UmengAnalyticsPlugin.pageStart(previousRoute?.settings?.name);
  }
}

/// 友盟replece页面
void umengDidReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
  if (TextUtil.isNotEmpty(oldRoute?.settings?.name)) {
    //UmengAnalyticsPlugin.pageEnd(oldRoute?.settings?.name);
  }

  if (TextUtil.isNotEmpty(newRoute?.settings?.name)) {
    //UmengAnalyticsPlugin.pageStart(newRoute?.settings?.name);
  }

  if (TextUtil.isNotEmpty(oldRoute?.settings?.name) &&
      TextUtil.isNotEmpty(newRoute?.settings?.name)) {
    if (null != newRoute?.settings?.arguments &&
        newRoute.settings.arguments is Map) {
      var originId =
          (newRoute.settings.arguments as Map)[KEY_ORIGIN_ID] as String;
      if (TextUtil.isEmpty(originId)) {
        originId = oldRoute.settings.name;
        if (null != oldRoute?.settings?.arguments &&
            oldRoute.settings.arguments is Map) {
          var oOriginId =
              (oldRoute.settings.arguments as Map)[KEY_ORIGIN_ID] as String;
          if (TextUtil.isNotEmpty(oOriginId) && !oOriginId.contains(originId)) {
            originId = "$oOriginId->$originId";
          }
        }
        l.i("router",
            "didPush()...n:${newRoute?.settings?.name} 设置新的originId:$originId");
        (newRoute.settings.arguments as Map)[KEY_ORIGIN_ID] = originId;
        (newRoute.settings.arguments as Map)[KEY_SELF_ID] =
            newRoute?.settings?.name;
      } else {
        l.i("router",
            "didPush()...n:${newRoute?.settings?.name} 存在originId:$originId 不再设置");
      }
    } else {
      l.e("router",
          "didPush()...${newRoute?.settings?.name} args is not a map");
    }
  }
}
