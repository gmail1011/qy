import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/model/novel_model.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/dimens.dart';

Widget getItem(dynamic item) {
  String label = '';
  String assetName = '';
  if (item is LouFengItem) {
    label = '楼凤';
    assetName = AssetsSvg.IC_FIRE;
  } else if (item is NoveItem) {
    label = '小说';
    assetName = AssetsSvg.IC_SPEAKER;
  }

  return GestureDetector(
    onTap: () async {
      autoPlayModel.disposeAll();
      if (item is LouFengItem) {
        await JRouter()
            .go(YUE_PAO_DETAILS_PAGE, arguments: {'id': item.id});
      } else if (item is NoveItem) {
        if (GlobalStore.isVIP()) {
          await JRouter().go(PAGE_NOVEL_PLAYER, arguments: {'id': item.id});
        } else {
          await JRouter()
              .go(PAGE_PASSION_NOVEL_LIST, arguments: {'showTitle': true});
        }
      }
      autoPlayModel.startAvailblePlayer();
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
      color: Colors.black.withOpacity(.3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          svgAssets(
            assetName,
            height: Dimens.pt16,
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(left: Dimens.pt6),
              alignment: Alignment.centerLeft,
              child: Text(
                '【$label】${item.title}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color(0xffF5CE24),
                  fontSize: AppFontSize.fontSize12,
                ),
              ),
            ),
          ),
          svgAssets(
            AssetsSvg.IC_LEFT,
            height: Dimens.pt14,
            color: Color(0xffF5CE24),
          ),
        ],
      ),
    ),
  );
}
