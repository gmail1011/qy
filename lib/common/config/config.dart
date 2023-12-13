import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/announcement_entity.dart';
import 'package:flutter_app/model/anwangVipCard/AnWangVipCard.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/message/NewMessageTip.dart';
import 'package:flutter_app/model/tabs_tag_entity.dart';
import 'package:flutter_app/model/tags_liao_ba_entity.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/game_page/bean/game_balance_entity.dart';
import 'package:flutter_app/page/game_page/bean/transfer_result_entity.dart';
import 'package:flutter_app/page/user/member_centre_page/wallet/gold_tickets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Config {
  static const DEBUG = false;
  static const PROXY = false;
  static bool DNS_CUSTOM = false;
  static bool DNS_ALREADY_USE_NEWDOMAIN = false;
  static String DNS_IP = "223.5.5.5";
  static String GET_DOMAIN_URL = "http://123.56.28.222:1111/hjll";
  static bool isAbleClickProductBuy = true;

  static const PROXY_URL = "PROXY 192.168.1.150:8888";

  static String dataBuriedPoint = ""; // "/api/embed/prd/dataAdd";
  // 打开cdn源站 避免访问平凡无法测试的情况
  static const OPEN_SOURCE = false;
  //是否打印日志
  static const SHOWLOG = false;

  /// header里面，服务器返回,更新使用
  /// note-this:请保持pubspec.yaml一致
  static const innerVersion = "1.5.0";

  /// ios tf 的内部包名
  /// note_this:不要修改这个值
  static const IOS_TF_BUNDLE_ID = "yinse_opera";

  static const UMENG_ANDROID_KEY = "5f74666980455950e49cdc1e";

  static const UMENG_IOS_KEY = "5f7466da80455950e49cdc20";

  ///ios schemes
  static const IOS_SCHEMES = "yinseopera";

  static const PAGE_SIZE = 26;

  ///最后一次选线成功的host
  static const String LATEST_SUCCESS_LINE = "_key_latest_line_$DEBUG";

  ///线路信息
  static const String KEY_SERVER_DOMAIN = "domainInfo_$DEBUG";

  ///资源信息  图片、视频、官网等地址信息
  static const String SOURCE_INFO = "sourceInfo";

  ///更新信息
  static const String UPDATE_INFO = "updateInfo";

  ///公告信息
  static const String ANNOUNCEMENT_INFO = "announInfo";

  ///已观看了的视频列表
  static const String LOOKED_VIDEO_LIST = "lookedVideos";

  ///精选专区数据
  static const String GOLD_COIN_AREA_LIST = "goldCoinAreaList";

  ///是否保存了二维码图片
  static const String HAVE_SAVE_QR_CODE = "haveSaveQrCode";

  ///是否展示长按提示
  static const String PRESS_TIP = "showTip";

  ///发现精彩数据
  static const String FIND_LIST = "findList";

  static bool isGameSurface = false;

  static bool isFirstStartApp = false;

  static int liaoBaYuanChuangTempIndex = 0;

  static List<VideoModel> newVideoModel = [];

  // ///加密密钥
  // static String get encryptKey {
  //   String a = "dkV1a0EmdzE";
  //   String b = "1ejRWQUQza0FZI2ZrTCNy";
  //   String c = "Qm5VIVdEaE4=";
  //   String ret = String.fromCharCodes(base64Decode(a + b + c));
  //   return ret;
  //
  // }

  ///加密密钥
  static String get encryptKey {
    String ret = "c3d110af466a058d7bac6070b952aa5e"; //更换Key
    return ret;
  }

  /// m3u8 视频解密密钥请求接口
  static const M3U8_KEY_SECRET = "/ttl";

  ///马甲包检查情况
  static const String ReviewKey = "reivewKey";

  ///防重放攻击密钥
  static const ANTI_REPLAY_ATTACK_KEY = "kaFtkDJRcchRMTI9";

  ///im加密key
  static const IM_ENCRYPT_KEY = "abcwnelu4c3q1eee";

  /// 渠道id:短视频是1;泡芙社区2;91约炮3;斗鱼av4;qvod6;色中色7
  static const DISC_APP_ID = "1";

  /// cdn 源站地址
  static const SOURCE_URL = "https://yuan.dhuqh.com";

  ///本地线路配置
  static List<String> LINE_LIST = DEBUG
      ? [
          //"http://hjht.cestalt.com",

         // "http://163.53.216.122:9932",
          "http://163.53.216.122:9491",
        ]
      : [
          "https://dz699omw530y9.cloudfront.net",
          "https://d3mybiqstirk6c.cloudfront.net",
          "https://zk4o8.cc",
        ];

  ///ios使用域名
  // static const List<String> IOS_LINE_LIST = [
  //   "https://dspapi.cndreamer.cn",
  //   "https://dspapi.dipaojiu.cn",
  // ];

  ///IM线路   ws://192.168.1.116:3102/sub
  static const String IM_NTF_ROUTE =
      DEBUG ? "ws://202.60.250.122:3102/sub" : "ws://goim.ysappc.me:80/sub";

  ///默认高斯模糊的值
  static const GAUSS_VALUE = 40;

  static bool isGameWallet = false;

  ///新增加的游戏相关
  static GameBalanceEntity gameBalanceEntity;
  static InAppWebViewController webView;
  static TransferResultEntity transferResultEntity;
  static int transferTax = 0;

  static bool isAnnounceAvCommentary = false;

  static bool isSystemConfigJump = false;

  /// 获取加密后的设备id验签
  static String getDevToken(String devId) {
    String a = "g24p5VJ4fJ";
    String b = "5P#at%Yu";
    String c = "ZPRwQuKl8YlVIr";
    String s = a + b + c + devId + a + b + c;
    var data = utf8.encode(s);
    var chiper = sha256.convert(data);
    return base64Encode(chiper.bytes);
    // return chiper.toString();
  }

  ///最近存储的支付宝账号
  static const LAST_A_ACCOUNT = "lastAliAcount";

  ///最近存储的银行卡账号
  static const LAST_BANK_ACCOUNT = "LAST_BANK_ACCOUNT";

  ///同城刷新index保存
  static const NEAR_BY_PAGE_NUMBER = "cityPageNumber";

  ///VIP弹窗提示规则
  static const VIP_SHOW_TIME = "vipShowTime";

  ///是否已经查看过上传规则
  static const VIEW_UPLOAD_RULE = "uploadRule";

  static String imei;
  static String macAddress;

  static String lfCheatGuide;

  static List<AnnounceInfoBean> announceInfoBeanList = [];

  static List<AnnouncementEntity> announcesMarqueeList = [];

  static List<OfficeConfigList> officeConfigLists = [];

  static bool isNakeChatCoin = false;

  static bool isSouYe = true;

  static List<TabsTagData> homeDataTags = [];
  static List<TabsTagData> communityDataTags = [];
  static List<TabsTagData> deepWeb = [];
  static AnWangVipCard anWangVipCard;
  static int sendMsgPrice = 0;
  static List<String> homeVideType = ["最新更新", "本周最热", "最多观看", "十分钟以上"];
  static List<String> communityVideType = ["推荐", "最新", "最热", "精华", "视频"];
  static TagsLiaoBaData tagsLiaoBaData;

  static List<String> videoId = [];

  static Map<String, bool> followVideos = new Map();

  static Map<int, bool> followBlogger = new Map();

  static Map<String, bool> likeVideos = new Map();

  static Map<String, int> forwardVideoCount = new Map();

  static List<int> rewardMoney = [];
  static List<int> releaseMoney = [];
  static List<UserAwards> userAwards = [];
  static List<ProductBenefits> productBenefits = [];
  static List<PopsBean> pops = [];
  static bool hideEye = false;
  static List<VideoModel> hotPush = [];
  static List<QuickSearch> quickSearch = [];
  static int searchIndex = 0;
  static int hotPushIndex = 0;
  static String aiUndressPrice;
  static QuickSearch randomSearch() {
    searchIndex = Random().nextInt(1000);
    if (quickSearch.isNotEmpty == true) {
      if (quickSearch.length == 1) {
        return quickSearch.first;
      } else {
        int length = quickSearch.length;
        int index = searchIndex % length;
        searchIndex++;
        return quickSearch[index];
      }
    }
    return null;
  }

  static List<VideoModel> randomHotVideo() {
    hotPushIndex = Random().nextInt(1000);
    List<VideoModel> arr = [];
    if (hotPush.isNotEmpty == true) {
      if (hotPush.length <= 2) {
        arr.addAll(hotPush);
      } else {
        int length = hotPush.length;
        int oneIndex = hotPushIndex % length;
        hotPushIndex++;
        int twoIndex = hotPushIndex % length;
        hotPushIndex++;
        arr.add(hotPush[oneIndex]);
        arr.add(hotPush[twoIndex]);
      }
    }
    return arr;
  }

  static AdsInfoBean splashAds;

  ///单个视频拉起充值统计
  static VideoModel videoModel;
  static PayFormType payFromType; // 0 视频, 1 banner, 2签到提示  3 打赏提示,
  static int payBuyType; // 1 vip, 2 金币 （只有banner 会用到）

  static bool playGame = true;

  static bool isNewListRequest = false;

  static String isNewListRequestId;

  static GoldTicketList goldTicketList;

  ///
  static String groupTomato = "";

  ///
  static String groupTelegram = "";

  static String selectCity;
  static bool hasVideoAd = false; // 视频详情 广告关闭状态（广告状态，不能全屏）
  static bool followNewsStatus = false; //关注 的小红点
  static bool messageNewsStatus = false; // 我的 的小红点
  static bool autoPlayVoiceClose = true; //自动播放列表声音开关
  static NewMessageTip newMessageTip;
  static List<String> POST_TAG_RANDOM = [];
  static List<LinearGradient> gradientList = [
    // LinearGradient(
    //     colors: [
    //       Color.fromRGBO(211, 31, 234, 1),
    //       Color.fromRGBO(255, 74, 74, 1),
    //     ]
    // ),
    // LinearGradient(
    //     colors: [
    //       Color.fromRGBO(255, 0, 0, 1),
    //       Color.fromRGBO(255, 118, 0, 1),
    //     ]
    // ),
    // LinearGradient(
    //     colors: [
    //       Color.fromRGBO(31, 31, 234, 1),
    //       Color.fromRGBO(31, 31, 234, 1),
    //     ]
    // ),
    // LinearGradient(
    //     colors: [
    //       Color.fromRGBO(232, 79, 79, 1),
    //       Color.fromRGBO(232, 79, 79, 1),
    //     ]
    // ),
    // LinearGradient(
    //     colors: [
    //       Color.fromRGBO(117, 31, 234, 1),
    //       Color.fromRGBO(117, 31, 234, 1),
    //     ]
    // ),
    // LinearGradient(
    //     colors: [
    //       Color.fromRGBO(255, 36, 179, 1),
    //       Color.fromRGBO(222, 29, 43, 1),
    //     ]
    // ),
    LinearGradient(colors: [
      AppColors.primaryTextColor,
      AppColors.primaryTextColor,
    ]),
  ];
}

enum PayFormType {
  video,
  banner,
  sign,
  dashang,
  user,
}
