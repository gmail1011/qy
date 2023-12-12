import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/page/tag/tag_home/compont/cell/state.dart';

import '../../action.dart';

Widget buildView(
    TagItemState tagItemState, Dispatch dispatch, ViewService viewService) {
  return Container(
    child: GestureDetector(
      onTap: () {
        // dispatch(TagActionCreator.onclickVideo(tagItemState));
      },

      child: Stack(
        children: <Widget>[
          Positioned(
            child: CustomNetworkImage(
              imageUrl: tagItemState.videoModel.cover,
              placeholder: assetsImg(
                AssetsImages.IC_DEFAULT_IMG,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            right: Dimens.pt5,
            top: Dimens.pt5,
            child: tagItemState.videoModel.isVideo()
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
              decoration: const BoxDecoration(
                  // 默认是从左往右的渐变
                  image: DecorationImage(
                image: AssetImage(AssetsImages.IC_JUXING),
                fit: BoxFit.cover,
              )),
              height: Dimens.pt18,
              width: Dimens.pt360,
//              color: const Color.fromARGB(100, 9, 190, 9),
            ),
          ),
          Positioned(
            left: 0,
            bottom: Dimens.pt2,
            child: Row(
              children: <Widget>[
                svgAssets(AssetsSvg.MINE_LIKE),
                Text(" "),
                Text(
                  numCoverStr(tagItemState.videoModel.likeCount),
                  style: TextStyle(color: Colors.white, fontSize: Dimens.pt10),
                ),
              ],
            ),
          ),
          Positioned(
            right: Dimens.pt3,
            bottom: Dimens.pt2,
            child: Text(
              tagItemState.videoModel.location?.city ?? "",
              style: TextStyle(color: Colors.white, fontSize: Dimens.pt10),
            ),
          ),
        ],
      ),
//      overflow: Overflow.clip,//超出部分会被切掉
    ),
  );
}
