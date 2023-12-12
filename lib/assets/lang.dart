import 'package:sprintf/sprintf.dart';

/// note-this
/// 格式化参数 %d %s 用STR结尾 XXX_STR = "干了%个月";
/// 非单词 提示:用TIP(单行)/TIPS(多行) 结尾
//�
///項目文本管理
class Lang {
  static const COMMUNITY_TABS = ['关注', '推荐'];
  static const COMMUNITY_HOT_LIST_TABS = ['大事件', '争议榜', '周榜', '月榜', '黑马榜'];
  static const COMMUNITY_TABS_TOPIC = ['抖音', '图文', '影视'];
  static const SEARCH_RESULT = ['抖音', '图文', '影视', '用户', '话题'];
  static const BLOGGER_TABS = ['抖音', '图文', '影视'];
  static const BLOGGER_TABS_COLLECT = ['抖音', '图文', '影视', '合集'];
  static const BLOGGER_TABS_TWO = ['抖音', '图文'];
  static const More_Video_TABS = ['最新', '最热'];
  static const AI_TABS = ['AI脱衣', "AI换脸"];
  static const SWITCH_TABS = [
    '推荐',
  ];

  static const CITY_TABS = [
    '抖音',
    '图文',
    '影视',
  ];

  static const YUE_PAO_TWO_TABS = ['推薦', '最新'];
  static const YUE_PAO_TABS = ['解鎖專區', '認證專區', '赔付专区', '裸聊专区'];
  static const POPULAR_NOVELS = '熱門小說';
  static const CONTACT_MSG =
      '\n提示1：若对方要求定金，提高警觉！付款前一定查看「防骗指南」。\n提示2：搜索QQ后只点击查找人添加，底下群千万别加，都是骗子。\n提示3：请把所有联系方式都尝试一遍，全无效再举报。';
  static const CONDITION = '至少需要4張圖片';
  static const SUB_SUCCESS = '成功提交驗證';
  static const VERIFICATION_REPORT_MSG1 =
      '1.必須保證真實有效，請謹慎對待；\n2.照片必須包含支付憑證截圖；\n3.建議聊天截圖，妹子照片，環境照片等；\n4.至少4張照片；\n5.不滿足以上條件不予審核通過';
  static const VERIFICATION_REPORT_MSG = '報告要求';
  static const VERIFICATION_REPORT = '體驗報告';
  static const COLLECTION_RECORD = '收藏記錄';
  static const BUY_HISTORY = '购买記錄';
  static const RESERVE_HISTORY = '預約記錄';
  static const YUE_PAO_MSG = '籬笆盛開三徑滿，幽香偏與性相宜。';
  static const YUE_PAO_MSG1 = '妹子、經紀人招募，兼職萬元絕不是夢！\n千萬流量平台扶持，輕輕鬆鬆在家賺錢！';
  static const YUE_PAO_MSG2 = '請輸入具體原因';
  static const YUE_PAO_MSG3 = '無效聯繫方式';
  static const YUE_PAO_MSG4 = '舉報騙子，請提供圖片證明';
  static const YUE_PAO_MSG5 = '已隱藏，';
  static const YUE_PAO_MSG6 = '金幣解鎖可免費看';
  static const YUE_PAO_MSG8 = '楼凤详情';
  static const YUE_PAO_MSG9 = '親，解鎖該資源後才可以投訴該帖喲〜';
  static const YUE_PAO_MSG10 = '親，解鎖該資源後才可以驗證該帖喲〜';
  static const YUE_PAO_MSG11 = '可詳細描述MM個人情況，MM質量，服務過程（尤其是妹妹的特色）等，描述越詳細，用戶信任感可以。（不限字數';
  static const YUE_PAO_MSG7 =
      '凡是有要求路費/定金/保證金/照片驗證/視頻驗證等任何提前發現的行為，千萬不要上當。同時也請注意仙人跳，在尋歡前不要露富和帶過於貴重隨身物品。本APP為分享信息並不對尋歡經歷負責，碰到有問題的信息，請及時舉報給我們刪除信息。';
  static const YUE_PAO_MAP1 = '樓鳳兼職';
  static const YUE_PAO_MAP2 = '廣告';
  static const SUBMISSION = '確認提交';
  static const CON_MAN = '騙子';
  static const PHOTO = '照片';
  static const I_KNOW = '我知道了';
  static const KNOW = '知道了';
  static const WARM_TIPS = '溫馨提示';
  static const REPORT_MSG = '我要舉報';
  static const EQUIPMENT = '環境設備';
  static const SERVICE_STAR = '服務星級';
  static const FACE_VALUE = '妹妹顏值';
  static const MINUTE = '滿分';
  static const SERVICE_ITEMS = '服務項目';
  static const AREA2 = '所屬地區';
  static const BUSINESS_HOURS = '營業時間';
  static const PRICE_LIST = '價格一覽';
  static const SISTERS_AGE = '妹妹年齡';
  static const NUMBER_OF_SISTERS = '妹妹數量';
  static const DETAILS_MSG = '詳情介紹';
  static const RATING = '綜合評分';
  static const BASIC_MSG = '基本信息';
  static const CONTACT_DETAILS = '联系方式';
  static const OFFICIAL_DOWNLOAD = '官方下载';
  static const ACCOUNT_CODE = '查看账号凭证';
  static const CLICK_INSTALL = '点击安裝';
  static const NO_VIP = '非会员';
  static const SUBMIT = '提交';
  static const PROMOTION_REWARD = '推广奖励';
  static const APP_NAME = "91猎奇";
  static const GET_REWARD = "获赏";
  static const BOUGHT = "已购买";
  static const BUY_SUCCESS = '购买成功';
  static const MINE_FOLLOW = '关注';
  static const NO_MINE_FOLLOW = '取消关注';
  static const REWARD = ' 打赏';
  static const REWARD_YOU = '打赏您的：';
  static const REWARD_DATE = '打赏日期：';
  static const GET_CUSTOMER_INFO_FAILED = '获取客服信息失敗';
  static const REVIEW_HINT1 = "您还未通过审核";
  static const REVIEW_HINT2 = "您未通过审核";
  static const CHECK_RULE = "审核规则";
  static const WORD_BUBBLE = '气泡';
  static const PARSE_DATE_ERROR = '数据返回异常';
  static const CANCEL = "取消";
  static const BACKGROUND_UPLOADING_TIP = '正在后台上传';
  static const FEEDBACK = "意見反饋";
  static const LEAVE_A_MESSAGE1 = '請輸入打賞金額';
  static const LEAVE_A_MESSAGE2 = '附上你想說的話';
  static const WORD_REWARD = '賞';
  static const TOPUP_TO_TEST = '在線充值';
  static const REWARD_SUCCESS = '打赏成功';
  static const OPT_SUCCESS = '操作成功';
  static const OPT_FAIL = '操作失败';
  static const NO_SUMMARY_TIP = "我沒有个性所以不签名";
  static const WALLET_REMAINING = "錢包剩餘";
  static const HOMEPAGE = "个人主页";
  static const ADDITIONAL_MESSAGE = '附加消息：';
  static const NEW_USERS_MSG1 = '新用戶24小時內購卡限時打折';
  static const NOVEL_TABS = ['視頻專區', '裸聊专区', 'AV解說', '激情小說', '有聲小說'];

  static const FU_LI_TABS = [
    '簽到',
    '任務',
  ];

  static const YOU_HUi_JUAN_TABS = ["已獲得", "已使用", "已過期"];

