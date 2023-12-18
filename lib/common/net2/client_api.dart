import 'package:dio/dio.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/provider/countdown_update_model.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/HappyModel.dart';
import 'package:flutter_app/model/ai_record_entity.dart';
import 'package:flutter_app/model/alipay_bank_list_model.dart';
import 'package:flutter_app/model/anchor_model.dart';
import 'package:flutter_app/model/announce_liao_ba_entity.dart';
import 'package:flutter_app/model/anwangVipCard/AnWangVipCard.dart';
import 'package:flutter_app/model/audiobook_list_model.dart';
import 'package:flutter_app/model/audiobook_model.dart';
import 'package:flutter_app/model/audiobook_type_model.dart';
import 'package:flutter_app/model/city_detail_model.dart';
import 'package:flutter_app/model/comment_model.dart';
import 'package:flutter_app/model/feedback_model.dart';
import 'package:flutter_app/model/fiction_model.dart';
import 'package:flutter_app/model/film_tv_video/TagsListModel.dart';
import 'package:flutter_app/model/film_tv_video/TagsVideoDataModel.dart';
import 'package:flutter_app/model/film_tv_video/film_tv_video_detail_entity.dart';
import 'package:flutter_app/model/game_promotion_entity.dart';
import 'package:flutter_app/model/history_income_model.dart';
import 'package:flutter_app/model/hot_city_model.dart';
import 'package:flutter_app/model/invite_model.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/list_announ_info.dart';
import 'package:flutter_app/model/location_bean.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/model/lou_feng_obj.dart';
import 'package:flutter_app/model/message/NewMessageTip.dart';
import 'package:flutter_app/model/message/comment_reply_list.dart';
import 'package:flutter_app/model/message/fans_obj.dart';
import 'package:flutter_app/model/message/message_obj_model.dart';
import 'package:flutter_app/model/message/message_type_model.dart';
import 'package:flutter_app/model/nearby_bean.dart';
import 'package:flutter_app/model/new_hot_city_model.dart';
import 'package:flutter_app/model/nove_details_model.dart';
import 'package:flutter_app/model/novel_model.dart';
import 'package:flutter_app/model/office_item_entity.dart';
import 'package:flutter_app/model/or_code_model.dart';
import 'package:flutter_app/model/publish_tag_model.dart';
import 'package:flutter_app/model/recharge_history_obj.dart';
import 'package:flutter_app/model/reply_model.dart';
import 'package:flutter_app/model/res/comment_list_res.dart';
import 'package:flutter_app/model/res/common_post_res.dart';
import 'package:flutter_app/model/res/recommend_video_res.dart';
import 'package:flutter_app/model/res/reply_list_res.dart';
import 'package:flutter_app/model/res/watch_list_model.dart';
import 'package:flutter_app/model/reward_list_model.dart';
import 'package:flutter_app/model/search/search_talk_obj.dart';
import 'package:flutter_app/model/search/search_user_obj.dart';
import 'package:flutter_app/model/search/search_video_obj.dart';
import 'package:flutter_app/model/selected_tags_entity.dart';
import 'package:flutter_app/model/server_time.dart';
import 'package:flutter_app/model/services_model.dart';
import 'package:flutter_app/model/special_model.dart';
import 'package:flutter_app/model/tabs_tag_entity.dart';
import 'package:flutter_app/model/tag/hot_tag_model.dart';
import 'package:flutter_app/model/tag/tag_bean.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/model/tag/tag_list_model.dart';
import 'package:flutter_app/model/tags_liao_ba_entity.dart';
import 'package:flutter_app/model/token_model.dart';
import 'package:flutter_app/model/topinfo/RankInfoModel.dart';
import 'package:flutter_app/model/trade/FreezeAmount.dart';
import 'package:flutter_app/model/trade/TradeItemModel.dart';
import 'package:flutter_app/model/trade/TradeList.dart';
import 'package:flutter_app/model/trade/TradeTopic.dart';
import 'package:flutter_app/model/upgrade_vip_info.dart';
import 'package:flutter_app/model/user/mine_video.dart';
import 'package:flutter_app/model/user/mine_work_unit.dart';
import 'package:flutter_app/model/user/mini_work_unit_detail.dart';
import 'package:flutter_app/model/user/mobile_login_model.dart';
import 'package:flutter_app/model/user/new_product_list_model.dart';
import 'package:flutter_app/model/user/promotion_record.dart';
import 'package:flutter_app/model/user/proxy_income.dart';
import 'package:flutter_app/model/user/proxy_info.dart';
import 'package:flutter_app/model/user/task_center_data.dart';
import 'package:flutter_app/model/user/user_certification_entity.dart';
import 'package:flutter_app/model/user/vip_buy_history.dart';
import 'package:flutter_app/model/user/wish_list_entity.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/verifyreport_model.dart';
import 'package:flutter_app/model/video_income_model.dart';
import 'package:flutter_app/model/video_obj_model.dart';
import 'package:flutter_app/model/vote/VoteItemModel.dart';
import 'package:flutter_app/model/wallet/RechargeRecordModel.dart';
import 'package:flutter_app/model/wallet/recharge_list_model.dart';
import 'package:flutter_app/model/wallet/recharge_url_model.dart';
import 'package:flutter_app/model/wallet/user_income_model.dart';
import 'package:flutter_app/model/wallet/withdraw_config_data.dart';
import 'package:flutter_app/model/wallet/withdraw_details_model.dart';
import 'package:flutter_app/model/wallet/withdraw_fee_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/model/watch_count_model.dart';
import 'package:flutter_app/page/game_page/bean/game_balance_entity.dart';
import 'package:flutter_app/page/search/hot_search_list/find_obj.dart';
import 'package:flutter_app/page/search/hot_search_list/gold_obj.dart';
import 'package:flutter_app/page/search/hot_search_list/hot_topic_obj.dart';
import 'package:flutter_app/page/search/hot_search_list/popularity_obj.dart';
import 'package:flutter_app/page/wallet/mine_bill/model/mine_bill_section_model.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/guess_like_entity.dart';
import 'package:retrofit/retrofit.dart';

import '../../model/TopListCircleModel.dart';
import '../../model/TopListModel.dart';
import '../../model/TopListUPModel.dart';
import '../../model/domain_source_model.dart';
import '../../model/message/laud_model.dart';
import '../../model/search/search_hot_rank_model.dart';
import '../../model/search/search_topic_model.dart';

part 'client_api.g.dart';

/// net2 中间层，面向接口的编程和依赖注入

/// TODO
/// 现在有些接口返回的数据不对，有些data测试服返回的是空map，正是服返回的是String，要统一排查
@RestApi()
abstract class ClientApi {
  factory ClientApi(Dio dio, {String baseUrl}) = _ClientApi;

  @GET(Address.WALLET)
  Future<WalletModelEntity> getWallet();

  /// 点击广告
  @POST(Address.AD_CLICK)
  Future clickAdEvent(
    @Field() String id,
  );

  /// 获取远程配置信息
  @GET(Address.REMOTE_CONFIG)
  Future<DomainSourceModel> getRemoteConfig(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  ///获取城市视频列表
  @GET(Address.SAME_CITY_LIST)
  Future<NearbyBean> getCityVideoList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("city") String city,
    @Query("newsType") String newsType,
  );

