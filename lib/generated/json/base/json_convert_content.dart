// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: prefer_single_quotes

import 'package:flutter_app/generated/json/a_v_commentary_detail_entity_helper.dart';
import 'package:flutter_app/generated/json/a_v_commentary_entity_helper.dart';
import 'package:flutter_app/generated/json/activity_entity_helper.dart';
import 'package:flutter_app/generated/json/add_bean_entity_helper.dart';
import 'package:flutter_app/generated/json/add_user_entity_helper.dart';
import 'package:flutter_app/generated/json/agent_girl_list_entity_helper.dart';
import 'package:flutter_app/generated/json/announce_liao_ba_entity_helper.dart';
import 'package:flutter_app/generated/json/announce_vip_card_entity_helper.dart';
import 'package:flutter_app/generated/json/announcement_entity_helper.dart';
import 'package:flutter_app/generated/json/bang_dan_detail_entity_helper.dart';
import 'package:flutter_app/generated/json/buy_av_commentary_result_entity_helper.dart';
import 'package:flutter_app/generated/json/country_code_entity_helper.dart';
import 'package:flutter_app/generated/json/coupon_entity_helper.dart';
import 'package:flutter_app/generated/json/day_mark_entity_helper.dart';
import 'package:flutter_app/generated/json/dynamic_entity_helper.dart';
import 'package:flutter_app/generated/json/entry_history_entity_helper.dart';
import 'package:flutter_app/generated/json/entry_video_entity_helper.dart';
import 'package:flutter_app/generated/json/entry_videohistory_entity_helper.dart';
import 'package:flutter_app/generated/json/film_tv_video_detail_entity_helper.dart';
import 'package:flutter_app/generated/json/game_balance_entity_helper.dart';
import 'package:flutter_app/generated/json/game_bill_detail_entity_helper.dart';
import 'package:flutter_app/generated/json/game_promotion_entity_helper.dart';
import 'package:flutter_app/generated/json/guess_like_entity_helper.dart';
import 'package:flutter_app/generated/json/hot_recommend_entity_helper.dart';
import 'package:flutter_app/generated/json/liao_ba_history_entity_helper.dart';
import 'package:flutter_app/generated/json/liao_ba_tags_detail_entity_helper.dart';
import 'package:flutter_app/generated/json/lou_feng_discount_card_entity_helper.dart';
import 'package:flutter_app/generated/json/message_detail_entity_helper.dart';
import 'package:flutter_app/generated/json/message_list_entity_helper.dart';
import 'package:flutter_app/generated/json/nake_chat_bill_detail_entity_helper.dart';
import 'package:flutter_app/generated/json/publish_detail_entity_helper.dart';
import 'package:flutter_app/generated/json/reward_avatar_entity_helper.dart';
import 'package:flutter_app/generated/json/search_bean_entity_helper.dart';
import 'package:flutter_app/generated/json/search_default_entity_helper.dart';
import 'package:flutter_app/generated/json/search_default_hot_blogger_entity_helper.dart';
import 'package:flutter_app/generated/json/search_topic_entity_helper.dart';
import 'package:flutter_app/generated/json/search_video_entity_helper.dart';
import 'package:flutter_app/generated/json/selected_tags_entity_helper.dart';
import 'package:flutter_app/generated/json/switch_avatar_entity_helper.dart';
import 'package:flutter_app/generated/json/switch_background_entity_helper.dart';
import 'package:flutter_app/generated/json/tabs_tag_entity_helper.dart';
import 'package:flutter_app/generated/json/tags_detail_entity_helper.dart';
import 'package:flutter_app/generated/json/tags_liao_ba_entity_helper.dart';
import 'package:flutter_app/generated/json/task_center_entity_helper.dart';
import 'package:flutter_app/generated/json/task_detail_entity_helper.dart';
import 'package:flutter_app/generated/json/task_entity_helper.dart';
import 'package:flutter_app/generated/json/transfer_result_entity_helper.dart';
import 'package:flutter_app/generated/json/vip_announce_entity_helper.dart';
import 'package:flutter_app/generated/json/wish_list_entity_helper.dart';
import 'package:flutter_app/generated/json/withdraw_config_entity_helper.dart';
import 'package:flutter_app/generated/json/you_hui_juan_entity_helper.dart';
import 'package:flutter_app/model/agent_girl_list_entity.dart';
import 'package:flutter_app/model/announce_liao_ba_entity.dart';
import 'package:flutter_app/model/announce_vip_card_entity.dart';
import 'package:flutter_app/model/announcement_entity.dart';
import 'package:flutter_app/model/bang_dan_detail_entity.dart';
import 'package:flutter_app/model/country_code_entity.dart';
import 'package:flutter_app/model/coupon_entity.dart';
import 'package:flutter_app/model/entry_history_entity.dart';
import 'package:flutter_app/model/entry_video_entity.dart';
import 'package:flutter_app/model/entry_videohistory_entity.dart';
import 'package:flutter_app/model/film_tv_video/film_tv_video_detail_entity.dart';
import 'package:flutter_app/model/game_promotion_entity.dart';
import 'package:flutter_app/model/liao_ba_history_entity.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/publish_detail_entity.dart';
import 'package:flutter_app/model/search_default_entity.dart';
import 'package:flutter_app/model/search_default_hot_blogger_entity.dart';
import 'package:flutter_app/model/selected_tags_entity.dart';
import 'package:flutter_app/model/tabs_tag_entity.dart';
import 'package:flutter_app/model/tags_detail_entity.dart';
import 'package:flutter_app/model/tags_liao_ba_entity.dart';
import 'package:flutter_app/model/user/task_center_entity.dart';
import 'package:flutter_app/model/user/wish_list_entity.dart';
import 'package:flutter_app/model/vip_announce_entity.dart';
import 'package:flutter_app/model/wallet/withdraw_config_entity.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/day_mark_entity.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/lou_feng_discount_card_entity.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/task_detail_entity.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/task_entity.dart';
import 'package:flutter_app/page/game_page/bean/game_balance_entity.dart';
import 'package:flutter_app/page/game_page/bean/transfer_result_entity.dart';
import 'package:flutter_app/page/home/AVCommentary/bean/a_v_commentary_detail_entity.dart';
import 'package:flutter_app/page/home/AVCommentary/bean/a_v_commentary_entity.dart';
import 'package:flutter_app/page/home/AVCommentary/bean/buy_av_commentary_result_entity.dart';
import 'package:flutter_app/page/setting/you_hui_juan/you_hui_juan_entity.dart';
import 'package:flutter_app/page/user/switch_avatar_entity.dart';
import 'package:flutter_app/page/wallet/game_bill_detail/game_bill_detail_entity.dart';
import 'package:flutter_app/page/wallet/pay_for_nake_chat/model/nake_chat_bill_detail_entity.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/guess_like_entity.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/hot_recommend_entity.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_bean_entity.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_topic_entity.dart';
import 'package:flutter_app/weibo_page/community_recommend/search/search_result/search_video_entity.dart';
import 'package:flutter_app/weibo_page/message/activity_entity.dart';
import 'package:flutter_app/weibo_page/message/add/add_bean_entity.dart';
import 'package:flutter_app/weibo_page/message/add/add_user_entity.dart';
import 'package:flutter_app/weibo_page/message/dynamic_entity.dart';
import 'package:flutter_app/weibo_page/message/message_detail/message_detail_entity.dart';

// This file is automatically generated. DO NOT EDIT, all your changes would be lost.
import 'package:flutter_app/weibo_page/message/message_list_entity.dart';
import 'package:flutter_app/weibo_page/widget/reward_avatar_entity.dart';
import 'package:flutter_app/weibo_page/widget/switch_background_entity.dart';

class JsonConvert<T> {
  T fromJson(Map<String, dynamic> json) {
    return _getFromJson<T>(runtimeType, this, json);
  }

  Map<String, dynamic> toJson() {
    return _getToJson<T>(runtimeType, this);
  }