  ///錢包
  static const MY_INCOME = "我的收益";
  static const INCOME_BALANCE = "收益餘額";
  static const WITHDRAW = "提现";
  static const TRANSFER = "劃轉";
  static const BILL = "账单";
  static const DETAILS1 = '詳情';
  static const HISTORICAL_INCOME_DETAILS = "歷史收益詳情（近3個月）";
  static const INCOME_TOTAL = "總計: ";
  static const CASH_WITHDRAWAL_DETAILS = "提現明細";
  static const CHOOSE_WITHDRAWAL_METHOD = "選擇提現方式";
  static const ALI_PAY = "支付寶";
  static const BANK_CARD = "銀行卡";
  static const CASH_WITHDRAWAL_INSTRUCTIONS = "提现说明";
  static const WALLET = "我的錢包";
  static const GAMEWALLET = "游戏钱包";
  static const VIP_FOREVER = "永久";
  static const MY_FAVORITE = "我的收藏";
  static const MY_DOWNLOAD = '我的下載';
  static const WITHDRAWAL_INSTRUCTIONS_GOLD =
      "1、每次提現現金最低%s元起，單筆提現最大%s元，且為整數\n2、每次提現收取%s%手續費\n3、收款賬戶卡號和姓名請如實填寫，否則不能成功到賬，到賬時間為24小時內。\n4、USDT提现金额单位为人民币，非USDT数量。\n5、申请提现后请随时关注收款账户进款通知，长时间未到账，请及时联系客服";
  static const WITHDRAWAL_INSTRUCTIONS =
      "1、每次提現現金最低%s元起，單筆提現最大%s元，且為整數\n2、每次提現收取%s%手續費\n3、收款賬戶卡號和姓名請如實填寫，否則不能成功到賬，到賬時間為72小時內。\n4、USDT提现金额单位为人民币，非USDT数量。\n5、申请提现后请随时关注收款账户进款通知，长时间未到账，请及时联系客服";
  static const ALIPAY_WITHDRAW = "支付宝账号";
  static const BANKCARD_WITHDRAW = "银行卡提现";
  static const USDT_WITHDRAW = "USDT提现";
  static const BANKCARD_ACCOUNT = "银行卡账号";
  static const WITHDRAWAL_AMOUNT = "提现金额";
  static const WITHDRAW_DETAILS = "提现明细";
  static const RECHARGE_DETAILS = "充值記錄";
  static const COMMON_QA = "常見問題";
  static const WALLET_BALANCE = "钱包余额";
  static const GAME_WALLET_BALANCE = "游戏余额";
  static const WALLET_MSG = "聽說打賞的人，都會遇到真愛";
  static const WALLET_ALL_GLOD = '「充值金幣%s，收益金幣%s」';
  static const RECHARGE = "充值";
  static const SHOULD_PAY = "需支付";
  static const CONFIRM_PAY = "确认支付";
  static const MY_BILL = "账单明细";
  static const GOLD_COIN = "金币";
  static const GAME_GOLD_COIN = "游戏币";
  static const CONTACT_CUSTOM_SERVICE = "联系客服";
  static const COPY_ORDER_NUMBER = "复制订单号";
  static const ORDER_NUMBER = "订单编号";
  static const ONLINE_CUSTOM_SERVICE = "在线客服";
  static const ADD_ALIPAY_ACCOUNT = "添加支付寶賬號";
  static const TAB_INFO_SIGN = '資料';
  static const TAB_ACTIVITY_SIGN = '動態';
  static const NAME = "姓名：";
  static const USER_NAME = "用戶名";
  static const ALI_PAY_ACCOUNT = "賬號：";
  static const SURE = "确定";
  static const SURE_ADD = "確認添加";
  static const ADD_BANKCARD = "新增銀行卡";
  static const CARD_HOLDER = "持卡人：";
  static const CARD_NUMBER = "卡號：";

  static const BANKCARD_NUMBER = "銀行卡號";
  static const ACCOUNT_TYPE_A = "支付寶帳號";
  static const GRAPHIC = "发布图文";
  static const ACCOUNT = "賬號：";
  static const NETWORK_SETTING = "設置網絡";
  static const RECONNECT = "重新鏈接";
  static const AMOUNT = "金額：";
  static const ONE_GOLD_COINS = "1 元 = 10 金幣";
  static const ALL = "全部";
  static const SELECTED_ALI_PAY = "選擇到賬支付寶";
  static const ALI_PAY_TIM = "請留意支付寶到賬時間";
  static const WITH_IN_HOURS_GAME = "24小時內";
  static const WITH_IN_HOURS = "72小時內";
  static const SELECTED_BANKCARD = "選擇到賬銀行卡";
  static const BANKCARD_TIME = "請留意各銀行到賬時間";
  static const AMOUNT_IS_BELOW = "金額低於限額最低值";
  static const EDIT_AMOUNT = "請輸入提現金額";
  static const HANDLING_FEE = "手續費：";
  static const SINGLE_LIMIT = "單筆限額¥";
  static const ACCOUNT_IS_INCORRECT = "賬號不正確";
  static const ACCOUNT_CAN_NOT_EMPTY = "輸入正確的賬號信息";
  static const USER_CAN_NOT_EMPTY = "用戶名不能為空";
  static const NO_WITHDRAW_RECORD = "暫無提現明細";
  static const NO_RECHARGE_HISTORY = "暫無充值記錄";
  static const NO_BUY_BILL = "暫無訂單";
  static const ARRIVE_HOURS = "24小時內到賬";
  static const NO_INCOME = "暫無收益";
  static const PAY_LINK_ERROR = "支付鏈接異常";
  static const BUY_VIDEO = "购买視頻";
  static const WITHDRAW_FAIL_REFUND = "提現失敗退款";
  static const VIDEO_SALE_INCOME = "作品收益";
  static const ACTIVITY_INCOME = "活動收益";
  static const REFUND = "退款";
  static const INCOME = "收入";
  static const BUY = "购买";
  static const WE_CHAT_PAY = "微信支付";
  static const BANKCARD = "銀行卡";
  static const PROXY_RECHARGE = "代理充值";
  static const PROXY_RECHARGE_URL_NULL = "代充為空";
  static const PROXY_RECHARGE_PARAMETER_ERROR = "代充參數錯誤";
  static const RECHARGE_HINT = "购买金币";
  static const RECHARGE_GAME_HINT = "购买游戏币";
  static const PAY_TYPE = "支付方式";
  static const PLEASE_ADD_ALI_PAY_COUNT = '請添加支付寶賬號';
  static const PLEASE_ADD_BANK_COUNT = '請添加银行账号';
  static const WITH_IN_24_HOURS = '24小時內';
  static const PLEASE_WITHDRAW_AMOUNT = '請輸入提現金額';
  static const PAY_FOR_ALI_PAY = '提現到支付寶';
  static const PAY_FOR_BANK = '提現到銀行卡';
  static const PAY_FOR_USDT = '提現到USDT';
  static const WITHDRAW_TIP1 = '10金幣 = 1元';
  static const WITH_ARRIVE_TIP = '到賬:';
  static const INPUT_MONEY_TIP = '提现金额大于自身拥有金额！';

