import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/page/home/yue_pao_page/com/public.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    YuePaoIndexTabViewState state, Dispatch dispatch, ViewService viewService) {
  // 楼风列表
  List<LouFengItem> louFengList = state.louFengList ?? [];
  return Container(
    margin: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
    padding: EdgeInsets.only(top: Dimens.pt10),
    child: PullRefreshView(
      onLoading: () {
        dispatch(YuePaoIndexTabViewActionCreator.loadMoreData(true));
      },
      onRefresh: () {
        dispatch(YuePaoIndexTabViewActionCreator.loadRefresh(false));
      },
      retryOnTap: () {
        dispatch(YuePaoIndexTabViewActionCreator.loadMoreData(false));
      },
      controller: state.pullController,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 0.6,
        ),
        itemCount: louFengList.length,
        itemBuilder: (context,index){
          LouFengItem item = louFengList[index];
          if (item.loufengType == 'ad') {
            return adItemBuilderView(item);
          }
          return itemBuilderView1(item,pageTitle: state.pageTitle, click: () async {
            LouFengItem louFengItem = await JRouter().go(YUE_PAO_DETAILS_PAGE, arguments: {'id': item.id,"pageTitle" : state.pageTitle,});
            if (louFengItem != null) {
              dispatch(YuePaoIndexTabViewActionCreator.onChangeItem(louFengItem));
            }
          });
        },
      ),
      /*child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          LouFengItem item = louFengList[index];
          if (item.loufengType == 'ad') {
            return adItemBuilderView(item);
          }
          return itemBuilderView(item, click: () async {
            LouFengItem louFengItem = await JRouter()
                .go(YUE_PAO_DETAILS_PAGE, arguments: {'id': item.id});
            if (louFengItem != null) {
              dispatch(
                  YuePaoIndexTabViewActionCreator.onChangeItem(louFengItem));
            }
          });
        },
        itemCount: louFengList.length,
      ),*/
    ),
  );
}
