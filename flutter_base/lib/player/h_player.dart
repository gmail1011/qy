import 'dart:async';

import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/flutter_base.dart';
import 'h_player_progress.dart';
import 'video_gesturer.dart';
import 'video_progress_colors.dart';

const _kMaxHeight = 480.0;

/// 播放器组件builder,[callback] 你需要主页面帮你做什么，例如，你点击了重播，需要主页面setState
typedef PlayerWidgetBuilder = Widget Function(IjkBaseVideoController,
    {VoidCallback callback});

/// 横屏播放器，fullplayer是竖屏播放器
class HPlayer extends StatefulWidget {
  /// 外部限制视频宽高，不传为全屏宽高
  /// 不传为高度为480.0，宽为宽高比
  final double containerWidth, containerHeight;
  final IjkBaseVideoController controller;

  /// 视频分辨率
  final double resolutionWidth;

  /// 视频分辨率
  final double resolutionHeight;

  /// 播放器播放完成UI
  final PlayerWidgetBuilder endUIBuilder;

  ///  顶部UI
  final PlayerWidgetBuilder topUIBuilder;

  /// 有些需要自己定义返回按键的，请注入这个
  final PlayerWidgetBuilder backIconBuilder;

  ///  顶部UI 全屏的时候
  final PlayerWidgetBuilder fullScreenTopUIBuilder;

  ///  进度条UI
  final PlayerWidgetBuilder progressBarBuilder;

  final VideoProgressColors progressColors;

  /// 视频点击，主要是播放和暂停处理
  final ValueChanged<IjkBaseVideoController> onVideoClick;

  /// Defines the system overlays visible on entering fullscreen
  /// 进入全屏后的顶部状态栏和底部任务栏目
  final List<SystemUiOverlay> systemOverlaysOnEnterFullScreen;

  /// Defines the set of allowed device orientations on entering fullscreen
  /// 进入全屏之后手机支持的屏幕方式
  final List<DeviceOrientation> deviceOrientationsOnEnterFullScreen;

  /// Defines the system overlays visible after exiting fullscreen
  /// 退出全屏后的顶部状态栏和底部任务栏目
  final List<SystemUiOverlay> systemOverlaysExitFullScreen;

  /// Defines the set of allowed device orientations after exiting fullscreen
  /// 退出全屏之后手机支持的屏幕方式
  final List<DeviceOrientation> deviceOrientationsExitFullScreen;

  HPlayer({
    Key key,
    @required this.resolutionWidth,
    @required this.resolutionHeight,
    this.containerHeight,
    this.containerWidth,
    @required this.controller,
    this.systemOverlaysOnEnterFullScreen,
    this.deviceOrientationsOnEnterFullScreen,
    this.systemOverlaysExitFullScreen = SystemUiOverlay.values,
    this.deviceOrientationsExitFullScreen = DeviceOrientation.values,
    this.topUIBuilder,
    this.fullScreenTopUIBuilder,
    this.endUIBuilder,
    this.progressBarBuilder,
    this.onVideoClick,
    this.progressColors,
    this.backIconBuilder,
  }) : super(key: key);

  @override
  _HPlayerState createState() => _HPlayerState();
}

class _HPlayerState extends State<HPlayer> with TickerProviderStateMixin {
  /// 外部限制视频宽高，不传为全屏宽高
  /// see [configVideoSize]
  double containerWidth, containerHeight;
  //是否全屏播放
  bool isFullScreen = false;

  /// 视频是否是水平的
  bool isLandscapeVideo = true;

  /// 真正UI的视频使用宽高
  VideoResolution vr;

  /// 显示缓存loadding的UI
  bool isShowBuffingUI = false;

  Timer _hideTimer;

  /// 自动隐藏挂件UI
  bool _hideStuff = false;

