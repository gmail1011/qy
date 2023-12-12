import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/model/wallet/withdraw_details_model.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/load_more_footer.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

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
                  : _genWithdrawDetail(
                      context, dispatch, state.model?.list, index);
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
                '+ ${((lb.actualAmount / 100) ?? .0).toStringAsFixed(1)}',
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
    BuildContext context, Dispatch dispatch, List<ListBean> list, int index) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
              left: Dimens.pt16, top: Dimens.pt23, right: Dimens.pt16),
          height: Dimens.pt76,
          // color: Colors.white12,
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
                      child: Container(
                        alignment: Alignment.center,
                        width: Dimens.pt40,
                        height: Dimens.pt18,
                        color: Color(0xff464545),
                        child: Text(
                          '复制',
                          style: TextStyle(
                              fontSize: Dimens.pt12, color: Colors.white),
                        ),
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
                        // Text(
                        //   '+',
                        //   style: TextStyle(
                        //       fontSize: Dimens.pt12, color: Colors.white),
                        // ),
                        Text(
                          '${((list[index].money / 100 ?? 0)).toStringAsFixed(1) + Lang.YUAN}',
                          style: TextStyle(
                              fontSize: Dimens.pt18, color: Color(0xFFf6d85d)),
                        ),
                        // Text(
                        //   Lang.YUAN,
                        //   style: TextStyle(
                        //       fontSize: Dimens.pt12, color: Color(0xFFf6d85d)),
                        // )
                      ],
                    )
                  ],
                ),
              ),
              list[index].status == 3
                  ? Container(
                      margin: EdgeInsets.only(
                        left: Dimens.pt15,
                        right: Dimens.pt8,
                        top: Dimens.pt6,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          // Text(
                          //   '原因：' + list[index].statusDesc ?? " ",
                          //   style:
                          //   TextStyle(fontSize: Dimens.pt14, color: Colors.white),
                          // ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              left: Dimens.pt30, top: Dimens.pt8, right: Dimens.pt16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                DateTimeUtil.utc2iso(list[index].createdAt ?? ''),
                style: TextStyle(fontSize: Dimens.pt12, color: Colors.white),
              ),
              (list[index].statusDesc == "" || list[index].statusDesc == null)
                  ? Container()
                  : InkWell(
                      onTap: () {},
                      child: Container(
                        width: Dimens.pt62,
                        height: Dimens.pt24,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFff7f0f),
                              Color(0xFFe38825),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                showConfirm(
                                  context,
                                  title: "提现结果",
                                  content: "尊敬的用户：${list[index].statusDesc}",
                                  showCancelBtn: false,
                                  // alignment: Alignment.centerLeft,
                                );
                                // lightKV.setBool(Config.HAVE_SAVE_QR_CODE, true);
                                // csManager.openServices(context);
                              },
                              child: Text(
                                '查看原因',
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
        ),
        SizedBox(
          height: Dimens.pt20,
        ),
        Container(
          color: Colors.white.withOpacity(0.1),
          width: screen.screenWidth,
          height: Dimens.pt2,
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
