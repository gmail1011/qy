import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';

import 'action.dart';
import 'state.dart';

///绑定手机号成功UI
Widget buildView(BindingPhoneSuccessState state, Dispatch dispatch,
    ViewService viewService) {
  return FullBg(
      child: Scaffold(
    appBar: getCommonAppBar("更换手机号"),
    body: Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Image(
            image: AssetImage(AssetsImages.IC_BINDING_PHONE_SUCCESS),
            width: 63,
            height: 63,
          ),
          const SizedBox(height: 39),
          Text(
            state.newPhoneNum ?? "",
            style: TextStyle(color: Colors.white, fontSize: Dimens.pt17),
          ),
          const SizedBox(height: 14),
          Text(
            "换绑成功，点击返回到主页",
            style: TextStyle(
                color: Colors.white.withOpacity(0.8), fontSize: Dimens.pt16),
          ),
        ],
      ),
    ),
  ));
}
