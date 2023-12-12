import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/model/office_item_entity.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

import 'action.dart';
import 'state.dart';

///精品应用 BoutiqueAppPage
Widget buildView(
    BoutiqueAppState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar("精品应用"),
      body: BaseRequestView(
        controller: state.requestController,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.365,
              crossAxisSpacing: 18,
            ),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (BuildContext context, int index) {
              if (state.dataList == null) {
                return Container();
              }
              return _createBoutiqueAppItem(state.dataList[index]);
            },
            itemCount: state.dataList?.length ?? 0),
      ),
    ),
  );
}

///获取精品应用UI
Widget _createBoutiqueAppItem(OfficeItemData item) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: CustomNetworkImage(
            imageUrl: item?.officialImg ?? "",
            width: Dimens.pt60,
            height: Dimens.pt60,
            placeholder: assetsImg(AssetsImages.LOADING_IMAGE,
                height: Dimens.pt60, fit: BoxFit.fitWidth),
          ),
        ),
        const SizedBox(height: 5),
        Text(item?.officialName ?? "",
            style: TextStyle(fontSize: Dimens.pt14, color: Colors.white)),
        const SizedBox(height: 5),
        Text(item?.officialDesc ?? "",
            style: TextStyle(
                fontSize: Dimens.pt13,
                color: AppColors.userBoutiqueAppTextColor)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => launchUrl(item?.officialUrl),
          child: svgAssets(AssetsSvg.ICON_BOUTIQUEAPP_DOWNLOAD,
              height: Dimens.pt30, width: Dimens.pt70),
        ),
      ],
    ),
  );
}
