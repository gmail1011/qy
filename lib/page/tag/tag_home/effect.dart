import 'dart:io';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/model/tag/tag_bean.dart';
import 'package:flutter_app/model/tag/tag_detail_model.dart';
import 'package:flutter_app/page/tag/tag_home/compont/cell/state.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_app/widget/dialog/no_permission_dialog.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/net2/net_manager.dart';
import 'action.dart';
import 'state.dart';

///Effect 常用于定义 网络数据请求，或是界面点击事件等非数据操作
Effect<TagState> buildEffect() {
  return combineEffects(<Object, Effect<TagState>>{
    Lifecycle.initState: _init,
    TagAction.add: _onCollect,
    TagAction.onVideoLoadMore: _getTagListData,
    TagAction.onCoverLoadMore: _getWordTagListData,
    TagAction.onMovieLoadMore: _getMovieTagListData,
    TagAction.onclickVideo: _onclickVideo,
    TagAction.onVideoRecode: _onVideoRecorder,
    TagAction.onGetTagDetail: _onGetTagDetail
  });
}

_init(Action action, Context<TagState> ctx) async {
  Future.delayed(Duration(milliseconds: 200), () async {
    //执行标签详情请求
    await getTagInfo(ctx);
    //获取标签列表
    // Map<String, dynamic> mapList = Map();
    // mapList['tagID'] = ctx.state.tagId;
    // mapList['pageNumber'] = 1;
    // mapList['pageSize'] = 15;
    String tagID = ctx.state.tagId;
    try {
      TagBean tagListModel =
          await netManager.client.requestTagListData(1, 15, tagID);
      // println(json.encode(responseList.data));
      // TagBean tagListModel = TagBean.fromMap(responseList.data);
      ctx.dispatch(TagActionCreator.requestVideoListSuccess(tagListModel));
    } catch (e) {
      l.d('requestTagListData', e.toString());
      if (ctx.context == null) return;
      ctx.dispatch(TagActionCreator.onError(Lang.SERVER_ERROR));
    }
    //eaglePage(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  });

  Future.delayed(Duration(milliseconds: 200),(){
    _getWordTagListData(action,ctx);
  });


  Future.delayed(Duration(milliseconds: 400),(){
    _getMovieTagListData(action,ctx);
  });
}

Future getTagInfo(Context<TagState> ctx) async {
  // Map<String, dynamic> map = Map();
  // map['tagID'] = ctx.state.tagId;
  // BaseResponse response = await getTagDetail(map);

  String tagID = ctx.state.tagId;
  try {
    TagDetailModel tagDetailModel = await netManager.client.getTagDetail(tagID);
    ctx.dispatch(TagActionCreator.requestTagDetail(tagDetailModel));
  } catch (e) {
    l.d('getTagDetail', e.toString());
    ctx.dispatch(TagActionCreator.onError(Lang.SERVER_ERROR));
  }
  // if (response.code == 200) {
  //   TagDetailModel tagDetailModel = TagDetailModel.fromJson(response.data);
  //   ctx.dispatch(TagActionCreator.requestTagDetail(tagDetailModel));
  // } else {
  //   ctx.dispatch(TagActionCreator.onError(Lang.SERVER_ERROR));
  // }
}

_getTagListData(Action action, Context<TagState> ctx) async {
  int pageNumber = action.payload;
  int pageSize = ctx.state.pageSize;
  String tagID = ctx.state.tagId;

  TagBean nearbyBean;
  try {
    if (action.payload != null) {
      nearbyBean = await netManager.client
          .requestTagListDataByType(pageNumber, pageSize, tagID, "SP");

      ctx.state.tagVideoBean.list.addAll(nearbyBean.list);

      if (nearbyBean.hasNext) {
        ctx.state.refreshController.loadComplete();
      } else {
        ctx.state.refreshController.loadNoData();
      }

      ctx.dispatch(TagActionCreator.requestVideoListSuccess(ctx.state.tagVideoBean));
    } else {
      nearbyBean = await netManager.client
          .requestTagListDataByType(ctx.state.pageNumber, pageSize, tagID, "SP");

      if (nearbyBean.hasNext) {
        ctx.state.refreshController.loadComplete();
      } else {
        ctx.state.refreshController.loadNoData();
      }

      ctx.dispatch(TagActionCreator.requestVideoListSuccess(nearbyBean));
    }
  } catch (e) {
    l.d('getCityVideoList=', e.toString());
    showToast(msg: e.toString());
    // ctx.dispatch(CityVideoActionCreator.onError(e.toString()));
  }
}


_getWordTagListData(Action action, Context<TagState> ctx) async {
  int pageNumber = action.payload;
  int pageSize = ctx.state.pageSize;
  String tagID = ctx.state.tagId;

  TagBean nearbyBean;
  try {
    if (action.payload != null) {
      nearbyBean = await netManager.client
          .requestTagListDataByType(pageNumber, pageSize, tagID, "COVER");

      nearbyBean.list.removeWhere((element) => element.newsType == "SP");

      ctx.state.tagWordBean.list.addAll(nearbyBean.list);

      if (nearbyBean.hasNext) {
        ctx.state.refreshWordController.loadComplete();
      } else {
        ctx.state.refreshWordController.loadNoData();
      }

      ctx.dispatch(TagActionCreator.requestWordListSuccess(ctx.state.tagWordBean));
    } else {
      nearbyBean = await netManager.client
          .requestTagListDataByType(ctx.state.pageWordNumber, pageSize, tagID, "COVER");

      nearbyBean.list.removeWhere((element) => element.newsType == "SP");

      if (nearbyBean.hasNext) {
        ctx.state.refreshWordController.loadComplete();
      } else {
        ctx.state.refreshWordController.loadNoData();
      }

      ctx.dispatch(TagActionCreator.requestWordListSuccess(nearbyBean));
    }
  } catch (e) {
    l.d('getCityVideoList=', e.toString());
    showToast(msg: e.toString());
    // ctx.dispatch(CityVideoActionCreator.onError(e.toString()));
  }
}


_getMovieTagListData(Action action, Context<TagState> ctx) async {
  int pageNumber = action.payload;
  int pageSize = ctx.state.pageSize;
  String tagID = ctx.state.tagId;

  TagBean nearbyBean;
  try {
    if (action.payload != null) {
      nearbyBean = await netManager.client
          .requestTagListDataByType(pageNumber, pageSize, tagID, "MOVIE");

      ctx.state.tagMovieBean.list.addAll(nearbyBean.list);

      if (nearbyBean.hasNext) {
        ctx.state.refreshMovieController.loadComplete();
      } else {
        ctx.state.refreshMovieController.loadNoData();
      }

      ctx.dispatch(TagActionCreator.requestMovieListSuccess(ctx.state.tagMovieBean));
    } else {
      nearbyBean = await netManager.client
          .requestTagListDataByType(ctx.state.pageMovieNumber, pageSize, tagID, "MOVIE");

      if (nearbyBean.hasNext) {
        ctx.state.refreshMovieController.loadComplete();
      } else {
        ctx.state.refreshMovieController.loadNoData();
      }

      ctx.dispatch(TagActionCreator.requestMovieListSuccess(nearbyBean));
    }
  } catch (e) {
    l.d('getCityVideoList=', e.toString());
    showToast(msg: e.toString());
    // ctx.dispatch(CityVideoActionCreator.onError(e.toString()));
  }
}

// 收藏、取消收藏
_onCollect(Action action, Context<TagState> ctx) async {
  // Map<String, dynamic> map = Map();
  // map["type"] = "tag";
  // map["objID"] = ctx.state.tagId;
  // map["isCollect"] = action.payload;
  // BaseResponse response = await changeTagStatus(map);

  String type = 'tag';
  String objID = ctx.state.tagId;
  bool isCollect = action.payload;

  try {
    await netManager.client.changeTagStatus(objID, isCollect, type);
    ctx.dispatch(TagActionCreator.changeCollectStatusSuccess(action.payload));
  } catch (e) {
    l.d('changeTagStatus', e.toString());
    if (ctx.context == null) return;
    showToast(msg: e.toString());
  }

  // if (response.code == 200) {
  //   ctx.dispatch(TagActionCreator.changeCollectStatusSuccess(action.payload));
  // } else {
  //   if (ctx.context == null) return;
  //   showToast(msg: response.toString());
  // }
}

///点击视频
_onclickVideo(Action action, Context<TagState> ctx) async {
  TagItemState videoModel = action.payload;
  eagleClick(ctx.state.selfId(), sourceId: ctx.state.eagleId(ctx.context));
  Map<String, dynamic> map = Map();
  map["tagID"] = ctx.state.tagId;
  map["currentPosition"] = ctx.state.tagLists.indexOf(videoModel);
  map["pageSize"] = ctx.state.pageSize;
  map["pageNumber"] = ctx.state.pageNumber;
  map["playType"] = VideoPlayConfig.VIDEO_TAG;
  map['videoList'] = ctx.state.tagLists.map((it) => it.videoModel).toList();
  JRouter().go(SUB_PLAY_LIST, arguments: map);
}

///录制视频
_onVideoRecorder(Action action, Context<TagState> ctx) async {
  ///首先，检查权限
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
  ].request();
  if (statuses[Permission.camera].isGranted &&
      statuses[Permission.microphone].isGranted) {
    JRouter().go(VIDEO_PUBLISH);
  } else {
//拒绝或者没有权限
    if (Platform.isIOS) {
      if (!await Permission.camera.isGranted ||
          !await Permission.camera.isGranted) {
        //只要有一个权限没给，那么就提示ios用户手动去设置页面开启权限
        bool val = await showDialog(
            context: ctx.context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return NoPermissionDialog(msg: Lang.cancel);
            });
        if (val) {
          //去设置页面设置
          openAppSettings();
        }
      }
    }
  }
}

///获取标签详情
_onGetTagDetail(Action action, Context<TagState> ctx) async {
  getTagInfo(ctx);
}
