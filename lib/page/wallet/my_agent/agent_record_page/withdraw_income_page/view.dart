import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_app/model/wallet/withdraw_details_model.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    WithdrawIncomeState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    body: BaseRequestView(
      controller: state.requestController,
      child: Container(
        padding: EdgeInsets.all(AppPaddings.appMargin),
        child: pullYsRefresh(
          refreshController: state.refreshController,
          onLoading: () {
            dispatch(WithdrawIncomeActionCreator.loadMoreData());
          },
          onRefresh: () {
            dispatch(WithdrawIncomeActionCreator.loadData());
          },
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: state?.listData?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              var model = state.listData[index];
              return _genWithdrawDetail(context, model);
            },
          ),
        ),
      ),
    ),
  );
}

/// 提现明细的item
Widget _genWithdrawDetail(BuildContext context, ListBean model) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            top: Dimens.pt20,
          ),
          height: model.status == 3  ?  Dimens.pt96 : Dimens.pt80,
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
                      Lang.ORDER_NUMBER + ': ${model.id}',
                      style:
                          TextStyle(fontSize: Dimens.pt12, color: Colors.white),
                    ),
                    InkWell(
                      onTap: () {
                        ///复制分享链接到剪切板
                        Clipboard.setData(ClipboardData(text: model.id));
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
                      '${getPayType(model.payType)}--${getStatus(model.status)}',
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
                          '${((model?.money ?? 0) / 100).toStringAsFixed(1)}',
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




              model.status == 3  ?  Container(
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
                    Text(
                      '原因：' + model.statusDesc ?? " ",
                      style:
                      TextStyle(fontSize: Dimens.pt14, color: Colors.white),
                    ),
                  ],
                ),
              ) : Container(),
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
                DateTimeUtil.utc2iso(model.createdAt ?? ''),
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
