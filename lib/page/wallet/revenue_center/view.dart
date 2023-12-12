import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';
import 'state.dart';

///收益中心
Widget buildView(
    RevenueCenterState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: getCommonAppBar("收益", actions: [
      InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          JRouter().go(PAGE_WITHDRAW);
        },
        child: Image(
            image: AssetImage(AssetsImages.ICON_REVENUE_SUMIT),
            width: Dimens.pt80,
            height: Dimens.pt32),
      ),
      SizedBox(width: Dimens.pt15),
    ]),
    body: FullBg(
      child: Container(
          child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return _createRevenueItem();
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    height: 1,
                    color: Color(0xff272727));
              },
              itemCount: 30)),
    ),
    // BaseRequestView(
    //   controller: state.requestController,
    //   child:

    // ),
  );
}

///收益列表item
_createRevenueItem() {
  return Container(
    margin: EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipOval(
                    child: CustomNetworkImage(
                      imageUrl: "",
                      width: Dimens.pt60,
                      height: Dimens.pt60,
                      placeholder: assetsImg(AssetsImages.USER_DEFAULT_AVATAR,
                          width: Dimens.pt60,
                          height: Dimens.pt60,
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text("用户名",
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: Dimens.pt15)),
                  Text("解锁了你的帖子",
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: Dimens.pt14)),
                ],
              ),
            ),
            Row(
              children: [
                Text("+",
                    maxLines: 1,
                    style: TextStyle(
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: AppColors.goldCoinTgColors,
                          ).createShader(Rect.fromLTWH(0, 0, 20, 20)),
                        fontSize: Dimens.pt14)),
                const SizedBox(width: 3),
                Text("33金币",
                    maxLines: 1,
                    style: TextStyle(
                        color: AppColors.userGoldCoinColor,
                        fontSize: Dimens.pt14)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text("經常幻想和小婷經常幻想和小婷經常幻想和小婷經常幻想和小婷經常幻想和小婷",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: Dimens.pt13,
            )),
      ],
    ),
  );
}
