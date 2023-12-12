import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/common/guide/step_widget_params.dart';

/// The [WidgetBuilder] class that comes with Flutter Intro
///
/// You can use the defaultTheme provided by Flutter Intro
///
/// {@tool snippet}
/// ```dart
/// final Intro intro = Intro(
///   stepCount: 2,
///   widgetBuilder: StepWidgetBuilder.useDefaultTheme([
///     'say something',
///     'say other something',
///   ]),
/// );
/// ```
/// {@end-tool}
///
class StepWidgetBuilder {
  static Map _smartGetPosition({Size size, Size screenSize, Offset offset}) {
    double height = size.height;
    double width = size.width;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    double bottomArea = screenHeight - offset.dy - height;
    double topArea = screenHeight - height - bottomArea;
    double rightArea = screenWidth - offset.dx - width;
    double leftArea = screenWidth - width - rightArea;
    Map position = Map();
    position['crossAxisAlignment'] = CrossAxisAlignment.start;
    if (topArea > bottomArea) {
      position['bottom'] = bottomArea + height + 8;
    } else {
      position['top'] = offset.dy + height + 6;
    }
    if (leftArea > rightArea) {
      position['right'] = rightArea <= 0 ? 8.0 : rightArea;
      position['crossAxisAlignment'] = CrossAxisAlignment.end;
      position['width'] = min(leftArea + width - 8, screenWidth * 0.618);
    } else {
      position['left'] = offset.dx <= 0 ? 8.0 : offset.dx;
      position['width'] = min(rightArea + width - 8, screenWidth * 0.618);
    }

    /// The distance on the right side is very large, it is more beautiful on the right side
    if (rightArea > 0.8 * topArea && rightArea > 0.8 * bottomArea) {
      position['left'] = offset.dx + width + 8;
      position['top'] = offset.dy - 2;
      position['bottom'] = null;
      position['right'] = null;
      position['width'] = min<double>(position['width'], rightArea * 0.8);
    }

    /// The distance on the left is large, it is more beautiful on the left side
    if (leftArea > 0.8 * topArea && leftArea > 0.8 * bottomArea) {
      position['right'] = rightArea + width + 8;
      position['top'] = offset.dy - 2;
      position['bottom'] = null;
      position['left'] = null;
      position['crossAxisAlignment'] = CrossAxisAlignment.end;
      position['width'] = min<double>(position['width'], leftArea * 0.8);
    }
    return position;
  }

  static Map _smartGetPosition2({Size size, Size screenSize, Offset offset}) {
    double height = size.height;
    double width = size.width;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    double bottomArea = screenHeight - offset.dy - height;
    double topArea = screenHeight - height - bottomArea;
    double rightArea = screenWidth - offset.dx - width;
    double leftArea = screenWidth - width - rightArea;
    Map position = Map();
    position['crossAxisAlignment'] = CrossAxisAlignment.start;
    if (topArea > bottomArea) {
      position['bottom'] = bottomArea + height + 16;
    } else {
      position['top'] = offset.dy + height + 12;
    }
    if (leftArea > rightArea) {
      position['right'] = rightArea <= 0 ? 16.0 : rightArea;
      position['crossAxisAlignment'] = CrossAxisAlignment.end;
      position['width'] = min(leftArea + width - 16, screenWidth * 0.618);
    } else {
      position['left'] = offset.dx <= 0 ? 16.0 : offset.dx;
      position['width'] = min(rightArea + width - 16, screenWidth * 0.618);
    }

    /// The distance on the right side is very large, it is more beautiful on the right side
    if (rightArea > 0.8 * topArea && rightArea > 0.8 * bottomArea) {
      position['left'] = offset.dx + width + 16;
      position['top'] = offset.dy - 4;
      position['bottom'] = null;
      position['right'] = null;
      position['width'] = min<double>(position['width'], rightArea * 0.8);
    }

    /// The distance on the left is large, it is more beautiful on the left side
    if (leftArea > 0.8 * topArea && leftArea > 0.8 * bottomArea) {
      position['right'] = rightArea + width + 16;
      position['top'] = offset.dy - 4;
      position['bottom'] = null;
      position['left'] = null;
      position['crossAxisAlignment'] = CrossAxisAlignment.end;
      position['width'] = min<double>(position['width'], leftArea * 0.8);
    }
    return position;
  }

