import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/model/message/fans_model.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:get/route_manager.dart' as Gets;

import 'action.dart';
import 'state.dart';

Widget buildView(FansState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar(Lang.FAN_ONE),
      body: BaseRequestView(
        retryOnTap: () => dispatch(FansActionCreator.refreshData()),
        controller: state.requestController,
        child: pullYsRefresh(
          refreshController: state.refreshController,
          onRefresh: () => dispatch(FansActionCreator.refreshData()),
          onLoading: () => dispatch(FansActionCreator.loadMoreData()),
          child: ListView.builder(
              itemExtent: Dimens.pt84,
              itemBuilder: (BuildContext context, int index) {
                return _buildFansItemUI(state, dispatch, index);
              },
              itemCount: state.fansList?.length ?? 0),
        ),
      ),
    ),
  );
}

///创建fans item
GestureDetector _buildFansItemUI(
    FansState state, Dispatch dispatch, int index) {
  FansModel _fansModel = state.fansList[index];
  return GestureDetector(
    onTap: () {
      if (_fansModel?.uid == null) {
        return;
      }
      Map<String, dynamic> arguments = {
        'uid': _fansModel?.uid ?? 0,
        'uniqueId': DateTime.now().toIso8601String(),
      };
      Gets.Get.to(() => BloggerPage(arguments), opaque: false);
    },
    child: _getFansLineItem(state, dispatch, index),
  );
}

Widget _getFansLineItem(FansState state, Dispatch dispatch, int index) {
  FansModel _fansModel = state.fansList[index];
  return Container(
    color: Colors.transparent,
    padding: CustomEdgeInsets.only(left: 16, right: 16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            HeaderWidget(
              headPath: _fansModel.portrait ?? '',
              headHeight: Dimens.pt68,
              headWidth: Dimens.pt68,
              level: (_fansModel.superUser??false)? 1 : 0,
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: Dimens.pt11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fansModel.name ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimens.pt14,
                          ),
                        ),
                        buildHonorLevelUI(
                            hasKingIcon:
                                _fansModel.isVip && _fansModel.vipLevel > 0,
                            honorLevelList: _fansModel?.awardsExpire),
                      ],
                    ),
                    Container(
                      width: Dimens.pt150,
                      margin: EdgeInsets.only(top: Dimens.pt8),
                      child: Text(
                        "粉丝：${getShowFansCountStr(_fansModel.fans ?? 0)}",
                        style: TextStyle(
                          color: Color(0xff4e586e),
                          fontSize: Dimens.pt12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            buildCommonButton(
                _fansModel.hasFollow ? Lang.HAS_FOLLOW : Lang.FOLLOW,
                width: Dimens.pt68,
                height: Dimens.pt26,
                fontSize: Dimens.pt12,
                enable: !_fansModel.hasFollow, onTap: () {
              _fansModel.hasFollow = !_fansModel.hasFollow;
              dispatch(FansActionCreator.refreshUI());
              Map<String, dynamic> map = {
                'followUID': _fansModel.uid,
                'isFollow': _fansModel.hasFollow,
              };
              dispatch(FansActionCreator.followUser(map));
            }),
          ],
        ),
      ],
    ),
  );
}