  //获取热点榜的数据
  @GET(Address.SEARCH_RANK_HOT_SEARCH_API)
  Future<SearchHotRankModel> loadHotRankData(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  /// 获取标签列表
  @GET(Address.TAG_VIDEO_LIST)
  Future<TagBean> requestTagListData(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("tagID") String tagID, {
    @Query("sortType") String sortType,
  });

  /// 获取标签列表
  @GET(Address.TAG_VIDEO_LIST)
  Future<TagBean> requestTagListDataByType(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("tagID") String tagID,
    @Query("newsType") String newsType,
  );

  /// 获取聊吧标签列表
  @GET(Address.TAG_VIDEO_LIST_LIAOBA)
  Future<dynamic> requestLiaoBaTagListData(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("sectionID") String sectionID,
  );

  @GET(Address.TAG_VIDEO_LIST_LIAOBA)
  Future<dynamic> requestSelectedTagListData(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("sectionID") String sectionID,
    @Query("sortType") String sortType,
    @Query("playTimeType") int playTimeType,
  );

  /// 获取二维码信息
  @GET(Address.GET_QR_CODE_INFO)
  Future<OrCodeModel> getQrCodeInfo();

  /// 获取标签详情
  @GET(Address.TAG_DETAIL)
  Future<TagDetailModel> getTagDetail(
    @Query("tagID") String tagID,
  );

  /// vip购买记录
  @GET('/vip/history')
  Future<VipBuyHistory> getVipHistory(
    @Query("pageSize") int pageSize,
    @Query("pageNumber") int pageNumber,
  );

  /// 我的作品
  @GET(Address.MINE_WORKS)
  Future<MineVideo> getMineWorks(@Query("pageSize") int pageSize, @Query("pageNumber") int pageNumber,
      @Query("newsType") String newsType, @Query("type") String type,
      [@Query("uid") int uid]);

  /// 我的购买视频
  @GET(Address.MINE_BUY_VIDEO)
  Future<MineVideo> getMineBuy(
    @Query("pageSize") int pageSize,
    @Query("pageNumber") int pageNumber,
    @Query("newsType") String newsType,
    @Query("uid") int uid,
  );

  /// 我的喜欢视频
  @GET(Address.MINE_LIKE_VIDEO)
  Future<MineVideo> getMineLike(
    @Query("pageSize") int pageSize,
    @Query("pageNumber") int pageNumber,
    @Query("uid") int uid,
  );

  /// 获取代理收入列表
  @GET(Address.PROXY_INCOME)
  Future<ProxyIncome> getProxyIncome(
    @Query("pageSize") int pageSize,
    @Query("pageNumber") int pageNumber,
  );

  ///获取代理信息
  @GET(Address.PROXY_INFO)
  Future<ProxyInfo> getProxyInfo();

  ///在线客服token
  @GET(Address.IM_TOKEN)
  Future<TokenModel> getOnlineCustomerImToken(
    @Query("mid") String mid,
    @Query("appId") String appId,
    @Query("sign") String sign,
  );

  ///一级评论的全部列表
  @GET(Address.COMMENT_LIST)
  Future<CommentListRes> getCommentList(
    @Query("objID") String objID,
    @Query("curTime") String curTime,
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    {int objType}
  );

  ///评论的全部回复列表
  @GET(Address.CURRENT_COMMENT_LIST)
  Future<ReplyListRes> getReplyList(
    @Query("objID") String objID,
    @Query("cmtId") String cmtId,
    @Query("curTime") String curTime,
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize, [
    @Query("fstID") String fstID,
  ]);

  ///获取视频播放状态
  @GET(Address.VIDEO_PLAY_STATUS)
  Future<WatchCount> getPlayStatus([@Query("vid") String vid]);

  ///获取-热搜榜-【热门话题】列表信息
  @GET(Address.HOT_TOPIC_URL)
  Future<HotTopicObj> getHotTopicList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  ///获取-热搜榜-【人气榜单】列表信息
  @GET(Address.HOT_POPULARITY_URL)
  Future<PopularityObj> getPopularityList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  ///获取-热搜榜-【今日最热视频】列表信息
  @GET(Address.HOT_TODAY_HOTTEST_URL)
  Future<VideoObj> getTodayHottestVideoList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  ///获取-热搜榜-【精选专区】列表信息
  @GET(Address.HOT_GOLD_COIN_AREA_URL)
  Future<GoldObj> getGoldCoinAreaList();

  ///获取-热搜榜-【发现精彩】列表信息
  @GET(Address.FIND_WONDER_URL)
  Future<FindObj> getFindWonderfulList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  ///获取社区帖子列表信息
  ///[type] 0，最新；1，最热 ；2，同城；3，付费
  ///[subType] 最热需要 0日榜；1周榜；2月榜；
  ///[reqDate] 服务器时间
  @GET(Address.COMMUNITY_LIST_TOPIC)
  Future getPostList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("type") String type,
    @Query("subType") String subType,
    @Query("reqDate") String reqDate, [
    @Query("city") String city,
    @Query("version") String version,
  ]);

  ///获取支付宝账号列标
  @GET(Address.ALI_PAY_ACCOUNT_LIST)
  Future<ApBankListModel> getAliPayList();

  ///获取银行卡列标
  @GET("/mine/txnact/yh/get")
  Future<ApBankListModel> getBankCardList();

