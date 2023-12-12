import 'package:cached_network_image/cached_network_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:get/route_manager.dart' as Gets;
import 'action.dart';
import 'state.dart';

Widget buildView(
    MineLikeItemState state, Dispatch dispatch, ViewService viewService) {
  return GestureDetector(
    onTap: () {
      ///条目点击
      dispatch(MineLikeItemActionCreator.onTapItem(state.uniqueId));
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Container(
        child: Stack(
          overflow: Overflow.clip, //超出部分会被切掉
          children: <Widget>[
            Positioned(
              child: KeepAliveWidget(
                CachedNetworkImage(
                  imageUrl: getImagePath(state.videoModel.cover, true, false),
                  fit: BoxFit.cover,
                  memCacheHeight: 600,
                  cacheManager: ImageCacheManager(),
                  fadeInCurve: Curves.linear,
                  fadeOutCurve: Curves.linear,
                  fadeInDuration: Duration(milliseconds: 100),
                  fadeOutDuration: Duration(milliseconds: 100),
                  /*placeholder: (context, url) {
                    return placeHolder(ImgType.cover, null, Dimens.pt280);
                  },*/
                ),
              ),
            ),
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
                    "  " + getShowCountStr(state.videoModel.likeCount),
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
