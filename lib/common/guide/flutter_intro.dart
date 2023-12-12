import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/guide/step_widget_params.dart';

import 'delay_rendered_widget.dart';

/// Flutter Intro main class
///
/// Pass in [stepCount] when instantiating [Intro] object, and [widgetBuilder]
/// Obtain [GlobalKey] from [Intro.keys] and add it to the [Widget] where you need to add a guide page
/// Finally execute the [start] method, the parameter is the current [BuildContext], you can
///
/// {@tool snippet}
/// ```dart
/// final Intro intro = Intro(
///   stepCount: 4,
///   widgetBuilder: widgetBuilder,
/// );
///
/// Container(
///   key: intro.keys[0],
/// );
/// Text(
///   'need focus widget',
///   key: intro.keys[1],
/// );
///
/// intro.start(context);
/// ```
/// {@end-tool}
///
class Intro {
  bool _removed = false;
  double _widgetWidth;
  double _widgetHeight;
  Offset _widgetOffset;
  OverlayEntry _overlayEntry;
  int _currentStepIndex = 0;
  Widget _stepWidget;
  List<Map> _configMap = [];
  List<GlobalKey> _globalKeys = [];
  final Color _maskColor = Colors.black.withOpacity(.4);
  final Duration _animationDuration = Duration(milliseconds: 300);

  /// The method of generating the content of the guide page,
  /// which will be called internally by [Intro] when the guide page appears
  /// And will pass in some parameters on the current page through [StepWidgetParams]
  final Widget Function(StepWidgetParams params, BuildContext context)
      widgetBuilder;

  /// [Widget] [padding] of the selected area, the default is [EdgeInsets.all(8)]
  final EdgeInsets padding;

  /// [Widget] [borderRadius] of the selected area, the default is [BorderRadius.all(Radius.circular(4))]
  final BorderRadiusGeometry borderRadius;

  /// How many steps are there in total
  final int stepCount;
  final bool showMask;

  /// Create an Intro instance, the parameter [stepCount] is the number of guide pages
  /// [widgetBuilder] is the method of generating the guide page, and returns a [Widget] as the guide page
  Intro({
    @required this.widgetBuilder,
    @required this.stepCount,
    this.showMask = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.padding = const EdgeInsets.all(8),
  }) : assert(stepCount > 0) {
    for (int i = 0; i < stepCount; i++) {
      _globalKeys.add(GlobalKey());
      _configMap.add({});
    }
  }

  List<GlobalKey> get keys => _globalKeys;

  /// Set the configuration of the specified number of steps
  void setStepConfig(
    int stepIndex, {
    EdgeInsets padding,
    BorderRadiusGeometry borderRadius,
  }) {
    assert(stepIndex >= 0 && stepIndex < stepCount);
    _configMap[stepIndex] = {
      'padding': padding,
      'borderRadius': borderRadius,
    };
  }

  /// Set the configuration of multiple steps
  void setStepsConfig(
    List<int> stepsIndex, {
    EdgeInsets padding,
    BorderRadiusGeometry borderRadius,
  }) {
    assert(stepsIndex
        .every((stepIndex) => stepIndex >= 0 && stepIndex < stepCount));
    stepsIndex.forEach((index) {
      setStepConfig(
        index,
        padding: padding,
        borderRadius: borderRadius,
      );
    });
  }

  void _getWidgetInfo(GlobalKey globalKey) {
    EdgeInsets currentConfig = _configMap[_currentStepIndex]['padding'];
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    _widgetWidth = renderBox.size.width +
        (currentConfig?.horizontal ?? padding.horizontal);
    _widgetHeight =
        renderBox.size.height + (currentConfig?.vertical ?? padding.vertical);
    _widgetOffset = Offset(
      renderBox.localToGlobal(Offset.zero).dx -
          (currentConfig?.left ?? padding.left),
      renderBox.localToGlobal(Offset.zero).dy -
          (currentConfig?.top ?? padding.top),
    );
  }

