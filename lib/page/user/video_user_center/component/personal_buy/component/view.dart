import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_buy/component/action.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'state.dart';

Widget buildView(
    BuyItemState state, Dispatch dispatch, ViewService viewService) {
  return GestureDetector(
    onTap: () {
      dispatch(BuyItemActionCreator.onTapItem(state.uniqueId));
    },
    child: Stack(
      overflow: Overflow.clip, //超出部分会被切掉
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          child: CustomNetworkImage(
            imageUrl: state.videoModel?.cover,
            placeholder: assetsImg(
              AssetsImages.IC_DEFAULT_IMG,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: Dimens.pt5,
          right: Dimens.pt5,
          child: state.videoModel.isVideo()
              ? Container()
              : svgAssets(
                  AssetsSvg.ITEM_IMG_TIP,
                  width: Dimens.pt16,
                  height: Dimens.pt16,
                ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
              padding: EdgeInsets.all(Dimens.pt2),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetsImages.IC_JUXING),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      svgAssets(AssetsSvg.MINE_PLAY,
                          width: Dimens.pt14, height: Dimens.pt12),
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
                  Visibility(
                    visible: (state.videoModel.coins ?? 0) > 0,
                    child: Row(
                      children: <Widget>[
                        svgAssets(AssetsSvg.IC_GOLD,
                            width: Dimens.pt12, height: Dimens.pt12),
                        Text(
                          " ${state.videoModel.coins ?? 0}${Lang.GOLD_COIN}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        )
      ],
    ),
  );
}