  static _getFromJson<T>(Type type, data, json) {
    switch (type) {
      case MessageListEntity:
        return messageListEntityFromJson(data as MessageListEntity, json) as T;
      case MessageListData:
        return messageListDataFromJson(data as MessageListData, json) as T;
      case MessageListDataList:
        return messageListDataListFromJson(data as MessageListDataList, json) as T;
      case SwitchBackgroundEntity:
        return switchBackgroundEntityFromJson(data as SwitchBackgroundEntity, json) as T;
      case SwitchBackgroundData:
        return switchBackgroundDataFromJson(data as SwitchBackgroundData, json) as T;
      case SwitchBackgroundDataList:
        return switchBackgroundDataListFromJson(data as SwitchBackgroundDataList, json) as T;
      case SearchDefaultEntity:
        return searchDefaultEntityFromJson(data as SearchDefaultEntity, json) as T;
      case SearchDefaultData:
        return searchDefaultDataFromJson(data as SearchDefaultData, json) as T;
      case SearchDefaultDataList:
        return searchDefaultDataListFromJson(data as SearchDefaultDataList, json) as T;
      case SearchDefaultDataListTags:
        return searchDefaultDataListTagsFromJson(data as SearchDefaultDataListTags, json) as T;
      case SearchDefaultDataListPublisher:
        return searchDefaultDataListPublisherFromJson(data as SearchDefaultDataListPublisher, json) as T;
      case SearchDefaultDataListLocation:
        return searchDefaultDataListLocationFromJson(data as SearchDefaultDataListLocation, json) as T;
      case SearchDefaultDataListVidStatus:
        return searchDefaultDataListVidStatusFromJson(data as SearchDefaultDataListVidStatus, json) as T;
      case SearchDefaultDataListComment:
        return searchDefaultDataListCommentFromJson(data as SearchDefaultDataListComment, json) as T;
      case SearchDefaultDataListWatch:
        return searchDefaultDataListWatchFromJson(data as SearchDefaultDataListWatch, json) as T;
      case TaskCenterData:
        return taskCenterDataFromJson(data as TaskCenterData, json) as T;
      case TaskCenterDataTaskList:
        return taskCenterDataTaskListFromJson(data as TaskCenterDataTaskList, json) as T;
      case TagsDetailEntity:
        return tagsDetailEntityFromJson(data as TagsDetailEntity, json) as T;
      case TagsDetailData:
        return tagsDetailDataFromJson(data as TagsDetailData, json) as T;
      case TagsDetailDataSections:
        return tagsDetailDataSectionsFromJson(data as TagsDetailDataSections, json) as T;
      case TagsDetailDataSectionsVideoInfo:
        return tagsDetailDataSectionsVideoInfoFromJson(data as TagsDetailDataSectionsVideoInfo, json) as T;
      case TagsDetailDataSectionsVideoInfoTags:
        return tagsDetailDataSectionsVideoInfoTagsFromJson(data as TagsDetailDataSectionsVideoInfoTags, json)
            as T;
      case TagsDetailDataSectionsVideoInfoPublisher:
        return tagsDetailDataSectionsVideoInfoPublisherFromJson(
            data as TagsDetailDataSectionsVideoInfoPublisher, json) as T;
      case TagsDetailDataSectionsVideoInfoLocation:
        return tagsDetailDataSectionsVideoInfoLocationFromJson(
            data as TagsDetailDataSectionsVideoInfoLocation, json) as T;
      case TagsDetailDataSectionsVideoInfoVidStatus:
        return tagsDetailDataSectionsVideoInfoVidStatusFromJson(
            data as TagsDetailDataSectionsVideoInfoVidStatus, json) as T;
      case TagsDetailDataSectionsVideoInfoComment:
        return tagsDetailDataSectionsVideoInfoCommentFromJson(
            data as TagsDetailDataSectionsVideoInfoComment, json) as T;
      case TagsDetailDataSectionsVideoInfoWatch:
        return tagsDetailDataSectionsVideoInfoWatchFromJson(
            data as TagsDetailDataSectionsVideoInfoWatch, json) as T;
      case TagsDetailDataSectionsOriginalBloggerInfo:
        return tagsDetailDataSectionsOriginalBloggerInfoFromJson(
            data as TagsDetailDataSectionsOriginalBloggerInfo, json) as T;
      case SearchBeanEntity:
        return searchBeanEntityFromJson(data as SearchBeanEntity, json) as T;
      case SearchBeanData:
        return searchBeanDataFromJson(data as SearchBeanData, json) as T;
      case SearchBeanDataList:
        return searchBeanDataListFromJson(data as SearchBeanDataList, json) as T;
      case GamePromotionEntity:
        return gamePromotionEntityFromJson(data as GamePromotionEntity, json) as T;
      case GamePromotionData:
        return gamePromotionDataFromJson(data as GamePromotionData, json) as T;
      case GamePromotionDataList:
        return gamePromotionDataListFromJson(data as GamePromotionDataList, json) as T;
      case AddBeanEntity:
        return addBeanEntityFromJson(data as AddBeanEntity, json) as T;
      case AddBeanData:
        return addBeanDataFromJson(data as AddBeanData, json) as T;
      case AddBeanDataList:
        return addBeanDataListFromJson(data as AddBeanDataList, json) as T;
      case TagsLiaoBaEntity:
        return tagsLiaoBaEntityFromJson(data as TagsLiaoBaEntity, json) as T;
      case TagsLiaoBaData:
        return tagsLiaoBaDataFromJson(data as TagsLiaoBaData, json) as T;
      case TagsLiaoBaDataTags:
        return tagsLiaoBaDataTagsFromJson(data as TagsLiaoBaDataTags, json) as T;
      case GameBalanceEntity:
        return gameBalanceEntityFromJson(data as GameBalanceEntity, json) as T;
      case EntryVideohistoryEntity:
        return entryVideohistoryEntityFromJson(data as EntryVideohistoryEntity, json) as T;
      case EntryVideohistoryData:
        return entryVideohistoryDataFromJson(data as EntryVideohistoryData, json) as T;
      case EntryVideohistoryDataActivityList:
        return entryVideohistoryDataActivityListFromJson(data as EntryVideohistoryDataActivityList, json)
            as T;
      case SearchVideoEntity:
        return searchVideoEntityFromJson(data as SearchVideoEntity, json) as T;
      case SearchVideoData:
        return searchVideoDataFromJson(data as SearchVideoData, json) as T;
      case SearchVideoDataList:
        return searchVideoDataListFromJson(data as SearchVideoDataList, json) as T;
      case SearchVideoDataListTags:
        return searchVideoDataListTagsFromJson(data as SearchVideoDataListTags, json) as T;
      case SearchVideoDataListPublisher:
        return searchVideoDataListPublisherFromJson(data as SearchVideoDataListPublisher, json) as T;
      case SearchVideoDataListLocation:
        return searchVideoDataListLocationFromJson(data as SearchVideoDataListLocation, json) as T;
      case SearchVideoDataListVidStatus:
        return searchVideoDataListVidStatusFromJson(data as SearchVideoDataListVidStatus, json) as T;
      case SearchVideoDataListComment:
        return searchVideoDataListCommentFromJson(data as SearchVideoDataListComment, json) as T;
      case SearchVideoDataListWatch:
        return searchVideoDataListWatchFromJson(data as SearchVideoDataListWatch, json) as T;
      case MessageDetailEntity:
        return messageDetailEntityFromJson(data as MessageDetailEntity, json) as T;
      case MessageDetailData:
        return messageDetailDataFromJson(data as MessageDetailData, json) as T;
      case MessageDetailDataList:
        return messageDetailDataListFromJson(data as MessageDetailDataList, json) as T;
      case GameBillDetailEntity:
        return gameBillDetailEntityFromJson(data as GameBillDetailEntity, json) as T;
      case GameBillDetailData:
        return gameBillDetailDataFromJson(data as GameBillDetailData, json) as T;
      case GameBillDetailDataList:
        return gameBillDetailDataListFromJson(data as GameBillDetailDataList, json) as T;
      case DayMarkEntity:
        return dayMarkEntityFromJson(data as DayMarkEntity, json) as T;
      case DayMarkData:
        return dayMarkDataFromJson(data as DayMarkData, json) as T;
      case DayMarkDataList:
        return dayMarkDataListFromJson(data as DayMarkDataList, json) as T;
      case DayMarkDataListPrizes:
        return dayMarkDataListPrizesFromJson(data as DayMarkDataListPrizes, json) as T;
      case CouponEntity:
        return couponEntityFromJson(data as CouponEntity, json) as T;
      case CouponData:
        return couponDataFromJson(data as CouponData, json) as T;
      case CouponDataCouponList:
        return couponDataCouponListFromJson(data as CouponDataCouponList, json) as T;
      case SearchTopicEntity:
        return searchTopicEntityFromJson(data as SearchTopicEntity, json) as T;
      case SearchTopicData:
        return searchTopicDataFromJson(data as SearchTopicData, json) as T;
      case SearchTopicDataList:
        return searchTopicDataListFromJson(data as SearchTopicDataList, json) as T;
      case TaskEntity:
        return taskEntityFromJson(data as TaskEntity, json) as T;
      case TaskData:
        return taskDataFromJson(data as TaskData, json) as T;
      case TaskDataJewelBoxDetails:
        return taskDataJewelBoxDetailsFromJson(data as TaskDataJewelBoxDetails, json) as T;
      case TaskDataJewelBoxDetailsList:
        return taskDataJewelBoxDetailsListFromJson(data as TaskDataJewelBoxDetailsList, json) as T;
      case TaskDataJewelBoxDetailsListPrizes:
        return taskDataJewelBoxDetailsListPrizesFromJson(data as TaskDataJewelBoxDetailsListPrizes, json)
            as T;
      case TaskDataTaskList:
        return taskDataTaskListFromJson(data as TaskDataTaskList, json) as T;
      case TaskDataTaskListPrizes:
        return taskDataTaskListPrizesFromJson(data as TaskDataTaskListPrizes, json) as T;
      case LouFengDiscountCardEntity:
        return louFengDiscountCardEntityFromJson(data as LouFengDiscountCardEntity, json) as T;
      case LouFengDiscountCardData:
        return louFengDiscountCardDataFromJson(data as LouFengDiscountCardData, json) as T;
      case LouFengDiscountCardDataCouponList:
        return louFengDiscountCardDataCouponListFromJson(data as LouFengDiscountCardDataCouponList, json)
            as T;
      case HotRecommendEntity:
        return hotRecommendEntityFromJson(data as HotRecommendEntity, json) as T;
      case HotRecommendData:
        return hotRecommendDataFromJson(data as HotRecommendData, json) as T;
      case HotRecommendDataList:
        return hotRecommendDataListFromJson(data as HotRecommendDataList, json) as T;
      case HotRecommendDataListTags:
        return hotRecommendDataListTagsFromJson(data as HotRecommendDataListTags, json) as T;
      case HotRecommendDataListPublisher:
        return hotRecommendDataListPublisherFromJson(data as HotRecommendDataListPublisher, json) as T;
      case HotRecommendDataListLocation:
        return hotRecommendDataListLocationFromJson(data as HotRecommendDataListLocation, json) as T;
      case HotRecommendDataListVidStatus:
        return hotRecommendDataListVidStatusFromJson(data as HotRecommendDataListVidStatus, json) as T;
      case HotRecommendDataListComment:
        return hotRecommendDataListCommentFromJson(data as HotRecommendDataListComment, json) as T;
      case HotRecommendDataListWatch:
        return hotRecommendDataListWatchFromJson(data as HotRecommendDataListWatch, json) as T;
      case CountryCodeEntity:
        return countryCodeEntityFromJson(data as CountryCodeEntity, json) as T;
      case CountryCodeList:
        return countryCodeListFromJson(data as CountryCodeList, json) as T;
      case AVCommentaryEntity:
        return aVCommentaryEntityFromJson(data as AVCommentaryEntity, json) as T;
      case AVCommentaryData:
        return aVCommentaryDataFromJson(data as AVCommentaryData, json) as T;
      case AVCommentaryDataList:
        return aVCommentaryDataListFromJson(data as AVCommentaryDataList, json) as T;
      case AnnounceVipCardEntity:
        return announceVipCardEntityFromJson(data as AnnounceVipCardEntity, json) as T;
      case SwitchAvatarEntity:
        return switchAvatarEntityFromJson(data as SwitchAvatarEntity, json) as T;
      case SwitchAvatarData:
        return switchAvatarDataFromJson(data as SwitchAvatarData, json) as T;
      case SwitchAvatarDataList:
        return switchAvatarDataListFromJson(data as SwitchAvatarDataList, json) as T;
      case LiaoBaTagsDetailEntity:
        return liaoBaTagsDetailEntityFromJson(data as LiaoBaTagsDetailEntity, json) as T;
      case LiaoBaTagsDetailData:
        return liaoBaTagsDetailDataFromJson(data as LiaoBaTagsDetailData, json) as T;
      case LiaoBaTagsDetailDataVideos:
        return liaoBaTagsDetailDataVideosFromJson(data as LiaoBaTagsDetailDataVideos, json) as T;
      case LiaoBaTagsDetailDataVideosTags:
        return liaoBaTagsDetailDataVideosTagsFromJson(data as LiaoBaTagsDetailDataVideosTags, json) as T;
      case LiaoBaTagsDetailDataVideosPublisher:
        return liaoBaTagsDetailDataVideosPublisherFromJson(data as LiaoBaTagsDetailDataVideosPublisher, json)
            as T;
      case LiaoBaTagsDetailDataVideosLocation:
        return liaoBaTagsDetailDataVideosLocationFromJson(data as LiaoBaTagsDetailDataVideosLocation, json)
            as T;
      case LiaoBaTagsDetailDataVideosVidStatus:
        return liaoBaTagsDetailDataVideosVidStatusFromJson(data as LiaoBaTagsDetailDataVideosVidStatus, json)
            as T;
      case LiaoBaTagsDetailDataVideosComment:
        return liaoBaTagsDetailDataVideosCommentFromJson(data as LiaoBaTagsDetailDataVideosComment, json)
            as T;
      case LiaoBaTagsDetailDataVideosWatch:
        return liaoBaTagsDetailDataVideosWatchFromJson(data as LiaoBaTagsDetailDataVideosWatch, json) as T;
      case LiaoBaTagsDetailDataOriginalBloggerInfo:
        return liaoBaTagsDetailDataOriginalBloggerInfoFromJson(
            data as LiaoBaTagsDetailDataOriginalBloggerInfo, json) as T;
      case SearchDefaultHotBloggerEntity:
        return searchDefaultHotBloggerEntityFromJson(data as SearchDefaultHotBloggerEntity, json) as T;
      case SearchDefaultHotBloggerData:
        return searchDefaultHotBloggerDataFromJson(data as SearchDefaultHotBloggerData, json) as T;
      case SearchDefaultHotBloggerDataList:
        return searchDefaultHotBloggerDataListFromJson(data as SearchDefaultHotBloggerDataList, json) as T;
      case SearchDefaultHotBloggerDataListList:
        return searchDefaultHotBloggerDataListListFromJson(data as SearchDefaultHotBloggerDataListList, json)
            as T;
      case SearchDefaultHotBloggerDataListListTags:
        return searchDefaultHotBloggerDataListListTagsFromJson(
            data as SearchDefaultHotBloggerDataListListTags, json) as T;
      case SearchDefaultHotBloggerDataListListPublisher:
        return searchDefaultHotBloggerDataListListPublisherFromJson(
            data as SearchDefaultHotBloggerDataListListPublisher, json) as T;
      case SearchDefaultHotBloggerDataListListLocation:
        return searchDefaultHotBloggerDataListListLocationFromJson(
            data as SearchDefaultHotBloggerDataListListLocation, json) as T;
      case SearchDefaultHotBloggerDataListListVidStatus:
        return searchDefaultHotBloggerDataListListVidStatusFromJson(
            data as SearchDefaultHotBloggerDataListListVidStatus, json) as T;
      case SearchDefaultHotBloggerDataListListComment:
        return searchDefaultHotBloggerDataListListCommentFromJson(
            data as SearchDefaultHotBloggerDataListListComment, json) as T;
      case SearchDefaultHotBloggerDataListListWatch:
        return searchDefaultHotBloggerDataListListWatchFromJson(
            data as SearchDefaultHotBloggerDataListListWatch, json) as T;
      case BuyAvCommentaryResultEntity:
        return buyAvCommentaryResultEntityFromJson(data as BuyAvCommentaryResultEntity, json) as T;
      case VipAnnounceEntity:
        return vipAnnounceEntityFromJson(data as VipAnnounceEntity, json) as T;
      case VipAnnounceData:
        return vipAnnounceDataFromJson(data as VipAnnounceData, json) as T;
      case TaskDetailEntity:
        return taskDetailEntityFromJson(data as TaskDetailEntity, json) as T;
      case TaskDetailData:
        return taskDetailDataFromJson(data as TaskDetailData, json) as T;
      case TaskDetailDataTaskList:
        return taskDetailDataTaskListFromJson(data as TaskDetailDataTaskList, json) as T;
      case TaskDetailDataTaskListPrizes:
        return taskDetailDataTaskListPrizesFromJson(data as TaskDetailDataTaskListPrizes, json) as T;
      case BangDanDetailEntity:
        return bangDanDetailEntityFromJson(data as BangDanDetailEntity, json) as T;
      case BangDanDetailData:
        return bangDanDetailDataFromJson(data as BangDanDetailData, json) as T;
      case BangDanRankType:
        return bangDanRankTypeFromJson(data as BangDanRankType, json) as T;
      case BangDanDetailDataMembers:
        return bangDanDetailDataMembersFromJson(data as BangDanDetailDataMembers, json) as T;
      case YouHuiJuanEntity:
        return youHuiJuanEntityFromJson(data as YouHuiJuanEntity, json) as T;
      case YouHuiJuanData:
        return youHuiJuanDataFromJson(data as YouHuiJuanData, json) as T;
      case AgentGirlListEntity:
        return agentGirlListEntityFromJson(data as AgentGirlListEntity, json) as T;
      case AgentGirlListData:
        return agentGirlListDataFromJson(data as AgentGirlListData, json) as T;
      case AgentGirlListDataList:
        return agentGirlListDataListFromJson(data as AgentGirlListDataList, json) as T;
      case AgentGirlListDataListAgentInfo:
        return agentGirlListDataListAgentInfoFromJson(data as AgentGirlListDataListAgentInfo, json) as T;
      case DynamicEntity:
        return dynamicEntityFromJson(data as DynamicEntity, json) as T;
      case DynamicData:
        return dynamicDataFromJson(data as DynamicData, json) as T;
      case DynamicDataList:
        return dynamicDataListFromJson(data as DynamicDataList, json) as T;
      case WishListData:
        return wishListDataFromJson(data as WishListData, json) as T;
      case WishListDataList:
        return wishListDataListFromJson(data as WishListDataList, json) as T;
      case NakeChatBillDetailEntity:
        return nakeChatBillDetailEntityFromJson(data as NakeChatBillDetailEntity, json) as T;
      case NakeChatBillDetailData:
        return nakeChatBillDetailDataFromJson(data as NakeChatBillDetailData, json) as T;
      case NakeChatBillDetailDataList:
        return nakeChatBillDetailDataListFromJson(data as NakeChatBillDetailDataList, json) as T;
      case EntryHistoryEntity:
        return entryHistoryEntityFromJson(data as EntryHistoryEntity, json) as T;
      case EntryHistoryData:
        return entryHistoryDataFromJson(data as EntryHistoryData, json) as T;
      case EntryHistoryDataActivityList:
        return entryHistoryDataActivityListFromJson(data as EntryHistoryDataActivityList, json) as T;
      case SelectedTagsEntity:
        return selectedTagsEntityFromJson(data as SelectedTagsEntity, json) as T;
      case SelectedTagsData:
        return selectedTagsDataFromJson(data as SelectedTagsData, json) as T;
      case SelectedTagsDataList:
        return selectedTagsDataListFromJson(data as SelectedTagsDataList, json) as T;
      case SelectedTagsDataListTags:
        return selectedTagsDataListTagsFromJson(data as SelectedTagsDataListTags, json) as T;
      case SelectedTagsDataListPublisher:
        return selectedTagsDataListPublisherFromJson(data as SelectedTagsDataListPublisher, json) as T;
      case SelectedTagsDataListLocation:
        return selectedTagsDataListLocationFromJson(data as SelectedTagsDataListLocation, json) as T;
      case SelectedTagsDataListVidStatus:
        return selectedTagsDataListVidStatusFromJson(data as SelectedTagsDataListVidStatus, json) as T;
      case SelectedTagsDataListComment:
        return selectedTagsDataListCommentFromJson(data as SelectedTagsDataListComment, json) as T;
      case SelectedTagsDataListWatch:
        return selectedTagsDataListWatchFromJson(data as SelectedTagsDataListWatch, json) as T;
      case EntryVideoEntity:
        return entryVideoEntityFromJson(data as EntryVideoEntity, json) as T;
      case EntryVideoData:
        return entryVideoDataFromJson(data as EntryVideoData, json) as T;
      case EntryVideoDataWorkList:
        return entryVideoDataWorkListFromJson(data as EntryVideoDataWorkList, json) as T;
      case EntryVideoDataWorkListTags:
        return entryVideoDataWorkListTagsFromJson(data as EntryVideoDataWorkListTags, json) as T;
      case EntryVideoDataWorkListPublisher:
        return entryVideoDataWorkListPublisherFromJson(data as EntryVideoDataWorkListPublisher, json) as T;
      case EntryVideoDataWorkListLocation:
        return entryVideoDataWorkListLocationFromJson(data as EntryVideoDataWorkListLocation, json) as T;
      case EntryVideoDataWorkListVidStatus:
        return entryVideoDataWorkListVidStatusFromJson(data as EntryVideoDataWorkListVidStatus, json) as T;
      case EntryVideoDataWorkListComment:
        return entryVideoDataWorkListCommentFromJson(data as EntryVideoDataWorkListComment, json) as T;
      case EntryVideoDataWorkListWatch:
        return entryVideoDataWorkListWatchFromJson(data as EntryVideoDataWorkListWatch, json) as T;
      case WithdrawConfigData:
        return withdrawConfigDataFromJson(data as WithdrawConfigData, json) as T;
      case WithdrawConfigDataChannels:
        return withdrawConfigDataChannelsFromJson(data as WithdrawConfigDataChannels, json) as T;
      case AnnouncementEntity:
        return announcementEntityFromJson(data as AnnouncementEntity, json) as T;
      case GuessLikeEntity:
        return guessLikeEntityFromJson(data as GuessLikeEntity, json) as T;
      case GuessLikeData:
        return guessLikeDataFromJson(data as GuessLikeData, json) as T;
      case GuessLikeDataList:
        return guessLikeDataListFromJson(data as GuessLikeDataList, json) as T;
      case GuessLikeDataListVInfos:
        return guessLikeDataListVInfosFromJson(data as GuessLikeDataListVInfos, json) as T;
      case GuessLikeDataListVInfosTags:
        return guessLikeDataListVInfosTagsFromJson(data as GuessLikeDataListVInfosTags, json) as T;
      case GuessLikeDataListVInfosPublisher:
        return guessLikeDataListVInfosPublisherFromJson(data as GuessLikeDataListVInfosPublisher, json) as T;
      case GuessLikeDataListVInfosLocation:
        return guessLikeDataListVInfosLocationFromJson(data as GuessLikeDataListVInfosLocation, json) as T;
      case GuessLikeDataListVInfosVidStatus:
        return guessLikeDataListVInfosVidStatusFromJson(data as GuessLikeDataListVInfosVidStatus, json) as T;
      case GuessLikeDataListVInfosComment:
        return guessLikeDataListVInfosCommentFromJson(data as GuessLikeDataListVInfosComment, json) as T;
      case GuessLikeDataListVInfosWatch:
        return guessLikeDataListVInfosWatchFromJson(data as GuessLikeDataListVInfosWatch, json) as T;
      case TransferResultEntity:
        return transferResultEntityFromJson(data as TransferResultEntity, json) as T;
      case TransferResultData:
        return transferResultDataFromJson(data as TransferResultData, json) as T;
      case AnnounceLiaoBaEntity:
        return announceLiaoBaEntityFromJson(data as AnnounceLiaoBaEntity, json) as T;
      case AnnounceLiaoBaData:
        return announceLiaoBaDataFromJson(data as AnnounceLiaoBaData, json) as T;
      case AnnouncementData:
        return announcementDataFromJson(data as AnnouncementData, json) as T;
      case PublishDetailEntity:
        return publishDetailEntityFromJson(data as PublishDetailEntity, json) as T;
      case PublishDetailData:
        return publishDetailDataFromJson(data as PublishDetailData, json) as T;
      case PublishDetailDataActivityDetails:
        return publishDetailDataActivityDetailsFromJson(data as PublishDetailDataActivityDetails, json) as T;
      case PublishDetailDataLeaderboards:
        return publishDetailDataLeaderboardsFromJson(data as PublishDetailDataLeaderboards, json) as T;
      case PublishDetailDataLeaderboardsMembers:
        return publishDetailDataLeaderboardsMembersFromJson(
            data as PublishDetailDataLeaderboardsMembers, json) as T;
      case FilmTvVideoDetailEntity:
        return filmTvVideoDetailEntityFromJson(data as FilmTvVideoDetailEntity, json) as T;
      case FilmTvVideoDetailTags:
        return filmTvVideoDetailTagsFromJson(data as FilmTvVideoDetailTags, json) as T;
      case FilmTvVideoDetailPublisher:
        return filmTvVideoDetailPublisherFromJson(data as FilmTvVideoDetailPublisher, json) as T;
      case FilmTvVideoDetailLocation:
        return filmTvVideoDetailLocationFromJson(data as FilmTvVideoDetailLocation, json) as T;
      case FilmTvVideoDetailVidStatus:
        return filmTvVideoDetailVidStatusFromJson(data as FilmTvVideoDetailVidStatus, json) as T;
      case FilmTvVideoDetailComment:
        return filmTvVideoDetailCommentFromJson(data as FilmTvVideoDetailComment, json) as T;
      case FilmTvVideoDetailWatch:
        return filmTvVideoDetailWatchFromJson(data as FilmTvVideoDetailWatch, json) as T;
      case ActivityEntity:
        return activityEntityFromJson(data as ActivityEntity, json) as T;
      case ActivityData:
        return activityDataFromJson(data as ActivityData, json) as T;
      case ActivityDataList:
        return activityDataListFromJson(data as ActivityDataList, json) as T;
      case LiaoBaHistoryEntity:
        return liaoBaHistoryEntityFromJson(data as LiaoBaHistoryEntity, json) as T;
      case LiaoBaHistoryData:
        return liaoBaHistoryDataFromJson(data as LiaoBaHistoryData, json) as T;
      case LiaoBaHistoryDataWorkList:
        return liaoBaHistoryDataWorkListFromJson(data as LiaoBaHistoryDataWorkList, json) as T;
      case LiaoBaHistoryDataWorkListTags:
        return liaoBaHistoryDataWorkListTagsFromJson(data as LiaoBaHistoryDataWorkListTags, json) as T;
      case LiaoBaHistoryDataWorkListPublisher:
        return liaoBaHistoryDataWorkListPublisherFromJson(data as LiaoBaHistoryDataWorkListPublisher, json)
            as T;
      case LiaoBaHistoryDataWorkListLocation:
        return liaoBaHistoryDataWorkListLocationFromJson(data as LiaoBaHistoryDataWorkListLocation, json)
            as T;
      case LiaoBaHistoryDataWorkListVidStatus:
        return liaoBaHistoryDataWorkListVidStatusFromJson(data as LiaoBaHistoryDataWorkListVidStatus, json)
            as T;
      case LiaoBaHistoryDataWorkListComment:
        return liaoBaHistoryDataWorkListCommentFromJson(data as LiaoBaHistoryDataWorkListComment, json) as T;
      case LiaoBaHistoryDataWorkListWatch:
        return liaoBaHistoryDataWorkListWatchFromJson(data as LiaoBaHistoryDataWorkListWatch, json) as T;
      case AddUserEntity:
        return addUserEntityFromJson(data as AddUserEntity, json) as T;
      case AddUserData:
        return addUserDataFromJson(data as AddUserData, json) as T;
      case AddUserDataList:
        return addUserDataListFromJson(data as AddUserDataList, json) as T;
      case AddUserDataListVInfos:
        return addUserDataListVInfosFromJson(data as AddUserDataListVInfos, json) as T;
      case AddUserDataListVInfosTags:
        return addUserDataListVInfosTagsFromJson(data as AddUserDataListVInfosTags, json) as T;
      case AddUserDataListVInfosPublisher:
        return addUserDataListVInfosPublisherFromJson(data as AddUserDataListVInfosPublisher, json) as T;
      case AddUserDataListVInfosLocation:
        return addUserDataListVInfosLocationFromJson(data as AddUserDataListVInfosLocation, json) as T;
      case AddUserDataListVInfosVidStatus:
        return addUserDataListVInfosVidStatusFromJson(data as AddUserDataListVInfosVidStatus, json) as T;
      case AddUserDataListVInfosComment:
        return addUserDataListVInfosCommentFromJson(data as AddUserDataListVInfosComment, json) as T;
      case AddUserDataListVInfosWatch:
        return addUserDataListVInfosWatchFromJson(data as AddUserDataListVInfosWatch, json) as T;
      case TabsTagEntity:
        return tabsTagEntityFromJson(data as TabsTagEntity, json) as T;
      case TabsTagData:
        return tabsTagDataFromJson(data as TabsTagData, json) as T;
      case AVCommentaryDetailEntity:
        return aVCommentaryDetailEntityFromJson(data as AVCommentaryDetailEntity, json) as T;
      case RewardAvatarEntity:
        return rewardAvatarEntityFromJson(data as RewardAvatarEntity, json) as T;
      case RewardAvatarData:
        return rewardAvatarDataFromJson(data as RewardAvatarData, json) as T;
      case RewardAvatarDataList:
        return rewardAvatarDataListFromJson(data as RewardAvatarDataList, json) as T;
    }
    return data as T;
  }

