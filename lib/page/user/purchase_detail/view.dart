import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    PurchaseDetailState state, Dispatch dispatch, ViewService viewService) {
  Widget getRow(index) {
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: Dimens.pt20, horizontal: Dimens.pt16),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: Dimens.pt328,
                height: Dimens.pt80,
                padding: EdgeInsets.fromLTRB(
                    Dimens.pt14, Dimens.pt14, Dimens.pt5, Dimens.pt13),
                color: Color(0xff3A3A44),
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          '${Lang.ORDER_NUMBER}:${state.list[index].id}',
                          style: TextStyle(
                            fontSize: Dimens.pt12,
                            color: Color(0xffffffff),
                            height: 1.5,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                              ClipboardData(text: state.list[index].id ?? ''));
                          showToast(msg: Lang.COPY_ORDER_NUMBER_SUCCESS);
                        },
                        child: Text(
                          Lang.COPY_ORDER_NUMBER,
                          style: TextStyle(
                            fontSize: Dimens.pt12,
                            color: Color(0xffffffff),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ]),
                    Expanded(
                      flex: 1,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text.rich(
                                TextSpan(children: [
                                  TextSpan(
                                    text: state.list[index].name,
                                    style: TextStyle(
                                      fontSize: Dimens.pt14,
                                      color: Color(0xffffffff),
                                      height: 1.5,
                                    ),
                                  ),
                                  TextSpan(
                                    text: Lang.BUY_PAY,
                                    style: TextStyle(
                                      fontSize: Dimens.pt14,
                                      color: Color(0xffffffff),
                                      height: 1.5,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: '- ',
                                  style: TextStyle(
                                    fontSize: Dimens.pt20,
                                    color: Color(0xffffffff),
                                    height: 1.5,
                                  ),
                                ),
                                TextSpan(
                                  text: (state.list[index].amount +
                                          state.list[index].income)
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: Dimens.pt24,
                                    color: Color(0xffffffff),
                                    height: 0.9,
                                  ),
                                ),
                                TextSpan(
                                  text: Lang.GOLD_COIN,
                                  style: TextStyle(
                                    fontSize: Dimens.pt12,
                                    color: Color(0xffffffff),
                                    height: 1.5,
                                  ),
                                ),
                              ]),
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.only(left: Dimens.pt14, top: Dimens.pt10),
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[
                      Text(
                        DateTimeUtil.utc2iso(state.list[index].updatedAt),
                        style: TextStyle(
                          fontSize: Dimens.pt12,
                          color: Color(0xffffffff),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  return FullBg(
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          Lang.PURCHASE_DETAILS,
          style: TextStyle(
            color: Color(0xffffffff),
            fontSize: Dimens.pt20,
            height: 1.45,
          ),
        ),
      ),
      body: BaseRequestView(
        retryOnTap: () {
          dispatch(PurchaseDetailActionCreator.loadData());
        },
        controller: state.baseRequestController,
        child: pullYsRefresh(
          refreshController: state.refreshController,
          enablePullDown: false,
          onLoading: () {
            dispatch(PurchaseDetailActionCreator.loadMore());
          },
          child: ListView.builder(
            itemCount: state?.list?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return getRow(index);
            },
          ),
        ),
      ),
    ),
  );
}
