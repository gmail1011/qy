import 'package:flutter_app/model/domain_source_model.dart';

///地址数据
class Address {
  static const API_PREFIX = "api/app";

  ///M3U8视频加密字符
  static const SECRET_SUFFIX = "/vid/sec";

  static const H5_SUFFIX = "h5/app";

  ///判断iOS是进入本应用还是马甲包 tf包使用
  static const TI_BAO_url = [
    "https://ta.tv20lly.com",
    "https://tb.kkbok.me",
    "https://tc.kkbfons.com"
  ];

  /// 基本的path
  static String baseHost;

  /// 基本的path
  static String baseApiPath;

  ///h5地址
  static String h5Url;

  ///cdn地址，后台返回
  static String cdnAddress;

  ///cdn集合地址，后台返回，选线使用
  static List<DomainInfo> cdnAddressLists = [];
  static DomainInfo currentDomainInfo ;

  ///图片加载地址
  static String baseImagePath;

  ///官网地址
  static String baseGroupUrl;

  ///落地页地址
  static String groundURl;

  ///代理规则
  static String proxyRuleUrl;

  ///常见问题
  static String commonQuestion;

  /// 撩吧活动地址
  static String activityUrl;

  /// 落地页地址
  static String landUrl;

  /// 福利广场应用中心链接
  static String appCenterUrl;

  /// 邮箱
  static String groupEmail;

  ///商务合作
  static String businessCooperation;

  ///github上路线预留
  static const GITHUB_PATH =
      "https://raw.githubusercontent.com/JohnSnooow/bug-free-waffle/master/host.json";

  ///登录接口
  static const DEV_LOGIN = "/mine/login";

  ///视频播放地址后缀
  static const VIDEO_SUFFIX = "/vid/m3u8";

  ///获取二维码信息
  static const GET_QR_CODE_INFO = "/mine/certificate/qr";

  ///他人用户信息
  static const PERSONAL_INFO = "/user/info";

  ///钱包接口
  ///返回：string
  static const WALLET = "/mine/wallet";

  ///充值记录接口
  ///返回：string
  static const WALLET_RECHARGE_HISTORY = "/mine/rchg/order";

  ///充值接口
  ///返回：string
  static const WALLET_RECHARGE = "/mine/recharge";

  ///代充接口
  ///返回：string
  static const WALLET_PROXY_RECHARGE = "/daichong/takeChat";

  ///我的账单接口
  ///返回：string
  static const WALLET_BILL = "/mine/bills";

  ///绑定手机号接口 2.0.9->
  ///返回：string
  static const BIND_PHONE_NEW = "/mine/mobileBind";

  ///手机号登录
  static const MOBILE_LOGIN = "/mine/mobileLoginOnly";

  ///发送验证码接口
  ///返回：string
  static const SEND_SMS = "/sms/captcha";

  // ///分片上传视频接口
  // ///返回：string
  // static const UPLOAD_VIDEO = "/vid/uploadDotStream";

  // ///上传图片接口
  // ///返回：string
  // static const UPLOAD_IMAGE = "/vid/uploadStatic/batch";

  // ///批量图片上传接口
  // ///返回
  // static const UPLOAD_PICTURES = '/vid/uploadStatic/batch';

  ///检索标签接口
  ///返回：string
  // static const TAG_LIST = "/tag/list";

  ///检索标签接口
  ///返回：string
  static const TAG_RELATED_LIST = "/tag/related/list";

  ///创建标签接口
  ///返回：string
  // static const TAG_NEW = "/tag/add/new";

  ///视频发布接口
  ///返回：string
  // static const VIDEO_PUBLISH = "/vid/submit";

  ///我的收藏接口
  ///返回：string
  static const MY_FAVORITE = "/mine/collect/infoList";

  ///在线客服签名
  ///返回：string
  static const IM_SIGN = "/im/sign";

  ///im通知token
  static const IM_TOKEN = "/im/token";

  ///获取关注视频
  ///返回：string
  static const VIDEO_FOLLOW = "/follow/dynamics/list";

  ///关注用户
  static const FOLLOW = "/mine/follow";

  ///购买视频
  static const BUY_VIDEO = "/product/buy";

  ///查询标签对应的视频列表信息
  static const TAG_GET_VIDEO_LIST = "/mine/info?uid=0";

  ///线路检测
  static const PINE_CHECK = "/ping/check";

  ///远程配置信息获取
  static const REMOTE_CONFIG = "/ping/domain";

  ///查询标签详情
  static const String TAG_DETAIL = "/tag/info";

  ///搜索主页面接口
  /// = "search/index"
  // = "search/wonder/list"
  static const String SEARCH_HOME_API = '/search/index';

  ///发现精彩接口
  static const String SEARCH_FIND_API = '/search/wonder/list';