  ///提现明细
  @GET(Address.WITHDRAW_DETAILS)
  Future<WithdrawDetailsModel> getWithdrawDetails(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  ///收益明细
  @GET(Address.INCOME_DETAILS)
  Future<WithdrawDetailsModel> getIncomeDetails(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  ///支付宝提现限额
  @GET(Address.GET_AliPay_FEE)
  Future<WithdrawFeeModel> getAliPayFee(
    @Query("payType") String payType,
  );

  ///银行卡提现限额
  @GET(Address.GET_BankCard_FEE)
  Future<WithdrawFeeModel> getBankCardFee(
    @Query("payType") String payType,
  );

  ///收益数据
  @GET(Address.MY_INCOME_LIST)
  Future<HistoryIncomeModel> getIncomeList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  ///充值记录
  @GET(Address.WALLET_RECHARGE_HISTORY)
  Future<RechargeHistoryObj> getRechargeHistory(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  // 专题
  @GET(Address.SPECIAL_URL)
  Future<SpecialModel> getGroup(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  // 聊吧标签
  @GET(Address.QUERY_TAG_LIST)
  Future<TagsLiaoBaData> getTagsList(//@Query("pageNumber") int pageNumber,
      // @Query("pageSize") int pageSize,
      );

  // 聊吧标签列表
  @GET(Address.TAG_VIDEO_LIST_LIAO_BA)
  Future<SelectedTagsData> getTagsListDetail(
    @Query("type") int type,
    @Query("model") int model,
    @Query("tag") String tag,
    @Query("paymentType") int paymentType,
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  // 聊吧标签列表
  @GET(Address.TAG_VIDEO_LIST_LIAO_BA)
  Future<SelectedTagsData> getSquareListDetail(
    @Query("type") int type,
    @Query("model") int model,
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("uid") int uid,
  );

  // 聊吧公告
  @GET(Address.QUERY_ANNOUNCE)
  Future<dynamic> getAnnounce(//@Query("pageNumber") int pageNumber,
      // @Query("pageSize") int pageSize,
      );

  // 楼凤公告
  @GET(Address.QUERY_ANNOUNCE_LONGFENG)
  Future<dynamic> getAnnounceLouFeng(//@Query("pageNumber") int pageNumber,
      // @Query("pageSize") int pageSize,
      );

  // 聊吧顶部tab标签
  @GET(Address.QUERY_TAGS_MARKS)
  Future<dynamic> getTagsMarkList(//@Query("pageNumber") int pageNumber,
      // @Query("pageSize") int pageSize,
      );

  // 粉丝
  @GET(Address.FANS_LIST)
  Future<FansObj> getFansList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  // 粉丝
  @GET(Address.LIKE_LIST)
  Future<LaudModel> getLikeList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  ///推荐关注
  @GET(Address.RECOMMEND_USER_LIST)
  Future<dynamic> getRecommendList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  /// 24小时倒计时
  @GET('/vip/tiroCountdown')
  Future<Countdown> getCutDown();

  @GET(Address.COMMENT_REPLY_LIST)
  Future<ReplyListModel> getCommentReplyList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  @GET(Address.NOTICE_LIST)
  Future<MessageObjModel> getNoticeList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("sender") String sender,
  );

  @GET('/loufeng/cities')
  Future<HotCityModel> getHotCityList();

  // 获取约炮列表
  @GET('/loufeng/list')
  Future<LouFengModel> getLouFengList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("city") String city,
    @Query("hasAD") bool hasAD,
    @Query("pageTitle") int pageTitle,
    @Query("pageType") int pageType,
  );

  @GET('/loufeng/list/new')
  Future<LouFengModel> getLouFengListNew(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("city") String city,
    @Query("hasAD") bool hasAD,
    @Query("pageTitle") int pageTitle,
    @Query("pageType") int pageType,
  );

  @GET('/loufeng/agent/list')
  Future<LouFengModel> getLouFengAgentList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("agent") String pageType,
  );

  ///楼凤验证
  @POST("/loufeng/verifyReport")
  Future verifyReport(
    @Field() String productID,
    @Field() String serviceDetails,
    @Field() List<String> imgs,
    @Field() List<String> videos,
  );

  ///小说报错
  @POST('/fiction/feedback')
  Future reportErrFiction();

  ///小说报错
  @GET('/fiction/get')
  Future<NoveDetailsModel> fictionGet(
    @Query("id") String id,
  );

  ///获取搜索激情小说列表
  @GET('/fiction/search')
  Future<NovelModel> getFictionSearch(
    @Query("keyword") String keyword,
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  ///获取激情小说列表
  @GET('/fiction/list')
  Future<NovelModel> getFictionList(
    @Query("fictionType") String fictionType,
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  ///获取小说类别
  @GET('/fiction/fictionTypes')
  Future<FictionModel> getFictionTypes();

  ///获取楼凤验证报告
  @GET('/loufeng/verifyReport')
  Future<VerifyReportModel> getLoufengVerifyReport(
    @Query("productID") String productID,
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  // 获取查询约炮列表
  @GET('/loufeng/search')
  Future<LouFengModel> getSearchList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("keyword") String keyword,
  );

  // 获取约炮购买列表
  @GET('/loufeng/buylog')
  Future<LouFengModel> getBuyList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  // 获取约炮预约列表
  @GET('/loufeng/book/list')
  Future<LouFengModel> getReserveList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  // 获取楼风收藏记录
  @GET('/mine/collect/infoList')
  Future<LouFengModel> getCollectList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("uid") int uid,
    @Query("type") String type,
  );

  /// 获取激情小说收藏页面
  @GET('/mine/collect/infoList')
  Future<NovelModel> getFictionCollectList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("uid") int uid,
    @Query("type") String type,
  );

  /// 小说浏览次数
  @POST('/fiction/browse')
  Future fictionBrowse(
    @Field() String id,
  );

  /// 热门有声小说
  @GET('/audiobook/hots')
  Future<AudioBookListModel> getAudioHots(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  /// 热门激情小说
  @GET('/fiction/hots')
  Future<NovelModel> getFictionHots(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  // 获取约炮一个楼风信息
  @GET('/loufeng/get')
  Future<LouFengObj> getLouFengItem(
    @Query("id") String id,
  );

  // 获取约炮下一个楼风
  @GET('/loufeng/random')
  Future<LouFengModel> getNextLouFeng([@Query('size') int size = 1]);

  // 获取约炮下一个激情小说
  @GET('/fiction/random')
  Future<NovelModel> getNextNovel([@Query('size') int size = 1]);

  /// 添加浏览次数
  @POST('/loufeng/browse')
  Future postBrowse(
    @Field() String id,
  );

  /// 收藏/取消收藏
  @POST('/mine/collect')
  Future postCollect(
    @Field() String objId,
    @Field() String type,
    @Field() bool isCollect,
  );

  /// 收藏/取消收藏裸聊
  @POST('/nude/chat/collect')
  Future postNakeChatCollect(
    @Field() String id,
    @Field() int action,
  );

  /// 约炮举报
  @POST('/loufeng/feedback')
  Future postFeedBack(
    @Field() String loufengID,
    @Field() int feedbackType,
    @Field() List<String> imgs,
    @Field() String content,
  );

  /// 裸聊举报
  @POST('/nude/chat/feedback')
  Future postNakeChatFeedBack(
    @Field() String loufengID,
    @Field() int feedbackType,
    @Field() List<String> imgs,
    @Field() String content,
  );

  @GET(Address.NOTICE_TYPE_LIST)
  Future<MessageTypeModel> getNoticeTypeList();

  ///发现精彩数据对应的视频数据接口
  @POST(Address.DEL_WORK)
  Future postDelWork(
    @Field() List<String> ids,
  );

  @POST(Address.EXCHANGE_CODE)
  Future postExchangeCode(
    @Field() String code,
  );

  @POST(Address.SEND_SMS)
  Future postSendSms(@Field() String mobile, [@Field() int type]);

  @POST(Address.BIND_PHONE_NEW)
  Future postBindPhoneNew(
    @Field() String mobile,
    @Field() String code,
    @Field() String devID,
    @Field() String smsId,
    @Field() String sysType,
    @Field() String ver,
    @Field() String devType,
    @Field() String applicationID,
  );

  ///发现精彩数据对应的视频数据接口
  @POST(Address.SEARCH_WONDER_API)
  Future<VideoObj> postSearch(
    @Field() int pageNumber,
    @Field() int pageSize,
    @Field() String tagID,
  );

  //payType 提现方式，alipay，bankcard，usdt
  //money  提现金额
  //name 用户名
  //withdrawType 提现类型，0，代理提现； 1，金币提现
  //actName 交易账户持有人
  //act 交易账户
  //devID 设备id
  //productType 产品类型 0站群 1棋牌
  //bankCode
  ///提现
  @POST(Address.WITHDRAW)
  Future withdraw(
    @Field() String payType,
    @Field() String act,
    @Field() int money,
    @Field() String name,
    @Field() String actName,
    @Field() String devID,
    @Field() String bankCode,
    @Field() int withdrawType,
    @Field() int productType,
  );

  ///游戏钱包提现
  @POST(Address.WITHDRAW)
  Future withdrawGame(
    @Field() String payType,
    @Field('Act') String act,
    @Field() int money,
    @Field('ActName') String actName,
    @Field() String deviceType,
    @Field() int productType,
  );

  /// 充值
  @POST(Address.WALLET_RECHARGE)
  Future<RechargeUrlModel> postRecharge(
    @Field() String rechargeType, [
    @Field() String productId,
    @Field() String vipID,
  ]);

  /// 游戏充值
  @POST(Address.WALLET_RECHARGE)
  Future<RechargeUrlModel> postGameRecharge(
    @Field() String rechargeType, [
    @Field() String productId,
    @Field() String vipID,
    @Field() int productType,
    @Field() int money,
  ]);

  /// 详情页面通过直充购买购买裸聊服务
  @POST(Address.WALLET_RECHARGE)
  Future<RechargeUrlModel> postNakeChatRecharge(
    @Field() String rechargeType, [
    @Field() String productId,
    @Field() String serviceId,
  ]);

  /// 果币钱包通过直充购买购买果币
  @POST(Address.WALLET_RECHARGE)
  Future<RechargeUrlModel> postNakeChatWalletRecharge(
    @Field() String rechargeType, [
    @Field() String productId,
  ]);

  ///添加银行卡账号
  @POST(Address.ADD_BANK_CARD)
  Future getAddBankCard(
    @Field() String act,
    @Field() String actName,
    @Field() String bankCode,
    @Field() String cardType,
  );

  ///添加支付宝账号
  @POST(Address.ADD_ALI_PAY)
  Future getAddAp(
    @Field() String act,
    @Field() String actName,
  );

  ///发送视频观看记录
  @POST(Address.VIDEO_RECORD)
  Future sendVideoRecord(@Field() String videoID, @Field() int playWay, @Field() int longer,
      @Field() int progress, @Field() int via,
      [@Field() String tagID]);

  ///举报视频
  @POST('/mine/report')
  Future shareReport(
    @Field() String objType,
    @Field() String objID,
    @Field() String types,
    @Field() int uid,
    @Field() int objUID,
  );

  ///举报博主
  @POST('/mine/report')
  Future reportBlogger(
    @Field() String content,
    @Field() List<String> imgs,
    @Field() String objType,
    @Field() int objUID,
    @Field() String types,
    @Field() int uid,
  );

  ///发表评论(1)
  @POST(Address.SEND_COMMENT)
  Future<CommentModel> sendComment(
    @Field() String objID,
    @Field() int level,
    @Field() String content,
  { int objType,String image,}
  );

  ///发表评论(2)
  @POST(Address.SEND_COMMENT)
  Future<ReplyModel> sendReply(
    @Field() String objID,
    @Field() int level,
    @Field() String content, [
    @Field() String cid,
    @Field() String rid,
    @Field() int userID,
  ]);

  /// 取消点赞
  @POST(Address.CANCEL_LIKE)
  Future cancelLike(@Field() String objID, @Field() String type);

  ///发起点赞
  @POST(Address.SEND_LIKE)
  Future sendLike(@Field() String objID, @Field() String type);

  ///兑换码
  @POST(Address.EXCHANGE_CODE)
  Future postExChangeCode(@Field() String code);

  ///提交推广码
  @POST(Address.POST_TUI_GUANG)
  Future<dynamic> postTuiGuangCode(@Field() String code);

  ///查询推广码
  @POST(Address.QUERY_TUI_GUANG)
  Future<dynamic> QUERY_TUI_GUANG();

  ///填写推广码
  @POST(Address.PROXY_BIND)
  Future getProxyBind(
    @Field() String promotionCode,
  );

  ///购买视频
  @POST(Address.BUY_VIDEO)
  Future postBuyVideo(
    @Field() String productID,
    @Field() String name,
    @Field() int amount,
    @Field() int productType,
  );

  ///购买视频 +观影券
  @POST(Address.BUY_VIDEO)
  Future postBuyVideoWithDiscountCard(
    @Field() String productID,
    @Field() String name,
    @Field() int amount,
    @Field() int productType,
    @Field() int gold,
  );

  ///购买d楼凤使用优惠卷
  @POST(Address.BUY_VIDEO)
  Future postBuyLouFengWithDisCountCard(
    @Field() String productID,
    @Field() String name,
    @Field() int amount,
    @Field() int productType,
    @Field() String couponId,
  );

  ///购买裸聊
  @POST(Address.BUY_VIDEO)
  Future postBuyNakeChat(
    @Field() String productID,
    @Field() int productType,
    @Field() String serviceId,
  );

  ///购买小说
  @POST(Address.BUY_VIDEO)
  Future postBuyNovel(@Field() int productType, @Field() String productID, [@Field() String chapterID]);

  ///购买视频
  @POST('/mine/reward')
  Future reward(
    @Field() String vid,
    @Field() String coins,
    @Field() String msg,
  );

  /// 关注用户
  @POST(Address.FOLLOW)
  Future getFollow(
    @Field() int followUID,
    @Field() bool isFollow,
  );

  /// 收藏、取消收藏
  @POST(Address.COLLECT_URL)
  Future changeTagStatus(
    @Field() String objID,
    @Field() bool isCollect,
    @Field() String type,
  );

  /// 搜索视频专区下级页面
  @POST(Address.SEARCH_TOPIC_API)
  Future<SearchTopicModel> loadSearchTopicData(
    @Field() int pageNumber,
    @Field() int pageSize,
    @Field() String theme,
  );

  /// 点击收藏
  @POST(Address.COLLECT_URL)
  Future clickCollect(
    @Field() String objID,
    @Field() String type,
    @Field() bool isCollect,
  );

  /// 是否想去这个城市
  @POST(Address.COLLECT_URL)
  Future isWantGoCity(
    @Field() String objID,
    @Field() String type,
    @Field() bool isCollect,
  );

  /// 获取约炮搜索详情(loufeng)
  @POST(Address.SEARCH_TALK_API)
  Future<LouFengModel> getSearchData(
    @Field() int pageNumber,
    @Field() int pageSize,
    @Field() List<String> keyWords,
    @Field() String realm,
  );

  /// 获取搜索详情(talk)
  @POST(Address.SEARCH_TALK_API)
  Future<SearchTalkObj> getTalkData(
    @Field() int pageNumber,
    @Field() int pageSize,
    @Field() List<String> keyWords,
    @Field() String realm,
  );

  /// 获取搜索详情(video)
  @POST(Address.SEARCH_TALK_API)
  Future<SearchVideoObj> getVideoData(
    @Field() int pageNumber,
    @Field() int pageSize,
    @Field() List<String> keyWords,
    @Field() String realm,
  );

  /// 获取搜索详情(user)
  @POST(Address.SEARCH_TALK_API)
  Future<SearchUserObj> getUserData(
    @Field() int pageNumber,
    @Field() int pageSize,
    @Field() List<String> keyWords,
    @Field() String realm,
  );

  /// 设备和二维码登陆
  /// [devID] 设备id
  /// [qrCnt] qr二维码
  /// [devType] 设备信息
  /// [sysType] ios/android
  /// [ver] version
  /// [buildID] packageName
  /// [devToken] 登录设备id验签
  /// [cutInfos] 粘贴板信息
  @POST(Address.DEV_LOGIN)
  Future<UserInfoModel> devLogin(@Field() String devID, @Field() String qrCnt, @Field() String devType,
      @Field() String sysType, @Field() String ver, @Field() String buildID, @Field() String devToken,
      [@Field() String cutInfos = ""]);

  /// 手机登陆
  /// [mobile] 手机号码
  /// [code] 验证码
  @POST(Address.MOBILE_LOGIN)
  Future<MobileLoginModel> mobileLogin(@Field() String mobile, @Field() String code, @Field() String devID,
      @Field() String devType, @Field() String sysType, @Field() String ver, @Field() String buildID,
      [@Field() String cutInfos = ""]);

  /// 更新用户信息
  @POST("/mine/info")
  Future updateUserInfo(@Body() Map<String, dynamic> map);

  /// 获取用户信息
  /// uid == 0 查询自己否则查询别人
  @GET("/mine/info")
  Future<UserInfoModel> getUserInfo([@Query("uid") int uid = 0]);

  /// 获取账单列表
  @GET(Address.USER_BILL_LIST)
  Future<MineBillSectionModel> getMineBillList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("year") int year,
    @Query("month") int month,
  );

  /// 获取账单列表-new
  @GET("/mine/transaction")
  Future<RechargeRecordModel> getMineTransaction(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  /// 银行卡删除
  @DELETE(Address.USER_BANKCARD_DELETE)
  Future<String> bankCardDelete(@Field() String id);

  ///自动定位
  @GET(Address.AUTO_LOCATION)
  Future<LocationBean> autoLocation();

  /// 获取城市详情
  @GET(Address.CITY_DETAIL)
  Future<CityDetailModel> getCityDetail(@Query("id") String id);

  /// 获取打赏列表
  @GET("/mine/reward/log")
  Future<RewardListModel> getRewardUserList(@Query("pageNumber") int pageNumber,
      [@Query("pageSize") int pageSize = Config.PAGE_SIZE]);

  /// 获取服务器时间
  @GET("/ping/sysDate")
  Future<ServerTime> getReqDate();

  /// 用户提交作品,提交视频和图片
  /// [title]
  /// [newsType] 上传类型 COVER-图集 SP-视频
  /// [tags] 视频标签数组
  /// [playTime] 视频时长
  /// [cover] 封面
  /// [coverThumb] 封面小图
  /// [seriesCover]图集图片地址
  /// [via] 视频来源
  /// [coins] 观看金币
  /// [size] 文件大小
  /// [mimeType] 文件类型
  /// [actor] 演员名字
  /// [sourceURL]资源url 为SP时 必传
  /// [sourceID]上��视频成功后 返回���ID 为SP时必传
  /// [filename] 文件名
  /// [resolution] 分辨率
  /// [ratio] 视频比例
  /// [md5] 文件摘要
  /// [freeTime] 免费观影时长
  /// [location] 地理位置信息
  @POST("/vid/submit")
  Future<String> publishPost(@Field("title") String title, String content,@Field("newsType") String newsType,
      {@Field("tags") List<String> tags,
      @Field("playTime") int playTime,
      @Field("cover") String cover,
      @Field("coverThumb") String coverThumb,
      @Field("seriesCover") List<String> seriesCover,
      @Field("via") String via,
      @Field("coins") int coins,
      @Field("size") int size,
      @Field("mimeType") String mimeType,
      @Field("actor") String actor,
      @Field("sourceURL") String sourceURL,
      @Field("sourceID") String sourceID,
      @Field("filename") String filename,
      @Field("resolution") String resolution,
      @Field("ratio") double ratio,
      @Field("md5") String md5,
      @Field("freeTime") int freeTime,
      @Field("location") Map<String, dynamic> location,
      @Field("coin") int coin,
      @Field("taskID") String taskID});

  /// 获取官方的标签
  @GET("/tag/list")
  Future<TagListModel> getTags(@Query("pageNumber") int pageNumber,
      [@Query("pageSize") int pageSize = Config.PAGE_SIZE]);

  @GET("/search/hotTag")
  Future<HotTagModel> getHotTags();

  /// 创建标签
  @POST("/tag/add/new")
  Future<TagDetailModel> createTag(@Field() String tagName);

  ///獲取客服信息
  @GET("/im/newSign")
  Future<ServicesModel> getServices();

  ///vip充值列表,新版会员中心
  @GET("/vip/product")
  Future<NewProductList> getNewVipTypeList();

  ///会员跑马灯
  @GET("/mine/announce")
  Future getVipCardAnnounce();

  /// 获取充值的类型
  @GET("/mine/rechargeTypeList")
  Future<RechargeListModel> getRechargeTypeList();

  /// 获取果币充值的类型
  @GET("/mine/currencys")
  Future<RechargeListModel> getNakeChatRechargeTypeList(@Field() int type);

  @POST("/product/buy")
  Future buyVipProduct(@Field("productType") int productType, @Field("productID") String productID,
      @Field("productName") String productName, @Field("discountedPrice") int discountedPrice,
      {@Field("") String couponId = ""});

  //获取优惠券
  @GET("/product/coupon")
  Future getCoupon(
    @Field("productType") int productType,
    @Field("productID") String productID,
  );

  /// 获取首页推荐的内容
  @GET("/recommend/vid/list")
  Future<RecommendListRes> getRecommendVideoList(@Query("pageNumber") int pageNumber,
      [@Query("pageSize") int pageSize = Config.PAGE_SIZE]);

  /// 获取首页关注的内容
  @GET("/follow/dynamics/list")
  Future<RecommendListRes> getFollowList(@Query("pageNumber") int pageNumber,
      [@Query("pageSize") int pageSize = Config.PAGE_SIZE]);

  ///获取我的关注
  @GET("/follow/list")
  Future<WatchlistModel> getFollowedUserList(@Query("pageNumber") int pageNumber,
      [@Query("pageSize") int pageSize = Config.PAGE_SIZE]);

  ///获取博主的关注
  @GET("/follow/list")
  Future<WatchlistModel> getBloggerFollowedUserList(
      @Query("pageNumber") int pageNumber, @Query("uid") int uid,
      [@Query("pageSize") int pageSize = Config.PAGE_SIZE]);
  ///意见反馈
  @POST("/mine/feedback")
  Future feedbackMutil( @Query("content") String content,
      @Query("location") String location,
      @Query("device") String device, @Query("carrier") String carrier,
      @Query("img") List<String> img,@Query("contact") String contact,
      @Query("fType") String fType,
      );
  ///意见反馈
  @POST("/mine/feedback")
  Future feedback(@Field() String content);

  ///意见反馈列表
  @GET("/mine/feedback/list")
  Future<FeedbackModel> feedbackList(
    @Query("pageNumber") int pageNumber, [
    @Query("pageSize") int pageSize = Config.PAGE_SIZE,
  ]);

  ///删除购买作品
  @POST("/product/delBrought")
  Future deleteBuyWork(@Field("productID") String id);

  /// 获取上传视频的标签
  @GET("/tag/v2/list")
  Future<PublishTagModel> getPublishTags(@Query("pageNumber") int pageNumber,
      [@Query("pageSize") int pageSize = Config.PAGE_SIZE]);

  ///获取举报类型
  @GET("/mine/report/types/list")
  Future<List<String>> getReportList();

  /// 推广记录
  @POST(Address.PROXY_BIND_RECORD)
  Future<PromotionModel> getProxyBindRecord(
    @Field() int pageSize,
    @Field() int pageNumber,
  );

  /// 推广记录收益
  @POST("/userinvite/incomelist")
  Future<InviteIncomeModel> getInviteIncomeList(
    @Field() int pageSize,
    @Field() int pageNumber,
  );

  /// 视频收益记录
  @POST("/userinvite/videolist")
  Future<VideoIncomeModel> getVideoIncomeList(
    @Field() int pageSize,
    @Field() int pageNumber,
  );

  ///获取用户的所有收益信息
  @POST("/userinvite/info")
  Future<UserIncomeModel> getUserAllIncomeInfo();

  ///查询游戏收益
  @POST("/userinvite/incomelist/wali")
  Future<GamePromotionData> getIncomeInfo(
      @Query("pageSize") int pageSize, @Query("pageNumber") int pageNumber);

  ///获取游戏钱包余额
  @POST("/userinvite/info/wali")
  Future<UserIncomeModel> getGameAllIncomeInfo();

  ///获取有声小说首页数据
  @GET("/audiobook/home")
  Future<AudioBookHomeModel> getAudioBookHome();

  ///获取有声小说详情数据
  @GET("/audiobook/get")
  Future<AudioBook> getAudioBookDetail(
    @Query("id") String id,
  );

  ///获取有声小说主播列表
  @GET("/audiobook/anchor")
  Future<AnchorModel> getAnchorList(
    @Query("pageSize") int pageSize,
    @Query("pageNumber") int pageNumber,
  );

  ///获取有声小说主播作品集
  @GET("/audiobook/anchorList")
  Future<AudioBookListModel> getAnchorAudioBookList(
    @Query("pageSize") int pageSize,
    @Query("pageNumber") int pageNumber,
    @Query("name") String name,
  );

  ///获取有声小说类型
  @GET("/audiobook/audiobookTypes")
  Future<AudioBookTypeModel> getAudioBookType();

  ///获取有声小说对应类型数据
  @GET("/audiobook/list")
  Future<AudioBookListModel> getAudioBookList(
    @Query("pageSize") int pageSize,
    @Query("pageNumber") int pageNumber,
    @Query("audiobookType") String audiobookType,
  );

  @GET("/audiobook/buylog")
  Future<AudioBookListModel> getAudioBookBuylogList(
    @Query("pageSize") int pageSize,
    @Query("pageNumber") int pageNumber,
  );

  // 获取有声小说随机列表
  @GET('/audiobook/random')
  Future<AudioBookListModel> getAudioBookRandomList(@Query("size") int size);

  // 获取有声小说收藏记录
  @GET('/mine/collect/infoList')
  Future<AudioBookListModel> getAudioBookCollectList(
      @Query("pageNumber") int pageNumber, @Query("pageSize") int pageSize, @Query("uid") int uid,
      {@Query("type") String type = 'audiobook'});

  // 获取有声小说主播收藏记录
  @GET('/mine/collect/infoList')
  Future<AnchorModel> getAnchorCollectList(
      @Query("pageNumber") int pageNumber, @Query("pageSize") int pageSize, @Query("uid") int uid,
      {@Query("type") String type = 'audioAnchor'});

  ///有声小说预览计数
  @POST("/audiobook/browse")
  Future audioBookBrowse(@Field("id") String id);

  ///获取有声小说搜索
  @GET("/audiobook/search")
  Future<AudioBookListModel> seachAudioBook(
    @Query("pageSize") int pageSize,
    @Query("pageNumber") int pageNumber,
    @Query("keyword") String keyword,
  );

  ///获取有声小说主播列表
  @GET("/audiobook/anchor/random")
  Future<AnchorModel> getAnchorRandomList(
    @Query("size") int size,
  );

  ///获取有声小说主播列表
  @POST("/product/receiveLouFengDiscount")
  Future receiveLouFengDiscount();

  ///获取vip升级信息
  @GET("/vip/upInfo")
  Future<UpGradeVipInfo> getUpVipInfo();

  ///获取vip升级的公告提示
  @GET("/vip/Announ")
  Future<ListAnnounInfo> getVipAnnoun();

  /// 主动升级vip
  @POST("/vip/up")
  Future upgradVip();

  ///自动定位
  @GET(Address.HOT_CITY_LIST)
  Future<List<NewHotCity>> getHotCity();

  /// 获取余额
  @POST('/game/dongfang/getBalance')
  Future<dynamic> getBalance();

  /// 获取游戏url
  @POST("/game/dongfang/gameEnter")
  Future getGameUrl(
    @Field("game") String gameId,
  );

  /// 划转
  @POST("/game/dongfang/transfer")
  Future transfer(
    @Field("credit") int amount,
  );

  /// 获取游戏金额充值列表
  @POST("/game/dongfang/jine/list")
  Future<RechargeListModel> getGameAmountList();

  /// 获取划转费率
  @GET("/game/dongfang/transfer")
  Future transferTax();

  /// 获取游戏账单列表
  @POST("/game/dongfang/translog")
  Future<dynamic> getGameMineBillList(@Query("pageNum") int pageNumber,
      [@Query("pageSize") int pageSize = Config.PAGE_SIZE]);

  /// 获取果币账单列表
  @GET("/mine/fruitCoin/bill")
  Future<dynamic> getNakeChatMineBillList(@Query("pageNum") int pageNumber,
      [@Query("pageSize") int pageSize = Config.PAGE_SIZE]);

  ///获取AV解说页面数据
  @POST("/avcomment/list")
  Future<dynamic> getAVData(@Query("PageNumber") int pageNumber,
      [@Query("pageSize") int pageSize = Config.PAGE_SIZE]);

  /// 查询AV解说详情
  @POST("avcomment/one")
  Future<dynamic> getAVCommentaryDetail(
    @Field("id") String id,
  );

  ///购买AV解说
  @POST(Address.BUY_VIDEO)
  Future<dynamic> postBuyAVCommentary(
    @Field() String productID,
    @Field() String name,
    @Field() int amount,
    @Field() int productType,
  );

  ///获取游戏公告
  @GET("/game/dongfang/announcement")
  Future<dynamic> getGameAnnouncement();

  ///首次进入游戏需要赠送金币调用
  @POST("/game/dongfang/firstEnter")
  Future<dynamic> getFirstEnterGame();

  /// 获取AV解说收藏记录
  @GET('/mine/collect/infoList')
  Future<dynamic> getAVCommentaryCollectList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("uid") int uid,
    @Query("type") String type,
  );

  /// 获取AV解说购买记录
  @GET('/avcomment/buylog')
  Future<dynamic> getAVCommentaryBuyList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  /// 获取裸聊购买记录
  @GET('/nude/chat/buy/record')
  Future<dynamic> getNakeChatBuyList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  /// 获取裸聊收藏记录
  @GET('/nude/chat/collect/record')
  Future<dynamic> getNakeChatCollectList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  /// 取消点赞
  @POST(Address.CANCEL_LIKE)
  Future cancelLikeAVCommentary(@Field() String objID, @Field() String type, @Field() String tagID);

  /// 查询签到信息
  @GET('/task/sign')
  Future<dynamic> getDayMark();

  /// 签到
  @POST('/task/sign')
  Future<dynamic> postDayMark(
    @Field() String productID,
  );

  /// 查询任务信息
  @GET('/task')
  Future<dynamic> getTask();

  /// 领取宝箱
  @POST('/task/boon')
  Future<dynamic> getBox(@Field() String id, @Field() int type);

  /// 查询优惠券
  @GET('/backpack')
  Future<dynamic> getYouHuiJuan(@Field() int status, @Field() int Page, @Field() int Limit);

  /// 查询任务详情
  @GET('/task/detail')
  Future<dynamic> getTaskDetail(@Field() int type);

  /// 查询楼凤折扣优惠券
  @GET('/product/coupon')
  Future<dynamic> getLouFengDiscountCard(@Field() String id, @Field() int type);

  /// 查询裸聊列表
  @GET('/nude/chat')
  Future<dynamic> getNakeList(@Field() int pageNumber, @Field() int pageSize, @Field() int ageInterval,
      @Field() int heightInterval, @Field() int cup);

  /// 获取支付方式
  @GET('/nude/chat/pay/method')
  Future<dynamic> getNakeChatPay(@Field() String id);

  /// 查询裸聊详情
  @GET('/nude/chat/detail')
  Future<dynamic> getNakeChatDetail(
    @Field() String id,
  );

  /// 游戏充值
  @POST('/mine/topay')
  Future<dynamic> chargeGame(
    @Field() String rechargeType, [
    @Field() String productId,
    @Field() int productType,
  ]);

  /// 金币充值
  @POST('/mine/topay')
  Future<dynamic> chargeGoldCoin(
    @Field() String rechargeType, [
    @Field() String productId,
    @Field() bool isVip,
    @Field() String cId,
  ]);

  /// 果币充值
  @POST('/mine/topay')
  Future<dynamic> chargeNakeChatCoin(
    @Field() String rechargeType, [
    @Field() String productId,
    @Field() int productType,
  ]);

  /// 聊吧标签内容查询
  @GET('/vid/module')
  Future<dynamic> getTagsDetails(
    @Field() String id, [
    @Field() int sectionSize,
    @Field() int sectionPage,
    @Field() int moduleSort,
  ]);

  /// 聊吧观看历史记录查询
  @GET('/mine/watch_record/list')
  Future<dynamic> getLiaoBaTabHistory(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  /// 参赛视频
  @GET('/video_activity/list')
  Future<dynamic> getEntryVideo(
    @Query("activityId") String activityId,
    @Query("type") int type,
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  /// 往届视频
  @GET('/video_activity/history_record')
  Future<dynamic> getEntryVideoHistory(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  /// 发布详情
  @GET('/publish/details')
  Future<dynamic> getPublishDetail();

  /// 榜单列表
  @GET('/publish/leaderboard')
  Future<dynamic> getBangDanList();

  /// 榜单列表
  @GET('/search/hotVid/list')
  Future<dynamic> getSearchDefault(// @Query("pageNumber") int pageNumber,
      // @Query("pageSize") int pageSize,
      // @Query("type") int type,
      );

  /// 博主榜单
  @GET('/search/hotPublisher/list')
  Future<dynamic> getSearchDefaultBlogger(// @Query("pageNumber") int pageNumber,
      // @Query("pageSize") int pageSize,
      // @Query("type") int type,
      );

  ///获取社区帖子列表信息
  ///[type] 0，最新；1，最热 ；2，同城；3，付费
  ///[subType] 最热需要 0日榜；1周榜；2月榜；
  ///[reqDate] 服务器时间
  @GET(Address.COMMUNITY_LIST_TOPIC)
  Future<dynamic> getPostListNew(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("type") String type,
    @Query("reqDate") String reqDate,
  );

  ///精品推荐
  @GET(Address.MINE_WORKS)
  Future<MineVideo> getRecommandVideoList(
      @Query("pageSize") int pageSize,
      @Query("pageNumber") int pageNumber,
      @Query("newsType") String newsType,
      @Query("type") String type,
      @Query("uid") int uid);

//@Query("reqDate") String reqDate,
  ///转发帖子
  @POST("/vid/forward")
  Future<dynamic> forward(
    @Field("vid") String vid,
  );

  ///热门推荐
  @GET("/search/hotVid/list")
  Future<dynamic> hotRecommend();

  @GET("/recommend/user/list")
  Future<dynamic> guessLike(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  /// 搜索
  @POST(Address.SEARCH_TALK_API)
  Future<dynamic> getSearchDataNew(
    @Field() int pageNumber,
    @Field() int pageSize,
    @Field() List<String> keyWords,
    @Field() String realm,
  );


  ///发布帖子时选择
  @POST("/publisher/list")
  Future<dynamic> publisherTags();

  /// 新版话题
  @GET(Address.TAG_VIDEO_LIST)
  Future<TagBean> requestTopicDetail(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("tagID") String tagID,
    @Query("newsType") String newsType,
  );

  /// 搜索
  @GET("/vid/search")
  Future<dynamic> getSearchVideo(
    @Field() int pageNumber,
    @Field() int pageSize,
    @Field() String keyword,
    @Field() String videoType,
  );

  ///置顶帖子
  @POST('/vid/work/top')
  Future setTopVideo(
    @Field() int action,
    @Field() String videoId,
    @Field() String type,
  );

  ///推广帖子
  @POST('/vid/work/top')
  Future setPromoteVideo(
    @Field() int action,
    @Field() String videoId,
    @Field() String type,
    @Field() int actionPop,
    @Field() String popId,
  );

  ///查询视频
  @GET(Address.VIDEO_INFO)
  // Future<dynamic> getVideoDetail(@Query("videoID") String videoID);
  Future<dynamic> getVideoDetail(
    @Query("videoID") String videoID,
    @Field() String sectionId,
  );

  @POST('/mine/reward')
  Future rewardBlogger(
    @Field() int uid,
    @Field() String coins,
    @Field() String msg,
  );

  @GET('/msg/session/list')
  Future<dynamic>  getMessageList(
    @Field() int pageNumber,
    @Field() int pageSize,
  );

  @GET('/msg/message/list')
  Future getMessageDetail(
    @Field() int pageNumber,
    @Field() int pageSize,
    @Field() String sessionId,
  );

  @POST('/msg/priLetter/add')
  Future sendMessage(
    @Field() int takeUid,
    @Field() String content,
  );

  @POST('/msg/priLetter/add')
  Future sendImageMessage(
      @Field() int takeUid,
      List<String> imgUrl
      );

  @GET('/msg/session/get')
  Future<dynamic> getSessionId(
    @Field() int takeUid,
  );

  @GET('/msg/dynamic/list') // //1.点赞消息 2.评论消息
  Future<dynamic> getDynamic(
    @Field() int pageNumber,
    @Field() int pageSize,
  {int dynamicMsgType}
  );

  @GET('/mine/iIncomes')
  Future<dynamic> getInCome(
    @Field() int pageNumber,
    @Field() int pageSize,
  );

  @GET('/annou/msg/list')
  Future<dynamic> getDynamicAnnounce(
    @Field() int pageNumber,
    @Field() int pageSize,
  );

  /// 获取账单列表
  @GET(Address.MY_BILL_LIST)
  Future<MineBillSectionModel> getMyBillList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  /// 获取任务中心列表
  @GET(Address.MY_APP_TASK)
  Future<TaskCenterData> getMyTaskList();

  @GET(Address.OFFICE_APP)
  Future<List<OfficeItemData>> getOfficeList(@Query("type") int type);

  /// 我的作品
  @GET(Address.MINE_WORKS)
  Future<MineVideo> getMyWorks(
    @Query("pageSize") int pageSize,
    @Query("pageNumber") int pageNumber,
    @Query("status") String status,
  );

  /// 我的合集
  @GET(Address.MINE_WORKS_Unit_List)
  Future<MineWorkUnit> getWorkUnitList(
      @Query("page") int page, @Query("limit") int limit, @Query("uid") int uid, int type);

  ///合集视频列表
  @GET(Address.MINE_WORKS_Unit_Video_List)
  Future<MineWorkUnitDetail> getWorkUnitVideoList(
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("reqDate") String reqDate,
    @Query("cid") String cid, // 合集 ID
    @Query("uid") int uid, //
    int type,
  );

  ///我的模块 - 新增合集
  @POST(Address.MINE_WORKS_Unit_Add)
  Future postWorkUnitAdd(
    @Query("collectionName") String collectionName,
    @Query("collectionDesc") String collectionDesc,
    @Query("coverImg") String coverImg,
    @Query("price") int price,
    @Query('type') int type, //0个人作品 1个人收藏
  );

  ///我的模块 - 新增合集视频
  @POST(Address.MINE_WORKS_Unit_Video_Add)
  Future postWorkUnitVideoAdd(
    @Query("cid") String cid, // 合集id
    @Query("vIds") List<String> vIds, // 视频id
  );

  ///我的模块 - 新增合集视频
  @POST(Address.MINE_WORKS_Unit_Video_Delete)
  Future postWorkUnitVideoDelete(
    @Query("cid") String cid, // 合集id
    @Query("vIds") List<String> vIds, // 视频id
  );

  ///我的模块 - 推广作品列表
  @POST(Address.MINE_WORKS_Video_Pop)
  Future getWorkUnitVideoPop(
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("uid") int uid, //
    @Query("vidTitle") String vidTitle,
  );

  ///楼凤验证
  @POST(Address.MY_CERTIFICATION)
  Future submitMyCertificaiton();

  ///心愿工单-问题列表
  @GET(Address.DESIRE_LIST)
  Future<WishListData> getWishList(@Field() int pageNumber, @Field() int pageSize, [@Field() String uid]);

  ///心愿工单详情-评论列表
  @GET(Address.DESIRE_CMT_LIST)
  Future<CommentListRes> getDesireCmtList(
    @Query("objID") String objID,
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  @POST(Address.SUBMIT_DESIRE)
  Future submitDesire(
    @Field() int bountyGold,
    @Field() List<String> images,
    @Field() String question,
  );

  @POST(Address.ADOPTION_DESIRE)
  Future adoption(
    @Field() String commentId,
    @Field() String desireId,
  );

  ///提现配置信息
  @GET(Address.WITHDRAW_CONFIG)
  Future<WithdrawConfig> withdrawConfig();

  /// 更换博主主页背景
  @GET("/mine/userresource/list")
  Future<dynamic> getBloggerBackground(@Query("pageSize") int pageSize, @Query("pageNumber") int pageNumber,
      [@Field() String type]);

  /// 更新用户信息
  @POST("/mine/info")
  Future<dynamic> setBackground(
    @Field() List<String> lists,
    @Field() String type,
    @Field() bool isDefaultSource,
  );

  ///查询视频
  @GET(Address.VIDEO_INFO)
  Future<dynamic> getWordImageDetail(@Query("videoID") String videoID);

  ///发送短信
  @POST(Address.NOTIFICATION_SMS)
  Future postNotificationSms(@Field() String mobile, [@Field() int type]);

  ///绑定手机号
  @POST(Address.BIND_PHONE_NEW)
  Future postBindPhone(
    @Field() String mobile,
    @Field() String code,
  );

  ///发表评论(1)
  @POST(Address.SEND_WISH_COMMENT)
  Future<CommentModel> sendWishComment(
    @Field() String objID,
    @Field() int level,
    @Field() String content, [
    @Field() String cid,
    @Field() String rid,
    @Field() String cmtType,
  ]);

  ///发表评论(2)
  @POST(Address.SEND_WISH_COMMENT)
  Future<ReplyModel> sendWishReply(
    @Field() String objID,
    @Field() int level,
    @Field() String content, [
    @Field() String cid,
    @Field() String rid,
    @Field() String cmtType,
  ]);

  @GET(Address.FANS_LIST)
  Future<FansObj> getBloggerFansList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("uid") int uid,
  );

  @GET(Address.GET_REWARD_AVATAR)
  Future<dynamic> getRewardAvatar(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("uid") int uid,
  );

  @GET(Address.GET_OFFICIALCERT_STATUS)
  Future<dynamic> getOfficialCertStatus();

  ///购买视频
  @POST(Address.BUY_VIDEO)
  Future postBuyOfficicalCert(
    @Field() String productID,
    @Field() int productType,
  );

  ///心愿工单详情
  @GET(Address.WISH_DETAIL)
  Future<dynamic> wishDetailReq(@Field() String id);

  @GET(Address.COMMUNITY_RECOMMENT_LIST)
  Future<dynamic> getCommunityRecommentList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("tag") String tag,
    @Query("reqDate") String reqDate,
  );

  @GET(Address.COMMUNITY_RECOMMENT_LIST)
  Future<dynamic> getCommunityRecommentListHotVideo(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("tag") String tag,
    @Query("reqDate") String reqDate,
    @Query("isPopping") bool isPopping,
  );

  @GET(Address.COMMUNITY_HOT_LIST)
  Future<dynamic> communityHotlist(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("newsType") String newsType,
    @Query("reqDate") String reqDate,
  );

  ///推荐-换一换功能
  @GET(Address.RECOMMEND_USER_CHANGE_FUNC_LIST)
  Future<dynamic> getRecommendChangeFuncList();

  @GET(Address.RECOMMEND_USER_CHANGE_FUNC_LIST)
  Future<dynamic> getRecommendChangeFuncListDetail();

  ///删除消息
  @POST(Address.DEL_MSG_SESSION)
  Future delMsgSession(@Field() String sessionId);

  @GET("/modules/exchange_announce")
  Future<dynamic> getExchangeMarQuee(//@Query("pageNumber") int pageNumber,
      // @Query("pageSize") int pageSize,
      );

  @GET("/vid/pop_config/list")
  Future<dynamic> getPromoteConfig(//@Query("pageNumber") int pageNumber,
      // @Query("pageSize") int pageSize,
      );

  @GET("/vid/example_config/list")
  Future<dynamic> getExample(//@Query("pageNumber") int pageNumber,
      // @Query("pageSize") int pageSize,
      );

  /// 获取金币加购券
  @GET("/coupon/list")
  Future<dynamic> getTickets(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("type") int type,
  );

  /// 获取AI脱衣记录列表
  @GET("/ai/undress/list") // 1、进行中 2、生成成功 3、生成失败
  Future<AiRecordEntity> getAiRecordList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("type") int status,
  );

  /// 获取AI视频换脸记录列表
  @GET("/ai/changeface/list") // 1、进行中 2、生成成功 3、生成失败
  Future<AiRecordEntity> getAiFaceRecordList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("type") int status,
  );

  /// 获取AI图片换脸记录列表
  @GET("/ai/img/list") // 1、进行中 2、生成成功 3、生成失败
  Future<AiRecordEntity> getAiFacePictureRecordList(
      @Query("pageNumber") int pageNumber,
      @Query("pageSize") int pageSize,
      @Query("type") int status,
      );

  //生成AI脱衣记录
  @POST("/ai/undress/generate")
  Future<dynamic> aiGenerate(
    @Query("originPic") List<String> originPics,
  );

  //生成视频AI换脸记录
  @POST("/ai/changeface/generate")
  Future<dynamic> aiFaceGenerate(@Query("picture") List<String> picture, @Query("vidModId") String vidModId,
      {@Query("discount") List<String> discount});

  //生成图片AI换脸记录
  @POST("/ai/img/generate")
  Future<dynamic> aiFacegenerateByPicture(@Query("picture") String originPic, @Query("vidModId") String vidModId,
      {@Query("discount") List<String> discount});

  @GET("/ai/changeface/mod/list")
  Future<dynamic> getAIFaceModel(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
  );

  @GET("/ai/mod/list")
  Future<dynamic> getAIModelList();

  @GET("/ai/changeface/mod/getById")
  Future<dynamic> getAIModelDetail();

  ///删除AI订单
  @POST("/ai/undress/hide")
  Future<dynamic> deleteAiBill(
    @Query("id") String id,
  );

  ///删除AI换脸订单
  @POST("/ai/changeface/hide")
  Future<dynamic> deleteAiFaceBill(
    @Query("id") String id,
  );

  ///删除AI图片换脸订单
  @POST("/ai/img/hide")
  Future<dynamic> deleteAiImageFaceBill(
      @Query("id") String id,
      );


  //获取交易话题
  @GET("/trade/cate/list")
  Future<dynamic> getTradeTopicList();

  //获取交易列表
  @GET("/trade/list")
  Future<dynamic> getTradeList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("typeID") String typeID,
  );

  //获取我的交易列表
  @GET("/trade/mine")
  Future<dynamic> getMyTradeList(
    @Query("pageNumber") int pageNumber,
    @Query("pageSize") int pageSize,
    @Query("verifyStatus") String verifyStatus,
  );

  //用户下单
  @GET("/trade/order")
  Future<dynamic> orderTrade(@Query("id") String tradeId, @Query("leaveMsg") String leaveMsg);

  //取消交易
  @GET("/trade/cancel")
  Future<dynamic> cancelTrade(
    @Query("id") String tradeId,
  );

  //完成交易
  @GET("/trade/finish")
  Future<dynamic> finishTrade(@Query("id") String tradeId);

  //获取冻结金币
  @GET("/mine/freeze")
  Future<dynamic> freezeAmount();

  //获取投票接口
  @GET("/vote/list")
  Future<dynamic> voteList();

  //用户投票
  @GET("/vote/submit")
  Future<dynamic> voteSubmit(List<String> voteIDs, String optionID);

  //热榜列表(周榜、月榜)
  @GET("/top/list")
  Future<dynamic> getTopList(@Query("rankType") String rankType, {@Query("seriesID") String seriesID});

  //热榜列表（黑马博主）
  @GET("/top/list")
  Future<dynamic> getHMUpList({@Query("count") int count});

  //热榜期数
  @GET("/top/series/list")
  Future<TopListCircleModel> getTopSeriesList(
      @Query("pageNumber") int pageNumber, @Query("pageSize") int pageSize);

  //获取视频排行榜信息
  @GET("/top/vid/topInfo")
  Future<dynamic> topInfo(String vid);

  //交易详情
  @GET("/trade/info")
  Future<dynamic> tradeInfo(@Query("id") String tradeId);

  @GET("/mine/collect/batch")
  Future<dynamic> collectBatch(List<String> ids, String type, bool isCollect);

  //删除合集
  @GET("/video_collection/del")
  Future<dynamic> collectionDel(String cId);

  //查询我的消息
  @GET("/ping/checkMessageTip")
  Future<dynamic> checkMessageTip();

  ///积分兑换
  @POST("/product/exchangeIntegral")
  Future exchangeIntegral(@Field() String id);

  ///做任务
  @POST("/task/do")
  Future doTask(@Field() String taskId, @Field() int type);

  ///领取任务奖励
  @POST("/task/receive")
  Future receiveTask(@Field() String taskId, @Field() int type);

  ///消耗下载次数
  @POST("/mine/download/use")
  Future useDownLoadCount();


  ///消耗下载次数
  @POST("/product/getAwVip")
  Future getAwVip();


  @GET("/recreation/list")
  Future<dynamic> happyList();

  @GET("/recreation/click")
  //娱乐模块点击统计事件接口
  // id  点击id
  // type  广告类型. app 或 adv
  // sysType  设备类型. android或ios
  Future<dynamic> recreationList(String id,String type);

  Future<dynamic>  getSystemMessage(int pageNumber, int pageSize);

  Future<dynamic>  getTopicList(int pageNumber, int pageSize);

  Future<dynamic>  getTopicDetail(String id);

  Future<dynamic>  getTopicUpdate(String id);

  Future<dynamic>  getVoteGroup(int pageNumber, int pageSize);

  Future<dynamic>  getVoteDetail(String groupId, int pageNumber, int pageSize);

  Future<dynamic>  postVoteSubmit(String groupId, List<String> optionIds);

  Future<dynamic>  getVoteResult(String groupId);
}

//执行脚本
//flutter packages pub run build_runner build --delete-conflicting-outputs
