import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/varibel_config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/common/provider/can_play_count_model.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/liao_ba_tags_detail_entity.dart';
import 'package:flutter_app/model/local_video_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';

///是否需要购买VIP
bool needBuyVip(VideoModel videoModel)  {
  if (videoModel.freeArea ?? false) {
    return false;
  }


  ///VIP判断
  if (TextUtil.isNotEmpty(GlobalStore.getMe()?.vipExpireDate) ?? false) {
    DateTime dateTime = DateTime.parse(GlobalStore.getMe()?.vipExpireDate);
    if (dateTime.isAfter((netManager.getFixedCurTime()))) {
      return false;
    }
  }

  ///是否需要金币
  if (videoModel.coins != 0) {
    return false;
  }

  ///自己
  if (GlobalStore.isMe(videoModel.publisher.uid)) {
    return false;
  }

  ///已经播放过的则可以播放
  bool isInclude = false;
  if (VariableConfig.playedVideoList != null) {
    VariableConfig.playedVideoList.forEach((model) {
      if (model.videoID == videoModel.id) {
        isInclude = true;
      }
    });
  }
  if (isInclude) {
    return false;
  }
  if (playCountModel.canPlayCnt <= 0 && videoModel.originCoins == 0) {
    return true;
  }
  return false;
}

/// 是否需要购买视屏，视频是需要付费的
bool needBuyVideo(VideoModel model) {
  if (null == model) return false;

  return (model.isCoinVideo() &&
      !GlobalStore.isMe(model.publisher?.uid) &&
      !model.vidStatus.hasPaid &&
      !(model.freeArea ?? false));
}

///封面图
Widget getFullPlayerCoverWidget(
    String remoteCoverPath, double videoWidth, double videoHeight) {
  return Container(
    height: screen.screenHeight,
    width: screen.screenWidth,
    color: Colors.transparent,
    child: Center(
      child: CustomNetworkImage(
        width: videoWidth,
        height: videoHeight,
        imageUrl: remoteCoverPath,
        type: ImgType.cover,
        fit: BoxFit.contain,
      ),
    ),
  );
}

///发送播放记录
sendRecord(Duration position, Duration duration, VideoModel videoModel) async {
  if (position == null || duration == null) {
    return;
  }
  if (position.inMilliseconds < 1000) {
    return;
  }
  int durationInMil = duration.inMilliseconds;
  if (durationInMil <= 0) {
    durationInMil = videoModel.playTime * 1000;
  }
  // Map<String, dynamic> param = {};
  // param["videoID"] = videoModel.id;
  // param["playWay"] = videoModel.coins == 0 ? 0 : 1;
  // param["longer"] = position.inSeconds;
  // param["progress"] =
  //     ((position.inMilliseconds / duration.inMilliseconds) * 100).toInt();
  // param["via"] = 1;
  // if (videoModel.tags?.isNotEmpty ?? false) {
  //   param["tagID"] = videoModel.tags[0].id;
  // }
  try {
    String videoID = videoModel.id;
    int playWay = videoModel.coins == 0 ? 0 : 1;
    int longer = position.inSeconds;
    int progress = ((position.inMilliseconds / durationInMil) * 100).toInt();
    int via = 1;
    String tagID;
    if (videoModel.tags?.isNotEmpty ?? false) {
      tagID = videoModel.tags[0].id;
    }
    await netManager.client
        .sendVideoRecord(videoID, playWay, longer, progress, via, tagID);
  } catch (e) {
    l.e('sendVideoRecord', "error:$e");
  }
  // sendVideoRecord(param);
}

///本地记录播放次数
recordPlayCount(VideoModel videoModel, context) async {
  bool isInclude = false;
  if (VariableConfig.playedVideoList != null) {
    VariableConfig.playedVideoList.forEach((model) {
      if (model.videoID == videoModel.id) {
        isInclude = true;
      }
    });
  }
  bool isVip = false;
  if (TextUtil.isNotEmpty(GlobalStore.getMe()?.vipExpireDate) ?? false) {
    DateTime dateTime = DateTime.parse(GlobalStore.getMe()?.vipExpireDate);
    if (dateTime.isAfter((netManager.getFixedCurTime()))) {
      isVip = true;
    }
  }
  if (!isVip &&
      !isInclude &&
      videoModel.coins == 0 &&
      !GlobalStore.isMe(videoModel.publisher.uid) &&
      !(videoModel.freeArea ?? false)) {
    ///发送此视频已播放的记录
    // getPlayStatus(map: {"vid": videoModel.id});
    try {
      await netManager.client.getPlayStatus(videoModel.id);
    } catch (e) {
      l.e('getPlayStatus', e.toString());
      showToast(msg: e.toString());
    }

    LocalVideoModel model = LocalVideoModel();
    model.day = (netManager.getFixedCurTime()).day;
    model.videoID = videoModel.id;
    VariableConfig.playedVideoList.add(model);
    String convertValue = convert.jsonEncode(VariableConfig.playedVideoList);
    if (convertValue != null && convertValue.isNotEmpty) {
      lightKV.setString(Config.LOOKED_VIDEO_LIST, convertValue);
    }
    playCountModel.decreasePlayCnt();
    // Provider.of<PlayCountModel>(context, listen: false).decreasePlayCnt();
  }
}
