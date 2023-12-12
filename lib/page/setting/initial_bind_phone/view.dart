import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/count_down_timer.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    InitialBindPhoneState state, Dispatch dispatch, ViewService viewService) {
  FocusNode blankNode = FocusNode();
  return FullBg(
    child: GestureDetector(
      onTap: () {
        FocusScope.of(viewService.context).requestFocus(blankNode);
      },
      child: Scaffold(
        appBar: getCommonAppBar(state.bindMobileTitle ?? ""),
        body: Container(
          padding: CustomEdgeInsets.only(top: 18, left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                state.bindMobileType == 2 ? "通过手机号找回" : "手机号绑定",
                style: TextStyle(
                  fontSize: AppFontSize.fontSize16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.bindMobileType == 2 ? "" : "更换绑定手机号可使用新手机号登录",
                style: TextStyle(
                  fontSize: AppFontSize.fontSize12,
                  color: AppColors.userPumpkinOrangeColor,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16),
                padding: CustomEdgeInsets.only(right: 16, left: 16),
                decoration: BoxDecoration(
                  color: AppColors.bandingPhoneBgTextColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: InkWell(
                        onTap: () => dispatch(
                            InitialBindPhoneActionCreator.showCountryCodeUI()),
                        child: Container(
                            alignment: Alignment.center,
                            width: 80,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.phoneCode ?? "+86",
                                  style: TextStyle(
                                    fontSize: Dimens.pt14,
                                    color: Colors.white,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                  size: 13,
                                ),
                              ],
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                margin:
                                    CustomEdgeInsets.only(left: 6, right: 30),
                                child: TextField(
                                  controller: state.phoneController,
                                  maxLines: 1,
                                  cursorColor: Colors.white,
                                  autocorrect: true,
                                  autofocus: true,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                        color: Color(0x80FFFFFF),
                                        fontSize: 14.0),
                                    hintText: Lang.INPUT_PHONE_NUMBER,
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (val) {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: CustomEdgeInsets.only(right: 16, left: 16),
                decoration: BoxDecoration(
                  color: AppColors.bandingPhoneBgTextColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Container(
                  padding: CustomEdgeInsets.only(right: 16, left: 16),
                  child: Row(
                    children: [
                      Text(
                        "验证码：",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5), fontSize: 14),
                      ),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: state.smsCodeController,
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Color(0x80FFFFFF), fontSize: 14.0),
                            hintText: Lang.INPUT_VERIFY_CODE,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(right: 8),
                          width: 0.3,
                          height: 20,
                          color: Colors.grey.withOpacity(0.5)),

                      ///倒计时功能
                      TimerCountDownWidget(
                        phoneController: state.phoneController,
                        onTimerStart: () {
                          dispatch(InitialBindPhoneActionCreator
                              .sendNotificationSMSCode());
                        },
                        onTimerFinish: () {},
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 56),
                alignment: Alignment.center,
                child: commonSubmitButton(
                    state.bindMobileType == 2 ? "立即找回" : "立即绑定",
                    width: screen.screenWidth, onTap: () {
                  dispatch(InitialBindPhoneActionCreator.onClickNextStep());
                }),
              ),
            ],
          ),
        ),
      ),
    ),
  );
//  return InitialBindPhoneView(state, dispatch, viewService);
}
