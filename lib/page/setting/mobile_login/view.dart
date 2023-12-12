import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/setting/mobile_login/action.dart';
import 'package:flutter_app/page/setting/mobile_login/get_code.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_app/widget/custom_phone_inputview.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'state.dart';

///手机号登录UI
Widget buildView(
    MobileLoginState state, Dispatch dispatch, ViewService viewService) {
  FocusNode blankNode = FocusNode();
  return GestureDetector(
    onTap: () {
      FocusScope.of(viewService.context).requestFocus(blankNode);
    },
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: CustomEdgeInsets.only(top: 35),
              child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => safePopPage()),
            ),
            Container(
              margin: const EdgeInsets.only(left: 35),
              child: Text("欢迎登录",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimens.pt34,
                      fontWeight: FontWeight.w500)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 35),
              child: Text("手机号登录/注册",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: Dimens.pt17,
                      fontWeight: FontWeight.w500)),
            ),
            Container(
              margin: CustomEdgeInsets.only(top: 53, right: 16, left: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.pt22),
                color: Color(0xff1f1f1f),
              ),
              child: Container(
                margin: CustomEdgeInsets.only(left: 32, right: 14),
                child: Row(
                  children: <Widget>[
                    Text(
                      "手机号",
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: Dimens.pt14),
                    ),

                    Container(
                      width: 50,
                      padding: EdgeInsets.only(left: 8, bottom: 0.0),
                      child: CustomPhoneInputView(
                        lineBottomMargin: 10,
                        phoneCode: state.areaCode ?? '86',
                        onChanged: (String text) {
                          ///手机区号
                          state.areaCode = text;
                        },
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Container(
                        margin: CustomEdgeInsets.only(left: 8, right: 30),
                        child: TextField(
                          cursorColor: Colors.white.withOpacity(0.7),
                          controller: state.phoneController,
                          maxLines: 1,
                          autocorrect: true,
                          autofocus: state.phoneController.text == null ||
                              state.phoneController.text.isEmpty,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Color(0x80FFFFFF), fontSize: 14.0),
                            hintText: Lang.INPUT_PHONE_NUMBER,
                            border: InputBorder.none,
                          ),
                          onChanged: (val) {
                            if (val.length > 11) {
                              var phone = val.substring(0, 11);
                              state.phoneController.setTextAndPosition(phone,
                                  caretPosition: phone.length);
                            }
                          },
                          onSubmitted: (val) {},
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     state.phoneController.setTextAndPosition('');
                    //   },
                    //   child: svgAssets(AssetsSvg.IC_CLEAN,
                    //       width: Dimens.pt22, height: Dimens.pt22),
                    // ),
                  ],
                ),
              ),
            ),
            Container(
              margin: CustomEdgeInsets.only(top: 20, right: 16, left: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.pt22),
                color: Color(0xff1f1f1f),
              ),
              child: Container(
                margin: CustomEdgeInsets.only(left: 32, right: 14),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: CustomEdgeInsets.only(left: 4, right: 4),
                      child: Text(
                        "验证码",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: Dimens.pt14),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: CustomEdgeInsets.only(left: 0, right: 30),
                        child: TextField(
                          cursorColor: Colors.white.withOpacity(0.7),
                          controller: state.smsCodeController,
                          maxLines: 1,
                          autofocus: state.phoneController.text != null &&
                              state.phoneController.text.isNotEmpty,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: Dimens.pt14,
                              color: Colors.white.withOpacity(0.7)),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14.0),
                            hintText: Lang.INPUT_VERIFY_CODE,
                            border: InputBorder.none,
                          ),
                          onChanged: (val) {
                            if (val.length > 6) {
                              var code = val.substring(0, 6);
                              state.smsCodeController.setTextAndPosition(code,
                                  caretPosition: code.length);
                            }
                          },
                          onSubmitted: (val) {},
                        ),
                      ),
                    ),

                    ///验证码组件
                    GetCodeBtnWidget(state, dispatch),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: Dimens.pt44,
                    margin: CustomEdgeInsets.only(
                        left: 16, right: 16, top: 40, bottom: 21),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xffff7f0f), Color(0xffe38825)]),
                      borderRadius: BorderRadius.circular(Dimens.pt20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 4.0),
                      ],
                    ),
                    child: InkWell(
                      onTap: () {
                        dispatch(MobileLoginActionCreator.phoneLogin());
                      },
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              Dimens.pt20, Dimens.pt9, Dimens.pt20, Dimens.pt9),
                          color: Colors.transparent,
                          child: Text(
                            Lang.CONFIRM_LOGIN,
                            style: TextStyle(
                                fontSize: 14, color: Color(0xffffffff)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
    ),
  );
//  return MobileLoginView(state, dispatch, viewService);
}