  Widget _maskBuilder({
    @required double width,
    @required double height,
    BlendMode backgroundBlendMode,
    @required double left,
    @required double top,
    BorderRadiusGeometry borderRadiusGeometry,
    Widget child,
    VoidCallback onClick,
  }) {
    return AnimatedPositioned(
      duration: _animationDuration,
      child: AnimatedContainer(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          backgroundBlendMode: backgroundBlendMode,
          borderRadius: borderRadiusGeometry,
        ),
        width: width,
        height: height,
        duration: _animationDuration,
        child: GestureDetector(onTap: onClick, child: child),
      ),
      left: left,
      top: top,
    );
  }

  void _showOverlay(
    BuildContext context,
    GlobalKey globalKey,
  ) {
    /// TODO 可以改成dialog或者flutter 外部controller 刷新;
    Size screenSize = MediaQuery.of(context).size;
    _overlayEntry = new OverlayEntry(
      builder: (BuildContext context) {
        return DelayRenderedWidget(
          removed: _removed,
          childPersist: true,
          duration: _animationDuration,
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                showMask
                    ? ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          _maskColor,
                          BlendMode.srcOut,
                        ),
                        child: Stack(
                          children: [
                            _maskBuilder(
                                width: screenSize.width,
                                height: screenSize.height,
                                backgroundBlendMode: BlendMode.dstOut,
                                left: 0,
                                top: 0,
                                onClick: () {
                                  if (stepCount - 1 == _currentStepIndex) {
                                    _onFinish();
                                  } else {
                                    _onNext(context);
                                  }
                                }),
                            _maskBuilder(
                                width: _widgetWidth,
                                height: _widgetHeight,
                                left: _widgetOffset.dx,
                                top: _widgetOffset.dy,
                                borderRadiusGeometry:
                                    _configMap[_currentStepIndex]
                                            ['borderRadius'] ??
                                        borderRadius,
                                onClick: () {
                                  if (stepCount - 1 == _currentStepIndex) {
                                    _onFinish();
                                  } else {
                                    _onNext(context);
                                  }
                                }),
                          ],
                        ),
                      )
                    : Container(),
                DelayRenderedWidget(
                  child: _stepWidget,
                ),
              ],
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry);
  }

  void _onNext(BuildContext context) {
    // print("_onNext");
    _currentStepIndex++;
    if (_currentStepIndex < stepCount) {
      _createStepWidget(context);
      _overlayEntry.markNeedsBuild();
    }
  }

  void _onPrev(BuildContext context) {
    // print("_onPrev");
    _currentStepIndex--;
    if (_currentStepIndex >= 0) {
      _createStepWidget(context);
      _overlayEntry.markNeedsBuild();
    }
  }

  void _onFinish() {
    _removed = true;
    _overlayEntry.markNeedsBuild();
    Timer(_animationDuration, () {
      _overlayEntry.remove();
    });
  }

  void _createStepWidget(BuildContext context) {
    _getWidgetInfo(_globalKeys[_currentStepIndex]);
    Size screenSize = MediaQuery.of(context).size;
    Size widgetSize = Size(_widgetWidth, _widgetHeight);

    _stepWidget = widgetBuilder(
        StepWidgetParams(
          screenSize: screenSize,
          size: widgetSize,
          onNext: _currentStepIndex == stepCount - 1
              ? null
              : () {
                  _onNext(context);
                },
          onPrev: _currentStepIndex == 0
              ? null
              : () {
                  _onPrev(context);
                },
          offset: _widgetOffset,
          currentStepIndex: _currentStepIndex,
          stepCount: stepCount,
          onFinish: () {},
        ),
        context);
  }

  /// Trigger the start method of the guided operation
  ///
  /// [context] Current environment [BuildContext]
  void start(BuildContext context) {
    _removed = false;
    _currentStepIndex = 0;
    _createStepWidget(context);
    _showOverlay(
      context,
      _globalKeys[_currentStepIndex],
    );
  }
}
