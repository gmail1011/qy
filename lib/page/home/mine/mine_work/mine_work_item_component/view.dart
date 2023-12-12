import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/page/home/post/post_item_component/state.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/dialog/bottom_list_dialog.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/svg_util.dart';

import '../action.dart';

Widget buildView(
    PostItemState state, Dispatch dispatch, ViewService viewService) {
  return GestureDetector(
    onTap: () {
      dispatch(MineWorkActionCreator.onItemClick(state));
    },
    onLongPress: () async {
      /*var datas = <ItemData>[
        ItemData(Lang.DELETE, titleColor: Colors.red),
      ];
      var pos = await showListDialog(viewService.context, datas);
      if (pos == 0) {
        dispatch(MineWorkActionCreator.delWorkItem(state.videoModel));
      }*/
    },
    child: Stack(
      overflow: Overflow.clip, //超出部分会被切掉
      alignment: Alignment.center,
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
        state.videoModel.status == 1
            ? Positioned(
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
                            svgAssets(AssetsSvg.USER_ICON_VIDEO_PLAY,
                                width: Dimens.pt14, height: Dimens.pt12),
                            Text(
                              "  " +
                                  getShowCountStr(
                                      state.videoModel.playCount),
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
                                " ${state.videoModel.coins ?? 0}",
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
            : Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 0,
                child: Container(
                  alignment: Alignment.center,
                  color: Color(0x80000000),
                  child: getVideoReviewStatus(state.videoModel.status),
                ),
              ),
      ],
    ),
  );
}

Widget getVideoReviewStatus(int status) {
  switch (status) {
    case 0:
      return svgAssets(
        AssetsSvg.USER_IC_USER_REVIEW,
        width: Dimens.pt70,
        height: Dimens.pt70,
      );
    case 1:
      return Container();
    case 2:
      return svgAssets(
        AssetsSvg.USER_IC_USER_REVIEW_FAIL,
        width: Dimens.pt70,
        height: Dimens.pt70,
      );
    case 3:
      return Container();
  }
  return Container();
  // svgAssets(
  //       AssetsSvg.USER_IC_USER_REVIEW_FAIL,
  //       width: Dimens.pt70,
  //       height: Dimens.pt70,
  //     );
}
