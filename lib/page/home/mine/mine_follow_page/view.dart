import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:get/route_manager.dart' as Gets;

import 'action.dart';
import 'state.dart';

Widget buildView(
    MineFollowState state, Dispatch dispatch, ViewService viewService) {
  Widget _getChildWidget(BuildContext context, int index) {
    var data = state.list[index];
    return Container(
      padding: EdgeInsets.only(
          left: AppPaddings.appMargin, right: AppPaddings.appMargin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Map<String, dynamic> arguments = {
                'uid': data.uid ?? 0,
                'uniqueId': DateTime.now().toIso8601String(),
              };
              Gets.Get.to(() => BloggerPage(arguments), opaque: false);
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: <Widget>[
                  HeaderWidget(
                    headPath: data?.portrait,
                    headHeight: Dimens.pt68,
                    headWidth: Dimens.pt68,
                    level: (data.superUser??false) ? 1 : 0,
                  ),
                  SizedBox(width: AppPaddings.padding8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              data.name ?? "",
                              style: TextStyle(
                                fontSize: AppFontSize.fontSize14,
                                color: data.isVip && data.vipLevel > 0
                                    ? Color.fromRGBO(246, 197, 89, 1)
                                    : Colors.white,
                              ),
                            ),
                            buildHonorLevelUI(
                                hasKingIcon: data.isVip && data.vipLevel > 0,
                                honorLevelList: data?.awardsExpire),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: Dimens.pt8),
                          child: Text(
                            "粉丝：${getShowFansCountStr(data.fans ?? 0)}",
                            style: TextStyle(
                              fontSize: AppFontSize.fontSize12,
                              color: Color.fromRGBO(255, 255, 255, .5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildCommonButton(
                      data.hasFollow ? Lang.HAS_FOLLOW : Lang.FOLLOW,
                      width: Dimens.pt68,
                      height: Dimens.pt26,
                      enable: !data.hasFollow,
                      fontSize: Dimens.pt12,
                      onTap: () =>
                          dispatch(MineFollowActionCreator.onFollow(index))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar(Lang.MINE_FOLLOW),
      body: BaseRequestView(
        child: pullYsRefresh(
          refreshController: state.refreshController,
          onRefresh: () => dispatch(MineFollowActionCreator.onRefresh()),
          onLoading: () => dispatch(MineFollowActionCreator.onLoadMore()),
          child: ListView.builder(
              itemExtent: Dimens.pt84,
              itemBuilder: (BuildContext context, int index) {
                return _getChildWidget(context, index);
              },
              itemCount: state.list?.length ?? 0),
        ),
        controller: state.baseRequestController,
      ),
    ),
  );
}