  /// Use default theme
  /// [widgets] Text prompt list, each item is the text that needs to be displayed on the corresponding guide page
  /// [btnLabel] The text in the next button, the default value is "I KNOW"
  /// [showStepLabel] Whether to display the step indicator behind the button, the default display
  /// [posMap] 指定位置，1上，2下，3左，4右，其他或者没有，智能位置
  static Widget Function(StepWidgetParams params, BuildContext context)
      useDefaultTheme(
          {List<Map<String, dynamic>> widgets,
          List<String> texts,
          Map<int, int> posMap,
          // String btnLabel = 'I KNOW',
          bool showStepLabel = false,
          Color textBgColor = Colors.red}) {
    assert(null != widgets || null != texts);
    Map<int, int> _posMap = Map();
    if (null != posMap) _posMap.addAll(posMap);
    Widget getIntroWidget(int currentStepIndex) {
      if (null != widgets) {
        if (currentStepIndex > widgets.length - 1) {
          return Container();
        } else {
          return widgets[currentStepIndex]["widget"];
        }
      } else if (null != texts) {
        if (currentStepIndex > texts.length - 1) {
          return Container();
        } else {
          return Container(
            padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 6),
            decoration: BoxDecoration(
                color: textBgColor, borderRadius: BorderRadius.circular(14)),
            child: Text(
              texts[currentStepIndex],
              softWrap: true,
              style: TextStyle(
                // fontSize: 14,
                // fontWeight: FontWeight.bold,
                height: 1.4,
                color: Colors.white,
              ),
            ),
          );
        }
      } else {
        return Container();
      }
    }

