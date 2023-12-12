import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/model/domain_source_model.dart';
import 'package:flutter_app/model/local_video_model.dart';
import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/page/user/member_centre_page/wallet/gold_tickets.dart';

///统一存储一些静态变量d
class VariableConfig {
  ///楼风H5域名
  static String louFengH5;

  ///金币充值列表
  static List<RechargeTypeModel> rechargeType;

  ///果币充值列表
  static List<RechargeTypeModel> rechargeNakeChatType;

  ///已经播放过的视频
  static List<LocalVideoModel> playedVideoList = [];

  ///视频密
  static dynamic secContent;

  ///token异常弹窗
  static bool onMobileLoginView = false;

  static int totalWatch;


  static String luckyDrawH5;

  static GoldTickets goldTickets;

  static String videoCollectionPrice;

  static String refreshVideo = "refreshVideo";

  static String refreshVideoInfo = "refreshVideoInfo";

}
