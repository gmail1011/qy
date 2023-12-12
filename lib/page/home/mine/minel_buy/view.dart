import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/common_widget/load_more_footer.dart';
import 'package:flutter_app/widget/common_widget/empty_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    MineBuyPostState state, Dispatch dispatch, ViewService viewService) {
  ListAdapter adapter = viewService.buildAdapter();
  return !state.loadComplete
      ? Container(
          child: Center(
          child: LoadingWidget(),
        ))
      : EasyRefresh.custom(
          controller: state.controller,
          topBouncing: false,
          emptyWidget:
              state.videoList.length != 0 ? null : EmptyWidget('user', 1),
          footer: LoadMoreFooter(hasNext: state.hasNext ?? false),
          onLoad: () async {
            if (state.hasNext ?? false) {
              dispatch(MineBuyPostActionCreator.onLoadData());
            }
          },
          slivers: <Widget>[
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 0.5,
                crossAxisSpacing: 0.3,
                childAspectRatio: 0.7, //子控件宽高比
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return adapter.itemBuilder(context, index);
              }, childCount: adapter.itemCount),
            ),
          ],
        );
}
