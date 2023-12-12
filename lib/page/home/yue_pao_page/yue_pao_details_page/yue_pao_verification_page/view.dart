import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_app/widget/video_mange_widget.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    YuePaoVerificationState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: AppBar(
        title: Text(Lang.VERIFICATION_REPORT),
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          FlatButton(
            minWidth: Dimens.pt60,
            padding: EdgeInsets.zero,
            onPressed: () {
              dispatch(YuePaoVerificationActionCreator.onSubmit());
            },
            child: Container(
              height: Dimens.pt28,
              padding: EdgeInsets.symmetric(horizontal: Dimens.pt10),
              constraints: BoxConstraints(minWidth: Dimens.pt60),
              margin: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffF203FF), Color(0xffFF00A9)]),
                borderRadius: BorderRadius.circular(Dimens.pt14),
              ),
              child: Text(
                Lang.PUBLISH,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.pt16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppPaddings.padding16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(.2), width: .5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: state.editingController,
                cursorColor: AppColors.primaryRaised,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.pt12,
                ),
                // maxLength: 200,
                maxLines: 7,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: Lang.YUE_PAO_MSG11,
                  hintMaxLines: 5,
                  border: InputBorder.none,
                  counterText: "",
                  counterStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: Dimens.pt12),
                ),
              ),
              VideoMangeWidget(
                picList: state.localPicList,
                deleteItemCallback: (index) {
                  // dispatch(YuePaoVerificationActionCreator.onDeleteItem(index));
                },
                addItemCallback: () {
                  dispatch(YuePaoVerificationActionCreator.onSelectPic());
                },
              ),
              // 验证报告要求
              Container(
                margin: EdgeInsets.only(top: Dimens.pt40),
                width: Dimens.pt200,
                child: Text(
                  Lang.VERIFICATION_REPORT_MSG,
                  style: TextStyle(
                    fontSize: Dimens.pt16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: Dimens.pt10),
                child: Text(
                  Lang.VERIFICATION_REPORT_MSG1,
                  style: TextStyle(
                      fontSize: Dimens.pt12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.8),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