  ///VIP會員
  static const NO_TEXT = "暂无";
  static const PLATINUM_CARD = "铂金卡";
  static const DIAMOND_CARD = "钻石卡";
  static const VIP_CARD = "至尊卡";
  static const CONFIRM_CONSUMPTION = "确认消费";
  static const GOLD_COIN_PURCHASE = "金币购买";
  static const BUY_TEXT = "已购 ";
  static const INSUFFICIENT_GOLD_COINS = "你的金币余额不足，确认充值";
  static const AMOUNT_IS_TOO_LARGE = "充值金额过大，请分批自行充值！";
  static const VIP_MEMBER = "VIP会员";
  static const PURCHASE_DETAILS = "购买明细";
  static const BALANCE = " 余额:";
  static const VIP_EXPIRY_TIME = "VIP到期时间 ";
  static const MEMBER_PURCHASE = "会员专享特权";
  static const EXCLUSIVE_OFFER = '独家特供';
  static const PUFF_ARISTOCRACY = '91猎奇贵族';
  static const FULL_SITE_VIDEO = '全站视频';
  static const EXCLUSIVE_CONTENT = '独家內容';
  static const BROWSE_BYS = '任意浏览';
  static const BROWSE = '浏览';
  static const UNLIMITED_VIEWINGS = '无限观看';
  static const MAKE_AN_APPOINTMENT = '想約就約';
  static const GOLD_PURCHASE = "金币购买";
  static const PAY_ABLE = "需支付：";
  static const NOT_BUY_VIP = "你还没有购买VIP";
  static const COPY_ORDER_NUMBER_SUCCESS = "复制订单号成功";
  static const BUY_PAY = "购买-已支付";
  static const MONTHLY_MEMBER = "月卡";
  static const QUARTER_MEMBER = "季卡";
  static const ANNUAL_MEMBER = "年卡";
  static const UNLIMITED_VIEWING = "天無限觀看";
  static const BUY_VIP_FAILED = "购买VIP會員失敗，請稍後重試";
  static const PRIVILEGES_MEMBER = "會員專享特權";
  static const WALLET_BALANCE_TEXT = "  钱包余额: ";
  static const ADULT_THEATER = "成人影院";
  static const YEAH_NOBLE = "撩吧貴族";
  static const FULL_VIDEO = "全站視頻";
  static const CHAT_PERSONALS = "聊天交友";
  static const WATCH_FOR_FREE = "免費觀看";
  static const BROWSE_BY = "任意瀏覽";
  static const UNLIMITED_VIEW = "無限觀看";
  static const MAKE_APPOINTMENT = "想約就約";
  static const GOLD_COINS = "元充值金幣";
  static const REBATE_INCOME = "業績轉換：+";

  /// VIP购买彈窗
  static const VIP_TITLE1 = "免費升級VIP";
  static const VIP_TITLE2 = "成功推廣壹人";
  static const VIP_TITLE3 = "送三天基礎VIP無限觀看";
  static const VIP_TITLE4 = "可無限疊加VIP天數";

  static const UPLOADING_TIP = '正在上传';
  static const UPLOAD_FAILED_TIP = '上传失败';

  /// 視頻
  static const PUBLISH = "發佈";
  static const CONFIRM_PUBLISH = "確認發送";
  static const ADD_LOCATION = "添加位置";
  static const CONFIRM = '確認';
  static const VIDEO_LEAVE_TIP = '離開當前頁面將清除上传信息，是否確認離開？';
  static const SHOOT = '拍攝';
  static const SET_PRICE = "設置價格";
  static const SET_FREE_DURATION = "設置免費時長";
  static const VIDEO_PUBLISH_CONTENT_TIP = '暗芳驅迫興難禁，洞口陽春淺復，主人來兩句嘛！～';
  static const NOT_SET = "未设置";
  static const AGREE_UPLOAD_NOTICE = "已閱讀並同意上傳須知";
  static const VIDEO_PUBLISH_TITLE_HINT = "寫標題並使用合適的話題，能讓更多人看到～";
  static const SET_PRICE_DESC_LINE1 = "*收費視頻必須為原創視頻，否則統統設置為免費視頻";
  static const SET_PRICE_DESC_LINE2 = "*收費視頻必須攜帶【%s】的真實字樣或者手勢";
  static const SET_PRICE_DESC_LINE3 = "*為了維護觀看體驗，單個視頻價格不超過10金幣";
  static const SET_PRICE_DESC_LINE4 = "*每個付費視頻，平臺將收取30%的稅";
  static const TOPICS = '相關話題';
  static const HISTORY_TAG = '歷史話題';
  static const EXPERIENCE = '體驗';
  static const EXPERIENCE_DETAILS = '體驗詳情';

  static const SET_FREE_DURATION_DESC = "**收費視頻也可以設置免費時長，不得低于3秒";
  static const TOPIC = "專題";
  static const SELECT_ADDRESS = '選擇地址';
  static const SELECT_PRICE = '設定價格';
  static const UPLOAD_NOTICE = "上传须知";
  static const READ_AND_AGREE = "我已阅读并同意";
  static const NOT_AGREE_AND_QUIT = "我不同意并退出";
  static const READ_AND_AGREE_UPLOAD_NOTICE = "已阅读并同意上传";
  static const UPLOAD_RULE_TITLE = "上传协议";
  static const UPLOAD_RULE = "1、用户须年满18岁，具备完全民事行为能力，符合所在地区的法律法规，不满足条件者请主动退出。\n"
      "2、遵循自由、自愿原则，在被拍摄人允许的情况下方可上传，若有必要，请对视频内当事人做打码处理。\n"
      "3、禁止上传幼女、人兽、偷拍、真实强奸、枪支、政治等话题，以及相关侵害他人隐私的内容。\n"
      "4、禁止在视频中添加个人联系方式、广告、水印等。\n"
      "5、上传的视频将由平台进行审核，24小时内反馈审核结果。\n"
      "6、原创视频的UP主，可以设置收费金额，获取原创收益。";

  static const VIDEO_RULE =
      "*收費視頻必須為原創視頻，否則統統設置為免費視頻\n*收費視頻必須攜帶「91猎奇」的真實字樣或手勢\n*依據用戶會員等級，可設置的金幣有所不同\n*每個收費視頻，平臺將收取30％的稅*收費視頻必須設置免費時長，不得低於3秒";

  static const VIDEO_REVIEW_TITLE = "过审小秘诀";
  static const VIDEO_REVIEW_RULE = "1、上传视频越清晰、越真实、越容易通过。\n"
      "2、上传视频可配剧情，深具故事性或趣味性，有看点。\n"
      "3、上传视频大小不超过250M，视频时长不低于30S。\n"
      "4、带有91猎奇的文字或手势的原创视频通过率更高。";
  static const FORBID_SPECIAL_CHAR = '禁止輸入特殊字符';
  static const MAX_FOUR_TAG = '最多設置6個標籤';
  static const MAX_GOLD_COIN = '價格最多10金幣';
  static const TEN_MULTIPLE_GOLD_COIN = '金幣是10的倍數';
  static const PLEASE_INPUT_NUMBER = '請輸入數字';
  static const MIN_FREE_DURATION = '最低設置3秒';
  static const FREE_DURATION_MIN_SECOND = '免費時長最低3秒';
  static const OUT_OF_MAX_DURATION = '免費時長超過視頻時長（%d秒）';
  static const UPLOADING = '正在上傳...';
  static const CREATE_TAG_FAIL = '創建標籤異常';
  static const PUBLISH_SUCCESS = '發布成功';
  static const REQUIRE_MP4 = '請選擇mp4視頻文件';
  static const REQUIRE_NOT_WEI_XIN_QQ = '不能選擇微信或QQ內視頻';
  static const VIDEO_SIZE_LESS_250M = '请选择300M內视频';
  static const VIDEO_DURATION_LESS_4S = '请选择30秒以上的视频';
  static const VIDEO_RESOLUTION_THEN_360 = '請選擇分辨率大於360*360以上視頻';
  static const VIDEO_BTL_THEN_500 = '請選擇比特率大於500kbit每秒以上視頻';
  static const VIDEO_GET_RESOURCE_FAIL = '用户视频文件损坏或格式错误';

