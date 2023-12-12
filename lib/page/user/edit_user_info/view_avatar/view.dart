import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    ViewAvatarState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: AppBar(
      title: Text(''),
      //文字title居中
      centerTitle: true,
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            dispatch(ViewAvatarActionCreator.onBack());
          }),
    ),
    body: Container(
      child: GestureDetector(
        onTap: () {
          dispatch(ViewAvatarActionCreator.onBack());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ///此处添加content
            CustomNetworkImage(
              imageUrl: state.meInfo?.portrait ?? "",
              height: Dimens.pth500,
            )
          ],
        ),
      ),
    ),
  );
}
