import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/model/wallet/withdraw_config_data.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    WithDrawState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar(
        Lang.WITHDRAW,
        actions: <Widget>[
          FlatButton(
            child: Text(
              Lang.DETAILS,
              style: TextStyle(
                  color: Colors.white, fontSize: AppFontSize.fontSize16),
            ),
            onPressed: () {
              JRouter().go(PAGE_WITHDRAW_GAME_DETAIL);
              //JRouter().jumpPage(PAGE_AGENT_RECORD);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          child: Container(
            height: screen.screenHeight,
            margin: EdgeInsets.only(left: Dimens.pt16, right: Dimens.pt16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildBalanceUI(state),
                Row(
                  children: [
                    Container(
                      width: Dimens.pt72,
                      child: Text(
                        "提现币类：",
                        style: TextStyle(
                            color: Colors.white, fontSize: Dimens.pt14),
                      ),
                    ),
                    Text(
                      "人民币",
                      style: TextStyle(
                          color: AppColors.userTaskCenterSubTextColor,
                          fontSize: Dimens.pt12),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                //提现金额
                Row(
                  children: [
                    Container(
                      width: Dimens.pt72,
                      child: Text(
                        "提现金额：",
                        style: TextStyle(
                            color: Colors.white, fontSize: Dimens.pt14),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: Dimens.pt34,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          color: AppColors.userMakeBgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                            LengthLimitingTextInputFormatter(9),
                          ],
                          controller: state.moneyController,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimens.pt12,
                          ),
                          cursorColor: Colors.white.withOpacity(0.7),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: Dimens.pt12,
                            ),
                            hintText: "您目前最多可提现${_getPayMoneyRange(state)}元",
                          ),
                          focusNode: state.focusNode,
                          onChanged: (value) => dispatch(
                              WithDrawActionCreator.calcWithdrawAmount(value)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                //提现方式
                Row(
                  children: [
                    Container(
                      width: Dimens.pt72,
                      child: Text(
                        "提现方式：",
                        style: TextStyle(
                            color: Colors.white, fontSize: Dimens.pt14),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: (state.configData?.channels ?? []).isEmpty
                            ? Container()
                            : Container(
                                height: 50,
                                child: Row(
                                  children: state.configData?.channels
                                      ?.asMap()
                                      ?.map((index, e) => MapEntry(
                                          index,
                                          _buildPayTypeUI(
                                              e, state, dispatch, index)))
                                      ?.values
                                      ?.toList(),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                //姓名
                _getName(state),

                //提现金额
                Row(
                  children: [
                    Container(
                      width: Dimens.pt72,
                      child: Text(
                        _getActLabel(state),
                        style: TextStyle(
                            color: Colors.white, fontSize: Dimens.pt14),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: Dimens.pt34,
                        padding: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                          color: AppColors.userMakeBgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: state.accountController,
                          maxLines: 1,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: _getHintText(state),
                              hintStyle: TextStyle(
                                  fontSize: Dimens.pt12,
                                  color: Colors.white.withOpacity(0.5))),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Dimens.pt12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                _isUsdt(state) ? SizedBox(height: 16) : Container(),
                //提现金额
                _isUsdt(state)
                    ? Row(
                        children: [
                          Container(
                            width: Dimens.pt72,
                            child: Text(
                              "温馨提示：",
                              style: TextStyle(
                                  color: Colors.white, fontSize: Dimens.pt14),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "请您务必仔细核对收款地址信息后再做提交，避免给您带来不便。",
                              style: TextStyle(
                                color: AppColors.withdrawsubTextColor,
                                fontSize: Dimens.pt12,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: 16),
                //提现金额
                Row(
                  children: [
                    Container(
                      width: Dimens.pt72,
                      child: Text(
                        "手续费率：",
                        style: TextStyle(
                            color: Colors.white, fontSize: Dimens.pt14),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${state.configData?.coinTax ?? ""}% 本次提现手续：${(state.handlingFee ?? 0).toStringAsFixed(2)}  实际到账金额：${(state.actualAmount ?? 0).toStringAsFixed(2)}",
                        style: TextStyle(
                          color: AppColors.withdrawsubTextColor,
                          fontSize: Dimens.pt12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 100),

                Container(
                  alignment: Alignment.center,
                  child: commonSubmitButton("立即提现", onTap: () {
                    dispatch(WithDrawActionCreator.submitWithdraw());
                  }),
                ),

                GestureDetector(
                  onTap: () => csManager.openServices(viewService.context),
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "支付中如有问题，请在线联系 ",
                                style: TextStyle(
                                  color:
                                      AppColors.userPayTextColor.withAlpha(59),
                                  fontSize: AppFontSize.fontSize10,
                                ),
                              ),
                              TextSpan(
                                text: '联系客服',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: AppFontSize.fontSize10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            FocusScope.of(viewService.context).requestFocus(FocusNode());
          },
        ),
      ),
    ),
  );
}

///创建余额UI
Container _buildBalanceUI(WithDrawState state) {
  return Container(
    width: screen.screenWidth,
    margin: EdgeInsets.only(top: Dimens.pt16, bottom: Dimens.pt20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      textDirection: TextDirection.ltr,
      children: <Widget>[
        Container(
          width: screen.screenWidth - Dimens.pt16 * 2,
          padding: EdgeInsets.only(top: Dimens.pt13, bottom: Dimens.pt10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              svgAssets(AssetsSvg.ICON_WITHDRAW_RECTANGLE,
                  width: Dimens.pt6, height: Dimens.pt19),
              Container(
                margin: EdgeInsets.only(left: Dimens.pt15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "余额（元）",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: Dimens.pt12,
                      ),
                    ),
                    Text(
                      ((state.wallet?.income ?? 0) / 10).toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Dimens.pt32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: AppColors.userMakeBgColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    ),
  );
}

///支付类型
GestureDetector _buildPayTypeUI(
    Channel channel, WithDrawState state, Dispatch dispatch, int index) {
  return GestureDetector(
    onTap: () => dispatch(WithDrawActionCreator.changeWithdrawType(index)),
    child: Row(
      children: [
        //支付宝
        Image(
          image: AssetImage(_getPayTypeIconName(channel?.payType)),
          width: 39,
          height: 39,
        ),
        SizedBox(width: 5),
        Text(_getPayTypeName(channel?.payType, dispatch),
            style: TextStyle(color: Colors.white, fontSize: 14)),
        Radio(
          value: index,
          activeColor: Color(0xFFFF7F0F),
          focusColor: Color(0xFF4F515A),
          onChanged: (value) => {
            // print(value),
            dispatch(WithDrawActionCreator.changeWithdrawType(value))
          },
          groupValue: state.withdrawType,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    ),
  );
}

///获取支付方式名称
String _getPayTypeIconName(String payType) {
  if ("alipay" == payType) {
    return AssetsImages.ICON_ALIPAY;
  } else if ("bankcard" == payType) {
    return AssetsImages.ICON_UNION;
  } else if ("usdt" == payType) {
    return AssetsImages.ICON_USDT;
  }
  return AssetsImages.ICON_UNION;
}

///获取支付方式名称
String _getPayTypeName(String payType, Dispatch dispatch) {
  if ("alipay" == payType) {
    return "支付宝";
  } else if ("bankcard" == payType) {
    return "银行卡";
  } else if ("usdt" == payType) {
    return "USDT";
  }
  return "银行卡";
}

///获取提现金额范围
String _getPayMoneyRange(WithDrawState state) {
  try {
    int minMoney =
        state.configData?.channels[state.withdrawType]?.minMoney ?? 0;
    int maxMoney =
        state.configData?.channels[state.withdrawType]?.maxMoney ?? 0;
    return "${minMoney / 100}-${maxMoney / 100}";
  } catch (e) {}
  return "0";
}

String _getHintText(WithDrawState state) {
  int withdrawType = state?.withdrawType ?? 0;
  List<Channel> channels = state?.configData?.channels ?? [];
  if (channels.isEmpty) return "";
  if ((channels[withdrawType]?.payType ?? "") == 'alipay') {
    return '请输入支付宝账号';
  } else if ((channels[withdrawType]?.payType ?? "") == 'bankcard') {
    return '请输入银行卡号';
  } else if ((channels[withdrawType]?.payType ?? "") == 'usdt') {
    return '请输入钱包地址';
  }
  return "";
}

String _getActLabel(WithDrawState state) {
  int withdrawType = state?.withdrawType ?? 0;
  List<Channel> channels = state?.configData?.channels ?? [];
  if (channels.isEmpty) return "";
  if ((channels[withdrawType]?.payType ?? "") == 'alipay') {
    return '支付宝';
  } else if ((channels[withdrawType]?.payType ?? "") == 'bankcard') {
    return '银行卡号';
  } else if ((channels[withdrawType]?.payType ?? "") == 'usdt') {
    return '钱包地址';
  }
  return "银行卡号";
}

bool _isUsdt(WithDrawState state) {
  int withdrawType = state?.withdrawType ?? 0;
  List<Channel> channels = state?.configData?.channels ?? [];
  if (channels.isEmpty) {
    return false;
  }
  if ((channels[withdrawType]?.payType ?? "") == 'usdt') {
    return true;
  } else {
    return false;
  }
}

Widget _getName(WithDrawState state) {
  int withdrawType = state?.withdrawType ?? 0;
  List<Channel> channels = state?.configData?.channels ?? [];
  if (channels.isEmpty) {
    return Container();
  }
  if ((channels[withdrawType]?.payType ?? "") == 'usdt') {
    return Container();
  }

  return Column(
    children: [
      Row(
        children: [
          Container(
            width: Dimens.pt72,
            child: Text(
              state.withdrawType == 1 ? "开户姓名：" : "姓名：",
              style: TextStyle(color: Colors.white, fontSize: Dimens.pt14),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              height: Dimens.pt34,
              padding: EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                color: AppColors.userMakeBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                maxLines: 1,
                controller: state.nameController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: state.withdrawType == 1 ? "请输入开户姓名" : "请输入支付宝姓名",
                    hintStyle: TextStyle(
                        fontSize: Dimens.pt12,
                        color: Colors.white.withOpacity(0.5))),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.pt12,
                ),
              ),
            ),
          ),
        ],
      ),
      SizedBox(height: 16),
    ],
  );
}
