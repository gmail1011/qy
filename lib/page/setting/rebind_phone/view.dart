import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/setting/rebind_phone/get_code_widget.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_app/widget/custom_phone_inputview.dart';
import 'package:flutter_base/utils/navigator_util.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    RebindPhoneState state, Dispatch dispatch, ViewService viewService) {
  FocusNode blankNode = FocusNode();
  return GestureDetector(
    onTap: () {
      FocusScope.of(viewService.context).requestFocus(blankNode);
    },
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          ImageLoader.withP(ImageType.IMAGE_SVG,
                  address: AssetsSvg.LOGIN_BG,
                  width: double.infinity,
                  height: double.infinity)
              .load(),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            Container(
              margin: CustomEdgeInsets.only(top: 52),
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    safePopPage();
                  }),
            ),
            Container(
              margin: CustomEdgeInsets.only(top: 200, right: 16, left: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.pt40),
                color: Color(0x34ffffff),
              ),
              child: Container(
                margin: CustomEdgeInsets.only(left: 32, right: 14),
                child: Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        svgAssets(
                          AssetsSvg.IC_MOBILE,
                          width: Dimens.pt20,
                          height: Dimens.pt22,
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 9,
                          child: Container(
                            margin: CustomEdgeInsets.only(left: 18, right: 30),
                            child: TextField(
                              controller: state.phoneController,
                              maxLines: 1,
                              autocorrect: true,
                              autofocus: true,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                              decoration: InputDecoration(
                                hintStyle: TextStyle(
                                    color: Color(0x80FFFFFF), fontSize: 14.0),
                                hintText: Lang.INPUT_PHONE_NUMBER,
                                border: InputBorder.none,
                              ),
                              onChanged: (val) {
                                if (val.length > 11) {
                                  var phone = val.substring(0, 11);
                                  state.phoneController.setTextAndPosition(
                                      phone,
                                      caretPosition: phone.length);
                                }
                              },
                              onSubmitted: (val) {},
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            state.phoneController.setTextAndPosition('');
                            dispatch(RebindPhoneActionCreator.onRefreshState());
                          },
                          child: svgAssets(AssetsSvg.IC_CLEAN,
                              width: Dimens.pt22, height: Dimens.pt22),
                        ),
                      ],
                    ),
                    Positioned(
                      left: Dimens.pt22,
                      bottom: 0,
                      child: Container(
                        width: 60,
                        padding: EdgeInsets.only(left: 8, bottom: 0.0),
                        child: CustomPhoneInputView(
                          phoneCode: state.phoneCode ?? "86",
                          lineBottomMargin: 10,
                          onChanged: (String text) {
                            ///手机区号
                            state.phoneCode = text;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: CustomEdgeInsets.only(top: 20, right: 16, left: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimens.pt40),
                color: Color(0x34ffffff),
              ),
              child: Container(
                margin: CustomEdgeInsets.only(left: 32, right: 14),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: CustomEdgeInsets.only(left: 4, right: 4),
                      child: svgAssets(AssetsSvg.IC_VERIFY_CODE),
                    ),
                    Expanded(
                      child: Container(
                        margin: CustomEdgeInsets.only(left: 18, right: 30),
                        child: TextField(
                          controller: state.smsCodeController,
                          maxLines: 1,
                          autocorrect: true,
                          autofocus: false,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: Dimens.pt16, color: Colors.white),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Color(0x80FFFFFF), fontSize: 14.0),
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
                    Container(
                      margin: CustomEdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.pt11),
                          border: Border.all(
                              color: Color(0xffffffff), width: Dimens.pt1)),
                      child: GetCodeBtn(state, dispatch),
                    ),
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
                    margin: CustomEdgeInsets.only(
                        left: 16, right: 16, top: 46, bottom: 21),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.red, Colors.orange[700]]),
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
                        eagleClick(state.selfId(),sourceId:state.eagleId(viewService.context),label: "立即绑定");
                        dispatch(RebindPhoneActionCreator.onRebindPhone());
                      },
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              Dimens.pt20, Dimens.pt9, Dimens.pt20, Dimens.pt9),
                          color: Colors.transparent,
                          child: Text(
                            Lang.CONFIRM_REBIND,
                            style: TextStyle(
                                fontSize: 20, color: Color(0xffffffff)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    Lang.RECORDER_YOUR_LIFE,
                    style: TextStyle(
                        color: Color(0xff63E6F3), fontSize: Dimens.pt12),
                  ),
                ),
              ],
            ),
          ]),
        ],
      ),
    ),
  );
}
