import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/common_widget/load_more_footer.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_app/widget/common_widget/empty_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(MineWorkState state, Dispatch dispatch, ViewService viewService) {
  ListAdapter adapter = viewService.buildAdapter();

  return Container(
    padding: EdgeInsets.only(bottom: screen.paddingBottom),
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          child: Visibility(visible: state.isLoading, child: LoadingWidget()),
        ),
        EasyRefresh(
          controller: state.workController,
          topBouncing: false,
          bottomBouncing: false,
          footer: LoadMoreFooter(hasNext: state.workVideo?.hasNext ?? false),
          onLoad: () async {
            if (state.workVideo?.hasNext ?? false) {
              await dispatch(MineWorkActionCreator.onLoadWork());
            }
          },
          child: (state.workVideo?.list?.length ?? 0) > 0 || state.isLoading
              ? _mineDataView(adapter, state)
              : EmptyWidget('mine', 0),
        ),
      ],
    ),
  );
}

Widget _mineDataView(ListAdapter adapter, MineWorkState state) {
  return state.pageType == MineWorkPageType.DYNAMIC_PAGE
      ? ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: adapter.itemBuilder,
          itemCount: adapter.itemCount,
        )
      : GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 0.5,
            crossAxisSpacing: 0.3,
            childAspectRatio: 0.7,
          ),
          itemCount: adapter.itemCount,
          itemBuilder: adapter.itemBuilder,
        );
}
