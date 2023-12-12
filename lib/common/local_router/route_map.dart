import 'dart:core';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/new_page/recharge/recharge_vip_page.dart';
import 'package:flutter_app/page/account_qrcode/page.dart';
import 'package:flutter_app/page/audio_novel_page/page.dart';
import 'package:flutter_app/page/city/city_select/page.dart';
import 'package:flutter_app/page/city/city_video/page.dart';
import 'package:flutter_app/page/city/nearby/page.dart';
import 'package:flutter_app/page/fuli_guangchang/fu_li_guang_chang_page.dart';
import 'package:flutter_app/page/game_page/game_page_page.dart';
import 'package:flutter_app/page/game_page/game_rules_page/page.dart';
import 'package:flutter_app/page/game_wallet/wallet_main/page.dart';
import 'package:flutter_app/page/home/AVCommentary/a_v_commentary_page.dart';
import 'package:flutter_app/page/home/discovery_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/audiobook_more_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/audiobook_record_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/voice_anchor_info_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/voice_anchor_list_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/novel_search_page/novel_search_result_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/novel_search_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/passion_novel_page/av_commentary_recording_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/passion_novel_page/novel_player_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/passion_novel_page/page.dart';
import 'package:flutter_app/page/home/discovery_tab_page/passion_novel_page/passion_recording_page/page.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video/page.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/film_video_introduction/page.dart';
import 'package:flutter_app/page/home/film_tv/film_tv_video_detail/page.dart';
import 'package:flutter_app/page/home/film_tv/page.dart';
import 'package:flutter_app/page/home/mine/mine_follow_page/page.dart';
import 'package:flutter_app/page/home/mine/page.dart';
import 'package:flutter_app/page/home/mine/reward_log_page/page.dart';
import 'package:flutter_app/page/home/msg/comment/page.dart';
import 'package:flutter_app/page/home/msg/fans/page.dart';
import 'package:flutter_app/page/home/msg/laud/page.dart';
import 'package:flutter_app/page/home/msg/page.dart';
import 'package:flutter_app/page/home/msg/system_message/page.dart';
import 'package:flutter_app/page/home/page.dart';
import 'package:flutter_app/page/home/post/page/pay_post/page.dart';
import 'package:flutter_app/page/home/yue_pao_page/nake_chat_report_page/page.dart';
import 'package:flutter_app/page/home/yue_pao_page/recording_page/page.dart';
import 'package:flutter_app/page/home/yue_pao_page/yue_pao_details_page/page.dart';
import 'package:flutter_app/page/home/yue_pao_page/yue_pao_details_page/yue_pao_banner_page/page.dart';
import 'package:flutter_app/page/home/yue_pao_page/yue_pao_details_page/yue_pao_verification_page/page.dart';
import 'package:flutter_app/page/home/yue_pao_page/yue_pao_report_page/page.dart';
import 'package:flutter_app/page/home/yue_pao_page/yue_pao_search_page/page.dart';
import 'package:flutter_app/page/home/yue_pao_page/yue_pao_select_city_page/page.dart';
import 'package:flutter_app/page/publish/makeVideo/make_video_page.dart';
import 'package:flutter_app/page/publish/publish_help_page/page.dart';
import 'package:flutter_app/page/publish/works_manager/page.dart';
import 'package:flutter_app/page/search/search_page/page.dart';
import 'package:flutter_app/page/search/search_result_page/page.dart';
import 'package:flutter_app/page/search/search_tag/page.dart';
import 'package:flutter_app/page/setting/Feedback_page/page.dart';
import 'package:flutter_app/page/setting/account_safe/page.dart';
import 'package:flutter_app/page/setting/initial_bind_phone/binding_phone_success/page.dart';
import 'package:flutter_app/page/setting/initial_bind_phone/page.dart';
import 'package:flutter_app/page/setting/mobile_login/page.dart';
import 'package:flutter_app/page/setting/my_download/page.dart';
import 'package:flutter_app/page/setting/my_favorite/page.dart';
import 'package:flutter_app/page/setting/rebind_phone/page.dart';
import 'package:flutter_app/page/setting/setting_main/page.dart';
import 'package:flutter_app/page/setting/switch_account/page.dart';
import 'package:flutter_app/page/splash/no_net_page/page.dart';
import 'package:flutter_app/page/splash/page.dart';
import 'package:flutter_app/page/tag/liaoba_tag_detail/page.dart';
import 'package:flutter_app/page/tag/special_topic/page.dart';
import 'package:flutter_app/page/tag/tag_home/page.dart';
import 'package:flutter_app/page/user/about_app/page.dart';
import 'package:flutter_app/page/user/boutique_app/page.dart';
import 'package:flutter_app/page/user/edit_user_info/edit_nick/page.dart';
import 'package:flutter_app/page/user/edit_user_info/edit_summary/page.dart';
import 'package:flutter_app/page/user/edit_user_info/page.dart';
import 'package:flutter_app/page/user/edit_user_info/recover_account/page.dart';
import 'package:flutter_app/page/user/edit_user_info/recover_account/recover_mobile/page.dart';
import 'package:flutter_app/page/user/edit_user_info/view_avatar/page.dart';
import 'package:flutter_app/page/user/history_records/page.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/page/user/member_centre_page/vip/page.dart';
import 'package:flutter_app/page/user/my_certification/page.dart';
import 'package:flutter_app/page/user/my_purchases/page.dart';
import 'package:flutter_app/page/user/official_community/page.dart';
import 'package:flutter_app/page/user/offline_cache/page.dart';
import 'package:flutter_app/page/user/personal_card/page.dart';
import 'package:flutter_app/page/user/promotion_record/page.dart';
import 'package:flutter_app/page/user/purchase_detail/page.dart';
import 'package:flutter_app/page/user/upgrade_member_page/page.dart';
import 'package:flutter_app/page/user/video_user_center/page.dart';
import 'package:flutter_app/page/user/wish_list/page.dart';
import 'package:flutter_app/page/user/wish_list/wish_details/page.dart';
import 'package:flutter_app/page/user/wish_list/wish_question/page.dart';
import 'package:flutter_app/page/video/post_publish/page.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/upload_rule/page.dart';
import 'package:flutter_app/page/video/video_publish/page.dart';
import 'package:flutter_app/page/video/video_record/page.dart';
import 'package:flutter_app/page/wallet/ali_list/page.dart';
import 'package:flutter_app/page/wallet/bank_card_list/page.dart';
import 'package:flutter_app/page/wallet/detail_page/page.dart';
import 'package:flutter_app/page/wallet/game_detail_page/page.dart';
import 'package:flutter_app/page/wallet/game_withdraw/page.dart';
import 'package:flutter_app/page/wallet/mine_bill/page/page.dart';
import 'package:flutter_app/page/wallet/my_agent/agent_record_page/page.dart';
import 'package:flutter_app/page/wallet/my_agent/gamePromotion_page/gameIncomeRecord_page/page.dart';
import 'package:flutter_app/page/wallet/my_agent/page.dart';
import 'package:flutter_app/page/wallet/my_agent/promote_home_page/page.dart';
import 'package:flutter_app/page/wallet/my_income/page.dart';
import 'package:flutter_app/page/wallet/revenue_center/page.dart';
import 'package:flutter_app/page/wallet/wallet_main/page.dart';
import 'package:flutter_app/page/wallet/withdraw/page.dart';
import 'package:flutter_app/page/web/h5plugin/page.dart';
import 'package:flutter_app/weibo_page/community_recommend/hot_blogger/hot_blogger_page.dart';
import 'package:flutter_app/weibo_page/community_recommend/hot_video/hot_video_detail_page.dart';
import 'package:flutter_app/weibo_page/extension_setting/extension_setting_page.dart';

