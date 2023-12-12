import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/guide/flutter_intro.dart';
import 'package:flutter_app/common/guide/step_widget_builder.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/page_intro_helper.dart';

class YuePaoState
    with EagleHelper, PageIntroHelper
    implements Cloneable<YuePaoState> {
  String city = '';
  TabController tabController = TabController(length: 4, vsync: ScrollableState());
  List<AdsInfoBean> adsList = [];
  Intro intro = Intro(
      stepCount: 1,
      showMask: true,
      widgetBuilder: StepWidgetBuilder.useDefaultTheme(widgets: [
        {
          "widget": ImageLoader.withP(ImageType.IMAGE_ASSETS,
                  width: Dimens.pt100,
                  height: Dimens.pt40,
                  address: AssetsImages.IC_INTRO_YUEPAO_TO_CITY)
              .load(),
          "width": Dimens.pt100,
          "height": Dimens.pt20,
        }
      ],
          // texts: [Lang.INTRO_SWITCH_CITY_TIPS],
          posMap: {
            0: 2
          }, textBgColor: AppColors.primaryColor));
  @override
  YuePaoState clone() {
    return YuePaoState()
      ..intro = intro
      ..tabController = tabController
      ..adsList = adsList
      ..city = city;
  }
}

YuePaoState initState(Map<String, dynamic> args) {
  return YuePaoState();
}