  ///用戶
  static const VIP_BUY_HINT = "點我购买VIP";
  static const VIP_BUY = "VIP购买";
  static const VIDEO_LOOK = "VIP全站視頻無限觀看";
  static const BIND_PHONE = "綁定手機";
  static const UNIVERSAL_AGENT = "全民代理";
  static const OFFICIAL_GROUP_NUMBER = "官方群號";
  static const SHARE_PROMOTION = "分享推广";
  static const MEMBER_EXPIRYTIME = "会员到期时间：";
  static const NUMBER_OF_VIEWS = "今日观影次数:";
  static const EDIT_INFORMATION = "编辑资料";
  static const USER_ID = "用戶ID：";
  static const NO_PROFILE = "您还没有个人简介，点击添加...";
  static const MALE = " 男";
  static const FEMALE = " 女";
  static const AGE = "年龄";
  static const ADDRESS = "地址";
  static const ADD_SEX_ADDRESS = "+添加性別、年齡、地址標籤";
  static const PRAISE = " 获赞     \t";
  static const ATTENTION = " 关注     \t";
  static const FAN = " 粉丝     \t";
  static const FAN_ONE = "粉丝";
  static const LIKE = "赞";
  static const INTERACTIVE = "互动";
  static const COMMENT = "评论";
  static const FOLLOW = "关注";
  static const HAS_FOLLOW = "已关注";
  static const UN_FOLLOW = "取消关注";
  static const TAKE_PICTURE = "拍壹張";
  static const ALBUM_PICK = "相冊選擇";
  static const VIEW_IMAGE = "查看大圖";
  static const cancel = "取消";
  static const EDIT_USER_INFO = "个人资料";
  static const NEXT_STEP = "下一步";
  static const VERIFY_CODE = "驗證碼";
  static const GET_VERIFY_CODE = "发送验证码";
  static const PHONE_NUMBER_ERROR = "手機號格式有誤";

  static const PHONE_NUMBER_VERIFY = "手機號驗證";
  static const PHONE_NUMBER = "手機號";
  static const INPUT_PHONE_NUMBER = "请输入正确的手机号码";
  static const INPUT_PHONE_CODE = "區號";
  static const INPUT_VERIFY_CODE = "请输入";
  static const PHONE_NUMBER_RESET_TITLE = "更換說明";
  static const PHONE_NUMBER_RESET_DESC = "1、更換的新手機號碼若已經註冊，驗證之後將切換為該手機號碼登錄.\n2、更換的新手機號碼若沒有註冊，驗證之後將替換掉之前的手機號碼.";
  static const LOGOUT = "退出登录";
  static const UN_REVIEW_WED = "審核中";
  static const AUDIT_FAILURE = "未通過";
  static const VIP_END_TIME = "VIP到期时间：";
  static const VIP_REMAINING_TIME = "VIP剩余时间：";
  static const DAY = "天";
  static const HOURS = "小时";
  static const VIP_ONE_TIME = "VIP剩余时间：1小时";
  static const NOT_BUY_VIDEO = "您還沒有购买的視頻喲，快去添加吧";
  static const NOT_LIKE_VIDEO = "您還沒有喜歡的視頻喲，快去添加吧";
  static const NOT_WORK_VIDEO = "空虛寂寞冷，請快來填充我吧";
  static const USER_NOT_LIKE_VIDEO = "該用戶還沒有喜歡的內容";
  static const USER_NOT_BUY_VIDEO = "該用戶還沒有购买過";
  static const USER_NOT_WORK_VIDEO = "該用戶還沒有上传品";
  static const ACCOUNT_AND_SAFE = "账号安全";
  static const ACCOUNT_BIND_PHONE = "手机绑定";
  static const SWITCH_ACCOUNT = "切换账号";
  static const ACCOUNT_COVERY = "账号凭证";
  static const SCAN_LOGIN = "扫码登录";
  static const MODIFY_DESC = "修改简介";
  static const MODIFY_NICKNAME = "修改昵称";
  static const SETTING = "设置";
  static const CLEAN_CACHE = "清理緩存";
  static const VERSION_UPGRADE = "版本更新";
  static const BIND_PROMOTION = "綁定推廣碼";
  static const BIND_PROMOTION_SUCCESS = "綁定推廣碼成功";
  static const CLEAN_CACHE_SUCCESS = "清理緩存成功";
  static const HAVE_BIND_PROMOTION = "您已綁定推廣碼";
  static const VERSION_NAME = "版本號";
  static const VERIFY_CODE_SEND_FAIL = "驗證碼發送失敗";
  static const VERIFY_CODE_SEND_SUCCESS = "驗證碼發送成功";
  static const BIND_PHONE_EXCEPTION = "綁定手機號異常";
  static const BIND_PHONE_SUCCESS = "綁定手機號成功";
  static const PHONE_LOGIN_SUCCESS = "登录成功";
  static const WORK_TEXT = "作品 ";
  static const DYNAMIC_TEXT = "動態 ";
  static const SQUARE_TEXT = "廣場 ";
  static const LIKE_TEXT = "喜歡 ";
  static const CUSTOM_SERVICE_OFF = "客服已休息";
  static const CUSTOM_SERVICE_SUBTITLE = "請盡情吩咐我吧，主人～";
  static const COMMENT_AT = "动态";
  static const COMMENT_AT_YOU = "評論了妳的作品";
  static const COMMENT_TO_YOU = "評論中提到了妳";
  static const REPLY_TO_YOU = "回復了妳的評論";
  static const WRONG_WITHDRAW_AMOUNT = "請輸入正確的金額";
  static const BIND_NOW = "立即綁定";
  static const BIND_MOBILE = "綁定手機號";
  static const ACCOUNT_CREDENTIALS = "帳號憑證";
  static const VERIFY_MOBILE = "驗證手機號";
  static const RECORD_LIFE = "紀錄幸福生活";
  static const CURRENT_ACCOUNT = "当前账号";
  static const CONFIRM_REBIND = "確認更改";
  static const CONFIRM_LOGIN = "登录";
  static const UN_KNOWN = '未知';
  static const REPORT = '舉報';
  static const PULL_BLACK = '拉黑';
  static const SHIELD = '屏蔽';
  static const SHARE = '分享';
  static const IMPRESSION = '印象';
  static const WRITE_TO_SOMETHINGS = '快來寫點什麼吧～';
  static const WRONG_WITHDRAW_AMOUNT_NOT_IN_RANGE = "提現金額不在提現範圍內";

  ///全民代理
  static const EARN_MONEY = "代理賺錢";
  static const TOTAL_PERFORMANCE = "總業績";
  static const TOTAL_REVENUE = "總收益";
  static const PROXY_RULES = "代理規則";
  static const MONTHLY_INCOME = "當月收益";
  static const MONTHLY_RESULTS = "當月業績";
  static const PROMOTIONS_MONTH = "當月推廣人數";
  static const PROMOTION_STATISTICS = "推廣人數統計";
  static const PROMOTION_ONE = "壹級推廣";
  static const PROMOTION_TWO = "二級推廣";
  static const PROMOTION_THREE = "三級推廣";
  static const PROMOTION_FOUR = "四級推廣";
  static const PROXY_RULE = "代理加盟";
  static const BUY_PLATINUM_CARD = "购买鉑金卡會員";
  static const BUY_DIAMOND_CARD = "购买鑽石卡會員";
  static const BUY_VIP_CARD = "購买至尊卡會員";

