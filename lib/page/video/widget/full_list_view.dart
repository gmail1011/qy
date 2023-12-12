import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 保持widget 活跃
/// 使用：KeepAliveWidget(widget);
class FullListView extends StatefulWidget {
  final Function onPageChanged;
  final int itemCount;
  final Function itemBuilder;
  final int initPlayPosition;
  final bool isRefresh;
  bool useIsRefresh;

  FullListView({
    @required this.onPageChanged,
    @required this.itemCount,
    @required this.itemBuilder,
    this.initPlayPosition,
    this.isRefresh = false,
  }) {
    useIsRefresh = isRefresh;
  }

  @override
  FullListViewState createState() => FullListViewState();
}

class FullListViewState extends State<FullListView>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool absorbing = false;
  AnimationController animationControllerY;
  Animation<double> animationY;
  double offsetX = 0.0;
  double offsetY = 0.0;
  int currentIndex = 0;
  bool inMiddle = true;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.initPlayPosition;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: buildMiddlePage(),
    );
  }

  Widget buildMiddlePage() {
    var useIsRefresh = widget.useIsRefresh;
    widget.useIsRefresh = false;
    return AbsorbPointer(
      absorbing: absorbing,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return true;
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            var metrics = notification.metrics;
            double n = metrics.pixels / metrics.extentInside;
            double m = n % 1.0;
            int roundM = m.round();
            var bSide = (m - roundM).abs() < 0.005;
            if (notification is UserScrollNotification) {
              if (notification.direction == ScrollDirection.idle) {
                if (widget.onPageChanged != null && bSide) {
                  widget.onPageChanged(currentIndex);
                }
              }
              return true;
            }
            if (notification is ScrollEndNotification) {
              if (widget.onPageChanged != null && bSide) {
                widget.onPageChanged(currentIndex);
              }
            }
            return true;
          },
          child: MiddleExPage(
            isRefresh: useIsRefresh,
            itemCount: widget.itemCount,
            itemBuilder: widget.itemBuilder,
            initPlayPosition: widget.initPlayPosition,
            offsetX: offsetX,
            offsetY: offsetY,
            onPageChanged: (index) {
              print("====================>what set sp cur:$currentIndex to index:$index");
              if (mounted)
                setState(() {
                  currentIndex = index;
                });
            },
          ),
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    if (mounted)
      setState(() {
        currentIndex = index;
      });
  }

  /// 计算[offsetY]
  ///
  /// 手指上滑,[absorbing]为false，事件交给底层PageView处理
  /// 处于第一页且是下拉，则拦截滑动事件
  void calculateOffsetY(DragUpdateDetails details) {
    final tempY = offsetY + details.delta.dy / 2;
    if (currentIndex == 0) {
      if (tempY > 0) {
        absorbing = true;
        if (tempY < 40) {
          offsetY = tempY;
        } else if (offsetY != 40) {
          offsetY = 40;
          _vibrate();
        }
      } else {
        absorbing = false;
      }
      setState(() {});
    } else {
      absorbing = false;
      offsetY = 0;
      setState(() {});
    }
  }

  /// 滑动到顶部
  ///
  /// [offsetY] to 0.0
  void animateToTop() {
    animationControllerY =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    final curve = CurvedAnimation(
        parent: animationControllerY, curve: Curves.easeOutCubic);
    animationY = Tween(begin: offsetY, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {
          offsetY = animationY.value;
        });
      })
      ..addStatusListener((status) {});
    animationControllerY.forward();
  }

  /// 震动效果
  _vibrate() {
    // Not check if the device can vibrate
    // Vibrate.feedback(FeedbackType.impact);
  }

  @override
  bool get wantKeepAlive => true;
}

class MiddleExPage extends StatefulWidget {
  final double offsetX;
  final double offsetY;
  final ValueChanged<int> onPageChanged;
  final int itemCount;
  final int initPlayPosition;
  final Function(BuildContext, int) itemBuilder;
  final bool isRefresh;

  const MiddleExPage(
      {Key key,
      this.offsetX,
      this.offsetY,
      this.onPageChanged,
      this.initPlayPosition,
      @required this.itemCount,
      @required this.itemBuilder,
      this.isRefresh = false})
      : super(key: key);

  @override
  MiddleExState createState() => MiddleExState();
}

class MiddleExState extends State<MiddleExPage> {
  double offsetX;
  double offsetY;

  PageController _pageController;

  @override
  void initState() {
    offsetX = widget.offsetX;
    offsetY = widget.offsetY;

    _pageController = PageController(initialPage: widget.initPlayPosition ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRefresh) {
      _pageController.jumpToPage(0);
    }

    return buildMiddlePage();
  }

  /// 中间 Widget
  ///
  /// 通过 [Transform.translate] 根据 [offsetX] 进行偏移
  /// 水平偏移量为 [ offsetX] /5 产生视差效果
  Transform buildMiddlePage() {
    // ScrollPhysics
    return Transform.translate(
      offset: Offset(0, 0),
      child: Stack(
        children: <Widget>[
          Container(
            child: Column(
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Expanded(
                  child: PageView.builder(
                    onPageChanged: widget.onPageChanged,
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.itemCount,
                    itemBuilder: widget.itemBuilder,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
