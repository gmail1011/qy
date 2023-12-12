// File: 关注动画组件
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/toast_util.dart';

/// 关注动画组件
class FollowItem extends StatefulWidget {
  final bool isFollow;
  final int userID;
  final Function(bool isFollow) updateFollow;

  FollowItem({Key key, this.isFollow, this.userID, this.updateFollow})
      : super(key: key);

  @override
  _FollowItemState createState() => _FollowItemState();
}

class _FollowItemState extends State<FollowItem> with TickerProviderStateMixin {
  AnimationController _controller;

//  -----0.0 ～ 0.5------
  /// 新图 旋转
  Animation<double> spin;

  /// 旧图 透明度 消失
  Animation<double> transparency1;

  /// 新图 透明度 出现
  Animation<double> transparency2;

  /// 新图 缩放 变大
  Animation<double> zoom;

//  -----0.7 ～ 1.0------
  /// 新图 缩小
  Animation<double> zoom2;

  //================
  /// 是否关注
  bool isFollow;

  /// 最近一次请求是否成功
  bool repStatus;

  /// 已关注
  Widget followImg1;

  /// 未关注
  Widget followImg2;

  @override
  void initState() {
    // 初始化
    isFollow = widget.isFollow;

    followImg1 = Container(
      width: Dimens.pt20,
      height: Dimens.pt20,
      child: svgAssets(
        AssetsSvg.RECD_FOLLOW_ONE,
        fit: BoxFit.cover,
      ),
    );
    followImg2 = Container(
      width: Dimens.pt20,
      height: Dimens.pt20,
      child: svgAssets(
        AssetsSvg.RECD_FOLLOW_O,
        fit: BoxFit.cover,
      ),
    );

    initAnim();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 前置消失
    var _oldItem = Container(
      width: Dimens.pt20,
      height: Dimens.pt20,
      child: Opacity(
        opacity: transparency1.value,
        child: GestureDetector(
          onTap: onTap,
          child: followImg2,
        ),
      ),
    );
    var _newItem = Container(
      width: Dimens.pt20,
      height: Dimens.pt20,
      child: Transform(
        alignment: Alignment.center, //相对于坐标系原点的对齐方式
        transform: Matrix4.rotationZ(spin.value)
          ..scale(zoom.value, zoom.value)
          ..scale(zoom2.value, zoom2.value),
        child: Opacity(
          opacity: (isFollow == true) ? 1 : transparency2.value,
          child: followImg1,
        ),
      ),
    );
    var item = Stack(
      children: <Widget>[
        _newItem,
        (widget.isFollow == true) ? Center() : _oldItem,
      ],
    );
    return Opacity(
      opacity: (widget.isFollow == true) ? 0 : 1,
      child: item,
    );
  }

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
    super.dispose();
  }

  //==============================================

  /// 初始化动画
  void initAnim() {
    // 前置图渐淡。新图渐显。变大1.3。 新图旋转
    // 缩小至无
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800))
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              if (repStatus == false) {
                _controller.reset();
                setState(() {});
              } else if (repStatus == true) {
                /// 请求成功
                isFollow = !isFollow;
                setState(() {});
              }
            }
          })
          ..addListener(() {
            setState(() {});
          });

    spin = new Tween<double>(begin: -1.0 * pi, end: 0.0).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.0,
          0.5,
          curve: Curves.linear,
        ),
      ),
    );
    // 前置图渐淡
    transparency1 = new Tween<double>(begin: 1.0, end: 0.0).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.0,
          0.2,
          curve: Curves.linear,
        ),
      ),
    );
    // 新图渐显
    transparency2 = new Tween<double>(begin: 0.0, end: 1.0).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.0,
          0.5,
          curve: Curves.linear,
        ),
      ),
    );
    // 新图变大1.3
    zoom = new Tween<double>(begin: 1.0, end: 1.3).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.0,
          0.5,
          curve: Curves.linear,
        ),
      ),
    );
    // 新图缩小至无
    zoom2 = new Tween<double>(begin: 1.0, end: 0.0).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.7,
          1.0,
          curve: Curves.linear,
        ),
      ),
    );
  }

  /// 播放关注动画
  void playAnim() {
    _controller.reset();
    _controller.forward();
  }

  /// 点击关注
  void onTap() async {
    // 自己不能关注自己
    if (GlobalStore.isMe(widget.userID)) {
      showToast(msg: Lang.GLOBAL_TIP_TXT1);
      return;
    }
    if (isFollow ||
        _controller == null ||
        _controller.status == AnimationStatus.forward) {
      return;
    }

    // Map<String, dynamic> parameter = {
    //   "followUID": widget.userID,
    //   "isFollow": !widget.isFollow,
    // };
    // BaseResponse baseResponse = await getFollow(parameter);
    int followUID = widget.userID;
    bool widgetIsFollow = !widget.isFollow;
    try {

      await netManager.client.getFollow(followUID, widgetIsFollow);

      Config.followBlogger[widget.userID] = widgetIsFollow;

      if (widgetIsFollow) {
        widget.updateFollow(widgetIsFollow);
      }
      repStatus = !widget.isFollow;
      if (_controller.status != AnimationStatus.forward) {
        isFollow = !widget.isFollow;
        setState(() {});
      }
    } catch (e) {
      l.d('getFollow', e.toString());
      showToast(msg: e.toString());
    }
    // if (baseResponse.code == Code.SUCCESS) {
    //   if (!widget.isFollow) {
    //     widget.updateFollow(!widget.isFollow);
    //   }
    //   repStatus = !widget.isFollow;
    //   if (_controller.status != AnimationStatus.forward) {
    //     isFollow = !widget.isFollow;
    //     setState(() {});
    //   }
    // } else {
    //   showToast(msg: baseResponse.toString());
    // }

    /// 动画
    playAnim();
  }
}
