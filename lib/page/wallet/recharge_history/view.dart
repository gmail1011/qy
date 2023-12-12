import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/utils/date_time_util.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/error_widget.dart';
import 'package:flutter_app/widget/common_widget/load_more_footer.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import '../../../common/manager/cs_manager.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(RechargeHistoryState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
      appBar: CustomAppbar(
        title: "充值记录",
      ),
      body: Container(
        child: EasyRefresh.custom(
          emptyWidget: state.list == null
              ? null
              : state.list.length == 0
                  ? CErrorWidget(state.errorMsg)
                  : null,
          header: BallPulseHeader(),
          footer: LoadMoreFooter(),
          onRefresh: () async {},
          onLoad: () async {
            if (state.pageNumber * state.pageSize <= state.list.length) {
              state.pageNumber = state.pageNumber + 1;
              dispatch(RechargeHistoryActionCreator.requestData());
            }
          },
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 16.0, top: 22.5, right: 16.0),
                          height: Dimens.pt80,
                          color: Colors.white12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 14.7, top: 13.6, right: 8.5, bottom: 12.7),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      '${Lang.ORDER_NUMBER}：${state.list[index].id ?? ''}',
                                      style: TextStyle(fontSize: Dimens.pt12, color: Colors.white),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(text: state.list[index].id ?? ''));
                                        showToast(msg: Lang.COPY_ORDER_NUMBER_SUCCESS);
                                      },
                                      child: Text(
                                        Lang.COPY_ORDER_NUMBER,
                                        style: TextStyle(fontSize: Dimens.pt12, color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 14.7,
                                  right: 8.5,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      '${getPayType(state.list[index].rechargeType)}${getStatus(state.list[index].status)}',
                                      style: TextStyle(fontSize: Dimens.pt14, color: Colors.white),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '+',
                                          style: TextStyle(fontSize: Dimens.pt12, color: Colors.white),
                                        ),
                                        Text(
                                          '${state.list[index].amount}',
                                          style: TextStyle(fontSize: Dimens.pt18, color: Colors.white),
                                        ),
                                        Text(
                                          Lang.GOLD_COIN,
                                          style: TextStyle(fontSize: Dimens.pt12, color: Colors.white),
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
                          margin: EdgeInsets.only(left: 30.7, top: 8.5, right: 16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                DateTimeUtil.utc2iso(state.list[index].createdAt),
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
                                          style: TextStyle(fontSize: Dimens.pt12, color: Colors.white),
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
                },
                childCount: state.list == null ? 0 : state.list.length,
              ),
            ),
          ],
        ),
      ));
}

///根据支付类型显示支付方式
String getPayType(String payType) {
  if (payType.endsWith("alipay")) {
    return "支付宝充值";
  } else {
    return "银行卡充值";
  }
}

///支付状态
String getStatus(int status) {
  switch (status) {
    case 0:
      return "-等待中";
      break;
    case 1:
      return "-未支付";
      break;
    case 2:
      return "-支付失败";
      break;
    case 3:
      return "-已支付";
      break;
    case 4:
      return "-已经退款";
      break;
  }
  return "";
}