///启动页
const PAGE_SPLASH = "splash_page";
const PAGE_MY_INCOME = "my_income_page";
const PAGE_WITHDRAW = "withdraw_page";
const PAGE_WITHDRAW_GAME = "withdraw_page_game";
const PAGE_BANKCARD_LIST = "bank_card_list";

const PAGE_RECHARGE_HISTORY = "recharge_history";
const PAGE_MY_BILL = "my_bill";
const PAGE_WITHDRAW_BANKCARD = "bank_withdraw";
const PAGE_WITHDRAW_DETAIL = "money_detail";
const PAGE_WITHDRAW_GAME_DETAIL = "game_money_detail";

const PAGE_WEB = "h5_page";
const PAGE_VIDEO_USER_CENTER = "video_user_center";
const PURCHASE_DETAIL = "purchase_detail_page";
const PAGE_INITIAL_BIND_PHONE = "init_bind_phone_page";
const PAGE_MOBILE_LOGIN = "mobile_login_page";
const PAGE_SWITCH_ACCOUNT = "switch_account_page";
const PAGE_REBIND_PHONE = "rebind_phone_page";
const PAGE_ACCOUNT_QR_CODE = 'account_qrcode';
const PAGE_MINE = "page_mine";
const PAGE_SETTING = "setting_page";
const PAGE_ACCOUNT_SAFE = "account_safe_page";
const PAGE_HOME = "home_page";
const PAGE_ALI_LIST = "ali_list";
// 激情小说页面
const PAGE_PASSION_NOVEL_LIST = "passion_novel_list";
const PAGE_EDIT_INFO = "edit_info";
const PAGE_PERSONAL_CARD = "personal_card";
const GAME_RULES = "game_rules";
const PAGE_PROMOTE_HOME = "promote_home";
const PAGE_MY_FAVORITE = "my_favorite";
const PAGE_PROMOTION_RECORD = "promotion_record";
const PAGE_VIEW_AVATAR = "view_avatar";
const PAGE_UPLOAD_RULE = "upload_rule";
const PAGE_MY_DOWNLOAD = "my_download";
const PAGE_NO_NET = "no_net";