  ///分享推廣
  static const PROMOTION_DESCRIPTION = "推廣說明";
  static const PROMOTION_RECORD = "推广记录";
  static const PROMOTION_OF_BENEFITS = "推廣福利";
  static const BENEFITS_CONTENT = "成功推廣1人，送三天無限觀看，可無限疊加～";
  static const ASK_CONTENT1 = "問：怎樣才算推廣成功？";
  static const ANSWER_CONTENT1 = "答：發送推廣碼鏈接給其他新用戶們，用戶第壹次安裝打並打開APP後算邀請成功。";
  static const ASK_CONTENT2 = "問：為什麼推廣鏈接別人打不開？";
  static const ANSWER_CONTENT2 = "答：請勿使用微信或者QQ等第三方內置瀏覽器打開，因為包含色情內會導致被屏蔽，推薦使用自帶瀏覽器或者UC瀏覽器打開。";
  static const PROMOTION_TIME = "已推广人数：%s人";
  static const BUY_VIP = "购买会员";
  static const EDIT_PROMOTION_CODE = "輸入推廣碼";
  static const SAVE_PHOTO_ALBUM = "已保存至相冊";
  static const SAVE_PHOTO_DETAILS = "由於微信分享限制，請到微信上傳圖片來分享。";
  static const KEEP_SHARING = "繼續分享到微信";
  static const PERSONAL_BUSINESS_CARD = "個人名片";
  static const MY_PROMOTION_CODE = "我的推广码: ";
  static const FRIENDS_PROMOTION = "好友也可以在個人中心填寫您的推廣碼";
  static const SAVE_PIC = "保存推广图片";
  static const COPY_URL = "复制推广链接";
  static const RECORD_SEX = "記錄性福時光";
  static const SHARE_TXT = "推廣碼:";
  static const SHARE_TIP = "複製成功，快去分享吧";
  static const SHARE_TIP2 = "保存成功";
  static const SHARE_1 = "邀请步骤";
  static const SHARE_2 = "成功推广1人，送2天会员权益";
  static const NO_PROMOTION_RECORD = "暫無推廣記錄";

  ///評論
  static const COMMENT_NO_DATA = "暂无评论数据";
  static const COMMENT_NOTIFY = "快去發表評論吧！";
  static const COMMENT_STATUS_DELETE = "已刪除";
  static const COMMENT_STATUS_CHECK = "正在審核";
  static const COMMENT_STATUS_SHIELD = "已屏蔽";
  static const COMMENT_INPUT_TIP = "请输入您想说的";
  static const COMMENT_YOU_FOLLOW_USER = "您關註的人";
  static const COMMENT_SHOW_MORE_REPLY = "展开更多回复";

  /// net error
  static const BAD_NETWORK = "网络不好";
  static const NETWORK_ERROR = "网络异常";
  static const SERVER_ERROR = "服务器异常";
  static const DATA_ERROR = "数据处理异常";
  static const REQUEST_FAILED = '请求失败';
  static const CLICK_RETRY = '点击重试';
  static const EMPTY_DATA = '这里空空如也~';
  static const SEARCH_EMPTY_DATA = '搜索结果为空';

  ///城市
  static const SWITCH_TAB = "切換";
  static const WANT_GO = "想去";
  static const MUSIC_TEXT = "創作原聲";
  static const PEOPLE_VISIT = "人來過";
  static const SEE_ALL_COMMENT = "查看所有評論";
  static const ADD_COMMENT = "添加評論...";
  static const ERROR_TITLE = "請檢查網絡鏈接後重試";
  static const ERROR_CONTENT = "網絡链接錯誤";
  static const ERROR_BTN = "點擊重試";
  static const CITY1 = '全國';

  /// 相冊或視頻選擇頁面
  static const SELECT_TITLE = "上傳";
  static const SELECT_TITLE1 = "抖音";
  static const SELECT_TITLE2 = "圖片";
  static const SELECT_TITLE3 = "影视";
  static const SELECT_TITLE4 = "图文";

  static const SELECT_OK = "確定";
  static const SELECT_NO_DATA1 = "您相冊中沒有視頻";
  static const SELECT_NO_DATA2 = "您相冊中沒有圖片";

  /// 推薦
  static const NO_MORE = "沒有更多了";
  static const BOTTOM_COMMENT = "   留下妳精彩的評論吧";
  static const YOU_FOLLOW = "妳的關註";

  /// 首頁
  static const NAV_MAIN = "首頁";
  static const NAV_BAR = "撩吧";
  static const NAV_DISCOVERY = "發現";
  static const NAV_MSG = "消息";
  static const NAV_YUEPAO = "約炮";
  static const NAV_GAME = "遊戲";
  static const NAV_MINE = "我的";
  static const INDEX_TITLE_HOT = "熱點";
  static const INDEX_TITLE_FOLLOW = "關註";
  static const INDEX_TITLE_RECOMMEND = "推薦";

  static const THEMATIC = "專題";

  static const POST_NEW = "最新";
  static const POST_HOT = "推荐";
  static const POST_CITY = "同城";
  static const POST_NEARBY = "附近";
  static const POST_PAY = "付費";
  static const POST_ORIGINAL = "原创";
  static const POST_VIP = "会员";

  ///更新
  static const UPDATE_TEXT = "立即更新";
  static const UPDATE_TITLE = "更新";
  static const UPDATE_CONTENT = "更新內容";
  static const TIP = "提示";
  static const NOT_UPGRADE = "沒有可用的版本更新";
  static const COULD_UPGRADE = "当前有新版本可更新（91猎奇version placeHolder）";
  static const DOWNLOADING = "正在下載";
  static const DOWNLOAD_NOW = "立即下載";
  static const RE_DOWNLOAD = "點擊重新下載";

  ///專��
  static const LOOK_MORE = "查看更多>";
  static const MORE = "更多";
  static const PLAY_COUNT = "次播放";

  ///標簽
  static const PARTICIPATE = "参与";
  static const COLLECT = "收藏";
  static const HAVE_COLLECT = "已收藏";

  ///關註
  static const NO_FOLLOW_TITLE = "暂无关注人动态";
  static const NO_FOLLOW_CONTENT = "快去寻找更多可能认识的人來填充我吧";
  static const CANCEL_COLLECTION = "取消收藏成功";
  static const COLLECTION_SUCCESS = "收藏成功";
  static const COPY_SUCCESSFUL = "复制成功";
  static const UN_FOLLOW1 = "取消关注";
  static const NO_INTERESTED = "不感兴趣";
  static const UN_LOCK = "解锁";
  static const UNLOCKED = "已解锁";
  static const VERIFIED = '已验';

  ///視頻购买界面
  static const BUY_CONFIRM = "确认支付";
  static const BUY_DURING = "支付中";
  static const BUY_TXT1 = "该视频由「%s」上传，并设置价格为：";
  static const BUY_IMAGES = "该图片由「%s」上传，并设置观赏价格为：";
  static const BUY_GOLD = "金幣";
  static const BUY_CAMERA = "視頻隨拍";
  static const BUY_TXT2 = "*作者原創不易，給個獎勵上傳更多優秀作品";
  static const BUY_TXT3 = "*91猎奇朋友都可以上傳，分享妳的幸福生活";
  static const BUY_TXT4 = "*91猎奇不生產視頻，只做視頻的搬運工";

  ///城市選擇
  static const AUTO_LOCAL = "自动定位";
  static const HISTORY = "历史访问";
  static const HOT_CITY = "热门城市";
  static const SWITCH_CITY = "切换城市";

  static const SET_PASSWORD_LOCK = "设置密码锁";

  /// 提示文本
  static const GLOBAL_TIP_TXT0 = "余额不足，请前往充值";
  static const GLOBAL_TIP_TXT1 = "自己不能关注自己";
  static const GLOBAL_TIP_TXT2 = "未审核通过";
  static const author = "作者";

  ///視頻錄制
  static const LESS_THAN_THREE_S = "视频时长不能小于15秒，请重新录制...";
  static const DEL_VIDEO = "是否移除当前视频和拍摄进度";
  static const RE_CAMERA = "重新拍摄";
  static const EXIT = "退出";
  static const postVideo = "发布视频";

  ///系統公告
  static const SYSTEM_DIALOG = "系統公告";
  static const SYSTEM_DIALOG_1 = "我知道了";

  // static const SYSTEM_DIALOG_2 = "應用中心";
  static const SYSTEM_DIALOG_2 = "确认";

  ///我的收藏
  static const NO_CITY = "您还沒有收藏";
  static const NO_TAG = "您还沒有话题";
  static const FAVORITES_CITY = "快去收藏地点信息吧";
  static const ADD_TOPIC = "赶紧去添加吧";
  static const FAVORITE_VIDEO = "快去收藏视频信息吧";

