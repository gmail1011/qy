import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/page/home/yue_pao_page/com/public.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/custom_picture_management.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    NakeChatReportState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar(Lang.REPORT_MSG),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioGroupNakeChat(
                onChange: (value) {
                  dispatch(YuePaoReportActionCreator.onTypeChange(value));
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: Dimens.pt16),
                padding: EdgeInsets.symmetric(horizontal: Dimens.pt10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.pt6),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: state.editingController,
                  cursorColor: AppColors.primaryRaised,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimens.pt12,
                  ),
                  // maxLength: 200,
                  maxLines: 7,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: Lang.YUE_PAO_MSG2,
                    hintMaxLines: 5,
                    border: InputBorder.none,
                    counterText: "",
                    counterStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: Dimens.pt12),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: Dimens.pt16,
                    top: Dimens.pt46,
                    left: Dimens.pt16,
                    right: Dimens.pt16),
                child: Text(
                  Lang.PHOTO,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimens.pt16,
                  ),
                ),
              ),
              PictureMangeWidget(
                picList: state.localPicList,
                deleteItemCallback: (index) =>
                    dispatch(YuePaoReportActionCreator.onDeleteItem(index)),
                addItemCallback: () =>
                    dispatch(YuePaoReportActionCreator.onSelectPic()),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
                child: Text.rich(
                  TextSpan(
                    text: '举报说明\n',
                    children: [
                      TextSpan(
                        text:
                            '\n1、每个裸聊只能举报一次，不可重复举报；\n2、举报需提供相关截图，官方核实无误，用户获全额退款；\n3、购买裸聊15'
                                '天后再举报，视为常规举报，不享受退款处理。',
                        style: TextStyle(
                          fontSize: Dimens.pt12,
                        ),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimens.pt16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {
          // 举报
          dispatch(YuePaoReportActionCreator.onReport());
        },
        child: Container(
          width: double.infinity,
          height: Dimens.pt40,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
              horizontal: Dimens.pt30, vertical: Dimens.pt20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffF203FF),
                Color(0xffFF00A9),
              ],
            ),
            borderRadius: BorderRadius.circular(Dimens.pt20),
          ),
          child: Text(
            Lang.SUBMISSION,
            style: TextStyle(
              color: Colors.white,
              fontSize: Dimens.pt18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ),
  );
}
