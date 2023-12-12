// File: 音乐盘组件
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/video_list_model/main_player_ui_show_model.dart';
import 'package:flutter_app/page/video/video_list_model/second_player_ui_show_model.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 音乐盘组件
class MusicDiskAn extends StatefulWidget {
  final String avatarUrl;
  final VideoListType type;
  final VoidCallback onClick;
  MusicDiskAn(this.avatarUrl, this.type, {Key key, this.onClick})
      : super(key: key);

  @override
  MusicDiskAnState createState() => new MusicDiskAnState();
}

class MusicDiskAnState extends State<MusicDiskAn>
    with TickerProviderStateMixin {
  /// 动画时间
  final duration = Duration(milliseconds: 4000);

  /// 音乐盒宽
  var itemW = Dimens.pt88;

  /// 音乐盒高
  var itemH = Dimens.pt100;

  /// 盘子宽高
  var diskWH = Dimens.pt50; //58

  /// 头像宽高
  var avatarW = Dimens.pt28 * (50 / 58); //28

  /// 盘子旋转动画
  AnimationController _diskController;

  /// 盘子插值列表
  Animation<double> _diskAnimation;

  // 盘子
  String diskImg;

  // 头像
  CustomNetworkImage avatarImg;

  // 音符1
  String micImg1;

  // 音符2
  String micImg2;

  @override
  void initState() {
    diskImg = AssetsSvg.RECD_MUSIC_ZERO;
    avatarImg = CustomNetworkImage(
      type: ImgType.avatar,
      imageUrl: widget.avatarUrl ?? '',
      width: avatarW,
      height: avatarW,
    );
    micImg1 = AssetsSvg.RECD_MUSIC_ONE;
    micImg2 = AssetsSvg.RECD_MUSIC_TWO;

    initDiskAnimationController();
    initNoteAnimation();
    super.initState();
  }

  // @override
  // void didUpdateWidget(MusicDiskAn oldWidget) {
  //   if (oldWidget.ishide != ishide) {
  //     ishide = oldWidget.ishide;
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  startPlay() {
    if (!_diskController.isAnimating && !_noteController.isAnimating) {
      _diskController.repeat();
      _noteController.repeat();
    }
  }

  stopPlay() {
    if (_diskController.isAnimating && _noteController.isAnimating) {
      _diskController.stop();
      _noteController.stop();
    }
  }

  @override
  void dispose() {
    if (_diskController != null) _diskController.dispose();
    if (_noteController != null) _noteController.dispose();
    super.dispose();
  }

  /// 初始化盘子动画
  void initDiskAnimationController() {
    _diskController = AnimationController(duration: duration, vsync: this);
    _diskAnimation =
        Tween<double>(begin: 0.0, end: pi * 2).animate(CurvedAnimation(
      parent: _diskController,
      curve: Curves.linear,
    ))
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    // double from =
    /// 头像偏移
    // var avatarSp = (diskWH - avatarW) / 2;
    bool mainShow =
        context.select<MainPlayerUIShowModel, bool>((it) => it.isShow);
    bool secShow =
        context.select<SecondPlayerShowModel, bool>((it) => it.isShow);
    bool isShow = widget.type == VideoListType.SECOND ? secShow : mainShow;

    /// 旋转的盘子
    var transformDisk = Container(
      /*child: Transform.rotate(
        alignment: Alignment.center, //相对于坐标系原点的对齐方式
        angle: _diskAnimation.value,
        child: assetsImg(
          AssetsImages.IC_CD,
          width: Dimens.pt50,
          height: Dimens.pt50,
        ),
      ),*/
      //child: svgAssets(AssetsSvg.IC_EYE_OPEN,width: 34.w,height: 34.w),
    );

    // /// 旋转的头像
    // var transformAvatar = Transform.rotate(
    //   alignment: Alignment.center, //相对于坐标系原点的对齐方式
    //   angle: _diskAnimation.value,
    //   child: ClipOval(
    //     child: avatarImg,
    //   ),
    // );
    var disk = Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          right: 0,
          child: Visibility(
            visible: isShow,
            child: transformDisk,
          ),
        ),
        Positioned(
          bottom: 0, //avatarSp,
          right: 0, //avatarSp,
          child: Consumer2<MainPlayerUIShowModel, SecondPlayerShowModel>(
            builder: (BuildContext context, MainPlayerUIShowModel main,
                SecondPlayerShowModel second, Widget child) {
              var addr = (widget.type == VideoListType.SECOND
                      ? second.isShow
                      : main.isShow)
                  ? AssetsSvg.IC_EYE_OPEN
                  : AssetsSvg.IC_EYE_CLOSE;
              return GestureDetector(
                onTap: () {
                  if (widget.type == VideoListType.SECOND) {
                    second.setShow(!second.isShow);
                  } else {
                    main.setShow(!main.isShow);
                  }
                  widget.onClick?.call();
                },
                child: Container(
                  width: diskWH,
                  height: diskWH,
                  alignment: Alignment.center,
                  child: ImageLoader.withP(
                    ImageType.IMAGE_SVG,
                    address: addr,
                    width: Dimens.pt28,
                    height: Dimens.pt20,
                  ).load(),
                ),
              );
            },
          ),
        ),
      ],
    );

    return Container(
      width: itemW,
      height: itemH,
      child: Stack(
        children: <Widget>[
          buildNote(),
          disk,
        ],
      ),
    );
  }