  ///舉報
  static const REPORT_SUCCESS = "举报成功";
  static const REPORT_FAIL = "举报失败，请稍后再试试...";

  ///搜索
  static const PLAY_TODAY = "今日播放：";
  static const FAN_TEXT = "粉丝";
  static const SEARCH_HINT_TEXT = "输入你搜索的关键字";
  static const TODAY_HOT_VIDEO = "今日最熱視頻";
  static const LOOK_HOT_LIST = "查看熱搜榜  ";
  static const SEARCH_TEXT = "搜索";
  static const LOAD_FAILED = "加載失敗";
  static const NO_DATA = "暂无数据";
  static const LOCATION = "地点";
  static const TOPIC_TEXT = "话题";
  static const BIND_SUCCESS = "綁定成功";
  static const BINDING_EXCEPTION = "绑定异常";
  static const SEARCH_HISTORY_TITLE = '历史记录';
  static const DEL_HISTORY_TITLE = '清除記錄';
  static const ALL_SEARCH_HISTORY = '全部搜索記錄';
  static const INTRO_HOME_FIND_TIPS = '點擊發現可看到更多精彩內容';
  static const INTRO_HOME_SHARE_TIPS = '分\n享\n成\n功\n可\n獲\n得\n會\n員\n獎\n勵';
  static const INTRO_PROMOTION_TIPS = '「赚钱」和「免费会员」请点这';
  static const INTRO_SWITCH_CITY_TIPS = '點擊可切換城市';

  ///編輯用户信息
  static const NICKNAME_UPDATE_SUCCESS = "暱稱修改成功!";
  static const NAME_UPDATE_FAILED = "暱稱修改失敗,請重試!";
  static const HEAD_SUCCESS = "頭像修改成功!";
  static const HEAD_FAILED = "頭像修改失敗,請重試!";
  static const INTRODUCTION_SUCCESS = "簡介修改成功!";
  static const INTRODUCTION_FAILED = "簡介修改失敗,請重試!";
  static const SEX_SUCCESS = "性別修改成功!";
  static const SEX_FAILED = "性別修改失敗,請重試!";
  static const BIRTHDAY_SUCCESS = "生日修改成功!'";
  static const BIRTHDAY_FAILED = "生日修改失敗,請重試!";
  static const ADDRESS_SUCCESS = "地區修改成功!";
  static const ADDRESS_FAILED = "地區修改失敗,請重試!";
  static const UPDATE_HEAD = "切换头像";
  static const NICK_NAME = "昵称";
  static const AREA = "所在地";
  static const BIRTHDAY = "生日";
  static const SEX = "性別";
  static const INTRODUCTION = "个人简介";
  static const MY_PROMOTION = "我的邀請碼: ";

  ///啟動頁
  static const ENTER = "跳过";

  /// 賬號封禁
  static const ACCOUNT_BAN_1 = "此賬號被封禁";
  static const ACCOUNT_BAN_2 = "如有疑問，請聯繫客服";
  static const ACCOUNT_BAN_3 = "確定";
  static const ACCOUNT_BAN_4 = "联系客服";

  /// token失效
  static const TOKEN_AB_NORMAL_1 = "温馨提示";
  static const TOKEN_AB_NORMAL_2 = "当前登入已失效，是否重新登录？";
  static const TOKEN_AB_NORMAL_3 = "确定";
  static const TOKEN_AB_NORMAL_4 = "取消";

  ///
  static const DEVELOPING = "正在开发中...";

  ///暫無數據
  static const NO_DATA2 = "暂无数据，点击刷新";
  static const NO_MORE_DATA = "沒有更多数据了";
  static const PULL_DOWN_REFRESH = "下拉刷新";
  static const REFRESH_SUCCESS = "刷新完成！";
  static const REFRESH_FAILED = "刷新失敗!";
  static const RELEASE_REFRESH = "释放即可刷新";
  static const LOADING = "加载中...";
  static const RELEASE_LOAD_MORE = "松开加载更多...";
  static const PULL_UP_LOAD_MORE = "上拉加载更多";
  static const LOADING_FAILED = '加载失败了 刷新试试～';

  ///數據加載完成
  static const DATA_LOAD_COMPLETE = "数据加载完成";

  static const NOT_NULL_TIP = "输入內容不可为空";
  static const COMMENT_FORBID = "您已被禁言，请联系客服";
  static const COMMENT_BEYOND_CONTENT = "评论内容不可超过120";

  ///支付
  static const PAY_SUCCESS = "支付成功";
  static const PAYING_TIP = "正在支付中，请勿重复点击";
  static const PAY_ERROR = "支付失敗";
  static const FIVE_MINS_PAY_TIPS = '请在5分钟之内支付，否则链接将会失效!';

  ///再按壹次退出
  static const EXIT_CONTENT = "再按一次退出";

  ///
  static const NP_PERMISSION = "您已禁止權限，需要去設置頁面手動開啟才能繼續使用";

  ///
  static const STOP_RECODE = "停止錄製";

  static const TOAST_TIP_1 = "沒有權限";

  static const INSTALL_TX = "請先安裝微信";

  /// 關註用戶
  static const FOLLOW_ERROR = "关注失败";

  static const WATCH_COUNT_RANK = "看片之王";

  static const CONTRIBUTION_RANK = "貢獻之王";

  static const INCOME_RANK = "收益之王";

  ///-----------搜索-熱搜榜
  static const HOT_TOPIC = "熱門話題";
  static const HOT_POPULARITY = "人氣榜單";
  static const HOT_TODAY_HOTTEST = "今日最熱視頻";
  static const HOT_GOLD = "精選專區";
  static const HOT_FIND = "發現精彩";
  static const SEE_MORE = "查看更多";

  static const POPULARITY_TIPS = [
    "推廣達人",
    "上傳達人",
    "收益達人",
  ];

  ///人氣榜單 分類
  static const HOT_TOPIC_1 = "個視頻";
  static const TODAY_HOTTEST_1 = "今日播放：";
  static const GOLD_1 = "次购买";
  static const GOLD_2 = "次播放";
  static const BILLION = "亿";

  static const UP_VIDEO_PHONE = "沒有相冊權限";

  static const BEGIN_RECORDER = "開始錄製";

  /// 今日最熱榜單規則
  static const SEARCH_RULE_1 = "榜單規則";
  static const SEARCH_RULE_2 = "今日最熱視頻是實時站內綜合最熱門視頻，主要因素包含視頻當日新增的播放量，並參考視頻的有效點讚、評論、分享、轉發、收藏等互動數據。（作弊數據已被刨除）";
  static const SEARCH_RULE_3 = "確定";

  static const INPUT_EXCHANGE_CODE = "输入兑换码";
  static const INPUT_TUIGUANG_CODE = "輸入推廣碼";
  static const ACTIVITY = "抽奖";
  static const FEATURED = "精選";
  static const RANKING = "榜單";
  static const NO_RANKING = "暫未上榜";
  static const DETAILS = "明细";
  static const INCOME_WITHDRAW = "收益提現";
  static const INCOME_DETAILS = "收益明細";
  static const NO_DETAILS = "暫無明細";
  static const ACCOUNT_CREDIT = "账号凭证";
  static const SAVE_QR_TO_RETRIEVE = "保存二維碼方便找回";
  static const PROMOTION_CODE = "推广码";

  static const ACCOUNT_ID = "ID";
  static const PERSIST_URL = "永久网址:";
  static const ACCOUNT_CREDIT_TIPS =
      "1、请您保存二維码凭证，以便找回您的账号\n2、请妥善保管此账号凭证,不要随意透露给任何人\n3、若账号不慎丟失,可通过APP[账号安全]获取该二维码凭证登录账号";
  static const DESCRIPTION = "说明";
  static const PLEASE_SCREENSHOT = "若保存失败，请截屏保存";
  static const SAVE_ACCOUNT_CREDIT = "保存凭证";
  static const SAVE_IMAGE_SUCCESS = '保存成功';
  static const SAVE_IMAGE_FAILURE = '保存失敗，请检查权限是否开启';
  static const AVOID_ACCOUNT_LOSS = '防止账号丟失';
  static const AVOID_ACCOUNT_LOSS_TIP = '1、请绑定手机号码，可通过账号切换輸入手机号码找回账号。 \n2、请保存账号凭证，通过扫码二维码找回账号。';
  static const I_WANT_TO_SAVE = '我要保存';
  static const I_ALREADY_SAVE = '我已保存';

