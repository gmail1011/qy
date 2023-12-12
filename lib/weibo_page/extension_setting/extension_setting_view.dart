import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/numberpicker.dart';
import 'package:flutter_base/flutter_base.dart';

import 'extension_setting_action.dart';
import 'extension_setting_state.dart';

Widget buildView(
    ExtensionSettingState state, Dispatch dispatch, ViewService viewService) {
  return Theme(
    data: ThemeData(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      primaryColor: AppColors.weiboBackgroundColor,
      backgroundColor: AppColors.weiboBackgroundColor,
      bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.weiboJianPrimaryBackground),
    ),
    child: Scaffold(
      backgroundColor: AppColors.weiboBackgroundColor,
      appBar: getCommonAppBar("推广设置", actions: []),
      bottomSheet: Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          primaryColor: AppColors.weiboBackgroundColor,
          backgroundColor: AppColors.weiboBackgroundColor,
        ),
        child: Container(
          color: Colors.transparent,
          height: Dimens.pt100,
          width: screen.screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 6, bottom: 6, left: 14, right: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.selectBean.length == 0
                          ? ""
                          : "${state.selectBean.elementAt(state.selectedValue).price}金币",
                      style: TextStyle(
                          fontSize: Dimens.pt20,
                          color: Color.fromRGBO(255, 141, 62, 1)),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "余额：${GlobalStore.getWallet().income + GlobalStore.getWallet().amount}金币",
                      style: TextStyle(
                          fontSize: Dimens.pt13,
                          color: Color.fromRGBO(153, 153, 153, 1)),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  var res;
                  try {
                    res = await netManager.client.setPromoteVideo(
                      null,
                      state.videoModel.id,
                      "SP",
                      1,
                      state.selectBean.elementAt(state.selectedValue).popId,
                    );
                  } catch (e) {
                    l.e("reward_dialog", e.toString());
                  }
                  if (res != null) {
                    showToast(msg: Lang.OPT_SUCCESS);
                    /* if (setTopType == 'SP') {
                      videos = [];
                      getVideo(true);
                    } else if (setTopType == "COVER") {
                      covers = [];
                      getCovers();
                    } else if (setTopType == "MOVIE") {
                      movieList = [];
                      getMovieList();
                    }
                    setTopType = "SP";
                    setTopAction = 1;
                    setTopVideoId = "";*/
                    safePopPage();
                  }
                },
                child: Container(
                  height: Dimens.pt42,
                  width: Dimens.pt134,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(222, 142, 63, 1),
                        Color.fromRGBO(239, 133, 54, 1),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Text(
                    "去推广",
                    style:
                        TextStyle(color: Colors.white, fontSize: Dimens.pt18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 14, right: 14),
        child: Column(
          children: [
            Offstage(
              offstage: state.adsList.length == 0 ? true : false,
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  child: Container(
                    height: Dimens.pt120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: AdsBannerWidget(
                      state.adsList,
                      //width: Dimens.pt360,
                      height: Dimens.pt120,
                      onItemClick: (index) {
                        var ad = state.adsList[index];
                        if (ad.href.contains("game_page")) {
                          Navigator.of(FlutterBase.appContext).pop();
                          bus.emit(EventBusUtils.gamePage);
                        } else {
                          JRouter().handleAdsInfo(ad.href, id: ad.id);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              child: Container(
                height: Dimens.pt110,
                width: screen.screenWidth,
                padding:
                    EdgeInsets.only(left: 13, right: 13, bottom: 16, top: 16),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(30, 30, 30, 1),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      child: CustomNetworkImage(
                        imageUrl: state.videoModel.cover ?? "",
                        width: Dimens.pt78,
                        height: Dimens.pt78,
                      ),
                    ),
                    SizedBox(
                      width: 11.4,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 6, bottom: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.videoModel.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: Dimens.pt14, color: Colors.white),
                            ),
                            Text(
                              "@${state.videoModel.publisher?.name}",
                              style: TextStyle(
                                  fontSize: Dimens.pt12,
                                  color: Color.fromRGBO(255, 161, 50, 1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 14,
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              child: Container(
                height: Dimens.pt138,
                width: screen.screenWidth,
                // margin: EdgeInsets.only(top: 14,),
                padding:
                    EdgeInsets.only(left: 13, right: 13, bottom: 16, top: 16),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(30, 30, 30, 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "推广设置",
                      style:
                          TextStyle(color: Colors.white, fontSize: Dimens.pt16),
                    ),
                    Row(
                      children: [
                        Text(
                          "推广时长",
                          style: TextStyle(
                              color: Color.fromRGBO(183, 183, 183, 1),
                              fontSize: Dimens.pt16),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            int selectedValues = 1;
                            showModalBottomSheet(
                              context: viewService.context,
                              backgroundColor: Color.fromRGBO(248, 248, 248, 1),
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setDialogState) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Container(
                                      height: Dimens.pt400,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                        color: Color.fromRGBO(248, 248, 248, 1),
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                                top: 21, bottom: 17),
                                            child: Text(
                                              "推广时长",
                                              style: TextStyle(
                                                  fontSize: Dimens.pt18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(bottom: 27),
                                            height: 1,
                                            color: Color.fromRGBO(
                                                238, 238, 238, 1),
                                          ),
                                          SizedBox(
                                            height: 14,
                                          ),
                                          Container(
                                            height: Dimens.pt220,
                                            child: NumberPicker.integer(
                                              initialValue: selectedValues,
                                              minValue: 0,
                                              maxValue: 10,
                                              //step: 10,
                                              selectBean: state.selectBean,
                                              itemExtent: 70,
                                              selectedTextStyle: TextStyle(
                                                  fontSize: Dimens.pt18,
                                                  color: Color.fromRGBO(
                                                      255, 158, 44, 1)),
                                              textStyle: TextStyle(
                                                  fontSize: Dimens.pt18,
                                                  color: Color.fromRGBO(
                                                      102, 102, 102, 1)),
                                              infiniteLoop: false,
                                              onChanged: (value) {
                                                setDialogState(() {
                                                  return selectedValues = value;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              },
                            ).then((value) {
                              //print("-------------" + state.selectBean.elementAt(selectedValue).popId.toString());
                              dispatch(
                                  ExtensionSettingActionCreator.onSelectValue(
                                      selectedValues));
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.selectBean.length == 0
                                    ? ""
                                    : "${state.selectBean.elementAt(state.selectedValue).popDays}天",
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 155, 37, 1),
                                    fontSize: Dimens.pt14),
                              ),
                              Image.asset(
                                "assets/images/right_arrow.png",
                                width: 16,
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "金额",
                          style: TextStyle(
                              color: Color.fromRGBO(183, 183, 183, 1),
                              fontSize: Dimens.pt16),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.selectBean.length == 0
                                  ? ""
                                  : "${state.selectBean.elementAt(state.selectedValue).price}金币",
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 155, 37, 1),
                                  fontSize: Dimens.pt14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
