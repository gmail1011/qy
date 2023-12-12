import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:get/route_manager.dart' as Gets;

import 'shou_yi_detail_state.dart';

Widget buildView(
    ShouYiDetailState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    margin: EdgeInsets.only(
      left: AppPaddings.appMargin,
      right: AppPaddings.appMargin,
      top: AppPaddings.appMargin,
    ),
    child: BaseRequestView(
      controller: state.controller,
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (state.rankTypeData?.members?.isEmpty ?? true) {
            return Container();
          }
          return GestureDetector(
            onTap: () async {
              Map<String, dynamic> arguments = {
                'uid': state.rankTypeData?.members[index].id,
                'uniqueId': DateTime.now().toIso8601String(),
              };
              Gets.Get.to(() => BloggerPage(arguments), opaque: false);
              autoPlayModel.startAvailblePlayer();
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: AppPaddings.appMargin,
              ),
              child: Row(
                children: [
                  _buildRankIcon(index),
                  SizedBox(
                    width: Dimens.pt10,
                  ),
                  HeaderWidget(
                    headPath: state.rankTypeData?.members[index].avatar,
                    level: (state.rankTypeData?.members[index].superUser ?? false)
                        ? 1
                        : 0,
                    headWidth: Dimens.pt40,
                    headHeight: Dimens.pt40,
                    levelSize: Dimens.pt12,
                    positionedSize: 0,
                  ),
                  SizedBox(
                    width: Dimens.pt20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.rankTypeData?.members[index].name,
                        maxLines: 1,
                        style: TextStyle(
                            //superUser
                            color: _isVipByVipExpireDate(state
                                    .rankTypeData?.members[index].vipExpireDate)
                                ? Color.fromRGBO(255, 183, 68, 1)
                                : Colors.white,
                            fontSize: Dimens.pt14),
                      ),
                      SizedBox(
                        height: Dimens.pt4,
                      ),
                      Text(
                          _getRankNumberValue(
                              state.rankTypeData?.members[index].value,
                              state.rankTypeData?.type),
                          style: TextStyle(
                              color: Colors.white, fontSize: Dimens.pt13)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: state.rankTypeData?.members?.length ?? 0,
      ),
    ),
  );
}

///通过到期时间判断是否VIP
bool _isVipByVipExpireDate(String vipExpireDate) {
  ///VIP判断
  if (TextUtil.isNotEmpty(vipExpireDate) ?? false) {
    DateTime dateTime = DateTime.parse(vipExpireDate);
    return dateTime.isAfter((netManager.getFixedCurTime()));
  }
  return false;
}

///设置金额显示
String _getRankNumberValue(String value, int type) {
  String endStr = type == 1 ? "关注" : "金币";
  return double.parse(value) > 10000
      ? (double.parse(value) / 10000).toStringAsFixed(1) + "万$endStr"
      : (type == 1 ? value : double.parse(value).toStringAsFixed(1)) +
          "$endStr";
}

///配置排行榜ICON
Widget _buildRankIcon(int index) {
  switch (index) {
    case 0:
      return svgAssets(AssetsSvg.RANK01,
          width: Dimens.pt30, height: Dimens.pt30);
    case 1:
      return svgAssets(AssetsSvg.RANK02,
          width: Dimens.pt30, height: Dimens.pt30);
    case 2:
      return svgAssets(AssetsSvg.RANK03,
          width: Dimens.pt30, height: Dimens.pt30);
    default:
      return Container(
        width: Dimens.pt30,
        alignment: Alignment.center,
        child: Text(
          "${index + 1}",
          style: TextStyle(color: Colors.white, fontSize: Dimens.pt18),
        ),
      );
  }
}