//-----------------------------音符动画 begin-----------------------------
  /// 构建建音符
  Widget buildNote() {
    var item1 = Transform.translate(
      offset: Offset(_anmNoteHorizontal.value, _anmNoteUp.value),
      child: Opacity(
        opacity: _anmNoteOpaS.value,
        child: Opacity(
          opacity: _anmNoteOpaH.value,
          child: Transform.rotate(
            //旋转90度
            angle: _anmNoteRZ.value,
            child: svgAssets(micImg1, fit: BoxFit.cover, width: 17, height: 17),
          ),
        ),
      ),
    );
    var item2 = Transform.translate(
      offset: Offset(_anmNoteHorizontal2.value, _anmNoteUp2.value),
      child: Opacity(
        opacity: _anmNoteOpaS2.value,
        child: Opacity(
          opacity: _anmNoteOpaH2.value,
          child: Transform.rotate(
            //旋转90度
            angle: _anmNoteRZ2.value,
            child: svgAssets(micImg2, fit: BoxFit.cover, width: 17, height: 17),
          ),
        ),
      ),
    );
    // return item1;
    return Stack(
      children: <Widget>[item1, item2],
    );
  }

  AnimationController _noteController;
  Animation<double> _anmNoteUp; //上升
  Animation<double> _anmNoteHorizontal; //横移
  Animation<double> _anmNoteOpaS; //渐显
  Animation<double> _anmNoteOpaH; //渐隐
  Animation<double> _anmNoteRZ; //旋转

  Animation<double> _anmNoteUp2; //上升
  Animation<double> _anmNoteHorizontal2; //横移
  Animation<double> _anmNoteOpaS2; //渐显
  Animation<double> _anmNoteOpaH2; //渐隐
  Animation<double> _anmNoteRZ2; //旋转

  void initNoteAnimation() {
    _noteController = AnimationController(duration: duration, vsync: this)
      ..addListener(() {
        setState(() {});
      });

    aniSet();
    aniSet2();
//    _noteController.repeat();
  }

  void aniSet() {
    double timeFrom = 0.0;
    double timeTo = 0.6;

    ///
    _anmNoteUp = Tween<double>(
      begin: (itemH - diskWH / 2 + 10),
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _noteController,
        curve: Interval(
          timeFrom, timeTo, //间隔，100%的动画时间
          curve: Curves.linear,
        ),
      ),
    );

    ///
    _anmNoteHorizontal = Tween<double>(
      begin: (itemW - diskWH),
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _noteController,
        curve: Interval(
          timeFrom, timeTo, //间隔，100%的动画时间
          curve: Curves.decelerate,
        ),
      ),
    );

    ///
    _anmNoteOpaS = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _noteController,
        curve: Interval(
          timeFrom, timeTo / 2, //间隔，100%的动画时间
          curve: Curves.linear,
        ),
      ),
    );

    ///
    _anmNoteOpaH = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _noteController,
        curve: Interval(
          timeFrom / 2, timeTo, //间隔，100%的动画时间
          curve: Curves.linear,
        ),
      ),
    );
    _anmNoteRZ = Tween<double>(
      begin: 0,
      end: pi / 4,
    ).animate(
      CurvedAnimation(
        parent: _noteController,
        curve: Interval(
          timeFrom / 2, timeTo, //间隔，100%的动画时间
          curve: Curves.linear,
        ),
      ),
    );
  }

  void aniSet2() {
    double timeFrom = 0.4;
    double timeTo = 1.0;

    ///
    _anmNoteUp2 = Tween<double>(
      begin: (itemH - diskWH / 2 + 10),
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _noteController,
        curve: Interval(
          timeFrom, timeTo, //间隔，100%的动画��间
          curve: Curves.linear,
        ),
      ),
    );

    ///
    _anmNoteHorizontal2 = Tween<double>(
      begin: (itemW - diskWH),
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _noteController,
        curve: Interval(
          timeFrom, timeTo, //间隔，100%的动画时间
          curve: Curves.decelerate,
        ),
      ),
    );

    ///
    _anmNoteOpaS2 = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _noteController,
        curve: Interval(
          timeFrom, timeTo / 2, //间隔，100%的动画时间
          curve: Curves.linear,
        ),
      ),
    );

    ///
    _anmNoteOpaH2 = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _noteController,
        curve: Interval(
          timeFrom / 2, timeTo, //间隔，100%的动画时间
          curve: Curves.linear,
        ),
      ),
    );
    _anmNoteRZ2 = Tween<double>(
      begin: 0,
      end: -pi / 6,
    ).animate(
      CurvedAnimation(
        parent: _noteController,
        curve: Interval(
          timeFrom / 2, timeTo, //间隔，100%的动画时间
          curve: Curves.linear,
        ),
      ),
    );
  }

//-----------------------------音符动画 end-----------------------------
}
