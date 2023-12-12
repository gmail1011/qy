import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/analyticsEvent.dart';
import 'package:flutter_app/weibo_page/community_recommend/community_recommend_page.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'state.dart';

Widget buildView(
    CommunityTabState state, Dispatch dispatch, ViewService viewService) {
  return state.tabController == null
      ? Container()
      : Container(
          child: Column(
            children: [
              Container(
                  alignment: Alignment.centerLeft,
                  height: Dimens.pt40,
                  color: Color(0xff1e1e1e),
                  child: commonTabBar(
                    TabBar(
                      isScrollable: true,
                      onTap:(int index){
                        try {
                          String name = state.community[index].name ?? '';
                          AnalyticsEvent.clickToCommunityTabEvent(name);
                        } catch(e){
                        }
                      },
                      controller: state.tabController,
                      tabs: state.community
                          ?.map(
                            (e) => Text(e.name,
                                style: TextStyle(fontSize: Dimens.pt16)),
                          )
                          ?.toList(),
                      labelColor: Color(0xfff68216),
                      labelStyle: TextStyle(
                          fontSize: Dimens.pt18, fontWeight: FontWeight.w500),
                      unselectedLabelColor: Color(0xff737a8b),
                      unselectedLabelStyle: TextStyle(
                          fontSize: Dimens.pt17, fontWeight: FontWeight.w300),
                      indicator: const BoxDecoration(),
                    ),
                  )),
              Expanded(
                child: TabBarView(
                  controller: state.tabController,
                  children: state.community
                      ?.map((e) =>
                          CommunityRecommendPage().buildPage({"id": e.id,"name" : e.name}))
                      ?.toList(),
                ),
              ),
            ],
          ),
        );
}
