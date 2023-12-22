import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_base/flutter_base.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    AboutAppState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: getCommonAppBar(""),
    body: SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 32, right: 32),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Image(
              image: AssetImage(AssetsImages.ICON_APP_LOGO),
              width: Dimens.pt90,
              height: Dimens.pt90,
            ),
            const SizedBox(height: 15),
            Text(
              "51乱伦",
              style: TextStyle(color: Colors.white, fontSize: Dimens.pt21),
            ),
            const SizedBox(height: 5),
            Text(
              "当前版本:${Config.innerVersion}",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5), fontSize: Dimens.pt13),
            ),
            const SizedBox(height: 9),
            Text(
              "©51乱伦 版权所有",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.85), fontSize: Dimens.pt13),
            ),
            const SizedBox(height: 38),
            Text("下载地址",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: Dimens.pt13)),
            const SizedBox(height: 4),
            _buildCopyText(
                Address.landUrl ?? "",
                () => dispatch(
                    AboutAppActionCreator.copyText(Address.landUrl ?? ""))),
            const SizedBox(height: 40),
            Text(
              "官方邮箱",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5), fontSize: Dimens.pt13),
            ),
            const SizedBox(height: 8),
            _buildCopyText(
                Address.groupEmail ?? "",
                () => dispatch(
                    AboutAppActionCreator.copyText(Address.groupEmail ?? ""))),
            const SizedBox(height: 48),
            Text(
              "商务合作",
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5), fontSize: Dimens.pt13),
            ),
            const SizedBox(height: 8),
            _buildCopyText(
                Address.businessCooperation ?? "",
                () => dispatch(AboutAppActionCreator.copyText(
                    Address.businessCooperation ?? ""))),
          ],
        ),
      ),
    ),
  );
}

///可点击控件
InkWell _buildCopyText(String content, Function onTap) => InkWell(
      onTap: onTap,
      child: Text(
        content ?? "",
        softWrap: true,
        style: TextStyle(
            color: Colors.white.withOpacity(0.85), fontSize: Dimens.pt13),
      ),
    );
