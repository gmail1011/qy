import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'state.dart';

Widget buildView(
    SectionState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    padding: EdgeInsets.only(
        left: Dimens.pt15,
        right: Dimens.pt12,
        top: Dimens.pt25,
        bottom: Dimens.pt25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(Dimens.pt9, 0, Dimens.pt9, 0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimens.pt10)),
          child: Text(
            "${state.sectionModel?.month}月",
            style: TextStyle(color: Color(0xff999999), fontSize: Dimens.pt16),
          ),
        ),
        Column(
          children: <Widget>[
            Text(
              "收入  ${state.sectionModel?.income ??= "0"}${Lang.GOLD_COIN}",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5), fontSize: Dimens.pt12),
            ),
            Text(
              "提现  ${state.sectionModel?.expenditure ??= "0"}${Lang.GOLD_COIN}",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5), fontSize: Dimens.pt12),
            ),
          ],
        ),
      ],
    ),
  );
}
