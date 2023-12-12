import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/model/wallet/withdraw_details_model.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/load_more_footer.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../../../common/manager/cs_manager.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    WithdrawDetailsState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      body: Container(
    child: EasyRefresh.custom(
      controller: state.controller,
      emptyWidget: state.model == null
          ? null
          : state.model.list.length == 0
              ? CErrorWidget(state.errorMsg)
              : null,
      header: BallPulseHeader(),
      footer: LoadMoreFooter(hasNext: state.model?.hasNext ?? false),
      onRefresh: () async {},
      onLoad: () async {
        if (state.model?.hasNext ?? false) {
          dispatch(WithdrawDetailsActionCreator.loadData());
        } else {
          state.controller.finishLoad(success: true, noMore: true);
        }
      },
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return state.type == 0
                  ? _genIncomeDetails(context, state.model?.list, index)
                  : _genWithdrawDetail(context, state.model?.list, index);
            },
            childCount: state.model?.list?.length ?? 0,
          ),
        ),
      ],
    ),
  ));
}

/// 收益明细的item
Widget _genIncomeDetails(BuildContext context, List<ListBean> list, int index) {
  ListBean lb = list[index];
  return Container(
      padding:
          EdgeInsets.symmetric(horizontal: Dimens.pt24, vertical: Dimens.pt8),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // color: Colors.red,
                    width: Dimens.pt220,
                    child: Text(
                      lb?.desc ?? "",
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: Dimens.pt14, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: Dimens.pt14),
                  Text(
                    DateTimeUtil.utc2iso(lb.createdAt ?? ''),
                    style:
                        TextStyle(fontSize: Dimens.pt12, color: Colors.white),
                  ),
                ],
              ),
              // Text(
              //   '+',
              //   style: TextStyle(fontSize: Dimens.pt12, color: Colors.white),
              // ),
              Text(
                '+ ${(lb?.actualAmount ?? .0).toStringAsFixed(1)}',
                style: TextStyle(fontSize: Dimens.pt18, color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: Dimens.pt8,
          ),
          Divider(
            color: Colors.grey,
          ),
        ],
      ));
}

/// 提现明细的item
Widget _genWithdrawDetail(
    BuildContext context, List<ListBean> list, int index) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              left: Dimens.pt16, top: Dimens.pt23, right: Dimens.pt16),
          height: Dimens.pt80,
          color: Colors.white12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    left: Dimens.pt15,
                    top: Dimens.pt13,
                    right: Dimens.pt8,
                    bottom: Dimens.pt13),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      Lang.ORDER_NUMBER + ': ${list[index].id}',
                      style:
                          TextStyle(fontSize: Dimens.pt12, color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        ///复制分享链接到剪切板
                        Clipboard.setData(ClipboardData(text: list[index].id));
                        showToast(msg: "复制成功");
                      },
                      child: Text(
                        Lang.COPY_ORDER_NUMBER,
                        style: TextStyle(
                            fontSize: Dimens.pt12, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: Dimens.pt15,
                  right: Dimens.pt8,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      '${getPayType(list[index].payType)}--${getStatus(list[index].status)}',
                      style:
                          TextStyle(fontSize: Dimens.pt14, color: Colors.white),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '+',
                          style: TextStyle(
                              fontSize: Dimens.pt12, color: Colors.white),
                        ),
                        Text(
                          '${((list[index]?.money ?? 0) / 100).toStringAsFixed(1)}',
                          style: TextStyle(
                              fontSize: Dimens.pt18, color: Colors.white),
                        ),
                        Text(
                          Lang.YUAN,
                          style: TextStyle(
                              fontSize: Dimens.pt12, color: Colors.white),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: Dimens.pt30, top: Dimens.pt8, right: Dimens.pt16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                DateTimeUtil.utc2iso(list[index].createdAt ?? ''),
                style: TextStyle(fontSize: Dimens.pt12, color: Colors.white),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: Dimens.pt70,
                  height: Dimens.pt18,
                  color: Color(0xfffc3066),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          csManager.openServices(context);
                        },
                        child: Text(
                          Lang.CONTACT_CUSTOM_SERVICE,
                          style: TextStyle(
                              fontSize: Dimens.pt12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}

///���据支��类型显示支付方式
String getPayType(String payType) {
  if (payType?.endsWith("alipay") ?? false) {
    return Lang.ALIPAY_WITHDRAW;
  } else if (payType?.endsWith("usdt") ?? false) {
    return Lang.USDT_WITHDRAW;
  } else {
    return Lang.BANKCARD_WITHDRAW;
  }
}

///支付状态
String getStatus(int status) {
  switch (status) {
    case 1:
      return "审核中";
    case 2:
      return "审核通过，转账中";
    case 3:
      return "已拒绝";
    case 4:
      return "未知错误";
    case 5:
      return "提现成功";
    case 6:
      return Lang.WITHDRAW_ERROR;
  }
  return "";
}
