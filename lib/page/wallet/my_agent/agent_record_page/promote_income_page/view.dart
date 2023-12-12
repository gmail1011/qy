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
    PromoteIncomeState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    body: Container(
      padding: EdgeInsets.all(AppPaddings.appMargin),
      child: pullYsRefresh(
        refreshController: state.refreshController,
        onLoading: () {
          dispatch(PromoteIncomeActionCreator.loadMoreData());
        },
        onRefresh: () {
          dispatch(PromoteIncomeActionCreator.loadData());
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Row(
                    children: [
                      agentShowItemView(
                          "总推广人数", (state.model?.totalInvites ?? 0).toString()),
                      SizedBox(
                        width: Dimens.pt100,
                      ),
                      agentShowItemView("总推广收益",
                          (state.model?.totalInviteAmount ?? 0).toString(),
                          subValue: Lang.GOLD),
                    ],
                  ),
                  agentHLine(height:1),
                  Row(
                    children: [
                      agentShowItemView("今日推广人数",
                          (state.model?.todayInvites ?? 0).toString()),
                      SizedBox(
                        width: Dimens.pt100,
                      ),
                      agentShowItemView("今日推广收益",
                          (state.model?.todayInviteAmount ?? 0).toString(),
                          subValue: Lang.GOLD),
                    ],
                  ),
                  // agentHLine(1),
                  // Row(
                  //   children: [
                  //     agentShowItemView("昨日推广人数", "0"),
                  //     SizedBox(
                  //       width: Dimens.pt100,
                  //     ),
                  //     agentShowItemView("昨日推广收益", "0", Lang.YUAN),
                  //   ],
                  // ),
                  // agentHLine(1),
                  // Row(
                  //   children: [
                  //     agentShowItemView("当月推广人数", "0"),
                  //     SizedBox(
                  //       width: Dimens.pt100,
                  //     ),
                  //     agentShowItemView("当月推广收益", "0", Lang.YUAN),
                  //   ],
                  // ),
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
                  itemCount: state?.inviteIncomeList?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    var model = state.inviteIncomeList[index];
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
                                  model?.userName ?? Lang.UN_KNOWN,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimens.pt14),
                                ),
                              ),
                              Text(
                                "+${model?.incomeAmount ?? 0}" + Lang.GOLD,
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
                            DateTimeUtil.utc2iso(model?.rechargeAt ?? ''),
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
