import 'package:expandable/expandable.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

import 'state.dart';

Widget buildView(
    PublishHelpState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => safePopPage(),
      ),
      title: Text("常见问题", style: TextStyle(fontSize: AppFontSize.fontSize18)),
    ),
    body: Container(
      child: ExpandableTheme(
        data:
            ExpandableThemeData(iconColor: Color(0xFF969799), useInkWell: true),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: _getList(state, viewService.context),
        ),
      ),
    ),
  );
}

List<Widget> _getList(PublishHelpState state, context) {
  List arr = state.questionList;
  return arr.map((e) => _getItem(context, e)).toList();
}

Widget _getItem(context, item) {
  return ExpandableNotifier(
      child: Padding(
    padding: const EdgeInsets.all(10),
    child: Container(
      color: AppColors.primaryColor,
      // clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          ScrollOnExpand(
            scrollOnExpand: true,
            scrollOnCollapse: false,
            child: ExpandablePanel(
              theme: ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToCollapse: true,
              ),
              header: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0)),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    item["question"],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // collapsed: Text(
              //   "ksjdfkljsjfljksjdlfjklsjlkfjlsjdkfljl",
              //   softWrap: true,
              //   maxLines: 2,
              //   overflow: TextOverflow.ellipsis,
              // ),
              expanded: Container(
                width: screen.screenWidth,
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  color: Color(0xFF242424),
                ),
                child: Text(
                  item["answer"],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              builder: (_, collapsed, expanded) {
                return Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Expandable(
                    collapsed: collapsed,
                    expanded: expanded,
                    theme: ExpandableThemeData(crossFadePoint: 0),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  ));
}