  ///发现精彩数据对应的视频数据接口
  static const String SEARCH_WONDER_API = '/wonder/vid/list';

  ///搜索分类----话题
  static const String SEARCH_TALK_API = '/search/list';

  ///搜索视频专区下级页面地址
  static const String SEARCH_TOPIC_API = '/tone/vid/list';

  ///搜索视频查看更多 ----详情页数据vid/hot/list
  static const String SEARCH_VID_HOT_API = '/vid/hot/list';

  ///搜索热榜查看更多--------rank/list
  static const String SEARCH_RANK_HOT_SEARCH_API = '/rank/hotsearch/list';

  ///查询标签列表
  static const String TAG_VIDEO_LIST = "/tag/vid/list";

  ///查询聊吧标签列表
  static const String TAG_VIDEO_LIST_LIAO_BA = "/vid/list";

  ///查询聊吧标签列表
  static const String TAG_VIDEO_LIST_LIAOBA = "/vid/section";

  ///收藏接口
  static const String COLLECT_URL = "/mine/collect";

  ///我的收益
  static const MY_INCOME_LIST = "/mine/income/works";

  ///支付宝列表
  static const ALI_PAY_ACCOUNT_LIST = "/mine/txnact/alipay/get";

  ///银行卡列表
  static const BANK_CARD_LIST = "/mine/txnact/bank/get";

  ///取消点赞
  static const CANCEL_LIKE = "/thumbsDown";

  ///点赞
  static const SEND_LIKE = "/thumbsUp";

  ///发表评论
  static const SEND_COMMENT = "/comment/send";

  ///获取评论列表
  static const COMMENT_LIST = "/comment/list";

  ///当前评论的评论列表
  static const CURRENT_COMMENT_LIST = "/comment/info";

  ///提现明细列表
  static const WITHDRAW_DETAILS = "/withdraw/order";

  ///收益明细列表
  static const INCOME_DETAILS = "/mine/iIncomes";

  ///添加支付宝账号
  static const ADD_ALI_PAY = "/mine/txnact/alipay/add";

  ///添加银行卡
  static const ADD_BANK_CARD = "/mine/txnact/yh/add";

  ///通过支付宝API解析银行卡号发卡行和银行卡类别、获取银行LOGO
  static const ALI_CCD_API =
      "https://ccdcapi.alipay.com/validateAndCacheCardInfo.json?_input_charset=utf-8&cardBinCheck=true&cardNo=";

  ///获取支付宝限额
  static const GET_AliPay_FEE = "/withdraw/type";

  ///获取银行卡限额
  static const GET_BankCard_FEE = "/withdraw/type";

  ///提现
  static const WITHDRAW = "/withdraw";

  /// 附近列表
  static const SAME_CITY_LIST = "/vid/location/list";

  ///获得城市详情
  static const CITY_DETAIL = "/vid/location/info";

  ///我的作品
  static const MINE_WORKS = "/mine/collection";

  ///合集列表
  static const MINE_WORKS_Unit_List = "/video_collection/list";

  ///合集视频列表
  static const MINE_WORKS_Unit_Video_List = "/video_collection/videoList";

  ///我的模块 - 新增合集
  static const MINE_WORKS_Unit_Add = "/video_collection/add";

  ///我的模块 - 新增合集视频
  static const MINE_WORKS_Unit_Video_Add = "/video_collection/addVideos";

  ///我的模块 - 新增合集视频
  static const MINE_WORKS_Unit_Video_Delete = "/video_collection/delVideos";
  ///我的模块 - 推广作品列表
  static const MINE_WORKS_Video_Pop = "/mine/videoPop";

  ///我的购买视频
  static const MINE_BUY_VIDEO = "/mine/buyVid";

  ///我的喜欢视频
  static const MINE_LIKE_VIDEO = "/mine/like";

  ///获取视频播放状态
  static const VIDEO_PLAY_STATUS = "/vid/user/count";

  ///专题
  static const SPECIAL_URL = "/tag/group";

  ///代理收益列表
  static const PROXY_INCOME = "/proxy/incomes";

  ///获取代理信息
  static const PROXY_INFO = "/proxy/info";

  ///推广记录
  static const PROXY_BIND_RECORD = "/userinvite/userlist";

  ///填写推广码
  static const PROXY_BIND = "/proxy/bind";

  ///用户收益推广信息
  static const USER_INCOME_INFO = "/mine/getAllIncome";

  ///用户账单列表
  static const USER_BILL_LIST = "/mine/zhangdan";

  ///删除银行卡
  static const USER_BANKCARD_DELETE = "/mine/txnact/del";

  ///自动定位
  static const AUTO_LOCATION = "/mine/autoLocate";

  ///发送视频记录
  static const VIDEO_RECORD = "/vid/play";

