import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/wallet/detail_page/simple_details/page.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'state.dart';

Widget buildView(
    DetailState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Lang.DETAILS,
          style: TextStyle(fontSize: Dimens.pt20, color: Colors.white),
        ),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              safePopPage();
            }),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 顶部的三个标题
            Container(
              padding: EdgeInsets.only(left: Dimens.pt8),
              child: TabBar(
                isScrollable: false,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.white,
                indicatorWeight: Dimens.pt2,
                labelStyle: TextStyle(
                  fontSize: Dimens.pt16,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: Dimens.pt16,
                  fontWeight: FontWeight.w700,
                ),
                // labelPadding: EdgeInsets.symmetric(horizontal: 6),
                tabs: <Widget>[
                  Tab(child: Text(Lang.INCOME_DETAILS)),
                  Tab(child: Text(Lang.WITHDRAW_DETAILS)),
                ],
              ),
            ),

            // Divider(height: 1, thickness: 1, color: c.cD8D8D8),
            // 底部的是那三个子页面
            Expanded(
              flex: 1,
              child: TabBarView(
                children: <Widget>[
                  WithdrawDetailsPage().buildPage({"type": 0}),
                  WithdrawDetailsPage().buildPage({"type": 1}),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