  static const PAY_FOR_ICON_NAMES = ["支付宝", "微信", "银联", "信用卡", "花呗", "云闪付", "QQ钱包", "京东支付"];

  static const PAY_FOR_TIP0 = "选择支付方式";
  static const PAY_FOR_TIP1 = "金币";
  static const PAY_FOR_TIP2 = "在线支付";
  static const PAY_FOR_TIP3 = "官方代充";
  static const PAY_FOR_TIP4 = "更多支付方式";
  static const PAY_FOR_TIP5 = "滿";
  static const PAY_FOR_TIP6 = "金币兑换";

  static const UPLOAD_IMG = "上傳圖片";
  static const UPLOAD_COVER = "上傳封面";
  static const UPLOAD_VIDEO = "上傳視頻";

  static const PAY_FOR_LOADING = "數據加載中，請稍後";

  static const POST_PAY_UP = 'UP主原創';
  static const POST_PAY_WORK_ROOM = '工作室';
  static const POST_NEARBY_DAY = '日榜';
  static const POST_NEARBY_WEEK = '周榜';
  static const POST_NEARBY_MONTH = '月榜';

  static const PACK_UP = ' 收起';
  static const EXPAND = ' 全文';
  static const YOU_HAVE_NOT_LIKED = '你还沒有赞';
  static const YOU_HAVE_NOT_COMMENT = '你还沒有评论';
  static const YOU_HAVE_NOT_FANS = '你还沒有粉丝';
  static const YOU_HAVE_NOT_SYS_MSG = '沒有系統消息';
  static const LIKED_YOUR_VIDEO = '赞了你的视频';
  static const LIKED_YOUR_COMMENT = '赞了你的评论';
  static const MENTIONED_YOU = '提到了妳';
  static const FOLLOW_YOU = '关注了妳';
  static const FOLLOW_MUTUAL = '互相关注';
  static const FOLLOW_RECOMMEND = '推荐关注';
  static const CHECK_ALL = '查看全部';
  static const VIDEO_RECORDING = '   在录制中……';
  static const SOURCE_ID_EMPTY = 'sourceId信息為空';
  static const UPLOAD_IMAGE = '上传图片';
  static const PLEASE_INPUT_TITLE = '請輸入標題';
  static const NO_TOPIC_SELECTED = '沒有選擇話題';
  static const TOPIC_SELECTED_MORE = '最多選擇5个話題';
  static const PLEASE_SELECT_UPLOAD_FILE = '请选择上传文件';
  static const NO_AGREEMENT = '沒有同意上傳須知';
  static const NO_HISTORICAL_TAG_RECORD = '暫未有歷史記錄~';
  static const LOGIN_WARNING = '妳的賬號在其他設備登錄，需要重新登錄，請註意賬號安全';
  static const COMMENT_WARNING = '未绑定手机号不能评论，请先绑定手机号';
  static const DISCOUNTED_PRICES = '優惠價:%s0金幣';
  static const ORIGINAL_PRICE = '原價:%s0金幣';
  static const SUCCESSFUL_PURCHASE = '购买%s成功！ ';
  static const PRODUCT_IS_INVALID = '此產品已無效，無支持的支付類型';
  static const TYPES_OF = '類型';

  static const TOPIC_1 = '話題';
  static const REPEAT = '重複';
  static const CHANGE_REPLACE_ERROR = '圖中已有改圖，請勿重複更換！ ';
  static const CHANGE_SUCCESSFUL = '更換成功';

  static const HOT_SPOT = '热门搜索';
  static const GOLD = '金幣';
  static const VIDEO = '发布视频';
  static const USER = '用戶';
  static const SEARCH = '搜索';
  static const CHANGE = "更換";

  static const BANK_CARD_TYPE_1 = "儲蓄卡";
  static const BANK_CARD_TYPE_2 = "信用卡";
  static const BANK_CARD_TYPE_3 = "準貸記卡";
  static const BANK_CARD_TYPE_4 = "預付費卡";

  static const DELETE = "刪除";
  static const STICKY = '置頂';
  static const RECOMMEND = "力薦";
  static const ADD_FINE = '加精';

  static const ACCOUNT_SAFE = '賬戶安全';
  static const FULI_GUANGCHANG = '福利廣場';
  static const MY_WALLET = '金币充值';
  static const MY_PROXY = '推广赚钱';
  static const MY_PROXY1 = '我的收益';
  static const BASE_GROUP = '官方社群';
  static const SHARE_PROMOTE = '立即推广';
  static const NET_CANT_REACH_TIP = '網絡開小差了';
  static const PROMOTE_TO_FRIEND_TIP = '成功推廣好友，立即獲得會員權益';
  static const WATCH_COUNT_NOT_ENOUGH = '您的觀看次數不足';
  static const VIDEO_REMOVED_TIP = "很難過，該視頻已下架，請主人您觀看其他視頻喲～";
  static const SOURCE_ID_IS_EMPTY = "sourceId信息為空";
  static const GET_PERMISSION_ERROR = "權限獲取異常了，怎麼辦";
  static const NO_AUTHORITY_TO_USE_CAMERA = '沒有相機權限不能使用相機！';
  static const UPDATE_AT = "更新於：";
  static const RECENT_USE = "最近使用";
  static const ADD_ALI_PAY = "新增支付寶";
  static const ACCOUNT1 = "賬號";
  static const GET_ALI_PAY_ACCOUNT_ERROR = "獲取支付寶賬號失敗";
  static const GET_FEE_ERROR = "獲取費率失敗";
  static const WITHDRAW_ERROR = "提現失敗";
  static const TO_WALLET = "到賬：";
  static const MONEY_VIDEO = "付費視頻-";
  static const EXCHANGE_ERROR = "充值失敗";
  static const YUAN = "元";
  static const CAN_NOT_BIND_CODE = "您是渠道用戶，不可綁定推廣碼";
  static const RECORDER_YOUR_LIFE = "記錄你的性福生活";
  static const PLEASE_INPUT_VERTICAL_CODE = "請填寫验證碼";

