import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/assets/svg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/local_server/local_server.dart';
import 'package:flutter_base/utils/file_util.dart';
import 'package:flutter_base/utils/log.dart';

const String player_tag = "player";

/// 打印控制
playerPrint(Object msg) {
  l.i(player_tag, "$msg", saveFile: false);
}

class VideoResolution {
  double videoWidth;
  double videoHeight;

  VideoResolution(this.videoWidth, this.videoHeight);
  @override
  String toString() {
    return "videoWidth:$videoWidth  videoHeight:$videoHeight";
  }
}

/// 获取竖版播放器的实际使用宽高
///不管分辨率多少缩放到适合容器的大小
/// [containerWidth] 视频容器/输入视频限制 宽度
/// [containerHeight] 视频容器/输入视频限制 高度
/// [resolutionWidth] 服务器给的分辨率 宽度
/// [resolutionHeight] 服务器给的分辨率 高度
/// [enableLoose] 是否允许丢失/宽松部分宽高来适配，不然可能留白太多，短视频true，长视频false
VideoResolution configVideoSize(double containerWidth, double containerHeight,
    double resolutionWidth, double resolutionHeight,
    [bool enableLoose = true]) {
  assert(null != containerWidth &&
      null != containerHeight &&
      null != resolutionWidth &&
      null != resolutionHeight);

  /// 输出视频宽和高
  double outVideoWidth, outVideoHeight;

  resolutionWidth =
      (resolutionWidth ?? 0) <= 0 ? containerWidth : resolutionWidth;
  resolutionHeight =
      (resolutionHeight ?? 0) <= 0 ? containerHeight : resolutionHeight;

  /// 视频容器宽高比
  double containerAspectRation = containerWidth / containerHeight;

  /// 视频宽高比
  double videoAspectRation = resolutionWidth / resolutionHeight;
  playerPrint(
      "configVideoSize()...cw:$containerWidth ch:$containerHeight rw:$resolutionWidth rh:$resolutionHeight containerAspectRation:$containerAspectRation  videoAspectRation:$videoAspectRation");

  bool shouldBeWider = videoAspectRation > containerAspectRation;
  if (shouldBeWider) {
    //尝试按屏幕宽计算视频高
    outVideoWidth = containerWidth;
    outVideoHeight = containerWidth / videoAspectRation;
    if (enableLoose && outVideoHeight / containerHeight > 0.7) {
      //定宽算出来的高度 超过0.7,这时按高缩放,裁剪宽
      outVideoHeight = containerHeight;
      outVideoWidth = videoAspectRation * outVideoHeight;
    }
  } else {
    outVideoHeight = containerHeight;
    outVideoWidth = videoAspectRation * outVideoHeight;
    if (enableLoose && outVideoWidth / containerWidth > 0.7) {
      //定高算出来ls的宽度 占屏幕宽比超过0.7,这时按宽缩放,裁剪高
      outVideoWidth = containerWidth;
      outVideoHeight = outVideoWidth / videoAspectRation;
    }
  }
  var vr = VideoResolution(outVideoWidth, outVideoHeight);
  playerPrint("configVideoSize()...vr:$vr");
  return vr;
}

/// 根据分辨率判断是否是竖直的视频
/// 宽高比大于4:3才被认为是横版视频
bool isHorizontalVideo(double resolutionWidth, double resolutionHeight) {
  /// 暂时返回>4:3的视频,1:1的视频旋转没有没有意义
  return (resolutionWidth > resolutionHeight * 1.3);
  // return (vHeight / vWidth > 1.3);
}

double resolutionWidth(String resolution) {
  if (TextUtil.isNotEmpty(resolution)) {

    var arr ;
    if(resolution.contains("x")){
      arr = resolution.split("x");
    }else{
      arr = resolution.split("*");
    }

    if (ArrayUtil.isNotEmpty(arr)) {
      return double.parse(arr[0] ?? "0");
    }
  }
  return .0;
}

double resolutionHeight(String resolution) {
  if (TextUtil.isNotEmpty(resolution)) {
    var arr = resolution.split("*");
    if (ArrayUtil.isNotEmpty(arr) && arr.length > 1) {
      return double.parse(arr[1] ?? "0");
    }
  }
  return .0;
}

Widget buildVideoLoading() {
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(
      height: 16.0,
      child: const FlareActor(
          'packages/${FlutterBase.basePkgName}/${AssetsSvg.LOADING}',
          animation: 'Untitled',
          boundsNode: FlutterBase.basePkgName),
    ),
    SizedBox(height: 5),
    StreamBuilder<int>(
        // 监听Stream，每次值改变的时候，更新Text中的内容
        stream: CacheServer().onVideoSpeedUpdate,
        initialData: 0,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return Container(
              padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 6.0),
              decoration: BoxDecoration(
                  color: Color(0x66000000),
                  borderRadius: BorderRadius.circular((10.0))),
              child: Text(FileUtil.byteSpeedFmt(snapshot.data),
                  maxLines: 1,
                  style: TextStyle(fontSize: 12, color: Colors.white)));
        })
  ]);
}
