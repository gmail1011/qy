import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_cache_manager.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';

import 'state.dart';

Widget buildView(
    GameRulesState state, Dispatch dispatch, ViewService viewService) {
  ImageCacheManager image = new ImageCacheManager();
  return SafeArea(
    child: Stack(
      children: [
        // Image.asset(
        //   "assets/weibo/gameRules.png",
        //   width: screen.screenWidth,
        //   height: screen.screenHeight,
        //   // height: 600,
        //   fit: BoxFit.fitWidth,
        // ),
        // Image(
        //   image: CachedNetworkImageProvider(
        //     "assets/weibo/gameRules.png",
        //     cacheManager: image,
        //   ),
        //   fit: BoxFit.cover,
        //   width: screen.screenWidth,
        // ),
        CustomScrollView(
          controller: state.scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Image.asset(
                "assets/weibo/gameRules.webp",
                width: screen.screenWidth,
                // height: screen.screenHeight,
                // height: 600,
                fit: BoxFit.fitWidth,
              ),
            ),
            // Image.asset(
            //   "assets/images/play_icon.png",
            //   width: 53,
            //   height: 66,
            // ),
            // Image.asset(
            //   "assets/weibo/gameRules.png",
            //   width: 200,
            //   height: 600,
            //   fit: BoxFit.fitWidth,
            // ),
          ],
        ),
        Positioned(
          left: 16,
          top: 16,
          child: GestureDetector(
            onTap: () {
              safePopPage();
            },
            child: svgAssets(
              AssetsSvg.USER_IC_USER_BTN_BACK,
              width: Dimens.pt30,
              height: Dimens.pt32,
            ),
          ),
        ),
      ],
    ),
  );
}
