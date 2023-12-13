import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/bang_dan_detail_entity.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/video/video_list_model/auto_play_model.dart';
import 'package:flutter_app/page/video/video_publish/page.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/weibo_page/widget/bloggerPage.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:get/route_manager.dart' as Gets;

import 'bangdan/bang_dan_page.dart';
import 'make_video_state.dart';

///创作中心
Widget buildView(
    MakeVideoState state, Dispatch dispatch, ViewService viewService) {
  return Scaffold(
    appBar: getCommonAppBar("创作中心"),
    body: state.entryVideoData == null
        ? Center(child: LoadingWidget())
        : StatefulBuilder(
            builder: (context, setStates) {
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: Dimens.pt104,
                        width: screen.screenWidth,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                          left: AppPaddings.appMargin,
                          right: AppPaddings.appMargin,
                        ),
                        decoration: const BoxDecoration(
                          color: const Color.fromRGBO(30, 30, 30, 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(2)),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            var uploadType =
                                await showUploadType(viewService.context);
                            if (uploadType == null) {
                              return;
                            }
                            bool isEntry =
                                await lightKV.getBool(Config.VIEW_UPLOAD_RULE);
                            if (!isEntry) {
                              var agree = await JRouter().go(PAGE_UPLOAD_RULE);
                              if (agree == null) {
                                agree = await lightKV
                                    .getBool(Config.VIEW_UPLOAD_RULE);
                              }
                              if (!(null != agree && agree is bool && agree))
                                return;
                            }

                            l.i("post",
                                "_onSelectUploadType()...choose okay:$uploadType");
                            Map<String, dynamic> map = {
                              'type': uploadType,
                              "taskID": state.taskID,
                              "isFromCenter": true,
                            };
                            var ret = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return VideoAndPicturePublishPage()
                                  .buildPage(map);
                            }));
                            if (ret is int) {
                              state.entryVideoData?.pendingReviewWorkCount =
                                  (state.entryVideoData
                                              ?.pendingReviewWorkCount ??
                                          0) +
                                      1;
                              if (ret > 0) {
                                state.entryVideoData?.notFreeTotalCount =
                                    (state.entryVideoData?.notFreeTotalCount ??
                                            0) +
                                        1;
                              } else {
                                state.entryVideoData?.freeTotalCount =
                                    (state.entryVideoData?.freeTotalCount ??
                                            0) +
                                        1;
                              }
                              setStates(() {});
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              svgAssets(AssetsSvg.USER_MAKE_ADD,
                                  height: Dimens.pt38, width: Dimens.pt38),
                              SizedBox(height: Dimens.pt9),
                              Text(
                                "发布你的作品",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: Dimens.pt16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          JRouter().jumpPage(WORK_MANAGER_PAGE,
                              args: {"position": 0});
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: AppPaddings.appMargin,
                            right: AppPaddings.appMargin,
                          ),
                          padding: EdgeInsets.only(
                            left: AppPaddings.appMargin,
                            right: AppPaddings.appMargin,
                            top: 10,
                          ),
                          color: Color.fromRGBO(30, 30, 30, 1),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "作品管理",
                                  style: TextStyle(
                                    color: AppColors.userPayTextColor,
                                    fontSize: Dimens.pt16,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white.withOpacity(0.7),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      //const SizedBox(height: 10),

                      ///作品统计数据
                      _buildWorkStatisticsDataUI(state),

                      ///立即赚钱UI
                      _buildMakeMoneyUI(
                          state.entryVideoData.workCreateCount ?? 0),

                      const SizedBox(height: 16),

                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: (state?.adsList?.length ?? 0) > 0
                              ? AdsBannerWidget(
                                  state.adsList,
                                  height: 126.w,
                                  onItemClick: (index) {
                                    var ad = state.adsList[index];
                                    if (ad.href.contains("game_page")) {
                                      Navigator.of(FlutterBase.appContext)
                                          .pop();
                                      bus.emit(EventBusUtils.gamePage);
                                    } else {
                                      JRouter()
                                          .handleAdsInfo(ad.href, id: ad.id);
                                    }
                                  },
                                )
                              : Container(),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Container(
                        height: Dimens.pt228,
                        margin: EdgeInsets.only(
                          left: Dimens.pt16,
                          right: Dimens.pt16,
                        ),
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              if (state.rankTypeList == null) {
                                return Container();
                              }
                              return createRankItem(state, index);
                              // return createRankItem(state.rankTypeList[index], index);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(width: 16);
                            },
                            itemCount: state.rankTypeList?.length ?? 0),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
  );
}

///作品统计数据
Container _buildWorkStatisticsDataUI(MakeVideoState state) {
  return Container(
    height: Dimens.pt140,
    width: screen.screenWidth,
    alignment: Alignment.center,
    color: Color.fromRGBO(30, 30, 30, 1),
    margin: EdgeInsets.only(
      left: AppPaddings.appMargin,
      right: AppPaddings.appMargin,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: AppPaddings.appMargin,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMakeWorksStatusItemUI(
                  "${state.entryVideoData?.passWorkCount ?? 0}", "已发布", () {
                JRouter().jumpPage(WORK_MANAGER_PAGE, args: {"position": 1});
              }),
              _buildMakeWorksStatusItemUI(
                  "${state.entryVideoData?.pendingReviewWorkCount ?? 0}", "审核中",
                  () {
                //passWorkCount
                JRouter().jumpPage(WORK_MANAGER_PAGE, args: {"position": 2});
              }),
              _buildMakeWorksStatusItemUI(
                  "${state.entryVideoData?.noPassCount ?? 0}", "未过审", () {
                JRouter().jumpPage(WORK_MANAGER_PAGE, args: {"position": 3});
              }),
            ],
          ),
        ),
        Container(
          height: 1,
          margin: EdgeInsets.only(
            top: 11,
          ),
          color: Color.fromRGBO(21, 21, 21, 1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "免费作品 ：" + state.entryVideoData?.freeTotalCount.toString(),
              style: TextStyle(
                  color: Color.fromRGBO(154, 154, 154, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: Dimens.pt16),
            ),
            Container(
              width: 1,
              height: Dimens.pt56,
              color: Color.fromRGBO(21, 21, 21, 1),
            ),
            Text(
              "收费作品 ：" + state.entryVideoData?.notFreeTotalCount.toString(),
              style: TextStyle(
                  color: Color.fromRGBO(154, 154, 154, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: Dimens.pt16),
            ),
          ],
        ),
      ],
    ),
  );
}

