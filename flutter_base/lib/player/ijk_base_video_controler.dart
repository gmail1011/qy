import 'dart:async';
import 'dart:io';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/player/player_util.dart';

///播放器控制器
class IjkBaseVideoController extends FijkPlayer {
  bool isDisposed = false;
  String sourceUrl;
  //全屏实现不同，不只用value里面的fullScreen字段,hplayer使用
  // ValueNotifier<bool> isFullScreen = ValueNotifier(false);
  bool _isFullScreen = false;

  /// 原始模型
  var srcModel;

  String uniqueId;

  /// 是否循环播放
  /// m3u8bug，不支持循环播放，
  /// 循环播放放在外面的singlePlayer oncomplete处理
  bool loop;

  //当前播放位置的订阅
  StreamSubscription<Duration> curPositionSub;

  //用来做同步回调,系统回调,会有很多次
  final ValueChanged<IjkBaseVideoController> updateCallBack;
  // 播放完成的回调，可能有很多次，注意避免
  final ValueChanged<IjkBaseVideoController> onCompleted;
  // 播放器释放
  final ValueChanged<IjkBaseVideoController> onRelease;

  /// ISSUE THIS :不使用value里面的fullscreen因为我们的全屏功能实现方式不一样
  bool get isFullScreen => _isFullScreen;
  @override
  void enterFullScreen() {
    // super.enterFullScreen();
    if (!_isFullScreen) {
      _isFullScreen = true;
      notifyListeners();
    }
  }

  @override
  void exitFullScreen() {
    // super.exitFullScreen();
    if (_isFullScreen) {
      _isFullScreen = false;
      notifyListeners();
    }
  }

  IjkBaseVideoController.network(this.sourceUrl, this.uniqueId,
      {this.srcModel,
      this.updateCallBack,
      this.onCompleted,
      this.onRelease,
      this.loop = false});
  Completer<FijkState> prepareCompleter;

  ///初始化之后加上监听
  updateListener() {
    var state = this.state;
    if (state == FijkState.error) {
      playerPrint("${this.sourceUrl} 监听到错误:" + getStatus());
    } else {
      if (state == FijkState.completed) {
        playerPrint("播放完成重新播放");
        this.onCompleted?.call(this);
      }
      if (state == FijkState.started) {
        if (null != prepareCompleter && !prepareCompleter.isCompleted) {
          playerPrint("等待播放器状态成功 now is:$state ${this.hashCode}");
          _isInitialed = true;
          this.prepareCompleter.complete(state);
          this.prepareCompleter = null;
        }
      }
      this.updateCallBack?.call(this);
    }
  }

  bool get isPlaying => FijkState.started == state;
  bool get isPause => FijkState.paused == state;
  // bool get isBuffering => isBuffering;
  bool get isInitialed => _isInitialed;
  //     FijkState.initialized == state ||
  //     FijkState.asyncPreparing == state ||
  //     isPlayable();
  bool _isInitialed = false;
  bool isCompleted() {
    // => value.completed 这个值只对非流视频有用，see detail in value
    int duration = value.duration?.inMilliseconds ?? 0;
    if (duration > 0 && duration - currentPos.inMilliseconds < 500) {
      return true;
    }
    return false;
  }