  static _getToJson<T>(Type type, data) {
    switch (type) {
      case MessageListEntity:
        return messageListEntityToJson(data as MessageListEntity);
      case MessageListData:
        return messageListDataToJson(data as MessageListData);
      case MessageListDataList:
        return messageListDataListToJson(data as MessageListDataList);
      case SwitchBackgroundEntity:
        return switchBackgroundEntityToJson(data as SwitchBackgroundEntity);
      case SwitchBackgroundData:
        return switchBackgroundDataToJson(data as SwitchBackgroundData);
      case SwitchBackgroundDataList:
        return switchBackgroundDataListToJson(data as SwitchBackgroundDataList);
      case SearchDefaultEntity:
        return searchDefaultEntityToJson(data as SearchDefaultEntity);
      case SearchDefaultData:
        return searchDefaultDataToJson(data as SearchDefaultData);
      case SearchDefaultDataList:
        return searchDefaultDataListToJson(data as SearchDefaultDataList);
      case SearchDefaultDataListTags:
        return searchDefaultDataListTagsToJson(data as SearchDefaultDataListTags);
      case SearchDefaultDataListPublisher:
        return searchDefaultDataListPublisherToJson(data as SearchDefaultDataListPublisher);
      case SearchDefaultDataListLocation:
        return searchDefaultDataListLocationToJson(data as SearchDefaultDataListLocation);
      case SearchDefaultDataListVidStatus:
        return searchDefaultDataListVidStatusToJson(data as SearchDefaultDataListVidStatus);
      case SearchDefaultDataListComment:
        return searchDefaultDataListCommentToJson(data as SearchDefaultDataListComment);
      case SearchDefaultDataListWatch:
        return searchDefaultDataListWatchToJson(data as SearchDefaultDataListWatch);
      case TaskCenterData:
        return taskCenterDataToJson(data as TaskCenterData);
      case TaskCenterDataTaskList:
        return taskCenterDataTaskListToJson(data as TaskCenterDataTaskList);
      case TagsDetailEntity:
        return tagsDetailEntityToJson(data as TagsDetailEntity);
      case TagsDetailData:
        return tagsDetailDataToJson(data as TagsDetailData);
      case TagsDetailDataSections:
        return tagsDetailDataSectionsToJson(data as TagsDetailDataSections);
      case TagsDetailDataSectionsVideoInfo:
        return tagsDetailDataSectionsVideoInfoToJson(data as TagsDetailDataSectionsVideoInfo);
      case TagsDetailDataSectionsVideoInfoTags:
        return tagsDetailDataSectionsVideoInfoTagsToJson(data as TagsDetailDataSectionsVideoInfoTags);
      case TagsDetailDataSectionsVideoInfoPublisher:
        return tagsDetailDataSectionsVideoInfoPublisherToJson(
            data as TagsDetailDataSectionsVideoInfoPublisher);
      case TagsDetailDataSectionsVideoInfoLocation:
        return tagsDetailDataSectionsVideoInfoLocationToJson(data as TagsDetailDataSectionsVideoInfoLocation);
      case TagsDetailDataSectionsVideoInfoVidStatus:
        return tagsDetailDataSectionsVideoInfoVidStatusToJson(
            data as TagsDetailDataSectionsVideoInfoVidStatus);
      case TagsDetailDataSectionsVideoInfoComment:
        return tagsDetailDataSectionsVideoInfoCommentToJson(data as TagsDetailDataSectionsVideoInfoComment);
      case TagsDetailDataSectionsVideoInfoWatch:
        return tagsDetailDataSectionsVideoInfoWatchToJson(data as TagsDetailDataSectionsVideoInfoWatch);
      case TagsDetailDataSectionsOriginalBloggerInfo:
        return tagsDetailDataSectionsOriginalBloggerInfoToJson(
            data as TagsDetailDataSectionsOriginalBloggerInfo);
      case SearchBeanEntity:
        return searchBeanEntityToJson(data as SearchBeanEntity);
      case SearchBeanData:
        return searchBeanDataToJson(data as SearchBeanData);
      case SearchBeanDataList:
        return searchBeanDataListToJson(data as SearchBeanDataList);
      case GamePromotionEntity:
        return gamePromotionEntityToJson(data as GamePromotionEntity);
      case GamePromotionData:
        return gamePromotionDataToJson(data as GamePromotionData);
      case GamePromotionDataList:
        return gamePromotionDataListToJson(data as GamePromotionDataList);
      case AddBeanEntity:
        return addBeanEntityToJson(data as AddBeanEntity);
      case AddBeanData:
        return addBeanDataToJson(data as AddBeanData);
      case AddBeanDataList:
        return addBeanDataListToJson(data as AddBeanDataList);
      case TagsLiaoBaEntity:
        return tagsLiaoBaEntityToJson(data as TagsLiaoBaEntity);
      case TagsLiaoBaData:
        return tagsLiaoBaDataToJson(data as TagsLiaoBaData);
      case TagsLiaoBaDataTags:
        return tagsLiaoBaDataTagsToJson(data as TagsLiaoBaDataTags);
      case GameBalanceEntity:
        return gameBalanceEntityToJson(data as GameBalanceEntity);
      case EntryVideohistoryEntity:
        return entryVideohistoryEntityToJson(data as EntryVideohistoryEntity);
      case EntryVideohistoryData:
        return entryVideohistoryDataToJson(data as EntryVideohistoryData);
      case EntryVideohistoryDataActivityList:
        return entryVideohistoryDataActivityListToJson(data as EntryVideohistoryDataActivityList);
      case SearchVideoEntity:
        return searchVideoEntityToJson(data as SearchVideoEntity);
      case SearchVideoData:
        return searchVideoDataToJson(data as SearchVideoData);
      case SearchVideoDataList:
        return searchVideoDataListToJson(data as SearchVideoDataList);
      case SearchVideoDataListTags:
        return searchVideoDataListTagsToJson(data as SearchVideoDataListTags);
      case SearchVideoDataListPublisher:
        return searchVideoDataListPublisherToJson(data as SearchVideoDataListPublisher);
      case SearchVideoDataListLocation:
        return searchVideoDataListLocationToJson(data as SearchVideoDataListLocation);
      case SearchVideoDataListVidStatus:
        return searchVideoDataListVidStatusToJson(data as SearchVideoDataListVidStatus);
      case SearchVideoDataListComment:
        return searchVideoDataListCommentToJson(data as SearchVideoDataListComment);
      case SearchVideoDataListWatch:
        return searchVideoDataListWatchToJson(data as SearchVideoDataListWatch);
      case MessageDetailEntity:
        return messageDetailEntityToJson(data as MessageDetailEntity);
      case MessageDetailData:
        return messageDetailDataToJson(data as MessageDetailData);
      case MessageDetailDataList:
        return messageDetailDataListToJson(data as MessageDetailDataList);
      case GameBillDetailEntity:
        return gameBillDetailEntityToJson(data as GameBillDetailEntity);
      case GameBillDetailData:
        return gameBillDetailDataToJson(data as GameBillDetailData);
      case GameBillDetailDataList:
        return gameBillDetailDataListToJson(data as GameBillDetailDataList);
      case DayMarkEntity:
        return dayMarkEntityToJson(data as DayMarkEntity);
      case DayMarkData:
        return dayMarkDataToJson(data as DayMarkData);
      case DayMarkDataList:
        return dayMarkDataListToJson(data as DayMarkDataList);
      case DayMarkDataListPrizes:
        return dayMarkDataListPrizesToJson(data as DayMarkDataListPrizes);
      case CouponEntity:
        return couponEntityToJson(data as CouponEntity);
      case CouponData:
        return couponDataToJson(data as CouponData);
      case CouponDataCouponList:
        return couponDataCouponListToJson(data as CouponDataCouponList);
      case SearchTopicEntity:
        return searchTopicEntityToJson(data as SearchTopicEntity);
      case SearchTopicData:
        return searchTopicDataToJson(data as SearchTopicData);
      case SearchTopicDataList:
        return searchTopicDataListToJson(data as SearchTopicDataList);
      case TaskEntity:
        return taskEntityToJson(data as TaskEntity);
      case TaskData:
        return taskDataToJson(data as TaskData);
      case TaskDataJewelBoxDetails:
        return taskDataJewelBoxDetailsToJson(data as TaskDataJewelBoxDetails);
      case TaskDataJewelBoxDetailsList:
        return taskDataJewelBoxDetailsListToJson(data as TaskDataJewelBoxDetailsList);
      case TaskDataJewelBoxDetailsListPrizes:
        return taskDataJewelBoxDetailsListPrizesToJson(data as TaskDataJewelBoxDetailsListPrizes);
      case TaskDataTaskList:
        return taskDataTaskListToJson(data as TaskDataTaskList);
      case TaskDataTaskListPrizes:
        return taskDataTaskListPrizesToJson(data as TaskDataTaskListPrizes);
      case LouFengDiscountCardEntity:
        return louFengDiscountCardEntityToJson(data as LouFengDiscountCardEntity);
      case LouFengDiscountCardData:
        return louFengDiscountCardDataToJson(data as LouFengDiscountCardData);
      case LouFengDiscountCardDataCouponList:
        return louFengDiscountCardDataCouponListToJson(data as LouFengDiscountCardDataCouponList);
      case HotRecommendEntity:
        return hotRecommendEntityToJson(data as HotRecommendEntity);
      case HotRecommendData:
        return hotRecommendDataToJson(data as HotRecommendData);
      case HotRecommendDataList:
        return hotRecommendDataListToJson(data as HotRecommendDataList);
      case HotRecommendDataListTags:
        return hotRecommendDataListTagsToJson(data as HotRecommendDataListTags);
      case HotRecommendDataListPublisher:
        return hotRecommendDataListPublisherToJson(data as HotRecommendDataListPublisher);
      case HotRecommendDataListLocation:
        return hotRecommendDataListLocationToJson(data as HotRecommendDataListLocation);
      case HotRecommendDataListVidStatus:
        return hotRecommendDataListVidStatusToJson(data as HotRecommendDataListVidStatus);
      case HotRecommendDataListComment:
        return hotRecommendDataListCommentToJson(data as HotRecommendDataListComment);
      case HotRecommendDataListWatch:
        return hotRecommendDataListWatchToJson(data as HotRecommendDataListWatch);
      case CountryCodeEntity:
        return countryCodeEntityToJson(data as CountryCodeEntity);
      case CountryCodeList:
        return countryCodeListToJson(data as CountryCodeList);
      case AVCommentaryEntity:
        return aVCommentaryEntityToJson(data as AVCommentaryEntity);
      case AVCommentaryData:
        return aVCommentaryDataToJson(data as AVCommentaryData);
      case AVCommentaryDataList:
        return aVCommentaryDataListToJson(data as AVCommentaryDataList);
      case AnnounceVipCardEntity:
        return announceVipCardEntityToJson(data as AnnounceVipCardEntity);
      case SwitchAvatarEntity:
        return switchAvatarEntityToJson(data as SwitchAvatarEntity);
      case SwitchAvatarData:
        return switchAvatarDataToJson(data as SwitchAvatarData);
      case SwitchAvatarDataList:
        return switchAvatarDataListToJson(data as SwitchAvatarDataList);
      case LiaoBaTagsDetailEntity:
        return liaoBaTagsDetailEntityToJson(data as LiaoBaTagsDetailEntity);
      case LiaoBaTagsDetailData:
        return liaoBaTagsDetailDataToJson(data as LiaoBaTagsDetailData);
      case LiaoBaTagsDetailDataVideos:
        return liaoBaTagsDetailDataVideosToJson(data as LiaoBaTagsDetailDataVideos);
      case LiaoBaTagsDetailDataVideosTags:
        return liaoBaTagsDetailDataVideosTagsToJson(data as LiaoBaTagsDetailDataVideosTags);
      case LiaoBaTagsDetailDataVideosPublisher:
        return liaoBaTagsDetailDataVideosPublisherToJson(data as LiaoBaTagsDetailDataVideosPublisher);
      case LiaoBaTagsDetailDataVideosLocation:
        return liaoBaTagsDetailDataVideosLocationToJson(data as LiaoBaTagsDetailDataVideosLocation);
      case LiaoBaTagsDetailDataVideosVidStatus:
        return liaoBaTagsDetailDataVideosVidStatusToJson(data as LiaoBaTagsDetailDataVideosVidStatus);
      case LiaoBaTagsDetailDataVideosComment:
        return liaoBaTagsDetailDataVideosCommentToJson(data as LiaoBaTagsDetailDataVideosComment);
      case LiaoBaTagsDetailDataVideosWatch:
        return liaoBaTagsDetailDataVideosWatchToJson(data as LiaoBaTagsDetailDataVideosWatch);
      case LiaoBaTagsDetailDataOriginalBloggerInfo:
        return liaoBaTagsDetailDataOriginalBloggerInfoToJson(data as LiaoBaTagsDetailDataOriginalBloggerInfo);
      case SearchDefaultHotBloggerEntity:
        return searchDefaultHotBloggerEntityToJson(data as SearchDefaultHotBloggerEntity);
      case SearchDefaultHotBloggerData:
        return searchDefaultHotBloggerDataToJson(data as SearchDefaultHotBloggerData);
      case SearchDefaultHotBloggerDataList:
        return searchDefaultHotBloggerDataListToJson(data as SearchDefaultHotBloggerDataList);
      case SearchDefaultHotBloggerDataListList:
        return searchDefaultHotBloggerDataListListToJson(data as SearchDefaultHotBloggerDataListList);
      case SearchDefaultHotBloggerDataListListTags:
        return searchDefaultHotBloggerDataListListTagsToJson(data as SearchDefaultHotBloggerDataListListTags);
      case SearchDefaultHotBloggerDataListListPublisher:
        return searchDefaultHotBloggerDataListListPublisherToJson(
            data as SearchDefaultHotBloggerDataListListPublisher);
      case SearchDefaultHotBloggerDataListListLocation:
        return searchDefaultHotBloggerDataListListLocationToJson(
            data as SearchDefaultHotBloggerDataListListLocation);
      case SearchDefaultHotBloggerDataListListVidStatus:
        return searchDefaultHotBloggerDataListListVidStatusToJson(
            data as SearchDefaultHotBloggerDataListListVidStatus);
      case SearchDefaultHotBloggerDataListListComment:
        return searchDefaultHotBloggerDataListListCommentToJson(
            data as SearchDefaultHotBloggerDataListListComment);
      case SearchDefaultHotBloggerDataListListWatch:
        return searchDefaultHotBloggerDataListListWatchToJson(
            data as SearchDefaultHotBloggerDataListListWatch);
      case BuyAvCommentaryResultEntity:
        return buyAvCommentaryResultEntityToJson(data as BuyAvCommentaryResultEntity);
      case VipAnnounceEntity:
        return vipAnnounceEntityToJson(data as VipAnnounceEntity);
      case VipAnnounceData:
        return vipAnnounceDataToJson(data as VipAnnounceData);
      case TaskDetailEntity:
        return taskDetailEntityToJson(data as TaskDetailEntity);
      case TaskDetailData:
        return taskDetailDataToJson(data as TaskDetailData);
      case TaskDetailDataTaskList:
        return taskDetailDataTaskListToJson(data as TaskDetailDataTaskList);
      case TaskDetailDataTaskListPrizes:
        return taskDetailDataTaskListPrizesToJson(data as TaskDetailDataTaskListPrizes);
      case BangDanDetailEntity:
        return bangDanDetailEntityToJson(data as BangDanDetailEntity);
      case BangDanDetailData:
        return bangDanDetailDataToJson(data as BangDanDetailData);
      case BangDanRankType:
        return bangDanRankTypeToJson(data as BangDanRankType);
      case BangDanDetailDataMembers:
        return bangDanDetailDataMembersToJson(data as BangDanDetailDataMembers);
      case YouHuiJuanEntity:
        return youHuiJuanEntityToJson(data as YouHuiJuanEntity);
      case YouHuiJuanData:
        return youHuiJuanDataToJson(data as YouHuiJuanData);
      case AgentGirlListEntity:
        return agentGirlListEntityToJson(data as AgentGirlListEntity);
      case AgentGirlListData:
        return agentGirlListDataToJson(data as AgentGirlListData);
      case AgentGirlListDataList:
        return agentGirlListDataListToJson(data as AgentGirlListDataList);
      case AgentGirlListDataListAgentInfo:
        return agentGirlListDataListAgentInfoToJson(data as AgentGirlListDataListAgentInfo);
      case DynamicEntity:
        return dynamicEntityToJson(data as DynamicEntity);
      case DynamicData:
        return dynamicDataToJson(data as DynamicData);
      case DynamicDataList:
        return dynamicDataListToJson(data as DynamicDataList);
      case WishListData:
        return wishListDataToJson(data as WishListData);
      case WishListDataList:
        return wishListDataListToJson(data as WishListDataList);
      case NakeChatBillDetailEntity:
        return nakeChatBillDetailEntityToJson(data as NakeChatBillDetailEntity);
      case NakeChatBillDetailData:
        return nakeChatBillDetailDataToJson(data as NakeChatBillDetailData);
      case NakeChatBillDetailDataList:
        return nakeChatBillDetailDataListToJson(data as NakeChatBillDetailDataList);
      case EntryHistoryEntity:
        return entryHistoryEntityToJson(data as EntryHistoryEntity);
      case EntryHistoryData:
        return entryHistoryDataToJson(data as EntryHistoryData);
      case EntryHistoryDataActivityList:
        return entryHistoryDataActivityListToJson(data as EntryHistoryDataActivityList);
      case SelectedTagsEntity:
        return selectedTagsEntityToJson(data as SelectedTagsEntity);
      case SelectedTagsData:
        return selectedTagsDataToJson(data as SelectedTagsData);
      case SelectedTagsDataList:
        return selectedTagsDataListToJson(data as SelectedTagsDataList);
      case SelectedTagsDataListTags:
        return selectedTagsDataListTagsToJson(data as SelectedTagsDataListTags);
      case SelectedTagsDataListPublisher:
        return selectedTagsDataListPublisherToJson(data as SelectedTagsDataListPublisher);
      case SelectedTagsDataListLocation:
        return selectedTagsDataListLocationToJson(data as SelectedTagsDataListLocation);
      case SelectedTagsDataListVidStatus:
        return selectedTagsDataListVidStatusToJson(data as SelectedTagsDataListVidStatus);
      case SelectedTagsDataListComment:
        return selectedTagsDataListCommentToJson(data as SelectedTagsDataListComment);
      case SelectedTagsDataListWatch:
        return selectedTagsDataListWatchToJson(data as SelectedTagsDataListWatch);
      case EntryVideoEntity:
        return entryVideoEntityToJson(data as EntryVideoEntity);
      case EntryVideoData:
        return entryVideoDataToJson(data as EntryVideoData);
      case EntryVideoDataWorkList:
        return entryVideoDataWorkListToJson(data as EntryVideoDataWorkList);
      case EntryVideoDataWorkListTags:
        return entryVideoDataWorkListTagsToJson(data as EntryVideoDataWorkListTags);
      case EntryVideoDataWorkListPublisher:
        return entryVideoDataWorkListPublisherToJson(data as EntryVideoDataWorkListPublisher);
      case EntryVideoDataWorkListLocation:
        return entryVideoDataWorkListLocationToJson(data as EntryVideoDataWorkListLocation);
      case EntryVideoDataWorkListVidStatus:
        return entryVideoDataWorkListVidStatusToJson(data as EntryVideoDataWorkListVidStatus);
      case EntryVideoDataWorkListComment:
        return entryVideoDataWorkListCommentToJson(data as EntryVideoDataWorkListComment);
      case EntryVideoDataWorkListWatch:
        return entryVideoDataWorkListWatchToJson(data as EntryVideoDataWorkListWatch);
      case WithdrawConfigData:
        return withdrawConfigDataToJson(data as WithdrawConfigData);
      case WithdrawConfigDataChannels:
        return withdrawConfigDataChannelsToJson(data as WithdrawConfigDataChannels);
      case AnnouncementEntity:
        return announcementEntityToJson(data as AnnouncementEntity);
      case GuessLikeEntity:
        return guessLikeEntityToJson(data as GuessLikeEntity);
      case GuessLikeData:
        return guessLikeDataToJson(data as GuessLikeData);
      case GuessLikeDataList:
        return guessLikeDataListToJson(data as GuessLikeDataList);
      case GuessLikeDataListVInfos:
        return guessLikeDataListVInfosToJson(data as GuessLikeDataListVInfos);
      case GuessLikeDataListVInfosTags:
        return guessLikeDataListVInfosTagsToJson(data as GuessLikeDataListVInfosTags);
      case GuessLikeDataListVInfosPublisher:
        return guessLikeDataListVInfosPublisherToJson(data as GuessLikeDataListVInfosPublisher);
      case GuessLikeDataListVInfosLocation:
        return guessLikeDataListVInfosLocationToJson(data as GuessLikeDataListVInfosLocation);
      case GuessLikeDataListVInfosVidStatus:
        return guessLikeDataListVInfosVidStatusToJson(data as GuessLikeDataListVInfosVidStatus);
      case GuessLikeDataListVInfosComment:
        return guessLikeDataListVInfosCommentToJson(data as GuessLikeDataListVInfosComment);
      case GuessLikeDataListVInfosWatch:
        return guessLikeDataListVInfosWatchToJson(data as GuessLikeDataListVInfosWatch);
      case TransferResultEntity:
        return transferResultEntityToJson(data as TransferResultEntity);
      case TransferResultData:
        return transferResultDataToJson(data as TransferResultData);
      case AnnounceLiaoBaEntity:
        return announceLiaoBaEntityToJson(data as AnnounceLiaoBaEntity);
      case AnnounceLiaoBaData:
        return announceLiaoBaDataToJson(data as AnnounceLiaoBaData);
      case AnnouncementData:

      case PublishDetailEntity:
        return publishDetailEntityToJson(data as PublishDetailEntity);
      case PublishDetailData:
        return publishDetailDataToJson(data as PublishDetailData);
      case PublishDetailDataActivityDetails:
        return publishDetailDataActivityDetailsToJson(data as PublishDetailDataActivityDetails);
      case PublishDetailDataLeaderboards:
        return publishDetailDataLeaderboardsToJson(data as PublishDetailDataLeaderboards);
      case PublishDetailDataLeaderboardsMembers:
        return publishDetailDataLeaderboardsMembersToJson(data as PublishDetailDataLeaderboardsMembers);
      case FilmTvVideoDetailEntity:
        return filmTvVideoDetailEntityToJson(data as FilmTvVideoDetailEntity);
      case FilmTvVideoDetailTags:
        return filmTvVideoDetailTagsToJson(data as FilmTvVideoDetailTags);
      case FilmTvVideoDetailPublisher:
        return filmTvVideoDetailPublisherToJson(data as FilmTvVideoDetailPublisher);
      case FilmTvVideoDetailLocation:
        return filmTvVideoDetailLocationToJson(data as FilmTvVideoDetailLocation);
      case FilmTvVideoDetailVidStatus:
        return filmTvVideoDetailVidStatusToJson(data as FilmTvVideoDetailVidStatus);
      case FilmTvVideoDetailComment:
        return filmTvVideoDetailCommentToJson(data as FilmTvVideoDetailComment);
      case FilmTvVideoDetailWatch:
        return filmTvVideoDetailWatchToJson(data as FilmTvVideoDetailWatch);
      case ActivityEntity:
        return activityEntityToJson(data as ActivityEntity);
      case ActivityData:
        return activityDataToJson(data as ActivityData);
      case ActivityDataList:
        return activityDataListToJson(data as ActivityDataList);
      case LiaoBaHistoryEntity:
        return liaoBaHistoryEntityToJson(data as LiaoBaHistoryEntity);
      case LiaoBaHistoryData:
        return liaoBaHistoryDataToJson(data as LiaoBaHistoryData);
      case LiaoBaHistoryDataWorkList:
        return liaoBaHistoryDataWorkListToJson(data as LiaoBaHistoryDataWorkList);
      case LiaoBaHistoryDataWorkListTags:
        return liaoBaHistoryDataWorkListTagsToJson(data as LiaoBaHistoryDataWorkListTags);
      case LiaoBaHistoryDataWorkListPublisher:
        return liaoBaHistoryDataWorkListPublisherToJson(data as LiaoBaHistoryDataWorkListPublisher);
      case LiaoBaHistoryDataWorkListLocation:
        return liaoBaHistoryDataWorkListLocationToJson(data as LiaoBaHistoryDataWorkListLocation);
      case LiaoBaHistoryDataWorkListVidStatus:
        return liaoBaHistoryDataWorkListVidStatusToJson(data as LiaoBaHistoryDataWorkListVidStatus);
      case LiaoBaHistoryDataWorkListComment:
        return liaoBaHistoryDataWorkListCommentToJson(data as LiaoBaHistoryDataWorkListComment);
      case LiaoBaHistoryDataWorkListWatch:
        return liaoBaHistoryDataWorkListWatchToJson(data as LiaoBaHistoryDataWorkListWatch);
      case AddUserEntity:
        return addUserEntityToJson(data as AddUserEntity);
      case AddUserData:
        return addUserDataToJson(data as AddUserData);
      case AddUserDataList:
        return addUserDataListToJson(data as AddUserDataList);
      case AddUserDataListVInfos:
        return addUserDataListVInfosToJson(data as AddUserDataListVInfos);
      case AddUserDataListVInfosTags:
        return addUserDataListVInfosTagsToJson(data as AddUserDataListVInfosTags);
      case AddUserDataListVInfosPublisher:
        return addUserDataListVInfosPublisherToJson(data as AddUserDataListVInfosPublisher);
      case AddUserDataListVInfosLocation:
        return addUserDataListVInfosLocationToJson(data as AddUserDataListVInfosLocation);
      case AddUserDataListVInfosVidStatus:
        return addUserDataListVInfosVidStatusToJson(data as AddUserDataListVInfosVidStatus);
      case AddUserDataListVInfosComment:
        return addUserDataListVInfosCommentToJson(data as AddUserDataListVInfosComment);
      case AddUserDataListVInfosWatch:
        return addUserDataListVInfosWatchToJson(data as AddUserDataListVInfosWatch);
      case TabsTagEntity:
        return tabsTagEntityToJson(data as TabsTagEntity);
      case TabsTagData:
        return tabsTagDataToJson(data as TabsTagData);
      case AVCommentaryDetailEntity:
        return aVCommentaryDetailEntityToJson(data as AVCommentaryDetailEntity);
      case RewardAvatarEntity:
        return rewardAvatarEntityToJson(data as RewardAvatarEntity);
      case RewardAvatarData:
        return rewardAvatarDataToJson(data as RewardAvatarData);
      case RewardAvatarDataList:
        return rewardAvatarDataListToJson(data as RewardAvatarDataList);
    }
    return data as T;
  }

