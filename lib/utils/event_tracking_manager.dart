import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net/api.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/base_response.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_base/net/dio_cli.dart';
import 'package:dio/dio.dart';
import 'package:flutter_base/utils/log.dart';

enum GraphicsType { vip, coin }

///数据埋点 管理类
// 泡芙: 1
// 色中色: 7
// 蜜桃: 15
// 黑料: 13
// 妖精: 14
// 红杏: 16
// 无忧: 17
// 五月天: 18
// 瑶池: 19
// 知音: 20
// 春水: 21
const int appId = 13;

class EventTrackingManager {
  static EventTrackingManager _instance;

  factory EventTrackingManager() {
    if (_instance == null) {
      _instance = EventTrackingManager._();
    }
    return _instance;
  }

  EventTrackingManager._();

  Dio _dio = createDio();
  //视频埋点列表 videoId : true
  Map videos = {};

  ///类型 视频：1
  addVideoDatas(videoId, videoTitle) {
    if ((videos[videoId] ?? false)) {
      return;
    }
    videos[videoId] = true;
    final _data = {
      'dataType': 1,
      'videoDatas': {
        'appId': appId,
        'videoId': videoId,
        'videoTitle': videoTitle,
        'userType': GlobalStore.isVIP() ? 1 : 2
      }
    };
    _post(_data, '视频');
  }

  ///类型 标签：2
  addTagsDatas(tagsName) {
    final _data = {
      'dataType': 2,
      'tagDatas': {
        'appId': appId,
        'tagsName': tagsName,
        'userType': GlobalStore.isVIP() ? 1 : 2
      }
    };
    _post(_data, '标签');
  }

  ///类型 充值：3
  //graphicsId  视频传视频id   横幅传banner   用户自己传user
  //graphicsType 充值类型 1 金币 2 VIP
  static String _graphicsId = 'user';
  static String _graphicsTitle = 'user';
  static GraphicsType _graphicsType = GraphicsType.coin;
  addVideoVipGraphicss(videoId, videoTitle, GraphicsType graphicsType) {
    _graphicsId = videoId;
    _graphicsTitle = videoTitle;
    _graphicsType = graphicsType;
    addVipGraphicss();
    // _addVipGraphicss(videoId, videoTitle, graphicsType);
  }

  addBannerVipGraphicss(GraphicsType graphicsType) {
    _graphicsId = 'banner';
    _graphicsTitle = 'banner';
    _graphicsType = graphicsType;
    addVipGraphicss();
    // _addVipGraphicss('banner', 'banner', graphicsType);
  }
  //eventType 签到传值：signIn  打赏传值：exceptional
  addUserVipGraphicss(GraphicsType graphicsType, {String eventType}) {
    _graphicsId = eventType ?? 'user';
    _graphicsTitle = 'user';
    _graphicsType = graphicsType;
    addVipGraphicss();
    // _addVipGraphicss('user', 'user', graphicsType);
  }

  addVipGraphicss() {
    final _data = {
      'dataType': 3,
      'VipGraphicss': {
        'appId': appId,
        'graphicsId': _graphicsId,
        'graphicsTitle': _graphicsTitle,
        'graphicsType': _graphicsType == GraphicsType.coin ? 1 : 2,
        'userType': GlobalStore.isVIP() ? 1 : 2
      }
    };
    _post(_data,
        '$_graphicsId, $_graphicsTitle ${_graphicsType == GraphicsType.coin ? '金币' : 'VIP'}充值');
  }

  _post(data, dataType) async {
    if (Config.dataBuriedPoint.isEmpty) {
      return;
    }
    try {
      Response resp =
          await _dio.post(Config.dataBuriedPoint + "/api/embed/prd/dataAdd", data: data);
      l.e('EventTracking', "$dataType埋点成功");
    } catch (e) {
      l.e('EventTracking', "埋点 error:$e");
    }
  }
}