  /// 播放器内部的初始化，主要是挂载监听
  Future<void> doInit() async {
    isDisposed = false;
    //https://www.cnblogs.com/marklove/articles/10608812.html
    await setOption(FijkOption.hostCategory, "request-screen-on", 1);

    await setOption(FijkOption.hostCategory, "request-audio-focus", 1);

    //设置播放前的最大探测时间
    await setOption(FijkOption.formatCategory, "analyzemaxduration", 100);

    //设置播放前的探测时间 1,达到首屏秒开效果，开始播放的时候会黑屏-->先不用
    // setOption(FijkOption.formatCategory, "analyzeduration", 1);
    // 播放前的探测Size，默认是1M, 改小一点会出画面更快,播放初始话缓冲10kb-->先不用
    // 打开之后很多视频没有声音
    // await setOption(FijkOption.formatCategory, "probesize", 10 * KB_SIZE);
    if (Platform.isAndroid) {
      // 设置硬解码方式,可能会产生黑屏-->先不用
      // await setOption(FijkOption.playerCategory, "mediacodec", 1);
    } else if (Platform.isIOS) {
      // await setOption(FijkOption.playerCategory, "videotoolbox", 1);
    }
    // // 对于m3u8文件这句话没什么暖用
    // await setOption(FijkOption.playerCategory, "loop", loop ? 1 : 0);
    //每处理一个packet之后刷新io上下文
    await setOption(FijkOption.formatCategory, "flush_packets", 0);
    //关闭环路过滤减少解码开销
    await setOption(FijkOption.codecCategory, "skip_loop_filter", 48);
    //播放器的请求重连次数
    await setOption(FijkOption.playerCategory, "reconnect", 5);
    // 开启预备缓存
    // await setOption(FijkOption.playerCategory, "packet-buffering", 1);
    //最大缓冲大小,单位kb
    // await setOption(FijkOption.playerCategory, "max-buffer-size", 128 * 1024);
    //最大fps，避免播放器fps太大影响性能
    await setOption(FijkOption.playerCategory, "max-fps", 30);
    await setOption(FijkOption.playerCategory, "fps", 20);
    //seek优化，入关关键帧少无法定位的话，开启这个
    await setOption(FijkOption.playerCategory, "enable-accurate-seek", 1);
    //设置seekTo能够快速seek到指定位置并播放
    //解决m3u8文件拖动问题 比如:一个3个多少小时的音频文件，开始播放几秒中，然后拖动到2小时左右的时间，要loading 10分钟
    await setOption(FijkOption.formatCategory, "fflags", "fastseek");
    // 允许跳帧处理
    await setOption(FijkOption.codecCategory, "skip_frame", 1);
    //跳帧处理,放CPU处理较慢时，进行跳帧处理，保证播放流程，画面和声音同步
    await setOption(FijkOption.playerCategory, "framedrop", 5);


    // await setOption(FijkOption.playerCategory,"dns_buffer_size", "1000"); //设置DNS缓存大小
    // await setOption(FijkOption.playerCategory,"dns_cache_clear", "1"); //清除DNS缓存
    // await setOption(FijkOption.hostCategory,"dns_server", "0.0.0.0"); //设置DNS服务器地址

    // 在播放器 prepared 之后对视频进行解码，并把视频第一针画面渲染出来。在一些情况下可以作为封面，但不建议使用
    // 会引起再flutter 收不到position的回调
    // await setOption(FijkOption.playerCategory, "cover-after-prepared", 1);
    //协议白名单
    // await setOption(FijkOption.formatCategory,
    //     "protocol_whitelist", "crypto,file,http,https,tcp,tls,udp");
    removeListener(updateListener);
    addListener(updateListener);
    var startTime = DateTime.now();
    if (null == curPositionSub)
      curPositionSub = onCurrentPosUpdate.listen((_) {
        if (DateTime.now().difference(startTime).inMilliseconds > 800) {
          startTime = DateTime.now();
          updateListener?.call();
        }
      });

  }

  @override
  Future<void> reset() async {
    await super.reset();
    _isInitialed = false;
  }

  Future<FijkState> waitForPrepare() {
    FijkState current = value.state;
    // 几个不需要等待的状态
    if (FijkState.started == current ||
        FijkState.paused == current ||
        FijkState.completed == current ||
        FijkState.stopped == current ||
        FijkState.error == current ||
        FijkState.end == current) {
      _isInitialed = true;
      return Future.value(this.state);
    }
    if (null == prepareCompleter) prepareCompleter = Completer();
    playerPrint("waitForPrepare()...$current 需要等待播放器状态 started");
    return prepareCompleter.future;
  }

  /// 获取视频播放器状态
  String getStatus() {
    return "isPlayable:${isPlayable()} isDisposed:$isDisposed  isInited:$isInitialed isCsomplete:${isCompleted()} real:$state";
  }

  @override
  Future<void> dispose() async {
    // 这里主要是更改内部状态给外部使用
    if (!isDisposed) {
      playerPrint("dispose()...ijk释放:$sourceUrl");
      isDisposed = true;
      // _isInitialed = false;
      await stop();
      await reset();
      await release();
      curPositionSub?.cancel();
      removeListener(updateListener);
      // 必须要release��然会出现多个播放
      this.onRelease?.call(this);
      super.dispose();
    }
  }
}
