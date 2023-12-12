import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';

enum CmdType { video, image }

/// ffmpeg cmd 相关工具类
/// 视频压缩 ，获取视频图片，获取视频信息
///
///
///    压缩
///    VideoCmdUtils().compress(_path).then((data){
///      print("VideoCmdUtils compress path $data");
///    });
///    获取视频封面
///    VideoCmdUtils().getPic(_path).then((data){
///        print(" path $data");
///    });
///    视频信息
///    VideoCmdUtils().getVideoInfos(_path).then((data){
///        if(data.length>0){
///          print(" video info $data");
///        }else{
///          print(" video not exists");
///        }
///   });
///    视频压缩监听进度
///    VideoCmdUtils().setCompressCallBack(this.onCompressCallback);
///
///    void onCompressCallback(double progress){
///       print("VideoCmdUtils onCompressCallback $progress");
///    }
///
///    关闭页面调用 释放资源
///    VideoCmdUtils().disable();
class VideoCmdHelper {
  // final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  // final FlutterFFprobe _flutterFFprobe = FlutterFFprobe();

  // final FlutterFFmpegConfig _flutterFFmpegConfig = FlutterFFmpegConfig();

  VideoCmdHelper._();

  static final VideoCmdHelper _instance = VideoCmdHelper._();

  factory VideoCmdHelper() => _instance;

  Function(double progress) compressCallBack;

  /// 表示当前视频时长
  int videoDuration = 0;

  /// 表示当前视频压缩进度时长
  double compressProgress = 0;
  Directory directory;

  ///压缩视频
  Future<String> compress(String path, double br, int width, int height) async {
    String createPath = await creatDataPath(path, CmdType.video);
    //宽屏
    if (width > height) {
      if (height > 720) {
        width = (width * 720.0 / height).round();
        width = (width / 2).round() * 2;
        height = 720;
      }
    }
    //窄屏幕
    else {
      if (width > 720) {
        height = (height * 720.0 / width).round();
        height = (height / 2).round() * 2;
        width = 720;
      }
    }
    var bv = br.toString() + "M";
    var arguments = [
      "-y",
      "-i",
      path,
      "-b:v",
      bv,
      '-c:a',
      'aac',
      '-b:a',
      '128k',
      "-maxrate",
      "3.0M",
      "-bufsize",
      "3.0M",
      "-level",
      "3.0",
      "-r",
      "24",
      "-c:v",
      "libx264",
      '-preset',
      '2',
      '-crf',
      '24',
      '-vf',
      'scale=$width:$height',
      '-metadata',
      'comment=compressedByClient',
      createPath
    ];
    return baseCmd(path, arguments, CmdType.video);
  }

  ///获取视频第一帧图片
  Future<String> getPic(String path) async {
    String createPath = await creatDataPath(path, CmdType.image);
    var arguments = [
      "-y",
      "-i",
      path,
      "-ss",
      "00:00:00",
      "-vframes",
      "1",
      "-f",
      "image2",
      "-vcodec",
      "mjpeg",
      createPath
    ];
    return baseCmd(path, arguments, CmdType.image);
  }

  Future<String> baseCmd(
      String path, List<String> arguments, CmdType type) async {
    String createPath = await creatDataPath(path, type);
    File file = new File(createPath);
    if (await file.exists()) {
      return createPath;
    }
    if (type == CmdType.video) {
      Map<String, dynamic> videoInfo = await getVideoInfos(path);
      videoDuration = videoInfo["playTime"];
      compressProgress = 0;
    }
    // _flutterFFmpegConfig.enableStatisticsCallback(this.statisticsCallback);
    // int cmdResult = await _flutterFFmpeg.executeWithArguments(arguments);
    // if (cmdResult != 0) {
    //   return "";
    // }
    return createPath;
  }

  ///根据 不同平台创建相应的本地路径
  creatDataPath(String path, CmdType type) async {
    String creatMd5 = generateMd5(path);
    // directory = await getExternalStorageDirectory();
    directory = await getTemporaryDirectory();
    if (type == CmdType.video) {
      return directory.path + "/" + creatMd5 + ".mp4";
      // return path.substring(0, path.lastIndexOf('/') + 1) + creatMd5 + ".mp4";
    }
    return directory.path + "/" + creatMd5 + ".jpeg";
  }

  void statisticsCallback(int time, int size, double bitrate, double speed,
      int videoFrameNumber, double videoQuality, double videoFps) {
    if (compressCallBack != null) {
      double progress = (time / videoDuration);
      if (progress > 0 && progress < 1 && progress - compressProgress > 0.05) {
        compressProgress = progress;
        compressCallBack(progress);
      }
    }
  }

  /// Sets a callback to redirect FFmpeg statistics. [newCallback] is a new statistics callback function, use null to disable a previously defined callback
  void setCompressCallBack(Function(double progress) newCallback) {
    if (compressCallBack != null) {
      this.compressCallBack = null;
    }
    this.compressCallBack = newCallback;
  }

  ///获取视频信息
  Future<Map<String, dynamic>> getVideoInfos(final String path) async {
    Map<String, dynamic> videoInfo = new Map();

    File file = new File(path);
    bool exists = await file.exists();
    if (!exists) {
      return videoInfo;
    }
    videoInfo["size"] = file.lengthSync();
    // var info = await _flutterFFprobe.getMediaInformation(path);
    var info;
    if (info['streams'] != null) {
      final streamsInfoArray = info['streams'];
      if (streamsInfoArray.length > 0) {
        videoInfo["playTime"] = info['duration'];
        for (var streamsInfo in streamsInfoArray) {
          if (videoInfo["width"] == null) {
            videoInfo["width"] = streamsInfo['width'];
          }
          if (videoInfo["height"] == null) {
            videoInfo["height"] = streamsInfo['height'];
          }

          if (streamsInfo['metadata'] != null &&
              streamsInfo['metadata']['rotate'] != null) {
            videoInfo["rotate"] =
                int.parse(streamsInfo['metadata']['rotate'].toString());
          }
        }
      }
    }
    videoInfo['bitrate'] = info['bitrate'];
    if (videoInfo["rotate"] != null) {
      int rotate = (videoInfo["rotate"] + 720) % 360;
      if (rotate == 90 || rotate == 270) {
        var width = videoInfo["width"];
        videoInfo["width"] = videoInfo["height"];
        videoInfo["height"] = width;
      }
    }
    return videoInfo;
  }

  String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return digest.toString();
  }

  void disable() {
    // if (_flutterFFmpeg != null) {
    //   _flutterFFmpegConfig.disableLogs();
    //   _flutterFFmpegConfig.disableRedirection();
    //   _flutterFFmpegConfig.disableStatistics();
    //   compressCallBack = null;
    // }
  }
}
