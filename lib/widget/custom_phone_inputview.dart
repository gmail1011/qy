import 'package:flutter/material.dart';
import 'package:flutter_base/utils/dimens.dart';

typedef void PhoneInputViewOnChanged(String text);

class CustomPhoneInputView extends StatefulWidget {
  final double width;
  final double height;
  final Color bottomLineColor;
  final double lineBottomMargin;
  final PhoneInputViewOnChanged onChanged;
  final String phoneCode;

  CustomPhoneInputView(
      {Key key,
      this.phoneCode,
      this.width,
      this.height,
      this.lineBottomMargin,
      this.bottomLineColor,
      this.onChanged})
      : super(key: key);

  @override
  _CustomPhoneInputViewState createState() => _CustomPhoneInputViewState();
}

class _CustomPhoneInputViewState extends State<CustomPhoneInputView> {
  TextEditingController _editingController;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.phoneCode);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        //失去焦点
        _focusNode.unfocus();
        setState(() {});
      } else {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(bottom: Dimens.pt2),
                      child: Text(
                        "+",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: Dimens.pt16, color: Colors.white),
                      ))),
              Expanded(
                flex: 8,
                child: Container(
                  margin: EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextField(
                        cursorColor: Colors.white.withOpacity(0.5),
                        controller: _editingController,
                        maxLines: 1,
                        focusNode: _focusNode,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontSize: Dimens.pt14, color: Colors.white),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: Color(0x80FFFFFF), fontSize: Dimens.pt14),
                          border: InputBorder.none,
                        ),
                        onChanged: (val) {
                          if (widget.onChanged != null) {
                            widget.onChanged(val);
                          }
                        },
                        onSubmitted: (val) {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Positioned(
          //   bottom: widget.lineBottomMargin ?? 0,
          //   child: Container(width: 100,height:1,decoration: BoxDecoration(
          //     border: Border(
          //         bottom: BorderSide(
          //             color: _focusNode.hasFocus ? (widget.bottomLineColor ?? Colors.red) : Color(0xffEEEEEE),
          //             width: Dimens.pt1)),
          //   )),
          // )
        ],
      ),
    );
  }
}
