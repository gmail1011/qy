import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    EditSummaryState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar(
        "修改简介",
        actions: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => dispatch(EditSummaryActionCreator.editSummary()),
            child: Image(
                image: AssetImage(AssetsImages.ICON_PERSON_SAVE_BTN),
                width: Dimens.pt80,
                height: Dimens.pt32),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "我的简介",
              style: TextStyle(fontSize: Dimens.pt17, color: Colors.white),
            ),
            //输入文本
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
              color: AppColors.userMakeBgColor,
              child: TextField(
                controller: state.editingController,
                cursorColor: Colors.white.withOpacity(0.3),
                style: TextStyle(
                  wordSpacing: 1.5,
                  height: 1.5,
                  color: Colors.white,
                  fontSize: Dimens.pt16,
                ),
                maxLength: 100,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "你可以填写兴趣爱好，心情愿望，有趣的介绍能让被关注的概率高哦",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: Dimens.pt16,
                  ),
                  counterStyle: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: Dimens.pt16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}
