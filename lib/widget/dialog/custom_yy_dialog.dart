// file:  将 库YYDialog 自定义了， 因为没有需要的内容，自己添加了些小东西
import 'package:flutter/material.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog_widget.dart';

/// 将 库YYDialog 自定义了， 因为没有需要的内容，自己添加了些小东西
class CustomYYDialog {
  //================================弹窗属性======================================
  List<Widget> widgetList = []; //弹窗内部所有组件
  static BuildContext _context; //弹窗上下文
  BuildContext context; //弹窗上下文

  double width; //弹窗宽度
  double height; //弹窗高度
  Duration duration = Duration(milliseconds: 250); //弹窗动画出现的时间
  Gravity gravity = Gravity.center; //弹窗出现的位置
  bool gravityAnimationEnable = false; //弹窗出现的位置带有的默认动画是否可用
  Color barrierColor = Colors.black.withOpacity(.3); //弹窗外的背景色
  Color backgroundColor = Colors.white; //弹窗内的背景色
  double borderRadius = 0.0; //弹窗圆角
  BoxConstraints constraints; //弹窗约束
  Function(Widget child, Animation<double> animation) animatedFunc; //弹窗出现的动画
  bool barrierDismissible = true; //是否点击弹出外部消失
  EdgeInsets margin = EdgeInsets.all(0.0); //弹窗布局的外边距

  get isShowing => _isShowing; //当前弹窗是否可见
  bool _isShowing = false;
  get isOpen => _isOpen; //是否打开
  bool _isOpen = false;

  Function closeFunc;
  VideoModel videoModel;

  CustomYYDialog({this.closeFunc,this.videoModel});


  //============================================================================
  static void init(BuildContext ctx) {
    _context = ctx;
  }

  CustomYYDialog build([BuildContext ctx]) {
    if (ctx == null && _context != null) {
      this.context = _context;
      return this;
    }
    this.context = ctx;
    return this;
  }

  CustomYYDialog widget(Widget child) {
    this.widgetList.add(child);
    return this;
  }

  CustomYYDialog text(
      {padding,
      text,
      color,
      fontSize,
      alignment,
      textAlign,
      maxLines,
      textDirection,
      overflow,
      fontWeight,
      fontFamily}) {
    return this.widget(
      Padding(
        padding: padding ?? EdgeInsets.all(0.0),
        child: Align(
          alignment: alignment ?? Alignment.centerLeft,
          child: Text(
            text ?? "",
            textAlign: textAlign,
            maxLines: maxLines,
            textDirection: textDirection,
            overflow: overflow,
            style: TextStyle(
              color: color ?? Colors.black,
              fontSize: fontSize ?? 14.0,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
            ),
          ),
        ),
      ),
    );
  }