///标签页面
const PAGE_TAG = "tag_page";

///聊吧标签页面
const PAGE_TAG_LIAOBA = "tag_page_liaoba";

const PAGE_SPECIAL = "special_top";

///评论列表界面
const COMMENT_LIST_PAGE = "comment_list_page";

///视频
const SUB_PLAY_LIST = "sub_video_play";

///视频录制
const PAGE_VIDEO_RECORDER = "video_recorder";

///视频发布

///上传与录制分页
const VIDEO_PUBLISH = 'video_publish';

///付费的帖子
const PAGE_PAY_POST = "post_post";

///有声小说页面
const AUDIO_NOVEL_PAGE = "audio_novel_page";

///推广界面
const PROMOTE_ROUND = "promote_round";

///视频发布界面
const PAGE_POST_PUBLISH = "post_publish";

const PAGE_FANS = "fans_page";
const PAGE_LAUD = "laud_page";
const PAGE_COMMENT = "comment_page";
const PAGE_SYSTEM_MESSAGE = "system_message_page";

/// 精选
const PAGE_HOT_LIST = "hot_list";
const PAGE_RANKING = "ranking";

///城市选择
const PAGE_CITY_SELECT = "switch_city";

///同城列表
const PAGE_NEARBY_LIST = "nearby_list";

///城市视频列表
const PAGE_CITY_VIDEO = "city_video";

///搜索页面
const PAGE_SEARCH = "search_page";

///搜索结果页面
const PAGE_SEARCH_RESULT = "search_result_page";

///发现
const PAGE_DISCOVERY = 'discovery_page';

///意见反馈页面
const PAGE_FEEDBACK = "feedback_page";
const PAGE_MINE_FOLLOW = "page_mine_follow";

/// 打赏列表
const REWARD_LOG_PAGE = "reward_log_page";

/// 消息界面
const MSG_PAGE = "msg_page";

/// 个人记录
const RECORDING_PAGE = "recording_page";

/// 约炮搜索页面
const YUE_PAO_SEARCH_PAGE = "yue_pao_search_page";

/// 约炮详情页面
const YUE_PAO_DETAILS_PAGE = "yue_pao_details_page";

/// 约炮举报页面
const YUEPAOREPORTPAGE = "yue_pao_report_page";

/// 裸聊举报页面
const NAKECHATREPORTPAGE = "nake_chat_report_page";

/// 约炮城市选择页
const YUE_PAO_SELECT_CITY_PAGE = 'yue_pao_select_city_page';

///推广收益记录
const PAGE_AGENT_RECORD = 'agent_record_page';
const PAGE_AGENT_GAME_RECORD = 'game_income_record_page';

/// 约炮banner点开视图
const YUE_PAO_BANNER_PAGE = 'yue_pao_banner_page';

/// 体验报告
const YUE_PAO_VERIFICATION_PAGE = 'yue_pao_verification_page';

