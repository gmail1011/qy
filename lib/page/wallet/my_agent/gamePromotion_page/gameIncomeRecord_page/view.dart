import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/wallet/my_agent/view/agent_view.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    GameIncomeRecordState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
      child: Scaffold(
    appBar: AppBar(
      title: Text("收益明细"),
    ),
    body: Container(
      padding: EdgeInsets.all(AppPaddings.appMargin),
      child: pullYsRefresh(
        refreshController: state.refreshController,
        onLoading: () {
          dispatch(GameIncomeRecordActionCreator.loadMoreData());
        },
        onRefresh: () {
          dispatch(GameIncomeRecordActionCreator.onLoadData());
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    children: [
                      agentShowItemView("总推广人数",
                          "${state.gamePromotionData?.totalInvites ?? 0}"),
                      SizedBox(
                        width: Dimens.pt100,
                      ),
                      agentShowItemView("总推广收益",
                          "${state.userIncomeModel?.totalIncomeAmount ?? 0}",
                          subValue: Lang.GOLD),
                    ],
                  ),
                  agentHLine(height: 1),
                  Padding(
                    padding: EdgeInsets.only(left: Dimens.pt20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text("今日推广人数",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimens.pt12)),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                                "${state.gamePromotionData?.todayInvites ?? 0}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: Dimens.pt12))
                          ],
                        )
                      ],
                    ),
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
                  itemCount: state.dataList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
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
                                  state.dataList[index].desc ?? Lang.UN_KNOWN,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt14),
                                ),
                              ),
                              Text(
                                "+${state.dataList[index].incomeAmount ?? 0}" +
                                    Lang.GOLD,
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
                            DateTimeUtil.utc2iso(
                                state.dataList[index].setDate ?? ''),
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
  ));
}
