import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/video_item_commponent/state.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:uuid/uuid.dart';

class SubPlayListState extends MutableSource
    with EagleHelper
    implements Cloneable<SubPlayListState> {
  /// 视频列表
  List<VideoItemState> videoList = [];

  /// 传入参数
  Map<String, dynamic> proArgs;

  /// 是否开启加载更多
  bool needLoad = false;

  /// 还有下一页
  bool hasNext = true;

  /// 适配请求参数缓存
  Map<String, dynamic> requestParam;

  /// 请求链接
  String requestUrl;

  /// 当前分页
  int pageNumber = 0;

  /// 分页数量
  int pageSize = Config.PAGE_SIZE;

  /// 页面类型
  int playType;

  // 页面类型
  VideoListType type = VideoListType.SECOND;

  /// 当前播放索引
  int curVideoIndex = 0;
  PageController pageController;

  String uniqueId = Uuid().v1();
  bool canDrawer = true;

  TabController tabController;

  /// 监听外部的自动播放控制
  Function autoPlayListener;

  bool isLoading = false;

  bool isNewListRequest = false;

  String isNewListRequestId;

  initParameter() {
    this.playType = proArgs["playType"] ?? 0;
    this.curVideoIndex = proArgs["currentPosition"] ?? 0;
    this.pageController = PageController(initialPage: curVideoIndex);
    this.pageNumber = proArgs["pageNumber"] ?? 0;
    this.pageSize = proArgs["pageSize"] ?? Config.PAGE_SIZE;

    this.isNewListRequest = proArgs["isNewListRequest"] ?? false;
    this.isNewListRequestId = proArgs["isNewListRequestId"] ?? null;

    setRequestParam(proArgs);
    VideoItemState itemState;
    List<VideoModel> vms = proArgs["videoList"] ?? [];
    vms.forEach((model) {
      itemState = VideoItemState(videoModel: model);
      itemState.index = vms.indexOf(model);
      itemState.type = VideoListType.SECOND;
      itemState.uniqueId =
          "_uniqueId_in_type_${type}_at_index_${itemState.index}";
      itemState.enablePlay.value = (this.curVideoIndex == itemState.index);
      itemState.isTrandVideo = (proArgs["isTrade"]??false);
      this.videoList.add(itemState);
    });

    requestUrl = setRequestUrl(playType);
  }

  @override
  SubPlayListState clone() {
    return SubPlayListState()
      ..videoList = videoList
      ..proArgs = proArgs
      ..needLoad = needLoad
      ..hasNext = hasNext
      ..requestParam = requestParam
      ..requestUrl = requestUrl
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..playType = playType
      ..type = type
      ..curVideoIndex = curVideoIndex
      ..pageController = pageController
      ..uniqueId = uniqueId
      ..canDrawer = canDrawer
      ..isLoading = isLoading
      ..tabController = tabController
      ..autoPlayListener = autoPlayListener;
  }

  setRequestParam(Map<String, dynamic> args) {
    this.requestParam = {};
    assert(args["playType"] != null);
    switch (playType) {
      case VideoPlayConfig.HOT_VIDEO_FIND:
        this.requestParam["tagID"] = args["tagID"];
        break;
      case VideoPlayConfig.VIDEO_TYPE_NEARBY:
        this.requestParam["city"] = args["city"];
        this.requestParam["ip"] = args["ip"];
        break;
      case VideoPlayConfig.VIDEO_CITY_PLAY:
      case VideoPlayConfig.VIDEO_TYPE_HOT:
      case VideoPlayConfig.VIDEO_TYPE_TODAY_HOT:
        this.needLoad = true;
        break;
      case VideoPlayConfig.VIDEO_TAG:
        this.requestParam["tagID"] = args["tagID"];
        break;
      case VideoPlayConfig.VIDEO_FIND:
        this.requestParam["tagID"] = args["tagID"];
        break;
      case VideoPlayConfig.VIDEO_MORE_SEARCH:
        this.requestParam['keyWords'] = args["keyWords"];
        this.requestParam['realm'] = args["realm"];
        break;
      case VideoPlayConfig.VIDEO_DAY_HOT_RANK:
        this.requestParam["pageSize"] = args["pageSize"];
        break;
      case VideoPlayConfig.VIDEO_TYPE_WORKS:
        this.requestParam["uid"] = args["uid"];
        break;
      case VideoPlayConfig.VIDEO_TYPE_BUY:
        this.requestParam["uid"] = args["uid"];
        break;
      case VideoPlayConfig.VIDEO_TYPE_ENDORSE:
        this.requestParam["uid"] = args["uid"];
        break;
      case VideoPlayConfig.VIDEO_TYPE_COLLECT:
        this.requestParam["uid"] = args["uid"];
        this.requestParam["type"] = args["type"];
        break;
      case VideoPlayConfig.VIDEO_TYPE_ZONE:
        this.requestParam["theme"] = args["theme"];
        break;
      case VideoPlayConfig.VIDEO_POST:
        requestParam["type"] = null != args["requestparames"]
            ? args["requestparames"]["type"]
            : null;
        requestParam["subType"] = null != args["requestparames"]
            ? args["requestparames"]["subType"]
            : null;
    }
  }

  String setRequestUrl(int _playType) {
    switch (_playType) {
      case VideoPlayConfig.HOT_VIDEO_FIND:
        return Address.SEARCH_WONDER_API;
        break;
      case VideoPlayConfig.VIDEO_TYPE_NEARBY:
        return Address.SAME_CITY_LIST;
        break;
      case VideoPlayConfig.VIDEO_TAG:
        return Address.TAG_VIDEO_LIST;
        break;
      case VideoPlayConfig.VIDEO_FIND:
        return Address.SEARCH_WONDER_API;
        break;
      case VideoPlayConfig.VIDEO_MORE_SEARCH:
        return Address.SEARCH_TALK_API;
        break;
      case VideoPlayConfig.VIDEO_DAY_HOT_RANK:
        return Address.SEARCH_VID_HOT_API;
        break;
      case VideoPlayConfig.VIDEO_TYPE_WORKS:
        return Address.MINE_WORKS;
        break;
      case VideoPlayConfig.VIDEO_TYPE_BUY:
        return Address.MINE_BUY_VIDEO;
        break;
      case VideoPlayConfig.VIDEO_TYPE_ENDORSE:
        return Address.MINE_LIKE_VIDEO;
        break;
      case VideoPlayConfig.VIDEO_TYPE_COLLECT:
        return Address.MY_FAVORITE;
        break;
      case VideoPlayConfig.VIDEO_TYPE_ZONE:
        return Address.SEARCH_TOPIC_API;
        break;
      case VideoPlayConfig.VIDEO_POST:
        return Address.COMMUNITY_LIST_TOPIC;
      default:
        return null;
    }
  }

  @override
  Object getItemData(int index) {
    return videoList[index];
  }

  @override
  String getItemType(int index) {
    return 'video_item';
  }

  @override
  int get itemCount => videoList?.length ?? 0;

  @override
  void setItemData(int index, Object data) {
    if (data is Cloneable) {
      videoList[index] = data.clone();
    } else {
      videoList[index] = data;
    }
  }
}

SubPlayListState initState(Map<String, dynamic> args) {
  SubPlayListState newState = SubPlayListState();
  newState.proArgs = args;
  var canDrawer = true;
  if (null != args && args['playType'] == VideoPlayConfig.VIDEO_TYPE_WORKS) {
    ///我的作品不能左滑
    canDrawer = false;
  }

  ///BloggerPage 个人主页不能左滑
  if (null != args &&
      args.containsKey("canDrawer") &&
      args['canDrawer'] == false) {
    //我的作品不能左滑
    canDrawer = false;
  }

  newState.canDrawer = canDrawer;
  newState.tabController =
      TabController(initialIndex: 0, length: 2, vsync: ScrollableState());
  newState.initParameter();
  return newState;
}