/// 激情小说记录页面
const PASSION_RECORDING_PAGE = 'passion_recording_page';

const PAGE_NOVEL_PLAYER = 'novel_player_page';
const PAGE_VOICE_ANCHOR_LIST = 'voice_actors_list_page';
const PAGE_VOICE_ANCHOR_INFO = 'voice_actors_info_page';
const PAGE_AUDIOBOOK_MORE = 'audiobook_more_page';
const PAGE_AUDIOBOOK_RECORD = 'audiobook_record_page';
const PAGE_NOVEL_SEARCH = 'novel_search_page';
const PAGE_NOVEL_SEARCH_RESULT = 'novel_search_result_page';

/// 升级vip页面
const PAGE_UPGRADE_VIP = 'upgrade_vip_page';

///游戏页面
const PAGE_GAME = 'game_page';

///AV解说页面
const PAGE_AV_COMMENTARY = 'av_commentary_page';

///裸聊
const PAGE_NAKE_CHAT = 'nake_chat_page';

///AV解说页面记录页面
const AV_COMMENTARY_RECORDING_PAGE = 'av_commentary_recording_page';

const NAKE_CHAT_RECORDING_PAGE = 'nake_chat_recording_page';

const FU_LI_GUANG_CHANG_PAGE = 'welfare_plaza';

const YOU_HUi_JUAN_PAGE = 'youHuiJuan_page';

const GAME_WALLET = 'game_wallet';

///官方社群
const OFFICIAL_COMMUNIT = "official_community";

///精品应用
const BOUTIQUE_APP = "boutique_app";

///创作中心
const MAKE_VIDEO_PAGE = "make_video_page";

///我的认证
const MY_CERTIFICATION_PAGE = "my_certification_page";

///任务中心
const TASK_CENTER_PAGE = "task_center_page";

///任务详情
const MISSION_DETAILS_PAGE = "mission_details_page";

///关于app
const ABOUT_APP = "about_app";

///我的购买
const MY_PURCHASES_PAGE = "my_purchases_page";

///历史记录
const HISTORY_RECORDS_PAGE = "history_records_page";

///离线缓存
const OFFLINE_CACHE = "offline_cache_page";

///收益中心
const REVENUE_CENTER = "revenue_center_page";

///心愿工单
const WISH_LIST_PAGE = "wish_list_page";

///心愿工单-详情
const WISH_DETAILS_PAGE = "wish_details_page";

///绑定手机号成功UI
const BINDING_PHONE_SUCCESS = "binding_phone_success";

///稿件管理
const WORK_MANAGER_PAGE = "works_manager_page";

///常见问题
const PUBLISH_HELP_PAGE = "publish_help_page";

///账号找回
const RECOVER_ACCOUNT = "reconver_account_page";

///账号找回-手机号
const RECOVER_MOBILE = "reconver_mobile_page";

///长视频详情
const FILM_TV_VIDEO_DETAIL_PAGE = "film_tv_video_detail_page";

///简介
const FILM_VIDEO_INTRODUCTION = "film_video_introduction";

///修改昵称
const EDIT_NICKNAME = "edit_nickname";

///修改简介
const EDIT_SUMMARY = "edit_summary";

///愿望问题列表
const WISH_QUESTION_PAGE = "wish_question_page";

///长视频列表UI
const FILM_TV_VIDEO_PAGE = "film_television_video_page";

///会员UI
const RECHARGE_VIP_PAGE = "recharge_vip_page";

///视频列表
const FILM_TV_PAGE = "film_tv_page";

///推广设置页面
const EXTENSION_SETTING = "extension_setting";

///首页热门作品更多页面
const HOMEPAGE_HOT_VIDEO_DETAIL = "home_page_hot_video_detail";

///首页热门UP主更多页面
const HOMEPAGE_HOT_BLOGGER_DETAIL = "home_page_hot_blogger_detail";

