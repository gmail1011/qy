import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/utils/analytics.dart' show analytics;

enum VipPopUpsType {
  vip, //会员
  gold, //金币
  atlasGold, //金币图集
}

enum PlayFinishedType {
  movie, //影视
  shortVideo, //短视频
  post, //帖子
}

/// google 统计 埋点
class AnalyticsEvent {
  //点击搜索
  static clickToSearchEvent() {
    analytics.logEvent(name: '点击搜索', parameters: {
      '用户ID': GlobalStore.getMe().uid ?? '',
    });
  }

  //点击搜索热门标签
  static clickToSearchHotTagEvent(String tagName) {
    analytics.logEvent(name: '点击搜索热门标签', parameters: {
      '搜索标签名': tagName,
      '用户ID': GlobalStore.getMe().uid ?? '',
    });
  }

  //搜索手动输入内容
  static clickToSearchInputEvent(String text) {
    analytics.logEvent(name: '搜索输入框', parameters: {
      '搜索输入内容': text,
      '用户ID': GlobalStore.getMe().uid ?? '',
    });
  }

  //点击社区Tab
  static clickToCommunityTabEvent(String tabName) {
    analytics.logEvent(name: "点击社区Tab", parameters: {
      '社区Tab名': tabName,
      '用户ID': GlobalStore.getMe().uid ?? '',
    });
  }

  //点击分享推广
  static clickToSharePromotionEvent() {
    analytics.logEvent(name: "点击分享推广", parameters: {
      '用户ID': GlobalStore.getMe().uid ?? '',
    });
  }

  //点击分享推广--保存图片
  static clickToSharePromotionInSaveImageEvent() {
    analytics.logEvent(name: "点击分享推广保存图片", parameters: {
      '用户ID': GlobalStore.getMe().uid ?? '',
    });
  }

  //点击分享推广--复制链接
  static clickToSharePromotionInCopyLink() {
    analytics.logEvent(name: "点击分享推广复制链接", parameters: {
      '用户ID': GlobalStore.getMe().uid ?? '',
    });
  }

  //点击社区任务中心
  static clickToCommunityMissionCenterEvent() {
    analytics.logEvent(name: "点击社区任务中心", parameters: {
      '用户ID': GlobalStore.getMe().uid ?? '',
    });
  }

  //点击banner
  static clickToBannerEvent(String url, String id) {
    analytics.logEvent(name: "点击banner", parameters: {
      'bannerUrl': url,
      'bannerId': id,
      '用户ID': GlobalStore.getMe().uid ?? '',
    });
  }

  //点击banner
  static clickToAdvEvent(String url, String id) {
    analytics.logEvent(name: "点击首页弹窗图片广告", parameters: {
      'bannerUrl': url,
      'bannerId': id,
      '用户ID': GlobalStore.getMe().uid ?? '',
    });
  }

  // 从活动列表进入活动详情
  static clickToActivityDetailsEvent(String title, String id) {
    analytics.logEvent(name: "从活动列表进入活动详情", parameters: {
      '活动标题': title,
      '活动ID': id,
      '用户ID': GlobalStore.getMe().uid ?? '',
    });
  }

  //播放影视
  static playMoviesEvent(
      {String title, String id, List tags, String sectionId}) {
    analytics.logEvent(name: "播放影视", parameters: {
      '视频标题': title,
      '视频ID': id,
      "视频标签": tags.join('、'),
      '合集ID': sectionId,
      '用户ID': GlobalStore.getMe().uid ?? ''
    });
  }

  //弹窗购买会员
  static clickBuyMembership(
      String title, String id, List tags, VipPopUpsType type) {
    analytics.logEvent(name: "弹窗购买会员", parameters: {
      '视频标题': title,
      '视频ID': id,
      '视频标签': tags.join('、'),
      '弹窗类型': type.toString(),
      '用户ID': GlobalStore.getMe().uid ?? ''
    });
  }

  //会员弹窗点分享
  static clickBuyMembershipShare(
      String title, String id, List tags, VipPopUpsType type) {
    analytics.logEvent(name: "会员弹窗点分享", parameters: {
      '视频标题': title,
      '视频ID': id,
      '视频标签': tags.join('、'),
      '弹窗类型': type.toString(),
      '用户ID': GlobalStore.getMe().uid ?? ''
    });
  }

  //点击homeTab
  static clickToHomeTab(String tabName) {
    analytics.logEvent(name: '点击TAB', parameters: {
      'TAB名称': tabName,
      '用户ID': GlobalStore.getMe().uid ?? '',
    });
  }

  //点击标签
  static clickToTag(String name, String id) {
    analytics.logEvent(name: '点击标签', parameters: {
      '标签名': name,
      '标签ID': id,
      '用户ID': GlobalStore.getMe().uid ?? ''
    });
  }

  //播放完毕
  static clickToPlayFinished(
      PlayFinishedType type, String id, List tags, String title) {
    analytics.logEvent(name: '播放完毕', parameters: {
      '视频ID': id,
      '视频标签': tags.join('、'),
      '视频类型': type.toString(),
      '视频标题': title,
      '用户ID': GlobalStore.getMe().uid ?? ''
    });
  }

  //统计从单个视频拉起支付订单
  static videoPullupPaymentOrder(String id, List tags, String title) {
    analytics.logEvent(name: '从单个视频拉起支付订单', parameters: {
      '视频ID': id,
      '视频标签': tags.join('、'),
      '视频标题': title,
      '用户ID': GlobalStore.getMe().uid ?? ''
    });
  }

  //点击签到
  static clickToSign(String text) {
    analytics.logEvent(
        name: '点击签到',
        parameters: {'用户ID': GlobalStore.getMe().uid ?? '', "签到是否成功": text});
  }

  //点击活动
  static clickActive(String title, String id) {
    analytics.logEvent(name: '点击进入任务详情', parameters: {
      '用户ID': GlobalStore.getMe().uid ?? '',
      "活动标题": title,
      "活动ID": id,
    });
  }

  //点击任务中立即参与
  static clickActiveing(String title, String id) {
    analytics.logEvent(name: '点击任务中立即参与', parameters: {
      '用户ID': GlobalStore.getMe().uid ?? '',
      "活动标题": title,
      "活动ID": id,
    });
  }
}
