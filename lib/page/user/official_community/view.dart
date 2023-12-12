import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
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
import 'package:flutter_base/flutter_base.dart';

import 'state.dart';

Widget buildView(
    OfficialCommunityState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: getCommonAppBar("官方社群"),
      body: BaseRequestView(
        controller: state.requestController,
        child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (BuildContext context, int index) {
              if (state.dataList == null || state.dataList.isEmpty) {
                return Container();
              }
              return _createOfficialCommunityItem(state.dataList[index]);
            },
            itemCount: state.dataList?.length ?? 0),
      ),
    ),
  );
}

///社区列表
Widget _createOfficialCommunityItem(OfficeItemData item) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: CustomNetworkImage(
            imageUrl: item?.officialImg ?? "",
            height: Dimens.pt80,
            placeholder: assetsImg(AssetsImages.LOADING_IMAGE,
                height: Dimens.pt80, fit: BoxFit.fitWidth),
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.only(left: 9, right: 13),
        height: Dimens.pt80,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: Dimens.pt58,
              height: Dimens.pt56,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(item?.officialName ?? "",
                  style: TextStyle(fontSize: Dimens.pt14, color: Colors.white)),
            ),
            GestureDetector(
              onTap: () => launchUrl(item?.officialUrl),
              child: svgAssets(AssetsSvg.ICON_MINE_OFFICAL_JOIN,
                  width: Dimens.pt90, height: Dimens.pt34),
            ),
          ],
        ),
      ),
    ],
  );
}
