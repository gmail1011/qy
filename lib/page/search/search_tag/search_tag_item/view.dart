// file : 金币专区-网格小模块

import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/page/search/search_tag/action.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'state.dart';

Widget buildView(
    SearchTagItemState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    child: GestureDetector(
      onTap: () {
        dispatch(HotListActionCreator.onclickVideo(state));
      },

      child: Stack(
        children: <Widget>[
          Positioned(
            child: CustomNetworkImage(
              imageUrl: state.videoModel.cover,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: assetsImg(
                AssetsImages.IC_DEFAULT_IMG,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
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
              height: Dimens.pt25,
              width: Dimens.pt360,
//              color: const Color.fromARGB(100, 9, 190, 9),
            ),
          ),
          Positioned(
            left: 0,
            bottom: Dimens.pt2,
            child: Row(
              children: <Widget>[
                svgAssets(
                    state.bean.types == "goldCoinArea"
                        ? AssetsSvg.IC_GOLD
                        : AssetsSvg.SEARCH_PAGE_SEARCH_WHITE_STAR,
                    width: 16,
                    height: 16),
                Text(" "),
                Text(
                  state.bean.types == "goldCoinArea"
                      ? '${state.videoModel.coins}' + Lang.GOLD
                      : (state.videoModel.likeCount >= 10000
                          ? '${(state.videoModel.likeCount / 10000).toStringAsFixed(1)}W'
                          : '${state.videoModel.likeCount}'),
//                          state.tabs == null ? "" : numCoverStr(state.tabs[index].likeCount),
                  style: TextStyle(color: Colors.white, fontSize: Dimens.pt10),
                ),
              ],
            ),
          ),
          Positioned(
            right: Dimens.pt3,
            bottom: Dimens.pt2,
            child: Row(
              children: <Widget>[
                Offstage(
                  offstage: state.bean.types == "goldCoinArea" ? false : true,
                  child: svgAssets(AssetsSvg.SEARCH_PAGE_SEARCH_WHITE_HEAD,
                      width: 16, height: 16),
                ),
                Text(
                  state.bean.types == "goldCoinArea"
                      ? (state.videoModel.playCount >= 10000
                          ? '${(state.videoModel.playCount / 10000).toStringAsFixed(1)}W'
                          : '${state.videoModel.playCount}')
                      : (state.videoModel.location.city == null
                          ? ""
                          : state.videoModel.location.city),
                  style: TextStyle(color: Colors.white, fontSize: Dimens.pt10),
                )
              ],
            ),
          ),
        ],
      ),
//           overflow: Overflow.clip,//超出部分会被切掉
    ),
  );
}