    return (StepWidgetParams stepWidgetParams, BuildContext context) {
      int currentStepIndex = stepWidgetParams.currentStepIndex;
      int stepCount = stepWidgetParams.stepCount;
      Offset offset = stepWidgetParams.offset;

      double left, right, top, bottom;
      CrossAxisAlignment caa = CrossAxisAlignment.start;
      var pos = _posMap[currentStepIndex];
      if (null != texts && 1 == pos) {
        //上
        double height = stepWidgetParams.size.height;
        double width = stepWidgetParams.size.width;
        double centerPointX = offset.dx + width / 2;
        double centerPointY = offset.dy + height / 2;
        var textWidth = .0;
        var textHeight = .0;
        if (null != widgets) {
          textWidth = widgets[currentStepIndex]["width"];
          textHeight = widgets[currentStepIndex]["height"];
        } else {
          textWidth = calculateTextWidth(context, texts[currentStepIndex]) + 26;
          textHeight =
              calculateTextHeight(context, texts[currentStepIndex]) + 10;
        }
        left = centerPointX - textWidth / 2;
        top = centerPointY - textHeight / 2 - 26;
      } else if (2 == pos) {
        //下
        double height = stepWidgetParams.size.height;
        double width = stepWidgetParams.size.width;
        double centerPointX = offset.dx + width / 2;
        double centerPointY = offset.dy + height / 2;
        var textWidth = .0;
        var textHeight = .0;
        if (null != widgets) {
          textWidth = widgets[currentStepIndex]["width"];
          textHeight = widgets[currentStepIndex]["height"];
        } else {
          textWidth = calculateTextWidth(context, texts[currentStepIndex]) + 26;
          textHeight =
              calculateTextHeight(context, texts[currentStepIndex]) + 10;
        }
        left = centerPointX - textWidth / 2;
        top = centerPointY + textHeight / 2 + 26;
      } else if (3 == pos) {
        //左
        double height = stepWidgetParams.size.height;
        double width = stepWidgetParams.size.width;
        double centerPointX = offset.dx + width / 2;
        double centerPointY = offset.dy + height / 2;
        var textWidth = .0;
        var textHeight = .0;
        if (null != widgets) {
          textWidth = widgets[currentStepIndex]["width"];
          textHeight = widgets[currentStepIndex]["height"];
        } else {
          textWidth = calculateTextWidth(context, texts[currentStepIndex]) + 26;
          textHeight =
              calculateTextHeight(context, texts[currentStepIndex]) + 10;
        }
        left = centerPointX - textWidth / 2 - 26;
        top = centerPointY - textHeight / 2;
        caa = CrossAxisAlignment.end;
      } else if (4 == pos) {
        //右
        double height = stepWidgetParams.size.height;
        double width = stepWidgetParams.size.width;
        double centerPointX = offset.dx + width / 2;
        double centerPointY = offset.dy + height / 2;
        var textWidth = .0;
        var textHeight = .0;
        if (null != widgets) {
          textWidth = widgets[currentStepIndex]["width"];
          textHeight = widgets[currentStepIndex]["height"];
        } else {
          textWidth = calculateTextWidth(context, texts[currentStepIndex]) + 26;
          textHeight =
              calculateTextHeight(context, texts[currentStepIndex]) + 10;
        }
        left = centerPointX + textWidth / 2 + 26;
        top = centerPointY - textHeight / 2;
      } else {
        Map position = _smartGetPosition(
          screenSize: stepWidgetParams.screenSize,
          size: stepWidgetParams.size,
          offset: offset,
        );
        left = position['left'];
        top = position['top'];
        right = position['right'];
        bottom = position['bottom'];
        caa = position['crossAxisAlignment'];
      }
      // print("stepParam:$stepWidgetParams");
      // print("after position:$position");
      var widget = getIntroWidget(currentStepIndex);
      return Stack(
        children: [
          Positioned(
            child: Container(
              // width: position['width'],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: caa,
                children: [
                  GestureDetector(
                      onTap: stepCount - 1 == currentStepIndex
                          ? stepWidgetParams.onFinish
                          : stepWidgetParams.onNext,
                      child: widget),

                  // SizedBox(
                  //   height: 12,
                  // ),
                  // SizedBox(
                  //   height: 28,
                  //   child: OutlineButton(
                  //     padding: EdgeInsets.symmetric(
                  //       vertical: 0,
                  //       horizontal: 8,
                  //     ),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(64),
                  //       ),
                  //     ),
                  //     highlightedBorderColor: Colors.white,
                  //     borderSide: BorderSide(color: Colors.white),
                  //     textColor: Colors.white,
                  //     onPressed: stepCount - 1 == currentStepIndex
                  //         ? stepWidgetParams.onFinish
                  //         : stepWidgetParams.onNext,
                  //     child: Text(
                  //       '$btnLabel' +
                  //           (showStepLabel
                  //               ? ' ${currentStepIndex + 1}/$stepCount'
                  //               : ''),
                  //       style: TextStyle(
                  //         fontSize: 12,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            left: left,
            top: top,
            right: right,
            bottom: bottom,
          ),
        ],
      );
    };
  }
}

///计算文本高度
double calculateTextHeight(BuildContext ctx, String value,
    [double fontSize = 14.0, FontWeight fontWeight = FontWeight.w400]) {
  // value = filterText(value);
  // var s = value.split("\n");
  TextPainter painter = TextPainter(

      ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
      locale: Localizations.localeOf(ctx, nullOk: true),
      textDirection: TextDirection.ltr,
      text: TextSpan(
          text: value,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
          )));
  painter.layout();
  // print("==>s.length:${s.length}");

  ///文字的宽度:painter.width
  return painter.height;
}

/// 计算文本宽度
double calculateTextWidth(BuildContext ctx, String value,
    [double fontSize = 14.0, FontWeight fontWeight = FontWeight.w400]) {
  // value = filterText(value);
  TextPainter painter = TextPainter(

      ///AUTO：华为手机如果不指定locale的时候，该方法算出来的文字高度是比系统计算偏小的。
      locale: Localizations.localeOf(ctx, nullOk: true),
      textDirection: TextDirection.ltr,
      text: TextSpan(
          text: value,
          style: TextStyle(
            fontWeight: fontWeight,
            fontSize: fontSize,
          )));
  painter.layout();

  ///文字的宽度:painter.width
  return painter.width;
}
