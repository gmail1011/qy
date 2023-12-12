import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/model/tag/hot_tag_model.dart';
import 'package:flutter_app/model/video_model.dart';
import 'package:flutter_app/page/anwang_trade/widget/TradeCellWidget.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/search/search_view/search_appbar.dart';
import 'package:flutter_app/page/user/video_user_center/page.dart';
import 'package:flutter_app/page/video/VideoPage.dart';
import 'package:flutter_app/page/video/sub_play_list/page.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/video_play_config.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/round_under_line_tab_indicator.dart';
import 'package:flutter_app/widget/time_helper.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/player/player_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/route_manager.dart' as Gets;
import 'action.dart';
import 'state.dart';

Widget buildView(SearchState state, Dispatch dispatch, ViewService viewService) {
  double width = (screen.screenWidth - 10 * 3 - 46) / 4;
  double height = width * (32 / 88);
  return GestureDetector(
    onTap: () {
      FocusScope.of(viewService.context).requestFocus(FocusNode());
    },
    child: FullBg(
      child: Scaffold(
        appBar: SearchAppBar(
          controller: state.textEditingController,
          showPopBtn: true,
          autofocus: false,
          isSearchBtn: true,
          onSubmitted: (text) {
            dispatch(SearchActionCreator.onSubmitted(text));
          },
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // 返回一个 Sliver 数组给外部可滚动组件。
            return <Widget>[
              SliverStickyHeader(
                  sticky: false,
                  header: Material(
                    color: AppColors.weiboBackgroundColor,
                    child: Container(
                      margin: EdgeInsets.only(
                        left: AppPaddings.appMargin,
                        right: AppPaddings.appMargin,
                        bottom: AppPaddings.appMargin,
                      ),
                      child: Column(
                        children: [
                          Visibility(
                            visible: (state.searchHistorys?.length ?? 0) != 0,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "搜索记录",
                                        style: TextStyle(
                                          color: Color.fromRGBO(255, 255, 255, 1),
                                          fontSize: Dimens.pt14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(6, 3, 0, 3),
                                          child: Text(
                                            "清除记录",
                                            style: TextStyle(
                                              color: AppColors.primaryTextColor,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          dispatch(SearchActionCreator.deleteAll());
                                        },
                                      )
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 0, top: 10),
                                    child: Wrap(
                                        spacing: 0.0,
                                        direction: Axis.horizontal,
                                        runSpacing: 10.0,
                                        alignment: WrapAlignment.start,
                                        children: (state?.searchHistorys ?? []).map((item) {
                                          return GestureDetector(
                                            onTap: () {
                                              dispatch(SearchActionCreator.onSubmitted(item));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(left: 12, top: 5, bottom: 5),
                                              margin: EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Color.fromRGBO(31, 32, 49, 1),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    item ?? '',
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Container(
                                                    height: 12,
                                                    width: 1,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 8),
                                                  InkWell(
                                                    child: Container(
                                                        padding: EdgeInsets.only(right: 11),
                                                        child: Icon(
                                                          Icons.clear,
                                                          color: Colors.white,
                                                          size: 16,
                                                        )),
                                                    onTap: () {
                                                      dispatch(
                                                        SearchActionCreator.delete(state?.searchHistorys?.indexOf(item)),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList()),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          (state.adsList == null || state.adsList.length == 0)
                              ? SizedBox()
                              : AdsBannerWidget(
                                  state.adsList,
                                  width: screen.screenWidth - 10 * 2,
                                  height: (screen.screenWidth - 10 * 2) * (200 / 720),
                                  onItemClick: (index) {
                                    var ad = state.adsList[index];
                                    JRouter().handleAdsInfo(ad.href, id: ad.id);
                                  },
                                ),
                        ],
                      ),
                    ),
                  )),
            ];
          },
          body: BaseRequestView(
              controller: state.baseRequestController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      "热搜总榜",
                      style: TextStyle(color: AppColors.primaryTextColor, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (state.hotList == null || state.hotList == null) ? 0 : state.hotList.length,
                      itemBuilder: (context, index) {
                        HotTagItem hotTagItem = state.hotList[index];
                        int number = index + 1;
                        return GestureDetector(
                          onTap: () {
                            dispatch(SearchActionCreator.onSubmitted(hotTagItem.name));
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      gradient: LinearGradient(
                                          colors: number == 1
                                              ? [
                                                  Color.fromRGBO(255, 179, 66, 1),
                                                  Color.fromRGBO(255, 100, 66, 1),
                                                  Color.fromRGBO(255, 179, 66, 1),
                                                ]
                                              : number == 2
                                                  ? [
                                                      Color.fromRGBO(132, 239, 213, 1),
                                                      Color.fromRGBO(132, 207, 239, 1),
                                                    ]
                                                  : number == 3
                                                      ? [
                                                          Color.fromRGBO(179, 248, 112, 1),
                                                          Color.fromRGBO(104, 215, 87, 1),
                                                        ]
                                                      : [
                                                          Color.fromRGBO(126, 125, 138, 1),
                                                          Color.fromRGBO(155, 157, 165, 1),
                                                        ])),
                                  child: Text(
                                    "${number}",
                                    style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 13,),
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text("${hotTagItem.name}", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 12)),
                                Expanded(child: SizedBox()),
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/weibo/icon_tag_hot.png",
                                      width: 10,
                                      height: 12,
                                    ),
                                    SizedBox(width: 2),
                                    Text("${hotTagItem.hotDesc}", style: TextStyle(color: Color.fromRGBO(215, 106, 67, 1), fontSize: 12)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              )),
        ),
      ),
    ),
  );
}

_searchHistoryItem(String title, VoidCallback deleteClick) {
  return Container(
    color: Colors.transparent,
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.access_time,
              color: Colors.white,
              size: 13,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              title ?? '',
              style: TextStyle(color: Colors.white, fontSize: Dimens.pt12),
            )
          ],
        ),
        GestureDetector(
          child: Container(
              child: Icon(
            Icons.clear,
            color: Color(0xff999999),
            size: 16,
          )),
          onTap: deleteClick,
        )
      ],
    ),
  );
}

_searchHistoryItemHjll(
  String title,
  double containerWidth,
  double containerHeight,
  VoidCallback deleteClick,
) {
  return Container(
    color: Colors.transparent,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(color: Color.fromRGBO(172, 186, 191, 1), fontSize: 14),
        ),
        GestureDetector(
          child: Container(
              child: Icon(
            Icons.clear,
            color: Color(0xff999999),
            size: 16,
          )),
          onTap: deleteClick,
        )
      ],
    ),
  );
}
