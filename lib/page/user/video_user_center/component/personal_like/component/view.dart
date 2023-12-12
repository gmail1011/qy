import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/svg_util.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    LikeItemState state, Dispatch dispatch, ViewService viewService) {
  return GestureDetector(
    onTap: () {
      ///条目点击
      dispatch(LikeItemActionCreator.onTapItem(state.uniqueId));
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Container(
        child: Stack(
          overflow: Overflow.clip, //超出部分会被切掉
          children: <Widget>[
            Positioned(
                child: CustomNetworkImage(
              imageUrl: state.videoModel.cover,
              placeholder: assetsImg(
                AssetsImages.IC_DEFAULT_IMG,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              fit: BoxFit.cover,
            )),
            Positioned(
              right: Dimens.pt5,
              top: Dimens.pt5,
              child: state.videoModel.isVideo()
                  ? Container()
                  : svgAssets(
                      AssetsSvg.ITEM_IMG_TIP,
                      width: Dimens.pt16,
                      height: Dimens.pt16,
                    ),
            ),
            Positioned(
              bottom: 0,
              // height: 37,
              child: Container(
                decoration: BoxDecoration(
                    // 默认是从左往右的渐变
                    image: DecorationImage(
                  image: AssetImage(AssetsImages.IC_JUXING),
                  fit: BoxFit.cover,
                )),
                height: Dimens.pt20,
                width: 1000,
              ),
            ),
            Positioned(
              left: Dimens.pt10,
              bottom: Dimens.pt3,
              child: Row(
                children: <Widget>[
                  svgAssets(AssetsSvg.MINE_LIKE),
                  Text(
                    "  " +
                        getShowCountStr(
                            state.videoModel.likeCount),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
