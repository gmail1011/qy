import 'package:flutter/material.dart';
import 'package:flutter_base/ext_core/ys_value_notifier.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/player/ijk_base_video_controler.dart';
import 'package:flutter_base/utils/log.dart';

import 'player_single_ctrl.dart';

/// 上层UI是否展示SinglePlayer
class SingleController extends YsValueNotifier<bool> {
  SingleController(value) : super(value);
}

/// 构建播放器的builder
typedef PlayerBuilder = Widget Function(IjkBaseVideoController controller);

/// 单一播放器,主要通过controller控制单一播放器的生命周期;
/// 只控制初始化和释放相关
/// 是一个stateflu的控件，因为有生命周期
class SinglePlayer extends StatefulWidget {
  final dynamic srcModel;
  final String videoUrl;
  final String uniqueId;
  final PlayerBuilder playerBuilder;
  final ValueChanged<IjkBaseVideoController> updateCallBack;
  final ValueChanged<IjkBaseVideoController> onComplete;
  final ValueChanged<IjkBaseVideoController> onRelease;
  final ValueChanged<IjkBaseVideoController> onInited;
  final ValueChanged<IjkBaseVideoController> onCreateController;
  final SingleController singleController;

  /// 是否循环播放
  /// m3u8bug，不支持循环播放，
  /// 循环播放在singlePlayer oncomplete处理
  final bool loop;

  String realUrl;

  SinglePlayer(
    this.videoUrl,
    this.uniqueId, {
    this.srcModel,
    Key key,
    @required this.playerBuilder,
    this.updateCallBack,
    this.onComplete,
    this.onRelease,
    this.onInited,
    this.onCreateController,
    @required this.singleController,
    this.loop = false,
        this.realUrl,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SinglePlayerState();
  }
}

class _SinglePlayerState extends State<SinglePlayer>
    with TickerProviderStateMixin {
  final String tag = "single_player";

  IjkBaseVideoController controller;
  // 正在初始化
  bool isIniting = false;

  /// 正在播放完成，请勿重复调用
  bool isCompleting = false;

  /// 这个isPlay 监听外部的是否在显示，完成播放器的自动释放和创建
  /// @see `checkPlayOrDispose()`
  bool isPlay = true;
  SingleController singleController;
  @override
  void initState() {
    super.initState();
    l.i(tag, "initState()...url:${widget.videoUrl}");
    if (TextUtil.isNotEmpty(widget.videoUrl)) {
      singleController = widget.singleController ?? SingleController(isPlay);
      isPlay = singleController.value;
      checkPlayOrDispose();
      singleController.addListener(_handleValueChanged);
    } else {
      l.e(tag, "initState()...error url:${widget.videoUrl}");
    }
  }

  @override
  void dispose() {
    super.dispose();
    playerPrint("SinglePlayer dispose()...");
    singleController?.removeListener(_handleValueChanged);
    singleController = null;
    controller?.dispose();
    controller = null;
  }

  @override
  void didUpdateWidget(covariant SinglePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    playerPrint(
        "SinglePlayer didUpdateWidget()...oldWidget:${oldWidget.videoUrl}  newWidget:${widget.videoUrl}");
    if (oldWidget.videoUrl != widget.videoUrl) {
      // controller?.dispose();
      // controller = null;
      singleController = widget.singleController ?? SingleController(isPlay);
      isPlay = singleController.value;
      checkPlayOrDispose();
      singleController.addListener(_handleValueChanged);
      if (mounted) setState(() {});
    }
  }

  void _handleValueChanged() {
    var newIsPlay = singleController.value;
    l.i(tag,
        "_handleValueChanged()...oldIsPlay:$isPlay newIsPlay:$newIsPlay url:${widget.videoUrl} uniqueId:${widget.uniqueId}");
    setState(() {
      isPlay = newIsPlay;
    });
    checkPlayOrDispose();
  }

  /// 完成播放器的自动释放和创建
  void checkPlayOrDispose() {
    if (isPlay) {
      // playerPrint(
      //     "checkPlayOrDispose.............controller==null?:${null == controller} dispose:${controller?.isDisposed}");
      if (null == controller || controller.isDisposed) {
        controller = _createIjkController();
        widget.onCreateController?.call(controller);
        if (!controller.isInitialed) {
          _initIjkCoroller(controller);
        }
      } else {
        controller.updateListener();
      }
      // if(!controller.isDisposed){
      //    _initIjkCoroller(controller);
      // }
    } else {
      if (mounted)
        setState(() {
          controller?.dispose();
          controller = null;
        });
    }
  }

  /// 创建ijkController
  IjkBaseVideoController _createIjkController() {
    l.i(tag, '_createIjkController()...创建ijkplayer');
    return getCtrl(widget.videoUrl, widget.uniqueId,
        srcModel: widget.srcModel,
        loop: widget.loop,
        realUrl: widget.realUrl,
        updateCallBack: widget.updateCallBack, onRelease: (c) {
      widget.onRelease?.call(c);
      l.i(tag,
          "doDisposed()...释放以前旧的播放器${controller?.sourceUrl}，状态:${controller?.getStatus()}");
      if (mounted) {
        l.i(tag, "释放以前旧的播放器，开始刷新");
        setState(() {});
      }
      controller = null;
    }, onComplete: (c) async {
      // 重新播放
      /// m3u8bug，不支持循环播放，
      /// 循环播放放在外面的singlePlayer oncomplete处理
      l.i(tag, "doDisposed()...complete:${c.getStatus()}");
      widget.onComplete?.call(controller);
      if (widget.loop) {
        if (isCompleting) return;

        isCompleting = true;
        l.i(tag, "doDisposed()...正在重置播放器");
        await controller.reset();
        await _initIjkCoroller(c);
        isCompleting = false;
      }
    });
  }

  /// 开始初始化播放器
  Future _initIjkCoroller(IjkBaseVideoController controller) async {
    if (isIniting) {
      l.i(tag, "不要着急，正在初始化...${controller.sourceUrl}");
      return;
    }
    isIniting = true;
    bool suc = true;
    try {
      l.i(tag, 'initialize()...视频初始化好了,开始播放了 1');
      await controller?.doInit();
      await controller?.setDataSource(controller.sourceUrl,
          autoPlay: false, showCover: false);
      l.i(tag, 'initialize()...视频初始化好了,开始播放了 2');
      // 设置-1无限循环，文档写错了sdk不支持
      // 实际测试m3u8是不支持循环播放的
      // await controller.setLoop(100);
      // await controller.prepareAsync();
      await controller.start();
      await controller.waitForPrepare();
    } catch (e) {
      l.e(tag, "视频:${controller?.sourceUrl} 初始化失败:$e");
      suc = false;
    } finally {
      isIniting = false;
    }
    if (suc) {
      l.i(tag, 'initialize()...视频初始化好了,开始播放了 3');
      if (mounted) {
        l.i(tag, 'initialize()...视频初始化好了,开始播放了 4');
        setState(() {});
      }
    }
    widget.onInited?.call(controller);
  }

  @override
  Widget build(BuildContext context) {
    l.i(tag, "播放器${widget.videoUrl}现在的状态:${controller?.getStatus()}");
    return (controller != null && !controller.isDisposed)
        ? widget.playerBuilder?.call(controller) ??
            Container(color: Colors.transparent)
        : Container(color: Colors.transparent);
    // return widget.playerBuilder?.call(controller) ??
    //     Container(color: Colors.transparent);
  }
}
