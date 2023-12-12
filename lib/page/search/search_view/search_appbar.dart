import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackPressed;
  final TextEditingController controller;
  final bool autofocus;
  final bool showCancelBtn;
  final bool showPopBtn;
  final bool isSearchBtn;

  final VoidCallback onTap;

  SearchAppBar(
      {this.onSubmitted,
      this.onChanged,
      this.onBackPressed,
      @required this.controller,
      this.autofocus = true,
      this.onTap,
      this.showCancelBtn = true,
      this.showPopBtn = true,
      this.isSearchBtn = false})
      : super();

  @override
  State<StatefulWidget> createState() {
    return new _SearchAppBarState();
  }

  @override
  Size get preferredSize => new Size.fromHeight(44 + screen.paddingTop);
}

class _SearchAppBarState extends State<SearchAppBar> {
  var inputText = '';
  bool isClear = false;

  @override
  void initState() {
    super.initState();
    inputText = widget.controller.text ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 44 + screen.paddingTop,
      padding: EdgeInsets.only(
        top: screen.paddingTop,
        right: AppPaddings.appMargin,
        left: AppPaddings.appMargin,
      ),
      child: Row(
        children: <Widget>[
          Visibility(
            visible: widget.showPopBtn,
            child: GestureDetector(
              child: Container(
                width: 30,
                height: 30,
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/weibo/back_arrow.png",
                  width: 30.w,
                  height: 30.w,
                ),
              ),
              onTap: () {
                if(widget.onBackPressed != null) {
                  widget.onBackPressed();
                  return;
                }
                safePopPage();
              },
            ),
          ),
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 42.w,
              ),
              child: TextField(
                keyboardType: TextInputType.text,
                autofocus: widget.autofocus,
                autocorrect: true,
                onTap: widget.onTap,
                textInputAction: TextInputAction.search,
                cursorColor: Colors.white,
                textAlign: TextAlign.left,
                controller: widget.controller,
                style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
                onChanged: (text) {
                  inputText = text;
                  setState(() => isClear = text.length > 0);
                  if (widget.onChanged == null) return;
                  widget.onChanged(text);
                },
                onSubmitted: (text) {
                  if (widget.onSubmitted == null) return;
                  widget.onSubmitted(text);
                },
                decoration: InputDecoration(
                  prefixText: "",
                  suffixIcon: Visibility(
                    visible: isClear,
                    child: GestureDetector(
                      onTap: () {
                        print("object");
                        setState(
                          () {
                            widget.controller.clear();
                            inputText = '';
                            isClear = false;
                          },
                        );
                        if (widget.onChanged != null) {
                          widget.onChanged('');
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        margin: EdgeInsets.only(
                          top: 6.w,
                          bottom: 6.w,
                        ),
                        child: Image.asset(
                          "assets/weibo/search_close.png",
                          width: 18.w,
                          height: 18.w,
                        ),
                      ),
                    ),
                  ),
                  fillColor: Color.fromRGBO(32, 32, 32, 1),
                  hintText: Lang.SEARCH_HINT_TEXT,
                  hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3), fontSize: Dimens.pt13),
                  contentPadding: EdgeInsets.only(left: 12.0),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17.5)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17.5),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.showCancelBtn,
            child: GestureDetector(
              onTap: () {
                if (widget.isSearchBtn) {
                  if (widget.onSubmitted == null) return;
                  widget.onSubmitted(inputText);
                } else {
                  safePopPage();
                }
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  widget.isSearchBtn ? Lang.SEARCH : Lang.cancel,
                  style: TextStyle(
                    fontSize: Dimens.pt14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
