import 'package:flutter/services.dart';
import 'package:flutter_app/common/tasks/video_cmd_helper.dart';
import 'package:flutter_base/utils/file_util.dart';
import 'package:mime/mime.dart';

/// 视频工具类
class VideoUtils {
  ///获取视频mimeType
  static Future<String> getMimeType(String localPath) async {
    String mimeTypeStr = 'mp4';
    try {
      mimeTypeStr = lookupMimeType(localPath);
      // const platform = const MethodChannel("com.yinse/device");
      // await platform.invokeMethod("getMimeType", {'filePath': localPath});
    } on PlatformException {
      return '';
    }
    return mimeTypeStr;
  }

  ///获取视频时长
  static Future<int> getVideoDuration(String localPath) async {
    const platform = const MethodChannel("com.yinse/device");
    int duration = 0;
    try {
      duration = await platform
          .invokeMethod("getVideoDuration", {'filePath': localPath});
    } on PlatformException {
      return duration;
    }
    return duration;
  }

  ///获取视频分辨率
  static Future<String> getVideoResolution(String localPath) async {
    const platform = const MethodChannel("com.yinse/device");
    String resolutionStr = '';
    try {
      resolutionStr = await platform
          .invokeMethod("getVideoResolution", {'filePath': localPath});
    } on PlatformException {
      return '';
    }
    return resolutionStr;
  }

  ///获取视频宽高比
  static Future<String> getVideoRatio(String localPath) async {
    const platform = const MethodChannel("com.yinse/device");
    String ratioStr = '';
    try {
      ratioStr =
          await platform.invokeMethod("getVideoRatio", {'filePath': localPath});
    } on PlatformException {
      return '';
    }
    return ratioStr;
  }

  ///获取视频封面
  static Future<String> getVideoCoverPath(String localPath) async {
    const platform = const MethodChannel("com.yinse/device");
    String coverPath = '';
    try {
      coverPath = await platform
          .invokeMethod("saveCoverInLocal", {'filePath': localPath});
    } on PlatformException {
      return '';
    }
    return coverPath;
  }

  ///获取视频比特率
  static Future<String> getVideoBitrate(String localPath) async {
    const platform = const MethodChannel("com.yinse/device");
    String bitrate = '';
    try {
      bitrate = await platform
          .invokeMethod("getVideoBitrate", {'filePath': localPath});
    } on PlatformException {
      return '';
    }
    return bitrate;
  }

  /// 获取视频信息
  static Future<MediaInfo> getMediaInfo(String localPath) async {
    if (!FileUtil.isFileExist(localPath)) return Future.value(null);
    MediaInfo videoInfo = MediaInfo();
    videoInfo.resolution = await getVideoResolution(localPath);
    videoInfo.ratio = double.parse(await getVideoRatio(localPath));
    videoInfo.playTime = await getVideoDuration(localPath);
    videoInfo.bitrate = await getVideoBitrate(localPath);
    videoInfo.size = FileUtil.getFileSize(localPath);
    videoInfo.mimeType = await getMimeType(localPath);
    return videoInfo;
  }

  ///根据ffmpeg获取视频信息
  static Future<Map<String, dynamic>> getVideoInfo(String localPath) async {
    if (localPath == null || localPath.isEmpty) return Future.value(null);
    Map<String, dynamic> infoMap = {};
    var videoInfo = await VideoCmdHelper().getVideoInfos(localPath);
    int size = videoInfo["size"] ?? 0;
    if (size == 0) {
      return Future.value(null);
    }
    int duration = videoInfo["playTime"] ?? 0;
    int width = videoInfo["width"] ?? 0;
    int height = videoInfo["height"] ?? 0;
    //bytes
    infoMap['size'] = size;
    infoMap['width'] = width;
    infoMap['height'] = height;
    //width/height
    infoMap['ratio'] = width * 1.0 / height;
    //seconds
    infoMap['playTime'] = duration ~/ 1000;
    infoMap['bitrate'] = videoInfo["bitrate"];
    return infoMap;
  }
}

class MediaInfo {
  int size;
  String resolution;
  double ratio;
  int playTime;
  String bitrate;
  String mimeType;
}
