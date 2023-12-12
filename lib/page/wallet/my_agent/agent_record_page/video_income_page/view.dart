import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/wallet/my_agent/view/agent_view.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    VideoIncomeState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    body: Container(
      padding: EdgeInsets.all(AppPaddings.appMargin),
      child: pullYsRefresh(
        refreshController: state.refreshController,
        onLoading: () {
          dispatch(VideoIncomeActionCreator.loadMoreData());
        },
        onRefresh: () {
          dispatch(VideoIncomeActionCreator.loadData());
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    children: [
                      agentShowItemView(
                        "当月视频收益",
                        state.model?.mounthAmount ?? '0',
                        subValue: Lang.GOLD,
                      ),
                      SizedBox(
                        width: Dimens.pt100,
                      ),
                      agentShowItemView(
                        "视频总收益",
                        state.model?.totalVideoAmount ?? '0',
                        subValue: Lang.GOLD,
                      ),
                    ],
                  ),
                  agentHLine(height:1),
                  Row(
                    children: [
                      agentShowItemView(
                        "昨日视频收益",
                        state.model?.yesterdayAmount ?? '0',
                        subValue: Lang.GOLD,
                      ),
                      SizedBox(
                        width: Dimens.pt100,
                      ),
                      agentShowItemView(
                        "今日视频收益",
                        state.model?.todayTodayAmount ?? '0',
                        subValue: Lang.GOLD,
                      ),
                    ],
                  ),
                  agentHLine(),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "详情列表",
                      style:
                          TextStyle(color: Colors.white, fontSize: Dimens.pt16),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: BaseRequestView(
                controller: state.requestController,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state?.videoIncomeList?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    var model = state.videoIncomeList[index];
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  (model?.title ?? Lang.UN_KNOWN),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt14),
                                ),
                              ),
                              Text(
                                "+${model?.incomeAmount ?? "0"}" + Lang.GOLD,
                                style: TextStyle(
                                    color: Colors.white, fontSize: Dimens.pt14),
                              )
                            ],
                          ),
                          Text(
                            "收入",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: Dimens.pt12),
                          ),
                          Text(
                            DateTimeUtil.utc2iso(model?.incomeTime ?? ''),
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: Dimens.pt10),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
