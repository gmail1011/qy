import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/page/home/discovery_tab_page/audiobook_page/audiobook_record_page/page.dart';
import 'package:flutter_app/page/home/post/page/common_post_detail/common_post_detail_page.dart';
import 'package:flutter_app/page/home/post/page/history/history_page.dart';
import 'package:flutter_app/page/tag/special_topic/page.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/route_manager.dart' as Gets;

import '../search_default_page.dart';

class SearchAppBarLiaoBa extends StatefulWidget implements PreferredSizeWidget {
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final bool autofocus;
  final bool showCancelBtn;
  final bool showPopBtn;
  final bool isSearchBtn;

  final VoidCallback onTap;
  SearchAppBarLiaoBa(
      {this.onSubmitted,
      this.onChanged,
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

class _SearchAppBarState extends State<SearchAppBarLiaoBa> {
  var inputText = '';
  bool isClear = false;

  FocusNode focusNode = new FocusNode();

  bool isHide = true;

  @override
  void initState() {
    super.initState();
    inputText = widget.controller.text ?? '';

    bus.on(EventBusUtils.hideAudioBook, (arg) {
      if (arg) {
        isHide = true;
      } else {
        isHide = false;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.clear();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Container(
        color: Colors.transparent,
        height: Dimens.pt10 + screen.paddingTop,
        padding: EdgeInsets.only(
          top: Dimens.pt10,
          right: Dimens.pt6,
          left: AppPaddings.appMargin,
        ),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Config.payFromType = PayFormType.user;
              },
              // child: Image.asset(
              //   "assets/images/open_vip.png",
              //   width: Dimens.pt70,
              //   // height: Dimens.pt100,
              //   fit: BoxFit.cover,
              // ),
            ),
            SizedBox(
              width: Dimens.pt10,
            ),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 38,
                ),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  autocorrect: true,
                  onTap: () async {
                    focusNode.unfocus();
                    //await JRouter().go(PAGE_SPECIAL);
                   /* Gets.Get.to(SearchDefaultPage().buildPage(null),
                        opaque: false);*/
                    JRouter().jumpPage(PAGE_SEARCH);
                  },
                  textInputAction: TextInputAction.none,
                  cursorColor: Colors.white,
                  textAlign: TextAlign.left,
                  controller: widget.controller,
                  focusNode: focusNode,
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
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white.withOpacity(0.3),
                    ),
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
                          child: Icon(
                            Icons.cancel,
                            color: Color(0xFF2F2F2F).withOpacity(0.5),
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                    fillColor: Colors.white.withOpacity(0.3),
                    hintText: Lang.SEARCH_HINT_TEXT,
                    hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: Dimens.pt14),
                    contentPadding: EdgeInsets.only(left: 0.0),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(17.5)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17.5),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: Dimens.pt16,
            ),
            GestureDetector(
                onTap: () {
                  /*Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HistoryPage().buildPage(null)));*/

                  Gets.Get.to(() =>HistoryPage().buildPage(null), opaque: false);
                },
                child: Image.asset(
                  "assets/images/liaoba_history.png",
                  fit: BoxFit.cover,
                  width: Dimens.pt21,
                  height: Dimens.pt21,
                )),
            SizedBox(
              width: Dimens.pt16,
            ),
            GestureDetector(
                onTap: () {
                  /*Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CommonPostDetailPage().buildPage(null)));*/

                  Gets.Get.to(() =>CommonPostDetailPage().buildPage(null),
                      opaque: false);
                },
                child: Image.asset(
                  "assets/images/liaoba_saixuan.png",
                  fit: BoxFit.cover,
                  width: Dimens.pt21,
                  height: Dimens.pt21,
                )),
            SizedBox(
              width: Dimens.pt16,
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Visibility(
                visible: isHide ? false : true,
                child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(right: AppPaddings.appMargin),
                    child: svgAssets(AssetsSvg.RECORDING,
                        height: Dimens.pt21,
                        width: Dimens.pt21,
                        color: Colors.grey)),
              ),
              onTap: () {
                Gets.Get.to(() =>AudiobookRecordPage().buildPage(null),
                    opaque: false);
              },
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
      ),
    );
  }
}