  StreamSubscription<bool> bufStateSc;
  _updateListener() {
    // playerPrint("test code 1");
    if (isFullScreen != widget.controller.isFullScreen) {
      if (widget.controller.isFullScreen) {
        enterFullScreen();
      } else {
        exitFullScreen();
      }
    } else {
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isLandscapeVideo =
        isHorizontalVideo(widget.resolutionWidth, widget.resolutionHeight);
    isFullScreen = widget.controller.isFullScreen;
    configContainerWH(isFullScreen);
    vr = configVideoSize(containerWidth, containerHeight,
        widget.resolutionWidth, widget.resolutionHeight, false);

    playerPrint(
        "init HPlayer  containW:$containerWidth   containH:$containerHeight Vr:$vr");
    widget.controller.addListener(_updateListener);
    bufStateSc = widget.controller.onBufferStateUpdate.listen((b) {
      playerPrint("onBuffing:$b   status:${widget.controller.getStatus()}");
      if (isShowBuffingUI != b && mounted) {
        setState(() {
          isShowBuffingUI = b;
        });
      }
    });
    _cancelAndRestartTimer();
  }

  @override
  void didUpdateWidget(covariant HPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    playerPrint(
        "HPlayer didUpdateWidget()...oldState:${oldWidget.controller?.getStatus()} newState:${widget.controller?.getStatus()}");
  }

  @override
  void dispose() {
    playerPrint("HPlayer dispose()...${widget.controller?.isDisposed}");
    if (!(widget.controller?.isDisposed ?? false)) {
      widget.controller?.removeListener(_updateListener);
    }
    bufStateSc?.cancel();
    bufStateSc = null;
    _hideTimer?.cancel();
    _hideTimer = null;
    super.dispose();
  }

  /// 取消和重置自动隐藏的timer
  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    setState(() {
      _hideStuff = false;
      _startHideTimer();
    });
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  /// 配置容器的宽和高
  configContainerWH(bool isFullScreen) {
    // 视频分辨率配置
    if (isFullScreen) {
      // containerWidth = screen.screenWidth;
      // containerHeight = screen.screenHeight;
      containerWidth = screen.screenHeight;
      containerHeight = screen.screenWidth;
    } else {
      //  默认高度480.0
      var aspectRatio = 1.8;
      if ((widget.resolutionWidth ?? 0) > 0 &&
          (widget.resolutionHeight ?? 0) > 0) {
        aspectRatio = widget.resolutionWidth / widget.resolutionHeight;
      }
      containerWidth = widget.containerWidth ?? screen.screenWidth;
      containerHeight = containerWidth / aspectRatio;
      if (containerHeight > _kMaxHeight) {
        containerHeight = _kMaxHeight;
        containerWidth = containerHeight * aspectRatio;
      }
    }
  }

  /// 进入全屏
  enterFullScreen() {
    if (widget.systemOverlaysOnEnterFullScreen != null) {
      /// Optional user preferred settings
      SystemChrome.setEnabledSystemUIOverlays(
          widget.systemOverlaysOnEnterFullScreen);
    } else {
      /// Default behavior
      SystemChrome.setEnabledSystemUIOverlays([]);
    }

    if (widget.deviceOrientationsOnEnterFullScreen != null) {
      /// Optional user preferred settings
      SystemChrome.setPreferredOrientations(
          widget.deviceOrientationsOnEnterFullScreen);
    } else {
      if (isLandscapeVideo) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        // 垂直视频是不支持全屏的
        showToast(msg: "竖版视频在横版播放器暂时不支持全屏");
        return;
        // SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.portraitUp,
        //   DeviceOrientation.portraitDown,
        // ]);
      }
      // final isLandscapeVideo = videoWidth > videoHeight;
      // final isPortraitVideo = videoWidth < videoHeight;
      // /// Default behavior
      // if (isLandscapeVideo) {
      //   /// Video w > h means we force landscape
      //   SystemChrome.setPreferredOrientations([
      //     DeviceOrientation.landscapeLeft,
      //     DeviceOrientation.landscapeRight,
      //   ]);
      // } else if (isPortraitVideo) {
      //   /// Video h > w means we force portrait
      //   SystemChrome.setPreferredOrientations([
      //     DeviceOrientation.portraitUp,
      //     DeviceOrientation.portraitDown,
      //   ]);
      // } else {
      //   /// Otherwise if h == w (square video)
      //   SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      // }

    }
    if (mounted) {
      setState(() {
        isFullScreen = true;
        configContainerWH(isFullScreen);
        vr = configVideoSize(containerWidth, containerHeight,
            widget.resolutionWidth, widget.resolutionHeight, false);
        playerPrint(
            "enterFullScreen()...containW:$containerWidth   containH:$containerHeight Vr:$vr");
        widget.controller.enterFullScreen();
      });
    }
  }