///作品管理状态item
GestureDetector _buildMakeWorksStatusItemUI(
        String value, String desc, Function onTap) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value ?? "",
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimens.pt24,
              ),
            ),
            SizedBox(
              height: Dimens.pt8,
            ),
            Text(
              desc ?? "",
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: Dimens.pt14,
              ),
            ),
          ],
        ),
      ),
    );

///立即赚钱UI
GestureDetector _buildMakeMoneyUI(int workCreateCount) {
  return GestureDetector(
    onTap: () => JRouter().jumpPage(MY_CERTIFICATION_PAGE),
    child: Container(
      height: Dimens.pt47,
      width: screen.screenWidth,
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: Dimens.pt20,
        left: AppPaddings.appMargin,
        right: AppPaddings.appMargin,
      ),
      decoration: const BoxDecoration(
        color: const Color.fromRGBO(30, 30, 30, 1),
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "已有$workCreateCount人  成为海角社区认证大V",
            style: TextStyle(
                color: AppColors.userPayTextColor, fontSize: Dimens.pt12),
          ),
          commonSubmitButton("立即认证",
              height: Dimens.pt20,
              width: Dimens.pt88,
              radius: 16,
              fontSize: Dimens.pt13, onTap: () {
            JRouter().jumpPage(MY_CERTIFICATION_PAGE);
          }),
        ],
      ),
    ),
  );
}

///收益榜信息
Container createRankItem(MakeVideoState state, int index) {
  BangDanRankType rankItem = state.rankTypeList[index];
  return Container(
    width: Dimens.pt250,
    decoration: BoxDecoration(
      color: AppColors.userMakeBgColor,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, top: 13),
          width: Dimens.pt250 - Dimens.pt16 * 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      rankItem?.typeDesc ?? "",
                      style:
                          TextStyle(color: Colors.white, fontSize: Dimens.pt18),
                    ),
                  ),
                  SizedBox(width: Dimens.pt6),
                  GestureDetector(
                    onTap: () {
                      Gets.Get.to(
                          BangDanPage().buildPage({
                            "index": index,
                            "rankTypeList": state.rankTypeList,
                          }),
                          opaque: false);
                    },
                    child: Text(
                      "查看更多",
                      style: TextStyle(
                        color: AppColors.userMakeMoreTextColor,
                        fontSize: Dimens.pt12,
                      ),
                    ),
                  ),
                  SizedBox(width: Dimens.pt4),
                ],
              ),
              SizedBox(height: Dimens.pt8),
              Container(
                height: Dimens.pt180,
                width: screen.screenWidth,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (rankItem.members == null || rankItem.members.isEmpty) {
                      return Container();
                    }
                    return _buildRankItem(
                        rankItem.members[index], index, rankItem?.type);
                  },
                  itemCount: (rankItem.members?.length ?? 0) > 3
                      ? 3
                      : rankItem?.members?.length ?? 0,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: Dimens.pt6),
      ],
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

///创建排行榜列表item
GestureDetector _buildRankItem(
    BangDanDetailDataMembers rankMember, int index, int type) {
  bool isVip = _isVipByVipExpireDate(rankMember?.vipExpireDate);

  return GestureDetector(
    onTap: () async {
      Map<String, dynamic> arguments = {
        'uid': rankMember?.id,
        'uniqueId': DateTime.now().toIso8601String(),
      };

      Gets.Get.to(() => BloggerPage(arguments), opaque: false);
      autoPlayModel.startAvailblePlayer();
    },
    child: Container(
      margin: const EdgeInsets.only(top: 13),
      child: Row(
        children: [
          _buildRankIcon(index),
          SizedBox(width: Dimens.pt13),
          HeaderWidget(
              headPath: rankMember?.avatar,
              level: (rankMember?.superUser ?? false)  ? 1 : 0,
              headWidth: Dimens.pt40,
              headHeight: Dimens.pt40,
              levelSize: Dimens.pt12,
              positionedSize: 0),
          SizedBox(width: Dimens.pt17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  rankMember?.name ?? "",
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: (isVip && (rankMember?.vipLevel ?? 0) > 0)
                          ? Color.fromRGBO(246, 197, 89, 1)
                          : Colors.white,
                      fontSize: Dimens.pt17),
                ),
                SizedBox(height: Dimens.pt4),
                Text(
                  _getRankNumberValue(rankMember?.value, type),
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: Dimens.pt12),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

///设置金额显示
String _getRankNumberValue(String value, int type) {
  String endStr = type == 1 ? "关注" : "金币";
  return double.parse(value) > 10000
      ? (double.parse(value) / 10000).toStringAsFixed(1) + "W$endStr"
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
      return Container();
  }
}
