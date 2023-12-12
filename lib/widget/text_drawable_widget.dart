import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/utils/dimens.dart';

///文字+图片布局
class TextDrawableWidget extends StatefulWidget {
  final VoidCallback callback;

  final EdgeInsets padding;

  final String text;

  final Widget image;

  final Axis scrollDirection;
  final TextStyle textStyle;

  TextDrawableWidget({
    Key key,
    @required this.text,
    @required this.image,
    this.callback,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.textStyle,
  }) : super(key: key) {
    // if (null == textStyle) textStyle = TextStyle(color: Colors.white, fontSize: Dimens.pt12);
  }

  @override
  State<StatefulWidget> createState() {
    return TextDrawableState();
  }
}

class TextDrawableState extends State<TextDrawableWidget> {
  String textValue;

  Widget imgWidget;

  @override
  void initState() {
    super.initState();
    this.textValue = widget.text;
    this.imgWidget = widget.image;
  }

  configImgWidget(Widget imgWidget) {
    if (!mounted) return;
    setState(() {
      this.imgWidget = imgWidget;
    });
  }

  configText(String text) {
    if (!mounted) return;
    setState(() {
      this.textValue = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.callback,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: widget.padding ?? EdgeInsets.all(Dimens.pt5),
        child: widget.scrollDirection == Axis.vertical
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  imgWidget,
                  Padding(
                    padding: EdgeInsets.only(top: Dimens.pt3),
                  ),
                  Text(this.widget.text,
                      style: widget.textStyle ??
                          TextStyle(color: Colors.white, fontSize: Dimens.pt12))
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  imgWidget,
                  Padding(
                    padding: EdgeInsets.only(left: Dimens.pt3),
                  ),
                  Text(this.widget.text,
                      style: widget.textStyle ??
                          TextStyle(color: Colors.white, fontSize: Dimens.pt12))
                ],
              ),
      ),
    );
  }
}
