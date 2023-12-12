import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_base/assets/svg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/player/ijk_base_video_controler.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_svg/svg.dart';

enum ImgLocation { center, bottomLeft }

///视频播放挂件播放暂停按钮
class VideoPlayerUI extends StatefulWidget {
  ///暂停图片地址
  final String pauseImgPath;
  final IjkBaseVideoController controller;

  ///播放图片地址
  final String playImgPath;

  ///加载中图片地址
  final String loadingImgPath;

  ///按钮放的位置
  final ImgLocation imgLocation;

  ///图片宽度
  final double width;

  ///图片高度
  final double height;

  final VoidCallback pausePress;

  final VoidCallback playPress;

  VideoPlayerUI(
      {Key key,
      this.pauseImgPath,
      this.playImgPath,
      this.loadingImgPath,
      this.imgLocation,
      this.width,
      this.height,
      this.pausePress,
      this.playPress,
      @required this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return VideoPlayerUIState();
  }
}

class VideoPlayerUIState extends State<VideoPlayerUI> {
  listener() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listener);
  }

  @override
  void dispose() {
    if (!(widget.controller?.isDisposed ?? false))
      widget.controller.removeListener(listener);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant VideoPlayerUI oldWidget) {
    super.didUpdateWidget(oldWidget);
    playerPrint(
        "video UI didUpdateWidget()...oldState:${oldWidget.controller.state} newState:${widget.controller.state}");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playerPrint("videoUI didChangeDependencies()...");
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.isPlayable()) {
      return Container();
    }
    if (widget.imgLocation == ImgLocation.bottomLeft) {
      return _bottomLeftWidget();
    } else if (widget.imgLocation == ImgLocation.center) {
      return _centerWidget();
    }
    return Container();
  }

  ///居中显示
  Widget _centerWidget() {
    if (widget.controller.state == FijkState.paused) {
      playerPrint("videoUI _centerWidget()...state:${widget.controller.state}");
      return Center(
        child: GestureDetector(
          onTap: widget.pausePress,
          child: Container(
            child: SvgPicture.asset(
                widget.pauseImgPath ?? AssetsSvg.VIDEO_ICON_PAUSE,
                package: FlutterBase.basePkgName),
            width: widget.width ?? Dimens.pt40,
            height: widget.height ?? Dimens.pt50,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  ///居右下方显示
  Widget _bottomLeftWidget() {
    Widget currentWidget = Container();
    if (widget.controller.isPlaying) {
      currentWidget = GestureDetector(
        onTap: widget.playPress,
        child: Container(
          child: SvgPicture.asset(
              widget.playImgPath ?? AssetsSvg.VIDEO_ICON_PLAY,
              package: FlutterBase.basePkgName),
          width: Dimens.pt20,
          height: Dimens.pt20,
        ),
      );
    } else {
      currentWidget = GestureDetector(
        onTap: widget.pausePress,
        child: Container(
          child: SvgPicture.asset(
              widget.playImgPath ?? AssetsSvg.VIDEO_ICON_PAUSE,
              package: FlutterBase.basePkgName),
          width: Dimens.pt20,
          height: Dimens.pt20,
        ),
      );
    }
    return Positioned(
        bottom: Dimens.pt10, right: Dimens.pt10, child: currentWidget);
  }
}