  //Go back to a single instance by type
  static _fromJsonSingle<M>(json) {
    String type = M.toString();
    if (type == (MessageListEntity).toString()) {
      return MessageListEntity().fromJson(json);
    }
    if (type == (MessageListData).toString()) {
      return MessageListData().fromJson(json);
    }
    if (type == (MessageListDataList).toString()) {
      return MessageListDataList().fromJson(json);
    }
    if (type == (SwitchBackgroundEntity).toString()) {
      return SwitchBackgroundEntity().fromJson(json);
    }
    if (type == (SwitchBackgroundData).toString()) {
      return SwitchBackgroundData().fromJson(json);
    }
    if (type == (SwitchBackgroundDataList).toString()) {
      return SwitchBackgroundDataList().fromJson(json);
    }
    if (type == (SearchDefaultEntity).toString()) {
      return SearchDefaultEntity().fromJson(json);
    }
    if (type == (SearchDefaultData).toString()) {
      return SearchDefaultData().fromJson(json);
    }
    if (type == (SearchDefaultDataList).toString()) {
      return SearchDefaultDataList().fromJson(json);
    }
    if (type == (SearchDefaultDataListTags).toString()) {
      return SearchDefaultDataListTags().fromJson(json);
    }
    if (type == (SearchDefaultDataListPublisher).toString()) {
      return SearchDefaultDataListPublisher().fromJson(json);
    }
    if (type == (SearchDefaultDataListLocation).toString()) {
      return SearchDefaultDataListLocation().fromJson(json);
    }
    if (type == (SearchDefaultDataListVidStatus).toString()) {
      return SearchDefaultDataListVidStatus().fromJson(json);
    }
    if (type == (SearchDefaultDataListComment).toString()) {
      return SearchDefaultDataListComment().fromJson(json);
    }
    if (type == (SearchDefaultDataListWatch).toString()) {
      return SearchDefaultDataListWatch().fromJson(json);
    }
    if (type == (TaskCenterData).toString()) {
      return TaskCenterData().fromJson(json);
    }
    if (type == (TaskCenterDataTaskList).toString()) {
      return TaskCenterDataTaskList().fromJson(json);
    }
    if (type == (TagsDetailEntity).toString()) {
      return TagsDetailEntity().fromJson(json);
    }
    if (type == (TagsDetailData).toString()) {
      return TagsDetailData().fromJson(json);
    }
    if (type == (TagsDetailDataSections).toString()) {
      return TagsDetailDataSections().fromJson(json);
    }
    if (type == (TagsDetailDataSectionsVideoInfo).toString()) {
      return TagsDetailDataSectionsVideoInfo().fromJson(json);
    }
    if (type == (TagsDetailDataSectionsVideoInfoTags).toString()) {
      return TagsDetailDataSectionsVideoInfoTags().fromJson(json);
    }
    if (type == (TagsDetailDataSectionsVideoInfoPublisher).toString()) {
      return TagsDetailDataSectionsVideoInfoPublisher().fromJson(json);
    }
    if (type == (TagsDetailDataSectionsVideoInfoLocation).toString()) {
      return TagsDetailDataSectionsVideoInfoLocation().fromJson(json);
    }
    if (type == (TagsDetailDataSectionsVideoInfoVidStatus).toString()) {
      return TagsDetailDataSectionsVideoInfoVidStatus().fromJson(json);
    }
    if (type == (TagsDetailDataSectionsVideoInfoComment).toString()) {
      return TagsDetailDataSectionsVideoInfoComment().fromJson(json);
    }
    if (type == (TagsDetailDataSectionsVideoInfoWatch).toString()) {
      return TagsDetailDataSectionsVideoInfoWatch().fromJson(json);
    }
    if (type == (TagsDetailDataSectionsOriginalBloggerInfo).toString()) {
      return TagsDetailDataSectionsOriginalBloggerInfo().fromJson(json);
    }
    if (type == (SearchBeanEntity).toString()) {
      return SearchBeanEntity().fromJson(json);
    }
    if (type == (SearchBeanData).toString()) {
      return SearchBeanData().fromJson(json);
    }
    if (type == (SearchBeanDataList).toString()) {
      return SearchBeanDataList().fromJson(json);
    }
    if (type == (GamePromotionEntity).toString()) {
      return GamePromotionEntity().fromJson(json);
    }
    if (type == (GamePromotionData).toString()) {
      return GamePromotionData().fromJson(json);
    }
    if (type == (GamePromotionDataList).toString()) {
      return GamePromotionDataList().fromJson(json);
    }
    if (type == (AddBeanEntity).toString()) {
      return AddBeanEntity().fromJson(json);
    }
    if (type == (AddBeanData).toString()) {
      return AddBeanData().fromJson(json);
    }
    if (type == (AddBeanDataList).toString()) {
      return AddBeanDataList().fromJson(json);
    }
    if (type == (TagsLiaoBaEntity).toString()) {
      return TagsLiaoBaEntity().fromJson(json);
    }
    if (type == (TagsLiaoBaData).toString()) {
      return TagsLiaoBaData().fromJson(json);
    }
    if (type == (TagsLiaoBaDataTags).toString()) {
      return TagsLiaoBaDataTags().fromJson(json);
    }
    if (type == (GameBalanceEntity).toString()) {
      return GameBalanceEntity().fromJson(json);
    }
    if (type == (EntryVideohistoryEntity).toString()) {
      return EntryVideohistoryEntity().fromJson(json);
    }
    if (type == (EntryVideohistoryData).toString()) {
      return EntryVideohistoryData().fromJson(json);
    }
    if (type == (EntryVideohistoryDataActivityList).toString()) {
      return EntryVideohistoryDataActivityList().fromJson(json);
    }
    if (type == (SearchVideoEntity).toString()) {
      return SearchVideoEntity().fromJson(json);
    }
    if (type == (SearchVideoData).toString()) {
      return SearchVideoData().fromJson(json);
    }
    if (type == (SearchVideoDataList).toString()) {
      return SearchVideoDataList().fromJson(json);
    }
    if (type == (SearchVideoDataListTags).toString()) {
      return SearchVideoDataListTags().fromJson(json);
    }
    if (type == (SearchVideoDataListPublisher).toString()) {
      return SearchVideoDataListPublisher().fromJson(json);
    }
    if (type == (SearchVideoDataListLocation).toString()) {
      return SearchVideoDataListLocation().fromJson(json);
    }
    if (type == (SearchVideoDataListVidStatus).toString()) {
      return SearchVideoDataListVidStatus().fromJson(json);
    }
    if (type == (SearchVideoDataListComment).toString()) {
      return SearchVideoDataListComment().fromJson(json);
    }
    if (type == (SearchVideoDataListWatch).toString()) {
      return SearchVideoDataListWatch().fromJson(json);
    }
    if (type == (MessageDetailEntity).toString()) {
      return MessageDetailEntity().fromJson(json);
    }
    if (type == (MessageDetailData).toString()) {
      return MessageDetailData().fromJson(json);
    }
    if (type == (MessageDetailDataList).toString()) {
      return MessageDetailDataList().fromJson(json);
    }
    if (type == (GameBillDetailEntity).toString()) {
      return GameBillDetailEntity().fromJson(json);
    }
    if (type == (GameBillDetailData).toString()) {
      return GameBillDetailData().fromJson(json);
    }
    if (type == (GameBillDetailDataList).toString()) {
      return GameBillDetailDataList().fromJson(json);
    }
    if (type == (DayMarkEntity).toString()) {
      return DayMarkEntity().fromJson(json);
    }
    if (type == (DayMarkData).toString()) {
      return DayMarkData().fromJson(json);
    }
    if (type == (DayMarkDataList).toString()) {
      return DayMarkDataList().fromJson(json);
    }
    if (type == (DayMarkDataListPrizes).toString()) {
      return DayMarkDataListPrizes().fromJson(json);
    }
    if (type == (CouponEntity).toString()) {
      return CouponEntity().fromJson(json);
    }
    if (type == (CouponData).toString()) {
      return CouponData().fromJson(json);
    }
    if (type == (CouponDataCouponList).toString()) {
      return CouponDataCouponList().fromJson(json);
    }
    if (type == (SearchTopicEntity).toString()) {
      return SearchTopicEntity().fromJson(json);
    }
    if (type == (SearchTopicData).toString()) {
      return SearchTopicData().fromJson(json);
    }
    if (type == (SearchTopicDataList).toString()) {
      return SearchTopicDataList().fromJson(json);
    }
    if (type == (TaskEntity).toString()) {
      return TaskEntity().fromJson(json);
    }
    if (type == (TaskData).toString()) {
      return TaskData().fromJson(json);
    }
    if (type == (TaskDataJewelBoxDetails).toString()) {
      return TaskDataJewelBoxDetails().fromJson(json);
    }
    if (type == (TaskDataJewelBoxDetailsList).toString()) {
      return TaskDataJewelBoxDetailsList().fromJson(json);
    }
    if (type == (TaskDataJewelBoxDetailsListPrizes).toString()) {
      return TaskDataJewelBoxDetailsListPrizes().fromJson(json);
    }
    if (type == (TaskDataTaskList).toString()) {
      return TaskDataTaskList().fromJson(json);
    }
    if (type == (TaskDataTaskListPrizes).toString()) {
      return TaskDataTaskListPrizes().fromJson(json);
    }
    if (type == (LouFengDiscountCardEntity).toString()) {
      return LouFengDiscountCardEntity().fromJson(json);
    }
    if (type == (LouFengDiscountCardData).toString()) {
      return LouFengDiscountCardData().fromJson(json);
    }
    if (type == (LouFengDiscountCardDataCouponList).toString()) {
      return LouFengDiscountCardDataCouponList().fromJson(json);
    }
    if (type == (HotRecommendEntity).toString()) {
      return HotRecommendEntity().fromJson(json);
    }
    if (type == (HotRecommendData).toString()) {
      return HotRecommendData().fromJson(json);
    }
    if (type == (HotRecommendDataList).toString()) {
      return HotRecommendDataList().fromJson(json);
    }
    if (type == (HotRecommendDataListTags).toString()) {
      return HotRecommendDataListTags().fromJson(json);
    }
    if (type == (HotRecommendDataListPublisher).toString()) {
      return HotRecommendDataListPublisher().fromJson(json);
    }
    if (type == (HotRecommendDataListLocation).toString()) {
      return HotRecommendDataListLocation().fromJson(json);
    }
    if (type == (HotRecommendDataListVidStatus).toString()) {
      return HotRecommendDataListVidStatus().fromJson(json);
    }
    if (type == (HotRecommendDataListComment).toString()) {
      return HotRecommendDataListComment().fromJson(json);
    }
    if (type == (HotRecommendDataListWatch).toString()) {
      return HotRecommendDataListWatch().fromJson(json);
    }
    if (type == (CountryCodeEntity).toString()) {
      return CountryCodeEntity().fromJson(json);
    }
    if (type == (CountryCodeList).toString()) {
      return CountryCodeList().fromJson(json);
    }
    if (type == (AVCommentaryEntity).toString()) {
      return AVCommentaryEntity().fromJson(json);
    }
    if (type == (AVCommentaryData).toString()) {
      return AVCommentaryData().fromJson(json);
    }
    if (type == (AVCommentaryDataList).toString()) {
      return AVCommentaryDataList().fromJson(json);
    }
    if (type == (AnnounceVipCardEntity).toString()) {
      return AnnounceVipCardEntity().fromJson(json);
    }
    if (type == (SwitchAvatarEntity).toString()) {
      return SwitchAvatarEntity().fromJson(json);
    }
    if (type == (SwitchAvatarData).toString()) {
      return SwitchAvatarData().fromJson(json);
    }
    if (type == (SwitchAvatarDataList).toString()) {
      return SwitchAvatarDataList().fromJson(json);
    }
    if (type == (LiaoBaTagsDetailEntity).toString()) {
      return LiaoBaTagsDetailEntity().fromJson(json);
    }
    if (type == (LiaoBaTagsDetailData).toString()) {
      return LiaoBaTagsDetailData().fromJson(json);
    }
    if (type == (LiaoBaTagsDetailDataVideos).toString()) {
      return LiaoBaTagsDetailDataVideos().fromJson(json);
    }
    if (type == (LiaoBaTagsDetailDataVideosTags).toString()) {
      return LiaoBaTagsDetailDataVideosTags().fromJson(json);
    }
    if (type == (LiaoBaTagsDetailDataVideosPublisher).toString()) {
      return LiaoBaTagsDetailDataVideosPublisher().fromJson(json);
    }
    if (type == (LiaoBaTagsDetailDataVideosLocation).toString()) {
      return LiaoBaTagsDetailDataVideosLocation().fromJson(json);
    }
    if (type == (LiaoBaTagsDetailDataVideosVidStatus).toString()) {
      return LiaoBaTagsDetailDataVideosVidStatus().fromJson(json);
    }
    if (type == (LiaoBaTagsDetailDataVideosComment).toString()) {
      return LiaoBaTagsDetailDataVideosComment().fromJson(json);
    }
    if (type == (LiaoBaTagsDetailDataVideosWatch).toString()) {
      return LiaoBaTagsDetailDataVideosWatch().fromJson(json);
    }
    if (type == (LiaoBaTagsDetailDataOriginalBloggerInfo).toString()) {
      return LiaoBaTagsDetailDataOriginalBloggerInfo().fromJson(json);
    }
    if (type == (SearchDefaultHotBloggerEntity).toString()) {
      return SearchDefaultHotBloggerEntity().fromJson(json);
    }
    if (type == (SearchDefaultHotBloggerData).toString()) {
      return SearchDefaultHotBloggerData().fromJson(json);
    }
    if (type == (SearchDefaultHotBloggerDataList).toString()) {
      return SearchDefaultHotBloggerDataList().fromJson(json);
    }
    if (type == (SearchDefaultHotBloggerDataListList).toString()) {
      return SearchDefaultHotBloggerDataListList().fromJson(json);
    }
    if (type == (SearchDefaultHotBloggerDataListListTags).toString()) {
      return SearchDefaultHotBloggerDataListListTags().fromJson(json);
    }
    if (type == (SearchDefaultHotBloggerDataListListPublisher).toString()) {
      return SearchDefaultHotBloggerDataListListPublisher().fromJson(json);
    }
    if (type == (SearchDefaultHotBloggerDataListListLocation).toString()) {
      return SearchDefaultHotBloggerDataListListLocation().fromJson(json);
    }
    if (type == (SearchDefaultHotBloggerDataListListVidStatus).toString()) {
      return SearchDefaultHotBloggerDataListListVidStatus().fromJson(json);
    }
    if (type == (SearchDefaultHotBloggerDataListListComment).toString()) {
      return SearchDefaultHotBloggerDataListListComment().fromJson(json);
    }
    if (type == (SearchDefaultHotBloggerDataListListWatch).toString()) {
      return SearchDefaultHotBloggerDataListListWatch().fromJson(json);
    }
    if (type == (BuyAvCommentaryResultEntity).toString()) {
      return BuyAvCommentaryResultEntity().fromJson(json);
    }
    if (type == (VipAnnounceEntity).toString()) {
      return VipAnnounceEntity().fromJson(json);
    }
    if (type == (VipAnnounceData).toString()) {
      return VipAnnounceData().fromJson(json);
    }
    if (type == (TaskDetailEntity).toString()) {
      return TaskDetailEntity().fromJson(json);
    }
    if (type == (TaskDetailData).toString()) {
      return TaskDetailData().fromJson(json);
    }
    if (type == (TaskDetailDataTaskList).toString()) {
      return TaskDetailDataTaskList().fromJson(json);
    }
    if (type == (TaskDetailDataTaskListPrizes).toString()) {
      return TaskDetailDataTaskListPrizes().fromJson(json);
    }
    if (type == (BangDanDetailEntity).toString()) {
      return BangDanDetailEntity().fromJson(json);
    }
    if (type == (BangDanDetailData).toString()) {
      return BangDanDetailData().fromJson(json);
    }
    if (type == (BangDanRankType).toString()) {
      return BangDanRankType().fromJson(json);
    }
    if (type == (BangDanDetailDataMembers).toString()) {
      return BangDanDetailDataMembers().fromJson(json);
    }
    if (type == (YouHuiJuanEntity).toString()) {
      return YouHuiJuanEntity().fromJson(json);
    }
    if (type == (YouHuiJuanData).toString()) {
      return YouHuiJuanData().fromJson(json);
    }
    if (type == (AgentGirlListEntity).toString()) {
      return AgentGirlListEntity().fromJson(json);
    }
    if (type == (AgentGirlListData).toString()) {
      return AgentGirlListData().fromJson(json);
    }
    if (type == (AgentGirlListDataList).toString()) {
      return AgentGirlListDataList().fromJson(json);
    }
    if (type == (AgentGirlListDataListAgentInfo).toString()) {
      return AgentGirlListDataListAgentInfo().fromJson(json);
    }
    if (type == (DynamicEntity).toString()) {
      return DynamicEntity().fromJson(json);
    }
    if (type == (DynamicData).toString()) {
      return DynamicData().fromJson(json);
    }
    if (type == (DynamicDataList).toString()) {
      return DynamicDataList().fromJson(json);
    }
    if (type == (WishListData).toString()) {
      return WishListData().fromJson(json);
    }
    if (type == (WishListDataList).toString()) {
      return WishListDataList().fromJson(json);
    }
    if (type == (NakeChatBillDetailEntity).toString()) {
      return NakeChatBillDetailEntity().fromJson(json);
    }
    if (type == (NakeChatBillDetailData).toString()) {
      return NakeChatBillDetailData().fromJson(json);
    }
    if (type == (NakeChatBillDetailDataList).toString()) {
      return NakeChatBillDetailDataList().fromJson(json);
    }
    if (type == (EntryHistoryEntity).toString()) {
      return EntryHistoryEntity().fromJson(json);
    }
    if (type == (EntryHistoryData).toString()) {
      return EntryHistoryData().fromJson(json);
    }
    if (type == (EntryHistoryDataActivityList).toString()) {
      return EntryHistoryDataActivityList().fromJson(json);
    }
    if (type == (SelectedTagsEntity).toString()) {
      return SelectedTagsEntity().fromJson(json);
    }
    if (type == (SelectedTagsData).toString()) {
      return SelectedTagsData().fromJson(json);
    }
    if (type == (SelectedTagsDataList).toString()) {
      return SelectedTagsDataList().fromJson(json);
    }
    if (type == (SelectedTagsDataListTags).toString()) {
      return SelectedTagsDataListTags().fromJson(json);
    }
    if (type == (SelectedTagsDataListPublisher).toString()) {
      return SelectedTagsDataListPublisher().fromJson(json);
    }
    if (type == (SelectedTagsDataListLocation).toString()) {
      return SelectedTagsDataListLocation().fromJson(json);
    }
    if (type == (SelectedTagsDataListVidStatus).toString()) {
      return SelectedTagsDataListVidStatus().fromJson(json);
    }
    if (type == (SelectedTagsDataListComment).toString()) {
      return SelectedTagsDataListComment().fromJson(json);
    }
    if (type == (SelectedTagsDataListWatch).toString()) {
      return SelectedTagsDataListWatch().fromJson(json);
    }
    if (type == (EntryVideoEntity).toString()) {
      return EntryVideoEntity().fromJson(json);
    }
    if (type == (EntryVideoData).toString()) {
      return EntryVideoData().fromJson(json);
    }
    if (type == (EntryVideoDataWorkList).toString()) {
      return EntryVideoDataWorkList().fromJson(json);
    }
    if (type == (EntryVideoDataWorkListTags).toString()) {
      return EntryVideoDataWorkListTags().fromJson(json);
    }
    if (type == (EntryVideoDataWorkListPublisher).toString()) {
      return EntryVideoDataWorkListPublisher().fromJson(json);
    }
    if (type == (EntryVideoDataWorkListLocation).toString()) {
      return EntryVideoDataWorkListLocation().fromJson(json);
    }
    if (type == (EntryVideoDataWorkListVidStatus).toString()) {
      return EntryVideoDataWorkListVidStatus().fromJson(json);
    }
    if (type == (EntryVideoDataWorkListComment).toString()) {
      return EntryVideoDataWorkListComment().fromJson(json);
    }
    if (type == (EntryVideoDataWorkListWatch).toString()) {
      return EntryVideoDataWorkListWatch().fromJson(json);
    }
    if (type == (WithdrawConfigData).toString()) {
      return WithdrawConfigData().fromJson(json);
    }
    if (type == (WithdrawConfigDataChannels).toString()) {
      return WithdrawConfigDataChannels().fromJson(json);
    }
    if (type == (AnnouncementEntity).toString()) {
      return AnnouncementEntity().fromJson(json);
    }
    if (type == (GuessLikeEntity).toString()) {
      return GuessLikeEntity().fromJson(json);
    }
    if (type == (GuessLikeData).toString()) {
      return GuessLikeData().fromJson(json);
    }
    if (type == (GuessLikeDataList).toString()) {
      return GuessLikeDataList().fromJson(json);
    }
    if (type == (GuessLikeDataListVInfos).toString()) {
      return GuessLikeDataListVInfos().fromJson(json);
    }
    if (type == (GuessLikeDataListVInfosTags).toString()) {
      return GuessLikeDataListVInfosTags().fromJson(json);
    }
    if (type == (GuessLikeDataListVInfosPublisher).toString()) {
      return GuessLikeDataListVInfosPublisher().fromJson(json);
    }
    if (type == (GuessLikeDataListVInfosLocation).toString()) {
      return GuessLikeDataListVInfosLocation().fromJson(json);
    }
    if (type == (GuessLikeDataListVInfosVidStatus).toString()) {
      return GuessLikeDataListVInfosVidStatus().fromJson(json);
    }
    if (type == (GuessLikeDataListVInfosComment).toString()) {
      return GuessLikeDataListVInfosComment().fromJson(json);
    }
    if (type == (GuessLikeDataListVInfosWatch).toString()) {
      return GuessLikeDataListVInfosWatch().fromJson(json);
    }
    if (type == (TransferResultEntity).toString()) {
      return TransferResultEntity().fromJson(json);
    }
    if (type == (TransferResultData).toString()) {
      return TransferResultData().fromJson(json);
    }
    if (type == (AnnounceLiaoBaEntity).toString()) {
      return AnnounceLiaoBaEntity().fromJson(json);
    }
    if (type == (AnnounceLiaoBaData).toString()) {
      return AnnounceLiaoBaData().fromJson(json);
    }
    if (type == (AnnouncementData).toString()) {
      return AnnouncementData().fromJson(json);
    }

    if (type == (PublishDetailEntity).toString()) {
      return PublishDetailEntity().fromJson(json);
    }
    if (type == (PublishDetailData).toString()) {
      return PublishDetailData().fromJson(json);
    }
    if (type == (PublishDetailDataActivityDetails).toString()) {
      return PublishDetailDataActivityDetails().fromJson(json);
    }
    if (type == (PublishDetailDataLeaderboards).toString()) {
      return PublishDetailDataLeaderboards().fromJson(json);
    }
    if (type == (PublishDetailDataLeaderboardsMembers).toString()) {
      return PublishDetailDataLeaderboardsMembers().fromJson(json);
    }
    if (type == (FilmTvVideoDetailEntity).toString()) {
      return FilmTvVideoDetailEntity().fromJson(json);
    }
    if (type == (FilmTvVideoDetailTags).toString()) {
      return FilmTvVideoDetailTags().fromJson(json);
    }
    if (type == (FilmTvVideoDetailPublisher).toString()) {
      return FilmTvVideoDetailPublisher().fromJson(json);
    }
    if (type == (FilmTvVideoDetailLocation).toString()) {
      return FilmTvVideoDetailLocation().fromJson(json);
    }
    if (type == (FilmTvVideoDetailVidStatus).toString()) {
      return FilmTvVideoDetailVidStatus().fromJson(json);
    }
    if (type == (FilmTvVideoDetailComment).toString()) {
      return FilmTvVideoDetailComment().fromJson(json);
    }
    if (type == (FilmTvVideoDetailWatch).toString()) {
      return FilmTvVideoDetailWatch().fromJson(json);
    }
    if (type == (ActivityEntity).toString()) {
      return ActivityEntity().fromJson(json);
    }
    if (type == (ActivityData).toString()) {
      return ActivityData().fromJson(json);
    }
    if (type == (ActivityDataList).toString()) {
      return ActivityDataList().fromJson(json);
    }
    if (type == (LiaoBaHistoryEntity).toString()) {
      return LiaoBaHistoryEntity().fromJson(json);
    }
    if (type == (LiaoBaHistoryData).toString()) {
      return LiaoBaHistoryData().fromJson(json);
    }
    if (type == (LiaoBaHistoryDataWorkList).toString()) {
      return LiaoBaHistoryDataWorkList().fromJson(json);
    }
    if (type == (LiaoBaHistoryDataWorkListTags).toString()) {
      return LiaoBaHistoryDataWorkListTags().fromJson(json);
    }
    if (type == (LiaoBaHistoryDataWorkListPublisher).toString()) {
      return LiaoBaHistoryDataWorkListPublisher().fromJson(json);
    }
    if (type == (LiaoBaHistoryDataWorkListLocation).toString()) {
      return LiaoBaHistoryDataWorkListLocation().fromJson(json);
    }
    if (type == (LiaoBaHistoryDataWorkListVidStatus).toString()) {
      return LiaoBaHistoryDataWorkListVidStatus().fromJson(json);
    }
    if (type == (LiaoBaHistoryDataWorkListComment).toString()) {
      return LiaoBaHistoryDataWorkListComment().fromJson(json);
    }
    if (type == (LiaoBaHistoryDataWorkListWatch).toString()) {
      return LiaoBaHistoryDataWorkListWatch().fromJson(json);
    }
    if (type == (AddUserEntity).toString()) {
      return AddUserEntity().fromJson(json);
    }
    if (type == (AddUserData).toString()) {
      return AddUserData().fromJson(json);
    }
    if (type == (AddUserDataList).toString()) {
      return AddUserDataList().fromJson(json);
    }
    if (type == (AddUserDataListVInfos).toString()) {
      return AddUserDataListVInfos().fromJson(json);
    }
    if (type == (AddUserDataListVInfosTags).toString()) {
      return AddUserDataListVInfosTags().fromJson(json);
    }
    if (type == (AddUserDataListVInfosPublisher).toString()) {
      return AddUserDataListVInfosPublisher().fromJson(json);
    }
    if (type == (AddUserDataListVInfosLocation).toString()) {
      return AddUserDataListVInfosLocation().fromJson(json);
    }
    if (type == (AddUserDataListVInfosVidStatus).toString()) {
      return AddUserDataListVInfosVidStatus().fromJson(json);
    }
    if (type == (AddUserDataListVInfosComment).toString()) {
      return AddUserDataListVInfosComment().fromJson(json);
    }
    if (type == (AddUserDataListVInfosWatch).toString()) {
      return AddUserDataListVInfosWatch().fromJson(json);
    }
    if (type == (TabsTagEntity).toString()) {
      return TabsTagEntity().fromJson(json);
    }
    if (type == (TabsTagData).toString()) {
      return TabsTagData().fromJson(json);
    }
    if (type == (AVCommentaryDetailEntity).toString()) {
      return AVCommentaryDetailEntity().fromJson(json);
    }
    if (type == (RewardAvatarEntity).toString()) {
      return RewardAvatarEntity().fromJson(json);
    }
    if (type == (RewardAvatarData).toString()) {
      return RewardAvatarData().fromJson(json);
    }
    if (type == (RewardAvatarDataList).toString()) {
      return RewardAvatarDataList().fromJson(json);
    }

    return null;
  }

