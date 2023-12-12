import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/wallet/mine_bill/page/action.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'state.dart';

Widget buildView(
    MineBillState state, Dispatch dispatch, ViewService viewService) {
  ListAdapter adapter = viewService.buildAdapter();
  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar(Lang.MY_BILL),
      body: Container(
        child: Stack(
          children: <Widget>[
            EasyRefresh.custom(
              enableControlFinishLoad: true,
              enableControlFinishRefresh: true,
              controller: state.refreshController,
              header: state.header,
              footer: state.footer,
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    adapter.itemBuilder,
                    childCount: adapter.itemCount,
                  ),
                ),
              ],
              onRefresh: () async {
                if (!state.isLoading) {
                  await dispatch(MineBillActionCreator.onRefreshData());
                }
              },
              onLoad: () async {
                if (!state.isLoading) {
                  await dispatch(MineBillActionCreator.onLoadData());
                }
              },
            ),
            //加载动画
            Offstage(
              offstage: state.requestComplete,
              child: Center(child: LoadingWidget()),
            ),
            //空页面
            Offstage(
              offstage: state.dataIsNormal,
              child: InkResponse(
                child: Container(
                    width: Dimens.pt360, child: CErrorWidget(state.errorMsg)),
                onTap: () {
                  state.requestComplete = false;
                  state.dataIsNormal = true;
                  dispatch(MineBillActionCreator.onRefreshData());
                },
              ),
            )
          ],
        ),
      ),
    ),
  );
}
