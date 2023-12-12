import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    SearchUserState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    body: BaseRequestView(
      controller: state.baseRequestController,
      child: pullYsRefresh(
        // enablePullDown: false,
        onLoading: () {
          dispatch(SearchUserActionCreator.loadMoedData());
        },
        onRefresh: () {
          dispatch(SearchUserActionCreator.loadData());
        },
        refreshController: state.refreshController,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(10),
          itemExtent: Dimens.pt76,
          itemCount: state.searchUsers?.length ?? 0,
          itemBuilder: (context, index) {
            var item = state.searchUsers[index];
            return GestureDetector(
                onTap: () {
                  Map<String, dynamic> map = {
                    'uid': item?.uid,
                    'uniqueId': DateTime.now().toIso8601String(),
                  };
                 // JRouter().go(PAGE_VIDEO_USER_CENTER, arguments: map);
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: Dimens.pt230,
                        child: Row(
                          children: <Widget>[
                            HeaderWidget(
                              headPath: item?.portrait ?? '',
                              level: item?.vipLevel ?? 0,
                              headWidth: Dimens.pt55,
                              headHeight: Dimens.pt55,
                            ),
                            Container(
                                padding: EdgeInsets.only(left: Dimens.pt10),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: Dimens.pt18),
                                      width: Dimens.pt160,
                                      height: Dimens.pt50,
                                      child: Text(
                                        item?.name,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                        maxLines: 1,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 2),
                                      width: Dimens.pt160,
                                      child: Text(
                                          Lang.FAN_TEXT + ' ${item?.fansCount}',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  138, 138, 145, 1),
                                              fontSize: 14)),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 0),
                        height: 30,
                        width: Dimens.pt90,
                        child: RaisedButton(
                          color: item?.hasFollowed ?? false
                              ? Color.fromRGBO(58, 58, 68, 1)
                              : Color.fromRGBO(252, 48, 102, 1),
                          child: Text(
                            item?.hasFollowed == false
                                ? Lang.FOLLOW
                                : Lang.UN_FOLLOW,
                            style: TextStyle(
                                color: Colors.white, fontSize: Dimens.pt12),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3))),
                          onPressed: () {
                            dispatch(SearchUserActionCreator.followUser(index));
                          },
                        ),
                      )
                    ],
                  ),
                ));
          },
        ),
      ),
    ),
  );
}
