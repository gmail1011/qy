import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';

import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/text_util.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    FeedbackState state, Dispatch dispatch, ViewService viewService) {
  return GestureDetector(
    onTap: () {
      FocusScope.of(viewService.context).requestFocus(FocusNode());
    },
    child: FullBg(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(Lang.FEEDBACK),
            ),
            body: Container(
              margin: EdgeInsets.all(AppPaddings.appMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: AppPaddings.appMargin),
                    child: Text(
                      "问题描述（必填）：",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: AppFontSize.fontSize14),
                    ),
                  ),
                  Container(
                    width: screen.screenWidth,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    height: Dimens.pt150,
                    padding:
                        EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
                    child: TextField(
                      controller: state.editingController,
                      cursorColor: AppColors.primaryRaised,
                      style:
                          TextStyle(color: Colors.black, fontSize: Dimens.pt12),
                      maxLength: 200,
                      maxLines: null,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (text) {
                        dispatch(FeedbackActionCreator.onSubmit());
                      },
                      decoration: InputDecoration(
                        hintText: "请详细描述遇到的问题，方便我们及时为您解决。（200字以内）",
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
                    padding:
                        EdgeInsets.symmetric(vertical: AppPaddings.appMargin),
                    child: Text(
                      "反馈列表",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: AppFontSize.fontSize16),
                    ),
                  ),
                  Flexible(
                    child: pullYsRefresh(
                      refreshController: state.refreshController,
                      enablePullDown: false,
                      onLoading: () {
                        dispatch(FeedbackActionCreator.loadMoreFeedbackList());
                      },
                      child: ListView.builder(
                        padding: EdgeInsets.only(
                          bottom: screen.paddingBottom + Dimens.pt70,
                        ),
                        shrinkWrap: true,
                        itemCount: state.feedbacks?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          var item = state.feedbacks[index];
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            margin: EdgeInsets.only(top: AppPaddings.appMargin),
                            padding: EdgeInsets.all(AppPaddings.appMargin),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formatTime(index + 1) + ":",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: AppFontSize.fontSize14),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.content ?? "",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: AppFontSize.fontSize14),
                                    ),
                                    Visibility(
                                      visible: TextUtil.isNotEmpty(
                                        item.replay ?? "",
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            "官方回复：",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize:
                                                    AppFontSize.fontSize14),
                                          ),
                                          Text(
                                            item.replay ?? "",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    AppFontSize.fontSize14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: screen.paddingBottom + Dimens.pt30,
            right: AppPaddings.appMargin,
            left: AppPaddings.appMargin,
            child: Container(
              width: screen.screenWidth,
              margin: EdgeInsets.only(
                top: AppPaddings.appMargin,
              ),
              child: getLinearGradientBtn(
                Lang.SUBMIT,
                enableColors: [Color(0xFF2A72E3), Color(0xFF0057BB)],
                onTap: () {
                  dispatch(FeedbackActionCreator.onSubmit());
                },
              ),
            ),
          )
        ],
      ),
    ),
  );
}

String _formatTime(int number) {
  return "0" * (3 - number.toString().length) + number.toString();
}