  ///获取粉丝列表
  static const FANS_LIST = "/follow/fans/list";

  ///消息
  static const NOTICE_LIST = "/inform/notice/list";

  ///消息分类
  static const NOTICE_TYPE_LIST = "/inform/preview";

  ///推荐关注
  static const RECOMMEND_USER_LIST = "/recommend/user/list";

  ///评论
  static const COMMENT_REPLY_LIST = "/comment/reply/list";

  ///赞
  static const LIKE_LIST = "/like/record/list";

  ///本地推送配置
  static const LOCAL_PUSH_CONFIG = "/push/conf/list";

  //==============热搜榜 begin==============

  ///获取-热搜榜-【热门话题】
  static const HOT_TOPIC_URL = "/hotspot/htag";

  ///获取-热搜榜-【人气榜单】
  static const HOT_POPULARITY_URL = "/hotspot/rank";

  ///获取-热搜榜-【今日最���视频】
  static const HOT_TODAY_HOTTEST_URL = "/hotspot/hotvid/list";

  ///获取-热搜榜-【���选专区】
  static const HOT_GOLD_COIN_AREA_URL = "/hotspot/area";

  ///获取-热搜榜-【发现精彩】
  static const FIND_WONDER_URL = "/hotspot/wonder/list";

  ///关注人列表
  static const FOLLOW_PEOPLE_LIST = "/follow/list";

  ///删除自己的作品
  static const DEL_WORK = "/vid/remove";

  ///兑换码
  static const EXCHANGE_CODE = "/code/exchange";

  ///点击广告
  static const AD_CLICK = "/ads/click";

  ///社区帖子接口
  static const COMMUNITY_LIST_TOPIC = "/vid/news/list";

  ///社区帖子不感兴趣接口
  static const COMMUNITY_NEWS_UNLIKE = "/vid/news/unlike";

  ///未登录时使用此进入客服
  static const IM_NO_ACCOUNT_SIGN = "/im/whiteSign";

  ///视频上传
  static const UPLOAD_VIDEO = "/vid/uploadDotJson";

  ///热门城市
  static const HOT_CITY_LIST = "/vid/location/hot";

  ///获取推广码
  static const MINE_TUI_GUANG = "/mine/inviteBind";

  ///提交推广码
  static const POST_TUI_GUANG = "/mine/inviteBind";

  ///查询推广码
  static const QUERY_TUI_GUANG = "/mine/inviter";

  ///查询聊吧标签配置
  static const QUERY_TAG_LIST = "/tag/conf/list";

  ///查询聊吧公告
  static const QUERY_ANNOUNCE = "/modules/announce";

  ///查询楼凤公告
  static const QUERY_ANNOUNCE_LONGFENG = "/loufeng/announce";

  ///查询聊吧顶部标签公告
  static const QUERY_TAGS_MARKS = "/modules/list";

  ///查询视频
  static const VIDEO_INFO = "/vid/info";

  ///用户账单列表
  static const MY_BILL_LIST = "/mine/zqzhangdan";

  ///任务中心
  static const MY_APP_TASK = "/task/list";

  ///官方社群-精品应用
  static const OFFICE_APP = "/official/list";

  ///我的认证
  static const MY_CERTIFICATION = "/mine/officialcert/submit";

  ///心愿工单列表
  static const DESIRE_LIST = "/desire/list";

  ///心愿工单详情-评论列表
  static const DESIRE_CMT_LIST = "/desire/cmt/list";

  ///发布心愿工单
  static const SUBMIT_DESIRE = "/desire/add";

  ///采纳心愿工单
  static const ADOPTION_DESIRE = "/desire/adoption";

  ///提现配置
  static const WITHDRAW_CONFIG = "/withdraw/cfg";

  ///发送验证码
  static const NOTIFICATION_SMS = "/notification/captcha";

  ///发表心愿工单评论
  static const SEND_WISH_COMMENT = "/comment/sendV2";

  ///博主主页获取打赏的人的头像
  static const GET_REWARD_AVATAR = "/mine/reward/log";

  ///获取我的认证状态
  static const GET_OFFICIALCERT_STATUS = "/mine/officialcert/get";

  ///我的心愿工单详情
  static const WISH_DETAIL = "/desire/info";

  ///推荐列表
  static const COMMUNITY_RECOMMENT_LIST = "/vid/community/list";

  /// 热门作品
  static const COMMUNITY_HOT_LIST = "/vid/community/hot/list";

  ///换一换列表
  static const RECOMMEND_USER_CHANGE_FUNC_LIST = "/recommend/user/rand/list";

  ///删除消息
  static const DEL_MSG_SESSION = "/msg/session/del";

  ///消息数量
  static const MSG_COUNT = "/msg/dynamic/noRedNum";


  static String token;

}
