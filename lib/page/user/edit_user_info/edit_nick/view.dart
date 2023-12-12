import 'dart:ui';

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(EditNickNameState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
      child: Scaffold(
    appBar: getCommonAppBar("修改昵称", actions: [
      InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => dispatch(EditNickNameActionCreator.editNickName()),
        child: Container(
          height: 28,
          width: 58,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              colors: [
                Color(0xffca452e),
                Color(0xffca452e),
              ],
            ),
          ),
          child: Text(
            "保存",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ),
      ),
      //
    ]),
    body: Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "你的昵称",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            height: 50,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                TextField(
                  cursorColor: Colors.white.withOpacity(0.7),
                  controller: state.nickController,
                  maxLines: 1,
                  autocorrect: true,
                  autofocus: state.nickController.text == null || state.nickController.text.isEmpty,
                  keyboardType: TextInputType.text,
                  inputFormatters: [LengthLimitingTextInputFormatter(9)],
                  maxLength: 9,
                  style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9)),
                  decoration: InputDecoration(
                    hintText: "输入新的昵称",
                    hintStyle: TextStyle(color: Color(0xff999999), fontSize: 14),
                    // border: InputBorder.none,
                    counterStyle: TextStyle(
                      color: AppColors.publishTextColor,
                      fontSize: Dimens.pt12,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: Dimens.pt16,
                  child: GestureDetector(
                    onTap: () {
                      state.nickController?.clear();
                    },
                    child: Image(
                      image: AssetImage(AssetsImages.ICON_NICK_DEL),
                      width: Dimens.pt22,
                      height: Dimens.pt22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            "昵称30天内可修改4次",
            style: TextStyle(
              fontSize: 12,
              color:  Colors.white, //Color(0xff999999),
            ),
          ),
        ],
      ),
    ),
  ));
}