  static const VERIFICATION = "验证";
  static const NO_VERIFICATION = "未验证";
  static const VERTICAL_ERROR = "验证码有误";
  static const PLEASE_INPUT_PHONE = "请填写手机号码";
  static const PHONE_FORMAT_ERROR = "手机号码格式错误";
  static const PHOTO_ALBUM = "相册";
  static const MY_VOUCHER = "我的凭证";
  static const CLEAR_COMPLETE = "清理完成";
  static const TOUCH_HEAD_SWITCH_ACCOUNT = "轻触头像以切换账号";
  static const CLEAR_LOGIN_RECORDER = "清除登录痕迹";
  static const SWITCHING = "正在切换，請稍等...";
  static const ADD_ACCOUNT = "添加账号";
  static const LOGIN_ING = "正在登录";
  static const INSUFFICIENT_BALANCE = "餘額不足";
  static const NET_CONNECT_ERROR = "網絡連接不穩定";
  static const VIDEO_UPLOAD_RETRY = "上傳視頻失敗，是否進行重試？";
  static const RETRY = "重試";
  static const LINE_CHECK_ERROR = "線路檢查失敗";
  static const CHECK_PHONE_NETWORK = "親，請先檢查下手機網絡是否正常，若正常請點擊重識";
  static const RECHECK_LINE = "重新檢查線路";
  static const SET_FREE_TIME = "設定免費時長";
  static const SHARE_TO = "分享到";
  static const CANCEL_COLLECT = "取消收藏";
  static const QR_CODE = "二維碼";
  static const COPY_LINK = "複製鏈接";
  static const NETWORK_CONNECT_ERROR = "網絡連接失敗";
  static const PLEASE_LOOK_OR_RETRY = "請查看網絡或重試";
  static const PEOPLE_COME = "人來過";
  static const SECOND = "秒";
  static const GET_BANK_CARD_ERROR = "獲取銀行卡失敗";
  static const W_COUNT_PLAY = "W次播放";
  static const VIDEO_INFO_GET_ERROR = "視頻信息獲取失敗";
  static const PLEASE_THREE_UP_PHOTO = "請選擇三張以上的圖片";
  static const PLEASE_THREE_UP_PHOT1 = "最多可以上傳9張圖片";
  static const UPLOAD_PICS_SUC_STR = "上傳成功%d張圖片";
  static const POST_PICS_FAILED = "發布圖片集失敗";
  static const UPDATA_FAILED = "更新失敗";
  static const UPDATA_SUC = "更新成功";
  static const REDEMPTION_CODE = "兌換碼";
  static const REDEMPTION_SUCCESS = "兑换成功";
  static const BIND_ERROR = "綁定失敗";
  static const ADD_SUCCESS = "添加成功";
  static const UPDATE_ERROR = "更新錯誤";
  static const CHANGE_SUCCESS = "更換成功";
  static const CHANGE_PHOTO_ERROR = "更新圖片異常了";
  static const PHOTO_CHANGE = "圖片已添加滿，請點擊更換";
  static const PHOTO_NO_NEED_SET_PRICE = "圖片無需設置價格";
  static const PRICE = "價格";
  static const CHANGE_PHOTO_COVER = "更換相冊封面";
  static const SCORE = "評分";
  static const TUI_GUANG_MA = "推廣碼";

  static const ADD_PHOTO = "添加相片";
  static const STAY_TUNED = "敬請期待";
  static const INVALID_QR_CODE = "无效的二维码";
  static const COUNT_GET_ERROR = "次數获取失敗了";
  static const PRELOAD_ERROR = "預加載失敗了";
  static const GET_CONFIG_ERROR = "獲取配置信息失敗,請重新获取";
  static const NO_VIDEO_DATA = "無視頻數據";
  static const EXIT_TIP = "當前正在後台進行上傳，是否確認退出？";
  static const DOWNLOAD_SUC_AND_VIEWALBUM_TIP = '下載成功,請查看相冊';
  static const DOWNLOAD_FAILED = '下載失敗';
  static const DOWNLOAD_URL_ERROR = '下載地址錯誤';
  static const VIP_LEVEL_DIALOG_BTN1 = '取消';
  static const VIP_LEVEL_DIALOG_BTN2 = '前往购买VIP';
  static const VIP_LEVEL_DIALOG_TITLE = '温馨提示';
  static const VIP_LEVEL_DIALOG_MSG = 'VIP等級不足，不能進行該操作';
  static const VIP_LEVEL_DIALOG_MSG1 = '您还不是VIP，无法播听';
  static const VIP_LEVEL_DIALOG_MSG2 = '您还不是VIP，无法观看';
  static const VIP_LEVEL_DIALOG_MSG3 = '您还不是VIP，无法上传头像';
  static const VIP_LEVEL_DIALOG_MSG4 = '您还不是VIP，无法修改昵称';
  static const VIP_LEVEL_DIALOG_MSG5 = '您还不是VIP，无法修改简介';
  static const VIP_LEVEL_DIALOG_MSG6 = '您还不是VIP，无法缓存视频';
  static const VIP_LEVEL_DIALOG_MSG7 = '您还不是VIP，无法认证';
  static const MEMBER_CENTRE = "会员中心";
  static const SPECIAL_SERVICE = "特殊服務";
  static const RECORD = "個人記錄";
  static const CERTIFICATION = "妹子認證";
  static const SERVICE = "服務";
  static const WORD_AGE = '歲';
  static const WORD_ORIGINAL_PRICE = '原价';
  static const WORD_UNIT_PRICE = '元/天';
  static const TICKET_DISCOUNT = '持有約會券可抵扣';
  static const AD_LINK_EMPTY_TIP = '廣告鏈接為空';
  static const VIDEO_AD = '視頻廣告';
  static const NO_AD_COVER = '沒有找到廣告圖';
  static const ALREADY_CACHED_TIP = '您已经添加过缓存了～';
  static const CACHED = "已緩存";
  static const SAVE = '保存';
  static const CACHING1 = "正在\n緩存";
  static const DOWNLOADING1 = '正在\n下载';
  static const CACHE = "緩存";
  static const DOWNLOADING_TIP = "正在下载中";
  static const CACHING_TIP = "正在緩存中";
  static const CACHE_FAILED = "緩存失败";
  static const DOWNLOAD_PERMISSION_TIP = "需要购买vip才能下載，並在設置裡面觀看";
  static const CLEAR_ALL_VIDEO = "是否清除所有視頻？";
  static const DELETE_SUC = "删除成功";
  static const DELETE_FAI = "删除失败";
  static const AGENT_RECORD_TABS = ['推廣', '視頻', '提現'];
  static const PROMOTE_HOME_TABS = ['APP推广', '游戏推广'];
  static const RECORDS_TABS = ['瀏覽記錄', '收藏記錄'];
  static const AV_COMMENTARY_BUY_RECORDS_TABS = ['购买記錄', '收藏記錄'];
  static const AUDIOBOOK_RECORDS_TABS = ['播放記錄', "购买記錄", '收藏記錄'];
  static const AUDIOBOOK_COLLECT_TABS = ['音頻', "主播"];
  static const AUDIOBOOK_MORE_TABS = ['自慰催眠', "短篇激情", "長篇劇情"];
  static const PASSION_NOVEL = "激情小说";

  static const NOTIFICATION_TITLES = [
    "重磅：圈内人士爆料",
    "解密业内盗摄潜规则",
    "嫩模自曝行业内部",
    "从家庭主妇到性欲妖姬",
    "揭秘AV行业的女优",
    "出大事了",
    "明星耍大牌",
    "昨夜发生了什么？",
    "警惕迷药",
    "秘密",
    "天价彩礼",
    "现妻大战小三",
    "教你如何快速撩妹",
    "1080P高清剪辑",
    "人生污点",
  ];

  static const NOTIFICATION_CONTENTS = [
    "某杨姓明星当着老公的面出轨情人，画面十分辣眼睛",
    "业内专业偷拍人士苏先生现场传授盗摄技巧",
    "你不知道的那些嫩模行业，间接利润如此之大",
    "当一个人对性的解放，你根本不知道底线在哪里！",
    "女优的收入远远不如你的想象，也许了解之后，你可以再进一步",
    "今日凌晨，某国际知名品牌的超模裸着上身从楼上跳下",
    "就在昨天，某知名女星让陪酒某董事长，女星打了董事长一耳光",
    "小美第二天醒来，发现自己在弟弟的床上，什么都没穿",
    "王姓妹子与客户约谈，被下药迷奸，不堪受辱跳楼",
    "女友趁我出差，居然跟我两个兄弟...",
    "一个按摩店的妹子竟然跟男朋友要300万的天价彩礼",
    "某停车场，两个女人上演撕逼大战，场面十分刺激",
    "今天贤哥教兄弟们如何快速引起妹子的注意",
    "快来看看这些妹子是否符合你的口味",
    "瑶瑶被两个男人架进去的那天，她整个人都懵了",
  ];

  static String sprint(String key, {List<dynamic> args}) {
    return args != null ? sprintf(key, args) : key;
  }
}