  /// 退出全屏幕
  exitFullScreen() {
    SystemChrome.setEnabledSystemUIOverlays(
        widget.systemOverlaysExitFullScreen);
    // SystemChrome.setPreferredOrientations(
    //     widget.deviceOrientationsExitFullScreen);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if (mounted) {
      setState(() {
        isFullScreen = false;
        configContainerWH(isFullScreen);
        vr = configVideoSize(containerWidth, containerHeight,
            widget.resolutionWidth, widget.resolutionHeight, false);
        playerPrint(
            "exitFullScreen()...containW:$containerWidth   containH:$containerHeight Vr:$vr");
        widget.controller.exitFullScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("containerWidth:$containerWidth  containerHeight:$containerHeight");
    if (null == widget.controller || !widget.controller.isInitialed) {
      return Container(
        color: Colors.black,
        width: containerWidth,
        height: containerHeight,
        child: buildVideoLoading(),
      );
    } else if (widget.controller.isDisposed) {
      return Container(color: Colors.transparent);
    } else if (widget.controller.isPlayable()) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        // onPointerDown: (PointerDownEvent e) {
        // print("test code 2");
        // hide timer
        onTap: () {
          if (_hideStuff) {
            _cancelAndRestartTimer();
          } else {
            setState(() {
              _hideStuff = true;
            });
          }
        },
        child: Container(
          width: containerWidth,
          height: containerHeight,
          color: Colors.black,
          child: Stack(
            fit: StackFit.loose,
            alignment: AlignmentDirectional.center,
            children: [
              getVideoPlayer(),
              // 顶部标题
              _hideStuff
                  ? Container()
                  : Align(
                      alignment: Alignment.topCenter,
                      child: _defaultTopUI(widget.controller),
                    ),

              // 中部 loading
              Align(
                alignment: Alignment(0, 0),
                child: _getCenterUI(),
              ),

              // 中部结束UI
              // Align(
              //   alignment: Alignment(0, 0),
              //   child: (null != widget.endUIBuilder &&
              //           !(widget.controller?.loop ?? false) &&
              //           (widget.controller?.isCompleted() ?? false))
              //       ? widget.endUIBuilder.call(widget.controller, callback: () {
              //           setState(() {});
              //         })
              //       : VideoGesturer(
              //           width: containerWidth,
              //           height: containerHeight,
              //           controller: widget.controller,
              //           onDragStart: () {
              //             _cancelAndRestartTimer();
              //           },
              //           onDragEnd: () {
              //             _cancelAndRestartTimer();
              //           },
              //         ),
              // ),

              /// 底部正常进度条
              _hideStuff
                  ? Container()
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: (widget.progressBarBuilder ?? _defaultProgressBar)
                          .call(widget.controller),
                    ),
            ],
          ),
        ),
      );
    } else {
      return Container(color: Colors.transparent);
    }
  }

  Widget _getCenterUI() {
    if (isShowBuffingUI) {
      return buildVideoLoading();
    } else if ((null != widget.endUIBuilder &&
        !(widget.controller?.loop ?? false) &&
        (widget.controller?.isCompleted() ?? false))) {
      return widget.endUIBuilder.call(widget.controller, callback: () {
        setState(() {});
      });
    } else {
      return VideoGesturer(
        width: containerWidth,
        height: containerHeight,
        controller: widget.controller,
        onDragStart: () {
          _cancelAndRestartTimer();
        },
        onDragEnd: () {
          _cancelAndRestartTimer();
        },
        child: _hideStuff
            ? Container()
            : buildPlayButton(widget.controller,
                playOrPause: widget.onVideoClick,
                iconSize:
                    widget.controller.isFullScreen ? Dimens.pt48 : Dimens.pt38),
      );
    }
  }

  // 默认顶部返回UI
  Widget _defaultTopUI(IjkBaseVideoController controller) {
    PlayerWidgetBuilder builder =
        isFullScreen ? widget.fullScreenTopUIBuilder : widget.topUIBuilder;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Future.delayed(Duration(), () {
          _cancelAndRestartTimer();
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: isFullScreen ? 32 : 16,
            vertical: isFullScreen ? 16 : 8),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (isFullScreen) {
                  exitFullScreen();
                } else {
                  safePopPage();
                }
              },
              child: widget.backIconBuilder?.call(controller) ??
                  Container(
                    width: 35,
                    height: 35,
                    color: Color(0x11010001),
                    child: Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
            ),
            SizedBox(width: Dimens.pt4),
            if (null != builder) Expanded(child: builder.call(controller))
          ],
        ),
      ),
    );
  }

  /// 默认进度条
  Widget _defaultProgressBar(IjkBaseVideoController controller) {
    return Container(
        padding: EdgeInsets.fromLTRB(Dimens.pt16, 0, Dimens.pt16, Dimens.pt6),
        // color: Colors.red,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black54, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          buildPlayButton(controller, playOrPause: widget.onVideoClick),
          Expanded(
              child: HPlayerProgress(
            controller,
            colors:
                widget.progressColors ?? VideoProgressColors.defaultColors(),
            allowScrubbing: true,
            onDragEnd: () {
              _cancelAndRestartTimer();
            },
          )),
          buildFullScreenBtn(),
        ]));
  }

  // 播放暂停
  Widget buildPlayButton(IjkBaseVideoController controller,
      {ValueChanged<IjkBaseVideoController> playOrPause, double iconSize}) {
    if (controller == null) {
      return Container();
    }
    return Container(
      width: iconSize ?? Dimens.pt18,
      height: iconSize ?? Dimens.pt18,
      alignment: Alignment.center,
      // decoration: BoxDecoration(
      //     gradient: RadialGradient(
      //   colors: [Colors.black54, Colors.transparent],
      // )),
      // color: Colors.red,
      child: IconButton(
        alignment: Alignment.center,
        iconSize: iconSize ?? Dimens.pt18,
        padding: EdgeInsets.zero,
        // icon: SvgPicture.asset(
        //     controller.isPlaying ? AssetsSvg.PAUSE : AssetsSvg.PLAY,
        //     package: FlutterBase.basePkgName,
        //     color: Colors.white),
        icon: Icon(
            controller.isPlaying
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            size: iconSize ?? Dimens.pt18,
            color: Colors.white),
        onPressed: () {
          // print("test code 1");
          if (null != playOrPause) {
            // print("test code 2");
            playOrPause.call(controller);
          } else {
            // print("test code 3");
            if (controller.isPlaying) {
              controller.pause();
            } else if (controller.isPause) {
              controller.start();
            }
          }
        },
        // onPressed: () => playOrPause?.call(controller),
      ),
    );
  }

  // 全屏按钮
  Widget buildFullScreenBtn() {
    return Visibility(
      visible: isLandscapeVideo,
      child: Container(
        // color: Colors.yellow,
        width: Dimens.pt18,
        height: Dimens.pt18,
        alignment: Alignment.center,
        child: IconButton(
          alignment: Alignment.center,
          iconSize: Dimens.pt18,
          padding: EdgeInsets.zero,
          // padding: EdgeInsets.all(Dimens.pt2),
          color: Colors.white,
          // icon: SvgPicture.asset(
          //     widget.controller.isFullScreen
          //         ? AssetsSvg.FULLSCREEN_DOWN
          //         : AssetsSvg.FULLSCREEN_UP,
          //     package: FlutterBase.basePkgName),
          icon: Icon(
              widget.controller.isFullScreen
                  ? Icons.fullscreen_exit
                  : Icons.fullscreen,
              size: Dimens.pt18,
              color: Colors.white),
          onPressed: () {
            if (widget.controller.isFullScreen) {
              // exitFullScreen();
              widget.controller.exitFullScreen();
            } else {
              widget.controller.enterFullScreen();
              // enterFullScreen();
            }
          },
        ),
      ),
    );
  }

  Widget getVideoPlayer() {
    if (widget.controller.isDisposed) {
      return Container(
        width: containerWidth,
        height: containerHeight,
        color: Colors.transparent,
      );
    } else if (widget.controller.isPlayable()) {
      return Container(
        width: containerWidth,
        height: containerHeight,
        color: Colors.black,
        child: Container(
            width: vr.videoWidth,
            height: vr.videoHeight,
            color: Colors.transparent,
            child: FijkView(
              color: Colors.transparent,
              width: vr.videoWidth,
              height: vr.videoHeight,
              player: widget.controller,
              fit: FijkFit.contain,
              panelBuilder: null,
            )
            //  CustomPlayerView(
            //   controller: widget.controller,
            //   width: vr.videoWidth,
            //   height: vr.videoHeight,
            //   fit: PlayerFit.cover,
            // ),
            ),
      );
    } else {
      return Container(
        width: containerWidth,
        height: containerHeight,
        color: Colors.transparent,
      );
    }
  }

  // Widget getProgressBar(IjkBaseVideoController controller) {
  //   var _swidth = MediaQuery.of(context).size.width;
  //   var _width = _swidth;
  //   var _height = _swidth / widget.aspectRatio;

  //   if (_height > _maxHeight) {
  //     _height = _maxHeight;
  //     _width = _maxHeight * widget.aspectRatio;
  //   }
  //   return Row(
  //     children: <Widget>[
  //       Expanded(
  //         child: PFVideoProgressBar(
  //           playBtn: AssetsSvg.PLAY,
  //           pauseBtn: AssetsSvg.PAUSE,
  //           fullScreenIcon: AssetsSvg.FULLSCREEN_UP,
  //           controller: controller,
  //           fullScreenDel: () {
  //             //非自由旋转情况下��全屏之后，不能这样设置，否则5秒之后，会自动跳转到竖屏
  //             // setAutoRotate();
  //             // _showFullScreenWithRotateBox(context, _controller);
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