  //list is returned by type
  static M _getListChildType<M>(List data) {
    if (<MessageListEntity>[] is M) {
      return data.map<MessageListEntity>((e) => MessageListEntity().fromJson(e)).toList() as M;
    }
    if (<MessageListData>[] is M) {
      return data.map<MessageListData>((e) => MessageListData().fromJson(e)).toList() as M;
    }
    if (<MessageListDataList>[] is M) {
      return data.map<MessageListDataList>((e) => MessageListDataList().fromJson(e)).toList() as M;
    }
    if (<SwitchBackgroundEntity>[] is M) {
      return data.map<SwitchBackgroundEntity>((e) => SwitchBackgroundEntity().fromJson(e)).toList() as M;
    }
    if (<SwitchBackgroundData>[] is M) {
      return data.map<SwitchBackgroundData>((e) => SwitchBackgroundData().fromJson(e)).toList() as M;
    }
    if (<SwitchBackgroundDataList>[] is M) {
      return data.map<SwitchBackgroundDataList>((e) => SwitchBackgroundDataList().fromJson(e)).toList() as M;
    }
    if (<SearchDefaultEntity>[] is M) {
      return data.map<SearchDefaultEntity>((e) => SearchDefaultEntity().fromJson(e)).toList() as M;
    }
    if (<SearchDefaultData>[] is M) {
      return data.map<SearchDefaultData>((e) => SearchDefaultData().fromJson(e)).toList() as M;
    }
    if (<SearchDefaultDataList>[] is M) {
      return data.map<SearchDefaultDataList>((e) => SearchDefaultDataList().fromJson(e)).toList() as M;
    }
    if (<SearchDefaultDataListTags>[] is M) {
      return data.map<SearchDefaultDataListTags>((e) => SearchDefaultDataListTags().fromJson(e)).toList()
          as M;
    }
    if (<SearchDefaultDataListPublisher>[] is M) {
      return data
          .map<SearchDefaultDataListPublisher>((e) => SearchDefaultDataListPublisher().fromJson(e))
          .toList() as M;
    }
    if (<SearchDefaultDataListLocation>[] is M) {
      return data
          .map<SearchDefaultDataListLocation>((e) => SearchDefaultDataListLocation().fromJson(e))
          .toList() as M;
    }
    if (<SearchDefaultDataListVidStatus>[] is M) {
      return data
          .map<SearchDefaultDataListVidStatus>((e) => SearchDefaultDataListVidStatus().fromJson(e))
          .toList() as M;
    }
    if (<SearchDefaultDataListComment>[] is M) {
      return data
          .map<SearchDefaultDataListComment>((e) => SearchDefaultDataListComment().fromJson(e))
          .toList() as M;
    }
    if (<SearchDefaultDataListWatch>[] is M) {
      return data.map<SearchDefaultDataListWatch>((e) => SearchDefaultDataListWatch().fromJson(e)).toList()
          as M;
    }
    if (<TaskCenterData>[] is M) {
      return data.map<TaskCenterData>((e) => TaskCenterData().fromJson(e)).toList() as M;
    }
    if (<TaskCenterDataTaskList>[] is M) {
      return data.map<TaskCenterDataTaskList>((e) => TaskCenterDataTaskList().fromJson(e)).toList() as M;
    }
    if (<TagsDetailEntity>[] is M) {
      return data.map<TagsDetailEntity>((e) => TagsDetailEntity().fromJson(e)).toList() as M;
    }
    if (<TagsDetailData>[] is M) {
      return data.map<TagsDetailData>((e) => TagsDetailData().fromJson(e)).toList() as M;
    }
    if (<TagsDetailDataSections>[] is M) {
      return data.map<TagsDetailDataSections>((e) => TagsDetailDataSections().fromJson(e)).toList() as M;
    }
    if (<TagsDetailDataSectionsVideoInfo>[] is M) {
      return data
          .map<TagsDetailDataSectionsVideoInfo>((e) => TagsDetailDataSectionsVideoInfo().fromJson(e))
          .toList() as M;
    }
    if (<TagsDetailDataSectionsVideoInfoTags>[] is M) {
      return data
          .map<TagsDetailDataSectionsVideoInfoTags>((e) => TagsDetailDataSectionsVideoInfoTags().fromJson(e))
          .toList() as M;
    }
    if (<TagsDetailDataSectionsVideoInfoPublisher>[] is M) {
      return data
          .map<TagsDetailDataSectionsVideoInfoPublisher>(
              (e) => TagsDetailDataSectionsVideoInfoPublisher().fromJson(e))
          .toList() as M;
    }
    if (<TagsDetailDataSectionsVideoInfoLocation>[] is M) {
      return data
          .map<TagsDetailDataSectionsVideoInfoLocation>(
              (e) => TagsDetailDataSectionsVideoInfoLocation().fromJson(e))
          .toList() as M;
    }
    if (<TagsDetailDataSectionsVideoInfoVidStatus>[] is M) {
      return data
          .map<TagsDetailDataSectionsVideoInfoVidStatus>(
              (e) => TagsDetailDataSectionsVideoInfoVidStatus().fromJson(e))
          .toList() as M;
    }
    if (<TagsDetailDataSectionsVideoInfoComment>[] is M) {
      return data
          .map<TagsDetailDataSectionsVideoInfoComment>(
              (e) => TagsDetailDataSectionsVideoInfoComment().fromJson(e))
          .toList() as M;
    }
    if (<TagsDetailDataSectionsVideoInfoWatch>[] is M) {
      return data
          .map<TagsDetailDataSectionsVideoInfoWatch>(
              (e) => TagsDetailDataSectionsVideoInfoWatch().fromJson(e))
          .toList() as M;
    }
    if (<TagsDetailDataSectionsOriginalBloggerInfo>[] is M) {
      return data
          .map<TagsDetailDataSectionsOriginalBloggerInfo>(
              (e) => TagsDetailDataSectionsOriginalBloggerInfo().fromJson(e))
          .toList() as M;
    }
    if (<SearchBeanEntity>[] is M) {
      return data.map<SearchBeanEntity>((e) => SearchBeanEntity().fromJson(e)).toList() as M;
    }
    if (<SearchBeanData>[] is M) {
      return data.map<SearchBeanData>((e) => SearchBeanData().fromJson(e)).toList() as M;
    }
    if (<SearchBeanDataList>[] is M) {
      return data.map<SearchBeanDataList>((e) => SearchBeanDataList().fromJson(e)).toList() as M;
    }
    if (<GamePromotionEntity>[] is M) {
      return data.map<GamePromotionEntity>((e) => GamePromotionEntity().fromJson(e)).toList() as M;
    }
    if (<GamePromotionData>[] is M) {
      return data.map<GamePromotionData>((e) => GamePromotionData().fromJson(e)).toList() as M;
    }
    if (<GamePromotionDataList>[] is M) {
      return data.map<GamePromotionDataList>((e) => GamePromotionDataList().fromJson(e)).toList() as M;
    }
    if (<AddBeanEntity>[] is M) {
      return data.map<AddBeanEntity>((e) => AddBeanEntity().fromJson(e)).toList() as M;
    }
    if (<AddBeanData>[] is M) {
      return data.map<AddBeanData>((e) => AddBeanData().fromJson(e)).toList() as M;
    }
    if (<AddBeanDataList>[] is M) {
      return data.map<AddBeanDataList>((e) => AddBeanDataList().fromJson(e)).toList() as M;
    }
    if (<TagsLiaoBaEntity>[] is M) {
      return data.map<TagsLiaoBaEntity>((e) => TagsLiaoBaEntity().fromJson(e)).toList() as M;
    }
    if (<TagsLiaoBaData>[] is M) {
      return data.map<TagsLiaoBaData>((e) => TagsLiaoBaData().fromJson(e)).toList() as M;
    }
    if (<TagsLiaoBaDataTags>[] is M) {
      return data.map<TagsLiaoBaDataTags>((e) => TagsLiaoBaDataTags().fromJson(e)).toList() as M;
    }
    if (<GameBalanceEntity>[] is M) {
      return data.map<GameBalanceEntity>((e) => GameBalanceEntity().fromJson(e)).toList() as M;
    }
    if (<EntryVideohistoryEntity>[] is M) {
      return data.map<EntryVideohistoryEntity>((e) => EntryVideohistoryEntity().fromJson(e)).toList() as M;
    }
    if (<EntryVideohistoryData>[] is M) {
      return data.map<EntryVideohistoryData>((e) => EntryVideohistoryData().fromJson(e)).toList() as M;
    }
    if (<EntryVideohistoryDataActivityList>[] is M) {
      return data
          .map<EntryVideohistoryDataActivityList>((e) => EntryVideohistoryDataActivityList().fromJson(e))
          .toList() as M;
    }
    if (<SearchVideoEntity>[] is M) {
      return data.map<SearchVideoEntity>((e) => SearchVideoEntity().fromJson(e)).toList() as M;
    }
    if (<SearchVideoData>[] is M) {
      return data.map<SearchVideoData>((e) => SearchVideoData().fromJson(e)).toList() as M;
    }
    if (<SearchVideoDataList>[] is M) {
      return data.map<SearchVideoDataList>((e) => SearchVideoDataList().fromJson(e)).toList() as M;
    }
    if (<SearchVideoDataListTags>[] is M) {
      return data.map<SearchVideoDataListTags>((e) => SearchVideoDataListTags().fromJson(e)).toList() as M;
    }
    if (<SearchVideoDataListPublisher>[] is M) {
      return data
          .map<SearchVideoDataListPublisher>((e) => SearchVideoDataListPublisher().fromJson(e))
          .toList() as M;
    }
    if (<SearchVideoDataListLocation>[] is M) {
      return data.map<SearchVideoDataListLocation>((e) => SearchVideoDataListLocation().fromJson(e)).toList()
          as M;
    }
    if (<SearchVideoDataListVidStatus>[] is M) {
      return data
          .map<SearchVideoDataListVidStatus>((e) => SearchVideoDataListVidStatus().fromJson(e))
          .toList() as M;
    }
    if (<SearchVideoDataListComment>[] is M) {
      return data.map<SearchVideoDataListComment>((e) => SearchVideoDataListComment().fromJson(e)).toList()
          as M;
    }
    if (<SearchVideoDataListWatch>[] is M) {
      return data.map<SearchVideoDataListWatch>((e) => SearchVideoDataListWatch().fromJson(e)).toList() as M;
    }
    if (<MessageDetailEntity>[] is M) {
      return data.map<MessageDetailEntity>((e) => MessageDetailEntity().fromJson(e)).toList() as M;
    }
    if (<MessageDetailData>[] is M) {
      return data.map<MessageDetailData>((e) => MessageDetailData().fromJson(e)).toList() as M;
    }
    if (<MessageDetailDataList>[] is M) {
      return data.map<MessageDetailDataList>((e) => MessageDetailDataList().fromJson(e)).toList() as M;
    }
    if (<GameBillDetailEntity>[] is M) {
      return data.map<GameBillDetailEntity>((e) => GameBillDetailEntity().fromJson(e)).toList() as M;
    }
    if (<GameBillDetailData>[] is M) {
      return data.map<GameBillDetailData>((e) => GameBillDetailData().fromJson(e)).toList() as M;
    }
    if (<GameBillDetailDataList>[] is M) {
      return data.map<GameBillDetailDataList>((e) => GameBillDetailDataList().fromJson(e)).toList() as M;
    }
    if (<DayMarkEntity>[] is M) {
      return data.map<DayMarkEntity>((e) => DayMarkEntity().fromJson(e)).toList() as M;
    }
    if (<DayMarkData>[] is M) {
      return data.map<DayMarkData>((e) => DayMarkData().fromJson(e)).toList() as M;
    }
    if (<DayMarkDataList>[] is M) {
      return data.map<DayMarkDataList>((e) => DayMarkDataList().fromJson(e)).toList() as M;
    }
    if (<DayMarkDataListPrizes>[] is M) {
      return data.map<DayMarkDataListPrizes>((e) => DayMarkDataListPrizes().fromJson(e)).toList() as M;
    }
    if (<CouponEntity>[] is M) {
      return data.map<CouponEntity>((e) => CouponEntity().fromJson(e)).toList() as M;
    }
    if (<CouponData>[] is M) {
      return data.map<CouponData>((e) => CouponData().fromJson(e)).toList() as M;
    }
    if (<CouponDataCouponList>[] is M) {
      return data.map<CouponDataCouponList>((e) => CouponDataCouponList().fromJson(e)).toList() as M;
    }
    if (<SearchTopicEntity>[] is M) {
      return data.map<SearchTopicEntity>((e) => SearchTopicEntity().fromJson(e)).toList() as M;
    }
    if (<SearchTopicData>[] is M) {
      return data.map<SearchTopicData>((e) => SearchTopicData().fromJson(e)).toList() as M;
    }
    if (<SearchTopicDataList>[] is M) {
      return data.map<SearchTopicDataList>((e) => SearchTopicDataList().fromJson(e)).toList() as M;
    }
    if (<TaskEntity>[] is M) {
      return data.map<TaskEntity>((e) => TaskEntity().fromJson(e)).toList() as M;
    }
    if (<TaskData>[] is M) {
      return data.map<TaskData>((e) => TaskData().fromJson(e)).toList() as M;
    }
    if (<TaskDataJewelBoxDetails>[] is M) {
      return data.map<TaskDataJewelBoxDetails>((e) => TaskDataJewelBoxDetails().fromJson(e)).toList() as M;
    }
    if (<TaskDataJewelBoxDetailsList>[] is M) {
      return data.map<TaskDataJewelBoxDetailsList>((e) => TaskDataJewelBoxDetailsList().fromJson(e)).toList()
          as M;
    }
    if (<TaskDataJewelBoxDetailsListPrizes>[] is M) {
      return data
          .map<TaskDataJewelBoxDetailsListPrizes>((e) => TaskDataJewelBoxDetailsListPrizes().fromJson(e))
          .toList() as M;
    }
    if (<TaskDataTaskList>[] is M) {
      return data.map<TaskDataTaskList>((e) => TaskDataTaskList().fromJson(e)).toList() as M;
    }
    if (<TaskDataTaskListPrizes>[] is M) {
      return data.map<TaskDataTaskListPrizes>((e) => TaskDataTaskListPrizes().fromJson(e)).toList() as M;
    }
    if (<LouFengDiscountCardEntity>[] is M) {
      return data.map<LouFengDiscountCardEntity>((e) => LouFengDiscountCardEntity().fromJson(e)).toList()
          as M;
    }
    if (<LouFengDiscountCardData>[] is M) {
      return data.map<LouFengDiscountCardData>((e) => LouFengDiscountCardData().fromJson(e)).toList() as M;
    }
    if (<LouFengDiscountCardDataCouponList>[] is M) {
      return data
          .map<LouFengDiscountCardDataCouponList>((e) => LouFengDiscountCardDataCouponList().fromJson(e))
          .toList() as M;
    }
    if (<HotRecommendEntity>[] is M) {
      return data.map<HotRecommendEntity>((e) => HotRecommendEntity().fromJson(e)).toList() as M;
    }
    if (<HotRecommendData>[] is M) {
      return data.map<HotRecommendData>((e) => HotRecommendData().fromJson(e)).toList() as M;
    }
    if (<HotRecommendDataList>[] is M) {
      return data.map<HotRecommendDataList>((e) => HotRecommendDataList().fromJson(e)).toList() as M;
    }
    if (<HotRecommendDataListTags>[] is M) {
      return data.map<HotRecommendDataListTags>((e) => HotRecommendDataListTags().fromJson(e)).toList() as M;
    }
    if (<HotRecommendDataListPublisher>[] is M) {
      return data
          .map<HotRecommendDataListPublisher>((e) => HotRecommendDataListPublisher().fromJson(e))
          .toList() as M;
    }
    if (<HotRecommendDataListLocation>[] is M) {
      return data
          .map<HotRecommendDataListLocation>((e) => HotRecommendDataListLocation().fromJson(e))
          .toList() as M;
    }
    if (<HotRecommendDataListVidStatus>[] is M) {
      return data
          .map<HotRecommendDataListVidStatus>((e) => HotRecommendDataListVidStatus().fromJson(e))
          .toList() as M;
    }
    if (<HotRecommendDataListComment>[] is M) {
      return data.map<HotRecommendDataListComment>((e) => HotRecommendDataListComment().fromJson(e)).toList()
          as M;
    }
    if (<HotRecommendDataListWatch>[] is M) {
      return data.map<HotRecommendDataListWatch>((e) => HotRecommendDataListWatch().fromJson(e)).toList()
          as M;
    }
    if (<CountryCodeEntity>[] is M) {
      return data.map<CountryCodeEntity>((e) => CountryCodeEntity().fromJson(e)).toList() as M;
    }
    if (<CountryCodeList>[] is M) {
      return data.map<CountryCodeList>((e) => CountryCodeList().fromJson(e)).toList() as M;
    }
    if (<AVCommentaryEntity>[] is M) {
      return data.map<AVCommentaryEntity>((e) => AVCommentaryEntity().fromJson(e)).toList() as M;
    }
    if (<AVCommentaryData>[] is M) {
      return data.map<AVCommentaryData>((e) => AVCommentaryData().fromJson(e)).toList() as M;
    }
    if (<AVCommentaryDataList>[] is M) {
      return data.map<AVCommentaryDataList>((e) => AVCommentaryDataList().fromJson(e)).toList() as M;
    }
    if (<AnnounceVipCardEntity>[] is M) {
      return data.map<AnnounceVipCardEntity>((e) => AnnounceVipCardEntity().fromJson(e)).toList() as M;
    }
    if (<SwitchAvatarEntity>[] is M) {
      return data.map<SwitchAvatarEntity>((e) => SwitchAvatarEntity().fromJson(e)).toList() as M;
    }
    if (<SwitchAvatarData>[] is M) {
      return data.map<SwitchAvatarData>((e) => SwitchAvatarData().fromJson(e)).toList() as M;
    }
    if (<SwitchAvatarDataList>[] is M) {
      return data.map<SwitchAvatarDataList>((e) => SwitchAvatarDataList().fromJson(e)).toList() as M;
    }
    if (<LiaoBaTagsDetailEntity>[] is M) {
      return data.map<LiaoBaTagsDetailEntity>((e) => LiaoBaTagsDetailEntity().fromJson(e)).toList() as M;
    }
    if (<LiaoBaTagsDetailData>[] is M) {
      return data.map<LiaoBaTagsDetailData>((e) => LiaoBaTagsDetailData().fromJson(e)).toList() as M;
    }
    if (<LiaoBaTagsDetailDataVideos>[] is M) {
      return data.map<LiaoBaTagsDetailDataVideos>((e) => LiaoBaTagsDetailDataVideos().fromJson(e)).toList()
          as M;
    }
    if (<LiaoBaTagsDetailDataVideosTags>[] is M) {
      return data
          .map<LiaoBaTagsDetailDataVideosTags>((e) => LiaoBaTagsDetailDataVideosTags().fromJson(e))
          .toList() as M;
    }
    if (<LiaoBaTagsDetailDataVideosPublisher>[] is M) {
      return data
          .map<LiaoBaTagsDetailDataVideosPublisher>((e) => LiaoBaTagsDetailDataVideosPublisher().fromJson(e))
          .toList() as M;
    }
    if (<LiaoBaTagsDetailDataVideosLocation>[] is M) {
      return data
          .map<LiaoBaTagsDetailDataVideosLocation>((e) => LiaoBaTagsDetailDataVideosLocation().fromJson(e))
          .toList() as M;
    }
    if (<LiaoBaTagsDetailDataVideosVidStatus>[] is M) {
      return data
          .map<LiaoBaTagsDetailDataVideosVidStatus>((e) => LiaoBaTagsDetailDataVideosVidStatus().fromJson(e))
          .toList() as M;
    }
    if (<LiaoBaTagsDetailDataVideosComment>[] is M) {
      return data
          .map<LiaoBaTagsDetailDataVideosComment>((e) => LiaoBaTagsDetailDataVideosComment().fromJson(e))
          .toList() as M;
    }
    if (<LiaoBaTagsDetailDataVideosWatch>[] is M) {
      return data
          .map<LiaoBaTagsDetailDataVideosWatch>((e) => LiaoBaTagsDetailDataVideosWatch().fromJson(e))
          .toList() as M;
    }
    if (<LiaoBaTagsDetailDataOriginalBloggerInfo>[] is M) {
      return data
          .map<LiaoBaTagsDetailDataOriginalBloggerInfo>(
              (e) => LiaoBaTagsDetailDataOriginalBloggerInfo().fromJson(e))
          .toList() as M;
    }
    if (<SearchDefaultHotBloggerEntity>[] is M) {
      return data
          .map<SearchDefaultHotBloggerEntity>((e) => SearchDefaultHotBloggerEntity().fromJson(e))
          .toList() as M;
    }
    if (<SearchDefaultHotBloggerData>[] is M) {
      return data.map<SearchDefaultHotBloggerData>((e) => SearchDefaultHotBloggerData().fromJson(e)).toList()
          as M;
    }
    if (<SearchDefaultHotBloggerDataList>[] is M) {
      return data
          .map<SearchDefaultHotBloggerDataList>((e) => SearchDefaultHotBloggerDataList().fromJson(e))
          .toList() as M;
    }
    if (<SearchDefaultHotBloggerDataListList>[] is M) {
      return data
          .map<SearchDefaultHotBloggerDataListList>((e) => SearchDefaultHotBloggerDataListList().fromJson(e))
          .toList() as M;
    }
    if (<SearchDefaultHotBloggerDataListListTags>[] is M) {
      return data
          .map<SearchDefaultHotBloggerDataListListTags>(
              (e) => SearchDefaultHotBloggerDataListListTags().fromJson(e))
          .toList() as M;
    }
    if (<SearchDefaultHotBloggerDataListListPublisher>[] is M) {
      return data
          .map<SearchDefaultHotBloggerDataListListPublisher>(
              (e) => SearchDefaultHotBloggerDataListListPublisher().fromJson(e))
          .toList() as M;
    }
    if (<SearchDefaultHotBloggerDataListListLocation>[] is M) {
      return data
          .map<SearchDefaultHotBloggerDataListListLocation>(
              (e) => SearchDefaultHotBloggerDataListListLocation().fromJson(e))
          .toList() as M;
    }
    if (<SearchDefaultHotBloggerDataListListVidStatus>[] is M) {
      return data
          .map<SearchDefaultHotBloggerDataListListVidStatus>(
              (e) => SearchDefaultHotBloggerDataListListVidStatus().fromJson(e))
          .toList() as M;
    }
    if (<SearchDefaultHotBloggerDataListListComment>[] is M) {
      return data
          .map<SearchDefaultHotBloggerDataListListComment>(
              (e) => SearchDefaultHotBloggerDataListListComment().fromJson(e))
          .toList() as M;
    }
    if (<SearchDefaultHotBloggerDataListListWatch>[] is M) {
      return data
          .map<SearchDefaultHotBloggerDataListListWatch>(
              (e) => SearchDefaultHotBloggerDataListListWatch().fromJson(e))
          .toList() as M;
    }
    if (<BuyAvCommentaryResultEntity>[] is M) {
      return data.map<BuyAvCommentaryResultEntity>((e) => BuyAvCommentaryResultEntity().fromJson(e)).toList()
          as M;
    }
    if (<VipAnnounceEntity>[] is M) {
      return data.map<VipAnnounceEntity>((e) => VipAnnounceEntity().fromJson(e)).toList() as M;
    }
    if (<VipAnnounceData>[] is M) {
      return data.map<VipAnnounceData>((e) => VipAnnounceData().fromJson(e)).toList() as M;
    }
    if (<TaskDetailEntity>[] is M) {
      return data.map<TaskDetailEntity>((e) => TaskDetailEntity().fromJson(e)).toList() as M;
    }
    if (<TaskDetailData>[] is M) {
      return data.map<TaskDetailData>((e) => TaskDetailData().fromJson(e)).toList() as M;
    }
    if (<TaskDetailDataTaskList>[] is M) {
      return data.map<TaskDetailDataTaskList>((e) => TaskDetailDataTaskList().fromJson(e)).toList() as M;
    }
    if (<TaskDetailDataTaskListPrizes>[] is M) {
      return data
          .map<TaskDetailDataTaskListPrizes>((e) => TaskDetailDataTaskListPrizes().fromJson(e))
          .toList() as M;
    }
    if (<BangDanDetailEntity>[] is M) {
      return data.map<BangDanDetailEntity>((e) => BangDanDetailEntity().fromJson(e)).toList() as M;
    }
    if (<BangDanDetailData>[] is M) {
      return data.map<BangDanDetailData>((e) => BangDanDetailData().fromJson(e)).toList() as M;
    }
    if (<BangDanRankType>[] is M) {
      return data.map<BangDanRankType>((e) => BangDanRankType().fromJson(e)).toList() as M;
    }
    if (<BangDanDetailDataMembers>[] is M) {
      return data.map<BangDanDetailDataMembers>((e) => BangDanDetailDataMembers().fromJson(e)).toList() as M;
    }
    if (<YouHuiJuanEntity>[] is M) {
      return data.map<YouHuiJuanEntity>((e) => YouHuiJuanEntity().fromJson(e)).toList() as M;
    }
    if (<YouHuiJuanData>[] is M) {
      return data.map<YouHuiJuanData>((e) => YouHuiJuanData().fromJson(e)).toList() as M;
    }
    if (<AgentGirlListEntity>[] is M) {
      return data.map<AgentGirlListEntity>((e) => AgentGirlListEntity().fromJson(e)).toList() as M;
    }
    if (<AgentGirlListData>[] is M) {
      return data.map<AgentGirlListData>((e) => AgentGirlListData().fromJson(e)).toList() as M;
    }
    if (<AgentGirlListDataList>[] is M) {
      return data.map<AgentGirlListDataList>((e) => AgentGirlListDataList().fromJson(e)).toList() as M;
    }
    if (<AgentGirlListDataListAgentInfo>[] is M) {
      return data
          .map<AgentGirlListDataListAgentInfo>((e) => AgentGirlListDataListAgentInfo().fromJson(e))
          .toList() as M;
    }
    if (<DynamicEntity>[] is M) {
      return data.map<DynamicEntity>((e) => DynamicEntity().fromJson(e)).toList() as M;
    }
    if (<DynamicData>[] is M) {
      return data.map<DynamicData>((e) => DynamicData().fromJson(e)).toList() as M;
    }
    if (<DynamicDataList>[] is M) {
      return data.map<DynamicDataList>((e) => DynamicDataList().fromJson(e)).toList() as M;
    }
    if (<WishListData>[] is M) {
      return data.map<WishListData>((e) => WishListData().fromJson(e)).toList() as M;
    }
    if (<WishListDataList>[] is M) {
      return data.map<WishListDataList>((e) => WishListDataList().fromJson(e)).toList() as M;
    }
    if (<NakeChatBillDetailEntity>[] is M) {
      return data.map<NakeChatBillDetailEntity>((e) => NakeChatBillDetailEntity().fromJson(e)).toList() as M;
    }
    if (<NakeChatBillDetailData>[] is M) {
      return data.map<NakeChatBillDetailData>((e) => NakeChatBillDetailData().fromJson(e)).toList() as M;
    }
    if (<NakeChatBillDetailDataList>[] is M) {
      return data.map<NakeChatBillDetailDataList>((e) => NakeChatBillDetailDataList().fromJson(e)).toList()
          as M;
    }
    if (<EntryHistoryEntity>[] is M) {
      return data.map<EntryHistoryEntity>((e) => EntryHistoryEntity().fromJson(e)).toList() as M;
    }
    if (<EntryHistoryData>[] is M) {
      return data.map<EntryHistoryData>((e) => EntryHistoryData().fromJson(e)).toList() as M;
    }
    if (<EntryHistoryDataActivityList>[] is M) {
      return data
          .map<EntryHistoryDataActivityList>((e) => EntryHistoryDataActivityList().fromJson(e))
          .toList() as M;
    }
    if (<SelectedTagsEntity>[] is M) {
      return data.map<SelectedTagsEntity>((e) => SelectedTagsEntity().fromJson(e)).toList() as M;
    }
    if (<SelectedTagsData>[] is M) {
      return data.map<SelectedTagsData>((e) => SelectedTagsData().fromJson(e)).toList() as M;
    }
    if (<SelectedTagsDataList>[] is M) {
      return data.map<SelectedTagsDataList>((e) => SelectedTagsDataList().fromJson(e)).toList() as M;
    }
    if (<SelectedTagsDataListTags>[] is M) {
      return data.map<SelectedTagsDataListTags>((e) => SelectedTagsDataListTags().fromJson(e)).toList() as M;
    }
    if (<SelectedTagsDataListPublisher>[] is M) {
      return data
          .map<SelectedTagsDataListPublisher>((e) => SelectedTagsDataListPublisher().fromJson(e))
          .toList() as M;
    }
    if (<SelectedTagsDataListLocation>[] is M) {
      return data
          .map<SelectedTagsDataListLocation>((e) => SelectedTagsDataListLocation().fromJson(e))
          .toList() as M;
    }
    if (<SelectedTagsDataListVidStatus>[] is M) {
      return data
          .map<SelectedTagsDataListVidStatus>((e) => SelectedTagsDataListVidStatus().fromJson(e))
          .toList() as M;
    }
    if (<SelectedTagsDataListComment>[] is M) {
      return data.map<SelectedTagsDataListComment>((e) => SelectedTagsDataListComment().fromJson(e)).toList()
          as M;
    }
    if (<SelectedTagsDataListWatch>[] is M) {
      return data.map<SelectedTagsDataListWatch>((e) => SelectedTagsDataListWatch().fromJson(e)).toList()
          as M;
    }
    if (<EntryVideoEntity>[] is M) {
      return data.map<EntryVideoEntity>((e) => EntryVideoEntity().fromJson(e)).toList() as M;
    }
    if (<EntryVideoData>[] is M) {
      return data.map<EntryVideoData>((e) => EntryVideoData().fromJson(e)).toList() as M;
    }
    if (<EntryVideoDataWorkList>[] is M) {
      return data.map<EntryVideoDataWorkList>((e) => EntryVideoDataWorkList().fromJson(e)).toList() as M;
    }
    if (<EntryVideoDataWorkListTags>[] is M) {
      return data.map<EntryVideoDataWorkListTags>((e) => EntryVideoDataWorkListTags().fromJson(e)).toList()
          as M;
    }
    if (<EntryVideoDataWorkListPublisher>[] is M) {
      return data
          .map<EntryVideoDataWorkListPublisher>((e) => EntryVideoDataWorkListPublisher().fromJson(e))
          .toList() as M;
    }
    if (<EntryVideoDataWorkListLocation>[] is M) {
      return data
          .map<EntryVideoDataWorkListLocation>((e) => EntryVideoDataWorkListLocation().fromJson(e))
          .toList() as M;
    }
    if (<EntryVideoDataWorkListVidStatus>[] is M) {
      return data
          .map<EntryVideoDataWorkListVidStatus>((e) => EntryVideoDataWorkListVidStatus().fromJson(e))
          .toList() as M;
    }
    if (<EntryVideoDataWorkListComment>[] is M) {
      return data
          .map<EntryVideoDataWorkListComment>((e) => EntryVideoDataWorkListComment().fromJson(e))
          .toList() as M;
    }
    if (<EntryVideoDataWorkListWatch>[] is M) {
      return data.map<EntryVideoDataWorkListWatch>((e) => EntryVideoDataWorkListWatch().fromJson(e)).toList()
          as M;
    }
    if (<WithdrawConfigData>[] is M) {
      return data.map<WithdrawConfigData>((e) => WithdrawConfigData().fromJson(e)).toList() as M;
    }
    if (<WithdrawConfigDataChannels>[] is M) {
      return data.map<WithdrawConfigDataChannels>((e) => WithdrawConfigDataChannels().fromJson(e)).toList()
          as M;
    }
    if (<AnnouncementEntity>[] is M) {
      return data.map<AnnouncementEntity>((e) => AnnouncementEntity().fromJson(e)).toList() as M;
    }
    if (<GuessLikeEntity>[] is M) {
      return data.map<GuessLikeEntity>((e) => GuessLikeEntity().fromJson(e)).toList() as M;
    }
    if (<GuessLikeData>[] is M) {
      return data.map<GuessLikeData>((e) => GuessLikeData().fromJson(e)).toList() as M;
    }
    if (<GuessLikeDataList>[] is M) {
      return data.map<GuessLikeDataList>((e) => GuessLikeDataList().fromJson(e)).toList() as M;
    }
    if (<GuessLikeDataListVInfos>[] is M) {
      return data.map<GuessLikeDataListVInfos>((e) => GuessLikeDataListVInfos().fromJson(e)).toList() as M;
    }
    if (<GuessLikeDataListVInfosTags>[] is M) {
      return data.map<GuessLikeDataListVInfosTags>((e) => GuessLikeDataListVInfosTags().fromJson(e)).toList()
          as M;
    }
    if (<GuessLikeDataListVInfosPublisher>[] is M) {
      return data
          .map<GuessLikeDataListVInfosPublisher>((e) => GuessLikeDataListVInfosPublisher().fromJson(e))
          .toList() as M;
    }
    if (<GuessLikeDataListVInfosLocation>[] is M) {
      return data
          .map<GuessLikeDataListVInfosLocation>((e) => GuessLikeDataListVInfosLocation().fromJson(e))
          .toList() as M;
    }
    if (<GuessLikeDataListVInfosVidStatus>[] is M) {
      return data
          .map<GuessLikeDataListVInfosVidStatus>((e) => GuessLikeDataListVInfosVidStatus().fromJson(e))
          .toList() as M;
    }
    if (<GuessLikeDataListVInfosComment>[] is M) {
      return data
          .map<GuessLikeDataListVInfosComment>((e) => GuessLikeDataListVInfosComment().fromJson(e))
          .toList() as M;
    }
    if (<GuessLikeDataListVInfosWatch>[] is M) {
      return data
          .map<GuessLikeDataListVInfosWatch>((e) => GuessLikeDataListVInfosWatch().fromJson(e))
          .toList() as M;
    }
    if (<TransferResultEntity>[] is M) {
      return data.map<TransferResultEntity>((e) => TransferResultEntity().fromJson(e)).toList() as M;
    }
    if (<TransferResultData>[] is M) {
      return data.map<TransferResultData>((e) => TransferResultData().fromJson(e)).toList() as M;
    }
    if (<AnnounceLiaoBaEntity>[] is M) {
      return data.map<AnnounceLiaoBaEntity>((e) => AnnounceLiaoBaEntity().fromJson(e)).toList() as M;
    }
    if (<AnnounceLiaoBaData>[] is M) {
      return data.map<AnnounceLiaoBaData>((e) => AnnounceLiaoBaData().fromJson(e)).toList() as M;
    }
    if (<AnnouncementData>[] is M) {
      return data.map<AnnouncementData>((e) => AnnouncementData().fromJson(e)).toList() as M;
    }
    if (<PublishDetailEntity>[] is M) {
      return data.map<PublishDetailEntity>((e) => PublishDetailEntity().fromJson(e)).toList() as M;
    }
    if (<PublishDetailData>[] is M) {
      return data.map<PublishDetailData>((e) => PublishDetailData().fromJson(e)).toList() as M;
    }
    if (<PublishDetailDataActivityDetails>[] is M) {
      return data
          .map<PublishDetailDataActivityDetails>((e) => PublishDetailDataActivityDetails().fromJson(e))
          .toList() as M;
    }
    if (<PublishDetailDataLeaderboards>[] is M) {
      return data
          .map<PublishDetailDataLeaderboards>((e) => PublishDetailDataLeaderboards().fromJson(e))
          .toList() as M;
    }
    if (<PublishDetailDataLeaderboardsMembers>[] is M) {
      return data
          .map<PublishDetailDataLeaderboardsMembers>(
              (e) => PublishDetailDataLeaderboardsMembers().fromJson(e))
          .toList() as M;
    }
    if (<FilmTvVideoDetailEntity>[] is M) {
      return data.map<FilmTvVideoDetailEntity>((e) => FilmTvVideoDetailEntity().fromJson(e)).toList() as M;
    }
    if (<FilmTvVideoDetailTags>[] is M) {
      return data.map<FilmTvVideoDetailTags>((e) => FilmTvVideoDetailTags().fromJson(e)).toList() as M;
    }
    if (<FilmTvVideoDetailPublisher>[] is M) {
      return data.map<FilmTvVideoDetailPublisher>((e) => FilmTvVideoDetailPublisher().fromJson(e)).toList()
          as M;
    }
    if (<FilmTvVideoDetailLocation>[] is M) {
      return data.map<FilmTvVideoDetailLocation>((e) => FilmTvVideoDetailLocation().fromJson(e)).toList()
          as M;
    }
    if (<FilmTvVideoDetailVidStatus>[] is M) {
      return data.map<FilmTvVideoDetailVidStatus>((e) => FilmTvVideoDetailVidStatus().fromJson(e)).toList()
          as M;
    }
    if (<FilmTvVideoDetailComment>[] is M) {
      return data.map<FilmTvVideoDetailComment>((e) => FilmTvVideoDetailComment().fromJson(e)).toList() as M;
    }
    if (<FilmTvVideoDetailWatch>[] is M) {
      return data.map<FilmTvVideoDetailWatch>((e) => FilmTvVideoDetailWatch().fromJson(e)).toList() as M;
    }
    if (<ActivityEntity>[] is M) {
      return data.map<ActivityEntity>((e) => ActivityEntity().fromJson(e)).toList() as M;
    }
    if (<ActivityData>[] is M) {
      return data.map<ActivityData>((e) => ActivityData().fromJson(e)).toList() as M;
    }
    if (<ActivityDataList>[] is M) {
      return data.map<ActivityDataList>((e) => ActivityDataList().fromJson(e)).toList() as M;
    }
    if (<LiaoBaHistoryEntity>[] is M) {
      return data.map<LiaoBaHistoryEntity>((e) => LiaoBaHistoryEntity().fromJson(e)).toList() as M;
    }
    if (<LiaoBaHistoryData>[] is M) {
      return data.map<LiaoBaHistoryData>((e) => LiaoBaHistoryData().fromJson(e)).toList() as M;
    }
    if (<LiaoBaHistoryDataWorkList>[] is M) {
      return data.map<LiaoBaHistoryDataWorkList>((e) => LiaoBaHistoryDataWorkList().fromJson(e)).toList()
          as M;
    }
    if (<LiaoBaHistoryDataWorkListTags>[] is M) {
      return data
          .map<LiaoBaHistoryDataWorkListTags>((e) => LiaoBaHistoryDataWorkListTags().fromJson(e))
          .toList() as M;
    }
    if (<LiaoBaHistoryDataWorkListPublisher>[] is M) {
      return data
          .map<LiaoBaHistoryDataWorkListPublisher>((e) => LiaoBaHistoryDataWorkListPublisher().fromJson(e))
          .toList() as M;
    }
    if (<LiaoBaHistoryDataWorkListLocation>[] is M) {
      return data
          .map<LiaoBaHistoryDataWorkListLocation>((e) => LiaoBaHistoryDataWorkListLocation().fromJson(e))
          .toList() as M;
    }
    if (<LiaoBaHistoryDataWorkListVidStatus>[] is M) {
      return data
          .map<LiaoBaHistoryDataWorkListVidStatus>((e) => LiaoBaHistoryDataWorkListVidStatus().fromJson(e))
          .toList() as M;
    }
    if (<LiaoBaHistoryDataWorkListComment>[] is M) {
      return data
          .map<LiaoBaHistoryDataWorkListComment>((e) => LiaoBaHistoryDataWorkListComment().fromJson(e))
          .toList() as M;
    }
    if (<LiaoBaHistoryDataWorkListWatch>[] is M) {
      return data
          .map<LiaoBaHistoryDataWorkListWatch>((e) => LiaoBaHistoryDataWorkListWatch().fromJson(e))
          .toList() as M;
    }
    if (<AddUserEntity>[] is M) {
      return data.map<AddUserEntity>((e) => AddUserEntity().fromJson(e)).toList() as M;
    }
    if (<AddUserData>[] is M) {
      return data.map<AddUserData>((e) => AddUserData().fromJson(e)).toList() as M;
    }
    if (<AddUserDataList>[] is M) {
      return data.map<AddUserDataList>((e) => AddUserDataList().fromJson(e)).toList() as M;
    }
    if (<AddUserDataListVInfos>[] is M) {
      return data.map<AddUserDataListVInfos>((e) => AddUserDataListVInfos().fromJson(e)).toList() as M;
    }
    if (<AddUserDataListVInfosTags>[] is M) {
      return data.map<AddUserDataListVInfosTags>((e) => AddUserDataListVInfosTags().fromJson(e)).toList()
          as M;
    }
    if (<AddUserDataListVInfosPublisher>[] is M) {
      return data
          .map<AddUserDataListVInfosPublisher>((e) => AddUserDataListVInfosPublisher().fromJson(e))
          .toList() as M;
    }
    if (<AddUserDataListVInfosLocation>[] is M) {
      return data
          .map<AddUserDataListVInfosLocation>((e) => AddUserDataListVInfosLocation().fromJson(e))
          .toList() as M;
    }
    if (<AddUserDataListVInfosVidStatus>[] is M) {
      return data
          .map<AddUserDataListVInfosVidStatus>((e) => AddUserDataListVInfosVidStatus().fromJson(e))
          .toList() as M;
    }
    if (<AddUserDataListVInfosComment>[] is M) {
      return data
          .map<AddUserDataListVInfosComment>((e) => AddUserDataListVInfosComment().fromJson(e))
          .toList() as M;
    }
    if (<AddUserDataListVInfosWatch>[] is M) {
      return data.map<AddUserDataListVInfosWatch>((e) => AddUserDataListVInfosWatch().fromJson(e)).toList()
          as M;
    }
    if (<TabsTagEntity>[] is M) {
      return data.map<TabsTagEntity>((e) => TabsTagEntity().fromJson(e)).toList() as M;
    }
    if (<TabsTagData>[] is M) {
      return data.map<TabsTagData>((e) => TabsTagData().fromJson(e)).toList() as M;
    }
    if (<AVCommentaryDetailEntity>[] is M) {
      return data.map<AVCommentaryDetailEntity>((e) => AVCommentaryDetailEntity().fromJson(e)).toList() as M;
    }
    if (<RewardAvatarEntity>[] is M) {
      return data.map<RewardAvatarEntity>((e) => RewardAvatarEntity().fromJson(e)).toList() as M;
    }
    if (<RewardAvatarData>[] is M) {
      return data.map<RewardAvatarData>((e) => RewardAvatarData().fromJson(e)).toList() as M;
    }
    if (<RewardAvatarDataList>[] is M) {
      return data.map<RewardAvatarDataList>((e) => RewardAvatarDataList().fromJson(e)).toList() as M;
    }

    throw Exception("not found");
  }

  static M fromJsonAsT<M>(json) {
    if (json is List) {
      return _getListChildType<M>(json);
    } else {
      return _fromJsonSingle<M>(json) as M;
    }
  }
}
