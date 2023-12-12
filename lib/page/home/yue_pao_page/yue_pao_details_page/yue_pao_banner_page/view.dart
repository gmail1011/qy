
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/page/home/yue_pao_page/com/public.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'state.dart';

Widget buildView(
    YuePaoBannerState state, Dispatch dispatch, ViewService viewService) {
  return WillPopScope(
    onWillPop: () {
      if ((state.videoPlayerController?.value?.isPlaying ?? false)) {
        state.videoPlayerController?.pause();
      }
      return Future.value(true);
    },
    child: Scaffold(
      body: Stack(
        children: [
          Container(
            width: screen.screenWidth,
            height: screen.screenHeight,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                var item = state.resources[index];
                return yueResourcesItem(
                  item,
                  videoController: (v) {
                    state.videoPlayerController = v;
                  },
                );
              },
              index: state.selectIndex ?? 0,
              itemCount: state.resources?.length ?? 0,
              onIndexChanged: (index) {
                if ((state.videoPlayerController?.value?.isPlaying ?? false)) {
                  state.videoPlayerController?.pause();
                }
              },
              pagination: SwiperPagination(
                margin: EdgeInsets.all(0.0),
                builder: SwiperCustomPagination(
                  builder: (BuildContext context, SwiperPluginConfig config) {
                    return ConstrainedBox(
                      child: Container(
                        padding: EdgeInsets.only(bottom: screen.paddingBottom),
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Positioned(
                                right: 0,
                                child: Container(
                                  margin: EdgeInsets.only(right: 6),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    "${config.activeIndex + 1}/${config.itemCount}",
                                    style: TextStyle(
                                      fontSize: AppFontSize.fontSize12,
                                      color: AppColors.textColorWhite,
                                    ),
                                  ),
                                )),
                            DotSwiperPaginationBuilder(
                                    color: AppColors.primaryRaised
                                        .withOpacity(0.5),
                                    activeColor: AppColors.primaryRaised,
                                    size: 10.0,
                                    activeSize: 10.0)
                                .build(context, config)
                          ],
                        ),
                      ),
                      constraints: BoxConstraints.expand(height: 50.0),
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            height: kToolbarHeight + screen.paddingTop,
            padding: EdgeInsets.only(
                left: AppPaddings.appMargin, top: screen.paddingTop),
            child: GestureDetector(
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  width: kToolbarHeight,
                  height: kToolbarHeight,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: ImageLoader.withP(ImageType.IMAGE_SVG,
                          address: AssetsSvg.BACK, fit: BoxFit.scaleDown)
                      .load()),
              onTap: () {
                if ((state.videoPlayerController?.value?.isPlaying ?? false)) {
                  state.videoPlayerController?.pause();
                }
                Navigator.of(viewService.context).pop();
              },
            ),
          ),
        ],
      ),
    ),
  );
}
