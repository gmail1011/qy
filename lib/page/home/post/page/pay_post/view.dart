import 'package:extended_tabs/extended_tabs.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'state.dart';

Widget buildView(
    PayPostState state, Dispatch dispatch, ViewService viewService) {
  var tabWidgets = <Widget>[
    GestureDetector(
      onTap: () {
        state.vc.animateTo(0);
      },
      child: Container(
        height: Dimens.pt28,
        child: Center(
          child: Text(
            state.tabList[0],
          ),
        ),
      ),
    ),
    GestureDetector(
      onTap: () {
        state.vc.animateTo(1);
      },
      child: Container(
        height: Dimens.pt28,
        child: Center(
          child: Text(
            state.tabList[1],
          ),
        ),
      ),
    ),
  ];
  return Container(
    padding: EdgeInsets.only(top: Dimens.pt5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Container(
              margin: EdgeInsets.only(
                  right: Dimens.pt16, top: Dimens.pt6, bottom: Dimens.pt0),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                  color: Color(0xff0C0C17),
                  borderRadius: BorderRadius.circular(Dimens.pt28)),
              child: TabBar(
                  tabs: tabWidgets,
                  isScrollable: true,
                  labelStyle: TextStyle(
                      color: Color(0xffffffff), fontSize: Dimens.pt12),
                  unselectedLabelStyle: TextStyle(
                      color: Color(0xffBDBDBD), fontSize: Dimens.pt12),
                  controller: state.vc,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding:
                      EdgeInsets.only(left: Dimens.pt15, right: Dimens.pt15),
                  indicator: BoxDecoration(
                      color: Color(0xff43455A),
                      borderRadius: BorderRadius.circular(Dimens.pt20))),
            ),
          ],
        ),
        Expanded(
          child: ExtendedTabBarView(
            controller: state.vc,
            children: state.pageList,
            linkWithAncestor: true,
          ),
        ),
      ],
    ),
  );
}