  CustomYYDialog doubleButton({
    padding,
    gravity,
    height,
    isClickAutoDismiss = true, //点击按钮后自动关闭
    withDivider = false, //中间分割线
    text1,
    color1,
    fontSize1,
    fontWeight1,
    fontFamily1,
    VoidCallback onTap1,
    text2,
    color2,
    fontSize2,
    fontWeight2,
    fontFamily2,
    onTap2,
  }) {
    return this.widget(
      SizedBox(
        height: height ?? 45.0,
        child: Row(
          mainAxisAlignment: getRowMainAxisAlignment(gravity),
          children: <Widget>[
            FlatButton(
              onPressed: () {
                if (onTap1 != null) onTap1();
                if (isClickAutoDismiss) {
                  dismiss();
                }
              },
              padding: EdgeInsets.all(0.0),
              child: Text(
                text1 ?? "",
                style: TextStyle(
                  color: color1 ?? null,
                  fontSize: fontSize1 ?? null,
                  fontWeight: fontWeight1,
                  fontFamily: fontFamily1,
                ),
              ),
            ),
            Visibility(
              visible: withDivider,
              child: VerticalDivider(),
            ),
            FlatButton(
              onPressed: () {
                if (onTap2 != null) onTap2();
                if (isClickAutoDismiss) {
                  dismiss();
                }
              },
              padding: EdgeInsets.all(0.0),
              child: Text(
                text2 ?? "",
                style: TextStyle(
                  color: color2 ?? Colors.black,
                  fontSize: fontSize2 ?? 14.0,
                  fontWeight: fontWeight2,
                  fontFamily: fontFamily2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  CustomYYDialog listViewOfListTile({
    List<ListTileItem> items,
    double height,
    isClickAutoDismiss = true,
    Function(int) onClickItemListener,
  }) {
    return this.widget(
      Container(
        height: height,
        child: ListView.builder(
          padding: EdgeInsets.all(0.0),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Material(
              color: Colors.white,
              child: InkWell(
                child: ListTile(
                  onTap: () {
                    if (onClickItemListener != null) {
                      onClickItemListener(index);
                    }
                    if (isClickAutoDismiss) {
                      dismiss();
                    }
                  },
                  contentPadding: items[index].padding ?? EdgeInsets.all(0.0),
                  leading: items[index].leading,
                  title: Text(
                    items[index].text ?? "",
                    style: TextStyle(
                      color: items[index].color ?? null,
                      fontSize: items[index].fontSize ?? null,
                      fontWeight: items[index].fontWeight,
                      fontFamily: items[index].fontFamily,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  CustomYYDialog listViewOfRadioButton({
    List<RadioItem> items,
    double height,
    Color activeColor,
    Function(int) onClickItemListener,
  }) {
    Size size = MediaQuery.of(context).size;
    return this.widget(
      Container(
        height: height,
        constraints: BoxConstraints(
          minHeight: size.height * .1,
          minWidth: size.width * .1,
          maxHeight: size.height * .5,
        ),
        child: YYRadioListTile(
          items: items,
          activeColor: activeColor,
          onChanged: onClickItemListener,
        ),
      ),
    );
  }

  CustomYYDialog circularProgress({padding, backgroundColor, valueColor, strokeWidth}) {
    return this.widget(Padding(
      padding: padding,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? 4.0,
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(valueColor),
      ),
    ));
  }

  CustomYYDialog divider({color, height}) {
    return this.widget(
      Divider(
        color: color ?? Colors.grey[300],
        height: height ?? 0.1,
      ),
    );
  }

  ///  x坐标
  ///  y坐标
  void show([x, y]) {
    if (this.context == null) return;
    _isOpen = true;
    var mainAxisAlignment = getColumnMainAxisAlignment(gravity);
    var crossAxisAlignment = getColumnCrossAxisAlignment(gravity);
    if (x != null && y != null) {
      gravity = Gravity.leftTop;
      margin = EdgeInsets.only(left: x, top: y);
    }
    CustomDialog(
      gravity: gravity,
      gravityAnimationEnable: gravityAnimationEnable,
      context: this.context,
      barrierColor: barrierColor,
      animatedFunc: animatedFunc,
      barrierDismissible: barrierDismissible,
      duration: duration,
      child: Padding(
        padding: margin,
        child: Column(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: <Widget>[
            Material(
              type: MaterialType.transparency,
              child: Container(
                padding: EdgeInsets.all(borderRadius / 3.14),
                width: width ?? null,
                height: height ?? null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: backgroundColor,
                ),
                constraints: constraints ?? BoxConstraints(),
                child: CustomDialogChildren(
                  widgetList: widgetList,
                  isShowingChange: (bool isShowingChange) {
                    _isShowing = isShowingChange;
                    if (_isShowing == false) {
                      _isOpen = false;
                      if (closeFunc != null) closeFunc();
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void dismiss() {
    if (closeFunc != null) closeFunc();
    if (_isShowing) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    _isOpen = false;
  }

  getColumnMainAxisAlignment(gravity) {
    var mainAxisAlignment = MainAxisAlignment.start;
    switch (gravity) {
      case Gravity.bottom:
      case Gravity.leftBottom:
      case Gravity.rightBottom:
        mainAxisAlignment = MainAxisAlignment.end;
        break;
      case Gravity.top:
      case Gravity.leftTop:
      case Gravity.rightTop:
        mainAxisAlignment = MainAxisAlignment.start;
        break;
      case Gravity.left:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case Gravity.right:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
      case Gravity.center:
      default:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
    }
    return mainAxisAlignment;
  }

  getColumnCrossAxisAlignment(gravity) {
    var crossAxisAlignment = CrossAxisAlignment.center;
    switch (gravity) {
      case Gravity.bottom:
        break;
      case Gravity.top:
        break;
      case Gravity.left:
      case Gravity.leftTop:
      case Gravity.leftBottom:
        crossAxisAlignment = CrossAxisAlignment.start;
        break;
      case Gravity.right:
      case Gravity.rightTop:
      case Gravity.rightBottom:
        crossAxisAlignment = CrossAxisAlignment.end;
        break;
      default:
        break;
    }
    return crossAxisAlignment;
  }

  getRowMainAxisAlignment(gravity) {
    var mainAxisAlignment = MainAxisAlignment.start;
    switch (gravity) {
      case Gravity.bottom:
        break;
      case Gravity.top:
        break;
      case Gravity.left:
        mainAxisAlignment = MainAxisAlignment.start;
        break;
      case Gravity.right:
        mainAxisAlignment = MainAxisAlignment.end;
        break;
      case Gravity.center:
      default:
        mainAxisAlignment = MainAxisAlignment.center;
        break;
    }
    return mainAxisAlignment;
  }
}
