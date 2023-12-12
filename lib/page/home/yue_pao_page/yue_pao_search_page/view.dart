import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/page/home/yue_pao_page/com/public.dart';
import 'package:flutter_app/page/search/search_view/search_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    YuePaoSearchState state, Dispatch dispatch, ViewService viewService) {
  // 楼风列表
  List<LouFengItem> louFengList = state.louFengList ?? [];
  return GestureDetector(
    onTap: () {
      FocusScope.of(viewService.context).requestFocus(FocusNode());
    },
    child: FullBg(
      child: Scaffold(
        appBar: SearchAppBar(
          controller: state.textEditingController,
          isSearchBtn: true,
          autofocus: false,
          onSubmitted: (text) {
            dispatch(YuePaoSearchActionCreator.onSubmitted());
          },
        ),
        body: Container(
          margin: EdgeInsets.only(top: Dimens.pt16),
          padding: EdgeInsets.symmetric(horizontal: Dimens.pt16),
          child: BaseRequestView(
            controller: state.baseRequestController,
            child: pullYsRefresh(
              enablePullDown: false,
              refreshController: state.refreshController,
              onLoading: () {
                dispatch(YuePaoSearchActionCreator.loadMoedData());
              },
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return itemBuilderView(louFengList[index], click: () async {
                    LouFengItem louFengItem = await JRouter().go(
                        YUE_PAO_DETAILS_PAGE,
                        arguments: {'id': louFengList[index].id});
                    if(louFengItem!=null){
                      dispatch(YuePaoSearchActionCreator.onChangeItem(louFengItem));
                    }
                  });
                },
                itemCount: louFengList.length,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