// YuePaoBannerPage
Map routerMap = <String, Page<Object, dynamic>>{
  ///游戏钱包
  GAME_WALLET: GameWalletPage(),

  YUE_PAO_BANNER_PAGE: YuePaoBannerPage(),

  ///激情小说记录页面
  PASSION_RECORDING_PAGE: PassionRecordingPage(),

  ///AV解说记录页面
  AV_COMMENTARY_RECORDING_PAGE: AvCommentaryRecordingPage(),

  ///裸聊记录页面
  // NAKE_CHAT_RECORDING_PAGE: NakeChatRecordingPage(),

  /// 体验报告
  YUE_PAO_VERIFICATION_PAGE: YuePaoVerificationPage(),

  /// 无网络页面
  PAGE_NO_NET: NoNetPage(),

  ///约炮城市选择页
  YUE_PAO_SELECT_CITY_PAGE: YuePaoSelectCityPage(),

  ///约炮举报页面
  YUEPAOREPORTPAGE: YuePaoReportPage(),

  ///裸聊举报页面
  NAKECHATREPORTPAGE: NakeChatReportPage(),

  /// 约炮详情页面
  YUE_PAO_DETAILS_PAGE: YuePaoDetailsPage(),

  /// 约炮搜索页面
  YUE_PAO_SEARCH_PAGE: YuePaoSearchPage(),

  /// 约炮个人记录
  RECORDING_PAGE: RecordingPage(),

  /// 消息界面
  MSG_PAGE: MsgPage(),

  /// 我的关注
  PAGE_MINE_FOLLOW: MineFollowPage(),

  PAGE_DISCOVERY: DiscoveryPage(),


  ///钱包主页+充值
  PAGE_MY_INCOME: MyIncomePage(),

  ///我的收益
  PAGE_WITHDRAW: WithDrawPage(),

  ///游戏提现
  PAGE_WITHDRAW_GAME: GameWithDrawPage(),

  ///添加银行卡
  PAGE_BANKCARD_LIST: BankCardListPage(),

  ///我的账单
  PAGE_MY_BILL: MineBillPage(),

  ///提现明细
  PAGE_WITHDRAW_DETAIL: DetailPage(),

  ///游戏钱包提现明细
  PAGE_WITHDRAW_GAME_DETAIL: GameDetailPage(),

  /// 用户模块
  PAGE_SETTING: SettingPage(),

  ///设置中心
  PAGE_ACCOUNT_SAFE: AccountSafePage(),

  /// 我的下载页面
  PAGE_MY_DOWNLOAD: MyDownloadPage(),

  ///账户与安全
  PAGE_HOME: HomePage(),
  PAGE_PASSION_NOVEL_LIST: PassionNovelPage(),

  ///VIP购买
  PAGE_ALI_LIST: AliListPage(),
  PAGE_EDIT_INFO: EditUserInfoPage(),
  PURCHASE_DETAIL: PurchaseDetailPage(),
  PAGE_PERSONAL_CARD: PersonalCardPage(),

  ///代理页面
  PAGE_PROMOTE_HOME: PromoteHomePage(),

  ///游戏规则
  GAME_RULES: GameRulesPage(),

  ///推广说明
  PAGE_MY_FAVORITE: MyFavoritePage(),

  ///我的收藏
  PAGE_PROMOTION_RECORD: PromotionRecordPage(),

  ///推广记录
  PAGE_VIEW_AVATAR: ViewAvatarPage(),
  PAGE_UPLOAD_RULE: UploadRulePage(),
  PAGE_WEB: H5PluginPage(),

  ///点击头像进入用户页面
  PAGE_INITIAL_BIND_PHONE: InitialBindPhonePage(),
  PAGE_MOBILE_LOGIN: MobileLoginPage(),

  ///手机登录
  PAGE_SWITCH_ACCOUNT: SwitchAccountPage(),

  ///切换账号
  PAGE_REBIND_PHONE: RebindPhonePage(),

  ///重新绑定
  PAGE_ACCOUNT_QR_CODE: AccountQrCodePage(),

  ///用户中心
  PAGE_VIDEO_USER_CENTER: VideoUserCenterPage(),
  PAGE_MINE: MinePage(),

  /// 消息模块
  PAGE_FANS: FansPage(),
  PAGE_LAUD: LaudPage(),
  PAGE_COMMENT: CommentPage(),
  PAGE_SYSTEM_MESSAGE: SystemMessagePage(),

  ///视频模块
  PAGE_VIDEO_RECORDER: VideoRecordingPage(),

  ///标签模块
  PAGE_TAG: TagPage(),
  PAGE_TAG_LIAOBA: LiaoBaTagDetailPage(),
  PAGE_SPECIAL: SpecialTopicPage(),

  ///城市模块
  PAGE_CITY_SELECT: CitySelectPage(),
  PAGE_NEARBY_LIST: NearbyPage(),
  PAGE_CITY_VIDEO: CityVideoPage(),

  ///搜索模块
  ///其它模块
  PAGE_SPLASH: SplashPage(),

  SUB_PLAY_LIST: SubPlayListPage(),

  /// 打赏列表
  REWARD_LOG_PAGE: RewardLogPage(),

  ///视频图片上传
  VIDEO_PUBLISH: VideoAndPicturePublishPage(),
  PAGE_POST_PUBLISH: PostPublishPage(),

  PAGE_HOT_LIST: HotListPage(),

  PAGE_PAY_POST: PayPostPage(),

  PAGE_SEARCH: SearchPage(),
  PAGE_SEARCH_RESULT: SearchOldResultPage(),

  PAGE_FEEDBACK: FeedbackPage(),
  PAGE_AGENT_RECORD: AgentRecordPage(),
  PAGE_AGENT_GAME_RECORD: GameIncomeRecordPage(),
  PAGE_NOVEL_PLAYER: NovelPlayerPage(),
  PAGE_VOICE_ANCHOR_LIST: VoiceAnchorListPage(),

  PAGE_VOICE_ANCHOR_INFO: VoiceAnchorInfoPage(),
  PAGE_AUDIOBOOK_MORE: AudiobookMorePage(),
  AUDIO_NOVEL_PAGE: AudioNovelPage(),
  PAGE_AUDIOBOOK_RECORD: AudiobookRecordPage(),
  PAGE_NOVEL_SEARCH: NovelSearchPage(),
  PAGE_NOVEL_SEARCH_RESULT: NovelSearchResultPage(),
  PAGE_UPGRADE_VIP: UpgradeMemberPage(),

  PAGE_GAME: GamePagePage(),
  PAGE_AV_COMMENTARY: AVCommentaryPage(),
  //PAGE_NAKE_CHAT: NakeChatListPage(),

  FU_LI_GUANG_CHANG_PAGE: FuLiGuangChangPage(),

  OFFICIAL_COMMUNIT: OfficialCommunityPage(),

  BOUTIQUE_APP: BoutiqueAppPage(),
  MAKE_VIDEO_PAGE: MakeVideoPage(),
  MY_CERTIFICATION_PAGE: MyCertificationPage(),
  //
  // TASK_CENTER_PAGE: null,
  // MISSION_DETAILS_PAGE: null,

  ABOUT_APP: AboutAppPage(),

  MY_PURCHASES_PAGE: MyPurchasesPage(),

  HISTORY_RECORDS_PAGE: HistoryRecordsPage(),

  OFFLINE_CACHE: OfflineCachePage(),

  REVENUE_CENTER: RevenueCenterPage(),

  WISH_LIST_PAGE: WishlistPage(),

  WISH_DETAILS_PAGE: WishDetailsPage(),

  BINDING_PHONE_SUCCESS: BindingPhoneSuccessPage(),

  WORK_MANAGER_PAGE: WorksManagerPage(),

  PUBLISH_HELP_PAGE: PublishHelpPage(),

  RECOVER_ACCOUNT: RecoverAccountPage(),

  RECOVER_MOBILE: RecoverMobilePage(),

  FILM_TV_VIDEO_DETAIL_PAGE: FilmTvVideoDetailPage(),

  FILM_VIDEO_INTRODUCTION: FilmVideoIntroductionPage(),

  EDIT_NICKNAME: EditNickNamePage(),

  EDIT_SUMMARY: EditSummaryPage(),

  WISH_QUESTION_PAGE: WishQuestionPage(),

  FILM_TV_VIDEO_PAGE: FilmTelevisionVideoPage(),

  RECHARGE_VIP_PAGE: VIPPage(),

  FILM_TV_PAGE: FilmTelevisionPage(),

  EXTENSION_SETTING: ExtensionSettingPage(),

  HOMEPAGE_HOT_VIDEO_DETAIL: HotVideoDetailPage(),

  HOMEPAGE_HOT_BLOGGER_DETAIL: HotBloggerPage(),
};
