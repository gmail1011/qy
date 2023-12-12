import 'package:fish_redux/fish_redux.dart';
import 'package:flustars/flustars.dart' as uts;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/model/user/product_item.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/lou_feng_discount_card_entity.dart';
import 'package:flutter_app/page/home/yue_pao_page/com/public.dart';
import 'package:flutter_app/page/home/yue_pao_page/yue_pao_details_page/agent/agent.dart';
import 'package:flutter_app/page/user/member_centre_page/page.dart';
import 'package:flutter_app/utils/asset_util.dart';
import 'package:flutter_app/utils/event_tracking_manager.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/route_manager.dart' as Gets;
import '../LouFengDisCountBuy.dart';
import 'SafePage.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    YuePaoDetailsState state, Dispatch dispatch, ViewService viewService) {
  double btm = screen.paddingBottom == 0 ? 0 : 14;
  LouFengItem louFengItem = state.louFengItem;
  return FullBg(
    child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: .0,
        title: Text(
          Lang.YUE_PAO_MSG8,
          style: TextStyle(
            fontSize: Dimens.pt16,
            color: Colors.white,
            height: 1.4,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => safePopPage(louFengItem),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              dispatch(YuePaoDetailsActionCreator.onClickReport());
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: Dimens.pt16),
              alignment: Alignment.center,
              child: Text(
                Lang.REPORT,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimens.pt12,
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PullRefreshView(
              enablePullDown: false,
              controller: state.pullController,
              onLoading: () {
                dispatch(YuePaoDetailsActionCreator.loadMoreData());
              },
              child: Stack(
                children: [
                  ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return BaseInformation(
                          item: state.louFengItem,
                          resources: state.resources,
                          isShow: state.list.length > 0,
                          productItemBean: state.productItemBean,
                          state: state,
                          goVip: () {
                            dispatch(YuePaoDetailsActionCreator.goVip());
                          },
                        );
                      }
                      var item = state.list[index - 1];
                      return experienceItem(item);
                    },
                    itemCount: state.list.length + 1,
                  ),
                  Positioned(
                    bottom: 140,
                    right: 6,
                    child: Container(
                      width: 90,
                      height: 90,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            viewService.context,
                            MaterialPageRoute(
                              builder: (context) => SafePage(),
                            ),
                          );
                        },
                        child: Image.asset("assets/images/safe_floating.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          louFengItem != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 10,
                      child: GestureDetector(
                        onTap: () {
                          // 收藏/取消收藏
                          /*eagleClick(state.selfId(),
                              sourceId: state.eagleId(viewService.context),
                              label: "收藏${!(louFengItem?.isCollect ?? false)}");*/
                          dispatch(YuePaoDetailsActionCreator.onCollect(
                              !(louFengItem?.isCollect ?? false)));
                        },
                        child: Container(
                          height: Dimens.pt40 + btm,
                          color: Colors.white,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(bottom: btm),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_border,
                                size: Dimens.pt21,
                                color: (louFengItem?.isCollect ?? false)
                                    ? Color(0xffFFA26F)
                                    : Color(0x59000000),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: Dimens.pt8),
                                child: Text(
                                  (louFengItem?.isCollect ?? false)
                                      ? Lang.HAVE_COLLECT
                                      : Lang.COLLECT,
                                  style: TextStyle(
                                      fontSize: Dimens.pt16,
                                      color: Color(0x99000000)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: GestureDetector(
                        onTap: () {
                          /*eagleClick(state.selfId(),
                              sourceId: state.eagleId(viewService.context),
                              label: "认证");*/
                          // 验证
                          dispatch(YuePaoDetailsActionCreator.onVerification());
                        },
                        child: Container(
                          height: Dimens.pt40 + btm,
                          color: Colors.white,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(bottom: btm),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              svgAssets(AssetsSvg.IC_VERIFICATION,
                                  height: Dimens.pt21),
                              Container(
                                margin: EdgeInsets.only(left: Dimens.pt8),
                                child: Text(
                                  Lang.VERIFICATION,
                                  style: TextStyle(
                                      fontSize: Dimens.pt16,
                                      color: Color(0x99000000)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 14,
                      child: GestureDetector(
                        onTap: () async {
                          if (state.pageTitle == 2) {
                            bool isSelected = false;

                            Map<int, bool> mapIsSelected = new Map();
                            LouFengDiscountCardData louFengDiscountCardData;
                            List<LouFengDiscountCardDataCouponList> couponList =
                                [];
                            int curIndex;
                            String selectedDiscountPrice;
                            if (!louFengItem.isBought ?? false) {
                              if ((louFengItem?.contactPrice ?? 0) == 0) {
                                dispatch(YuePaoDetailsActionCreator.onBuy());
                              } else {
                                dynamic result = await netManager.client
                                    .getLouFengDiscountCard(louFengItem.id, 7);

                                louFengDiscountCardData =
                                    LouFengDiscountCardData().fromJson(result);

                                couponList =
                                    louFengDiscountCardData.couponList ?? [];

                                for (int i = 0; i < couponList.length; i++) {
                                  mapIsSelected[i] = false;
                                }
                                // if (couponList == null ||
                                //     couponList.length == 0) {
                                //   dispatch(YuePaoDetailsActionCreator.onBuy());
                                //   Navigator.of(viewService.context).pop();
                                //   return;
                                // }

                                showModalBottomSheet(
                                    context: viewService.context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, states) {
                                          int discountedPrice =
                                              louFengDiscountCardData
                                                  .discountedPrice;
                                          String id = "";
                                          if (curIndex != null &&
                                              curIndex <= couponList.length &&
                                              mapIsSelected[curIndex]) {
                                            discountedPrice =
                                                couponList[curIndex]
                                                    .discountedPrice;
                                            id = couponList[curIndex].id;
                                          }
                                          isSelected =
                                              mapIsSelected[curIndex] ?? false;
                                          return Container(
                                            height: Dimens.pt370,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: Dimens.pt18,
                                                ),
                                                Text("请选择楼凤折扣优惠券",
                                                    style: TextStyle(
                                                        fontSize: Dimens.pt18,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w400)),
                                                SizedBox(
                                                  height: Dimens.pt10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/svg/icon_gold_coin.svg",
                                                      width: Dimens.pt38,
                                                      height: Dimens.pt38,
                                                    ),
                                                    SizedBox(
                                                      width: Dimens.pt2,
                                                    ),
                                                    Text(
                                                      "$discountedPrice",
                                                      style: TextStyle(
                                                          fontSize: Dimens.pt40,
                                                          color: Color.fromRGBO(
                                                              222, 37, 43, 1),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: Dimens.pt10,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  alignment:
                                                      Alignment.centerRight,
                                                  padding: EdgeInsets.only(
                                                      right: Dimens.pt60),
                                                  child: Text(
                                                    "原价 ${louFengDiscountCardData.originalPrice}金币",
                                                    style: TextStyle(
                                                        fontSize: Dimens.pt12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        decorationColor:
                                                            Colors.red,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: Dimens.pt10,
                                                ),
                                                Container(
                                                  height: Dimens.pt0_6,
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                ),
                                                SizedBox(
                                                  height: Dimens.pt10,
                                                ),
                                                Container(
                                                  height: Dimens.pt160,
                                                  child: couponList.length == 0
                                                      ? SizedBox()
                                                      : ListView.separated(
                                                          itemCount:
                                                              louFengDiscountCardData
                                                                  .couponList
                                                                  .length,
                                                          separatorBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return Container(
                                                              height:
                                                                  Dimens.pt0_6,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                            );
                                                          },
                                                          itemBuilder:
                                                              (context, index) {
                                                            int count =
                                                                louFengDiscountCardData
                                                                        .couponList[
                                                                            index]
                                                                        .count ??
                                                                    0; //折扣券剩余次数
                                                            String name =
                                                                louFengDiscountCardData
                                                                        .couponList[
                                                                            index]
                                                                        .name ??
                                                                    "";
                                                            return Container(
                                                              padding: EdgeInsets.only(
                                                                  top: Dimens
                                                                      .pt10,
                                                                  bottom: Dimens
                                                                      .pt10),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Container(
                                                                        width: Dimens
                                                                            .pt120,
                                                                        padding:
                                                                            EdgeInsets.only(right: Dimens.pt20),
                                                                        child:
                                                                            Text(
                                                                          "$name",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                Dimens.pt12,
                                                                            color: Color.fromRGBO(
                                                                                219,
                                                                                10,
                                                                                10,
                                                                                1),
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        "剩余 $count",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Dimens.pt12,
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w500),
                                                                      ),
                                                                      count > 0
                                                                          ? Container(
                                                                              height: Dimens.pt20,
                                                                              child: Checkbox(
                                                                                value: mapIsSelected[index],
                                                                                activeColor: Colors.red, //选中时的颜色
                                                                                onChanged: (value) {
                                                                                  // 注意不是调用老页面的setState，而是要调用builder中的setState。
                                                                                  //在这里为了区分，在构建builder的时候将setState方法命名为了state。
                                                                                  states(() {
                                                                                    for (int i = 0; i < couponList.length; i++) {
                                                                                      mapIsSelected[i] = false;
                                                                                    }

                                                                                    mapIsSelected[index] = value;
                                                                                    curIndex = index;
                                                                                  });
                                                                                },
                                                                              ),
                                                                            )
                                                                          : GestureDetector(
                                                                              onTap: () {
                                                                                //JRouter().go(Address.activityUrl);
                                                                              },
                                                                              child:
                                                                                  /*Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              children: [
                                                                                Text("去抽奖", style: TextStyle(color: Color.fromRGBO(255, 0, 0, 0.5), fontSize: Dimens.pt12, fontWeight: FontWeight.w500)),
                                                                                Icon(
                                                                                  Icons.arrow_forward_ios_sharp,
                                                                                  size: Dimens.pt12,
                                                                                  color: Color.fromRGBO(255, 0, 0, 0.5),
                                                                                )
                                                                              ],
                                                                            ),*/
                                                                                  Container(),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                  Visibility(
                                                                    visible: index ==
                                                                            5
                                                                        ? true
                                                                        : false,
                                                                    child:
                                                                        Container(
                                                                      height: Dimens
                                                                          .pt0_6,
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.1),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    dispatch(isSelected
                                                        ? YuePaoDetailsActionCreator
                                                            .onBuyWithDiscountCard(
                                                                new LouFengDisCountBuy(
                                                                    id,
                                                                    discountedPrice))
                                                        : YuePaoDetailsActionCreator
                                                            .onBuy());

                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    width: Dimens.pt290,
                                                    height: Dimens.pt38,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  Dimens.pt20)),
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Color.fromRGBO(
                                                                245, 22, 78, 1),
                                                            Color.fromRGBO(255,
                                                                101, 56, 1),
                                                            Color.fromRGBO(
                                                                245, 68, 4, 1),
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          //阴影
                                                          color: Color.fromRGBO(
                                                              248, 44, 44, 0.4),
                                                          offset:
                                                              Offset(0.0, 1.0),
                                                          blurRadius: 8.0,
                                                          spreadRadius: 0.0,
                                                        ),
                                                      ],
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        left: Dimens.pt36,
                                                        right: Dimens.pt36,
                                                        top: Dimens.pt10),
                                                    child: Text(
                                                      "确认购买",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              Dimens.pt16),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    });
                              }
                            }
                          } else {

                            if(!louFengItem.isBooked){
                              Map<int, bool> mapIsSelected = new Map();
                              LouFengDiscountCardData louFengDiscountCardData;
                              List<LouFengDiscountCardDataCouponList> couponList =
                              [];
                              int curIndex;
                              String selectedDiscountPrice;
                              if (!louFengItem.isBought ?? false) {
                                if ((louFengItem?.contactPrice ?? 0) == 0) {
                                  dispatch(YuePaoDetailsActionCreator.onBuy());
                                } else {
                                  dynamic result = await netManager.client
                                      .getLouFengDiscountCard(louFengItem.id, 7);

                                  louFengDiscountCardData =
                                      LouFengDiscountCardData().fromJson(result);

                                  couponList =
                                      louFengDiscountCardData.couponList ?? [];

                                  for (int i = 0; i < couponList.length; i++) {
                                    mapIsSelected[i] = false;
                                  }
                                  // if (couponList == null ||
                                  //     couponList.length == 0) {
                                  //   dispatch(YuePaoDetailsActionCreator.onBuy());
                                  //   Navigator.of(viewService.context).pop();
                                  //   return;
                                  // }

                                  showModalBottomSheet(
                                      context: viewService.context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, states) {
                                            return Container(
                                              height: Dimens.pt370,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: Dimens.pt18,
                                                  ),
                                                  Text(
                                                      state.pageTitle == 1
                                                          ? "认证专区预约"
                                                          : "赔付专区预约",
                                                      style: TextStyle(
                                                          fontSize: Dimens.pt18,
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.w400)),
                                                  SizedBox(
                                                    height: Dimens.pt10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        "assets/svg/icon_gold_coin.svg",
                                                        width: Dimens.pt38,
                                                        height: Dimens.pt38,
                                                      ),
                                                      SizedBox(
                                                        width: Dimens.pt2,
                                                      ),
                                                      Text(
                                                       GlobalStore.isVIP() ? ((((100 - state.productItemBean.louFengDiscount) / 10).round() * louFengItem.originalBookPrice) /10 ).toStringAsFixed(0) : "${louFengItem.originalBookPrice}",
                                                        style: TextStyle(
                                                            fontSize: Dimens.pt40,
                                                            color: Color.fromRGBO(
                                                                222, 37, 43, 1),
                                                            fontWeight:
                                                            FontWeight.w600),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: Dimens.pt10,
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    alignment:
                                                    Alignment.centerRight,
                                                    padding: EdgeInsets.only(
                                                        right: Dimens.pt60),
                                                    child: Text(
                                                      "原价 ${louFengItem.originalBookPrice}金币",
                                                      style: TextStyle(
                                                          fontSize: Dimens.pt12,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          decoration:
                                                          TextDecoration
                                                              .lineThrough,
                                                          decorationColor:
                                                          Colors.red,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: Dimens.pt10,
                                                  ),
                                                  Container(
                                                    height: Dimens.pt0_6,
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                  ),
                                                  SizedBox(
                                                    height: Dimens.pt10,
                                                  ),
                                                  Container(
                                                    height: Dimens.pt160,
                                                    child: Column(
                                                      children: [
                                                        GlobalStore.isVIP()
                                                            ? Padding(
                                                          padding: EdgeInsets.only(
                                                              left: Dimens
                                                                  .pt10,
                                                              right: Dimens
                                                                  .pt10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "我的权益",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    Dimens
                                                                        .pt12,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  //JRouter().go(PAGE_MEMBER_CENTRE);
                                                                },
                                                                child: Text(
                                                                  "享受预约${((100 - state.productItemBean.louFengDiscount) / 10).toStringAsFixed(0)}折",
                                                                  style: TextStyle(
                                                                      fontSize: Dimens
                                                                          .pt12,
                                                                      fontWeight: FontWeight
                                                                          .w400,
                                                                      color:
                                                                      Colors.red),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                            : Padding(
                                                          padding: EdgeInsets.only(
                                                              left: Dimens
                                                                  .pt10,
                                                              right: Dimens
                                                                  .pt10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "会员最低可享${((100 - state.productItemBean.louFengDiscount) / 10).toStringAsFixed(0)}折预约折",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    Dimens
                                                                        .pt12,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                      Config.payFromType = PayFormType.user;
                                                                },
                                                                child:
                                                                Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal: Dimens
                                                                          .pt10,
                                                                      vertical:
                                                                      Dimens.pt3),
                                                                  decoration: BoxDecoration(
                                                                      gradient: LinearGradient(colors: [
                                                                        Color.fromRGBO(
                                                                            242,
                                                                            169,
                                                                            90,
                                                                            1),
                                                                        Color.fromRGBO(
                                                                            255,
                                                                            242,
                                                                            165,
                                                                            1),
                                                                        Color.fromRGBO(
                                                                            242,
                                                                            171,
                                                                            90,
                                                                            1)
                                                                      ]),
                                                                      borderRadius: BorderRadius.circular(Dimens.pt13),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            offset: Offset(0, 1),
                                                                            blurRadius: Dimens.pt4,
                                                                            color: Color(0xfff1ae70))
                                                                      ]),
                                                                  child: Text(
                                                                      "升级会员",
                                                                      style: TextStyle(
                                                                          color: Colors.black,
                                                                          fontSize: Dimens.pt11)),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: Dimens.pt10,
                                                        ),
                                                        Container(
                                                          height: Dimens.pt0_6,
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                        ),
                                                        SizedBox(
                                                          height: Dimens.pt10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              left:
                                                              Dimens.pt10,
                                                              right: Dimens
                                                                  .pt10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "资源信息",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    Dimens
                                                                        .pt12,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                        0.6)),
                                                              ),
                                                              Text(
                                                                louFengItem.title,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    Dimens
                                                                        .pt12,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                        0.6)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: Dimens.pt10,
                                                        ),
                                                        Container(
                                                          height: Dimens.pt0_6,
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                        ),
                                                        SizedBox(
                                                          height: Dimens.pt10,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.only(
                                                              left:
                                                              Dimens.pt10,
                                                              right: Dimens
                                                                  .pt10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "发布用户",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    Dimens
                                                                        .pt12,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                        0.6)),
                                                              ),
                                                              Text(
                                                                louFengItem
                                                                    .agentInfo
                                                                    .name,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    Dimens
                                                                        .pt12,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                        0.6)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: Dimens.pt10,
                                                        ),
                                                        Container(
                                                          height: Dimens.pt0_6,
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      dispatch(
                                                          YuePaoDetailsActionCreator
                                                              .renZhengZhuanQuYuYue());

                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Container(
                                                      width: Dimens.pt290,
                                                      height: Dimens.pt38,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                Dimens.pt20)),
                                                        gradient: LinearGradient(
                                                            colors: [
                                                              Color.fromRGBO(
                                                                  245, 22, 78, 1),
                                                              Color.fromRGBO(255,
                                                                  101, 56, 1),
                                                              Color.fromRGBO(
                                                                  245, 68, 4, 1),
                                                            ],
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            //阴影
                                                            color: Color.fromRGBO(
                                                                248, 44, 44, 0.4),
                                                            offset:
                                                            Offset(0.0, 1.0),
                                                            blurRadius: 8.0,
                                                            spreadRadius: 0.0,
                                                          ),
                                                        ],
                                                      ),
                                                      margin: EdgeInsets.only(
                                                          left: Dimens.pt36,
                                                          right: Dimens.pt36,
                                                          top: Dimens.pt10),
                                                      child: Text(
                                                        "立即预约",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize:
                                                            Dimens.pt16),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      });
                                }
                              }
                            }
                            }


                        },
                        child: state.pageTitle == 2
                            ? Container(
                                height: Dimens.pt40 + btm,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(bottom: btm),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: (louFengItem?.isBought ?? false)
                                        ? [Color(0xff979797), Color(0xff979797)]
                                        : [
                                            Color.fromRGBO(245, 22, 78, 1),
                                            Color.fromRGBO(255, 101, 56, 1),
                                            Color.fromRGBO(245, 68, 4, 1),
                                          ],
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    if ((state.productItemBean?.loufengCard
                                                ?.isBrought ??
                                            false) &&
                                        !(louFengItem?.isBought ?? false) &&
                                        (louFengItem?.contactPrice ?? 0) != 0 &&
                                        (louFengItem?.contactPriceDiscountRate ??
                                                0) >
                                            0)
                                      Container(
                                        alignment: Alignment.center,
                                        height: Dimens.pt40,
                                        width: Dimens.pt20,
                                        margin: EdgeInsets.only(right: 5),
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                AssetsImages.LOUFENG_ZQ),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        child: Text(
                                          "${((louFengItem?.contactPriceDiscountRate ?? 0) / 10).toStringAsFixed(0)}\n折",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: Dimens.pt13,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: Dimens.pt8),
                                            child: Text(
                                              (louFengItem?.isBought ?? false)
                                                  ? Lang.UNLOCKED
                                                  : (louFengItem?.contactPrice ??
                                                              0) ==
                                                          0
                                                      ? '免费领取'
                                                      : state.pageTitle == 2
                                                          ? '${louFengItem?.contactPrice ?? 0}${Lang.GOLD_COIN} ${Lang.UN_LOCK}'
                                                          : '${louFengItem?.originalBookPrice ?? 0}${Lang.GOLD_COIN} 預約',
                                              style: TextStyle(
                                                fontSize: Dimens.pt16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          svgAssets(
                                              AssetsSvg.SETTING_IC_ACCOUNT_SAFE,
                                              height: Dimens.pt21),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: Dimens.pt40 + btm,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(bottom: btm),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: (louFengItem?.isBooked ?? false)
                                        ? [Color(0xff979797), Color(0xff979797)]
                                        : [
                                            Color.fromRGBO(245, 22, 78, 1),
                                            Color.fromRGBO(255, 101, 56, 1),
                                            Color.fromRGBO(245, 68, 4, 1),
                                          ],
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                right: Dimens.pt8),
                                            child: Text(
                                              (louFengItem?.isBooked ?? false)
                                                  ? "已付" + louFengItem.originalBookPrice.toString()  + "預約金"
                                                  : (louFengItem?.contactPrice ??
                                                              0) ==
                                                          0
                                                      ? '免费领取'
                                                      : louFengItem.type == 0
                                                          ? '${louFengItem?.contactPrice ?? 0}${Lang.GOLD_COIN} ${Lang.UN_LOCK}'
                                                          : GlobalStore.isVIP() ? ((((100 - state.productItemBean.louFengDiscount) / 10).round() * louFengItem.originalBookPrice) /10 ).toStringAsFixed(0) + "金币預約" : "${louFengItem.originalBookPrice}金币預約",
                                              style: TextStyle(
                                                fontSize: Dimens.pt16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          svgAssets(
                                              AssetsSvg.SETTING_IC_ACCOUNT_SAFE,
                                              height: Dimens.pt21),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
      floatingActionButton: louFengItem != null
          ? Container(
              margin: EdgeInsets.only(bottom: Dimens.pt40),
              child: NextView(
                click: () {
                  dispatch(YuePaoDetailsActionCreator.onNextLouFeng());
                },
              ),
            )
          : Container(),
    ),
  );
}

/// 基本信息item
class BaseInformation extends StatelessWidget {
  final LouFengItem item;
  final ProductItemBean productItemBean;
  final bool isShow;
  final List<YuePaoResources> resources;
  final VoidCallback goVip;
  final YuePaoDetailsState state;

  const BaseInformation(
      {Key key,
      this.item,
      this.isShow,
      this.resources,
      this.productItemBean,
        this.state,
      this.goVip})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (item?.cover ?? []).isEmpty
            ? Container()
            : Container(
                height: Dimens.pt276,
                child: Swiper(
                  autoplay: true,
                  autoplayDelay: 10000,
                  pagination: SwiperCustomPagination(
                    builder: (context, config) {
                      return Container(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: Dimens.pt18,
                          width: Dimens.pt40,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              bottom: Dimens.pt17, right: Dimens.pt15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimens.pt10),
                            color: Color(0x80000000),
                          ),
                          child: Text(
                            '${(config?.activeIndex ?? 0) + 1}/${config?.itemCount ?? 0}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimens.pt12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  itemBuilder: (c, index) {
                    var item = resources[index];
                    return yueResourcesItem(item, onTap: () {
                      openYuepaoPreview(context, resources, index);
                    });
                  },
                  itemCount: resources.length ?? 0,
                ),
              ),

        /// 描述文字 功能按钮
        Container(
          padding: EdgeInsets.symmetric(
              vertical: Dimens.pt10, horizontal: Dimens.pt16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: Dimens.pt14),
                      child: Text(
                        item?.title ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Dimens.pt16,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Visibility(
                      visible: state.pageTitle == 0 ? true : false,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: [
                          Image.asset("assets/images/agent_bao.png",width: Dimens.pt24,height: Dimens.pt24,),

                          SizedBox(width: Dimens.pt8,),

                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(bottom: Dimens.pt14),
                            padding: EdgeInsets.only(left: Dimens.pt8,right: Dimens.pt8,top: Dimens.pt4,bottom: Dimens.pt4),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(254, 243, 226, 1),
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Text(
                              "已缴纳${item.agentInfo.deposit}元保证金",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: Dimens.pt12,
                                color: Color.fromRGBO(245, 68, 4, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),




                    Visibility(
                      visible: state.pageTitle == 0 || state.pageTitle == 1 ? true : false,
                      child: GestureDetector(
                        onTap: (){
                          Gets.Get.to(Agent(item.agentInfo),);
                        },
                        child: Container(
                          width: screen.screenWidth,
                          alignment: Alignment.center,
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  //margin: EdgeInsets.only(left: 10),
                                  child: ClipOval(
                                    child: CustomNetworkImage(
                                      height: Dimens.pt30,
                                      width: Dimens.pt30,
                                      fit: BoxFit.cover,
                                      imageUrl: item.agentInfo.avatar,
                                    ),
                                  ),
                                  decoration: ShapeDecoration(
                                    shape: CircleBorder(
                                      side: BorderSide(
                                        width: 0.5,
                                        color: Colors.white,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(width: Dimens.pt6,),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.agentInfo.name,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: AppFontSize.fontSize13,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                          width: Dimens.pt10,
                                        ),
                                        Text(
                                          "注册于" + uts.DateUtil.formatDate(item.agentInfo.createdAt,format: 'yyyy年MM月dd日'),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: AppFontSize.fontSize13,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                      ],
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: Dimens.pt8,
                    ),


                    Row(
                      children: [
                        // 已看
                        Row(
                          children: [
                            svgAssets(
                              AssetsSvg.IC_EYE,
                              height: Dimens.pt10,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: Dimens.pt4),
                              margin: EdgeInsets.only(right: Dimens.pt10),
                              child: Text(
                                '${(item?.countBrowse ?? 0) > 0 ? getShowCountStr(item.countBrowse) : Lang.BROWSE}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimens.pt10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // 收藏
                        Row(
                          children: [
                            svgAssets(
                              AssetsSvg.NO_COLLECTION,
                              height: Dimens.pt10,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: Dimens.pt4),
                              margin: EdgeInsets.only(right: Dimens.pt10),
                              child: Text(
                                '${(item?.countCollect ?? 0) > 0 ? getShowCountStr(item.countCollect) : Lang.COLLECT}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimens.pt10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // 解锁
                        Row(
                          children: [
                            svgAssets(
                              AssetsSvg.IC_LOCK,
                              height: Dimens.pt10,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: Dimens.pt4),
                              margin: EdgeInsets.only(right: Dimens.pt10),
                              child: Text(
                                '${(item?.countPurchases ?? 0) > 0 ? getShowCountStr(item.countPurchases) : Lang.UN_LOCK}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimens.pt10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // 验证
                        Row(
                          children: [
                            svgAssets(
                              AssetsSvg.IC_SHIELD,
                              height: Dimens.pt10,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: Dimens.pt4),
                              child: Text(
                                Lang.EXPERIENCE,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Dimens.pt10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              /*Visibility(
                visible: item?.isVerify ?? false,
                child: Container(
                  margin: EdgeInsets.only(left: Dimens.pt40),
                  child: assetsImg(
                    AssetsImages.CERTIFICATION,
                    height: Dimens.pt50,
                  ),
                ),
              ),*/
            ],
          ),
        ),

        /// 描述
        /*Container(
          margin: EdgeInsets.only(top: Dimens.pt6),
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.pt16, vertical: Dimens.pt7),
          color: Color(0xffFDF3CD),
          child: Text(
            Lang.YUE_PAO_MSG7,
            style: TextStyle(
              fontSize: Dimens.pt10,
              color: Color(0xff8D6D1B),
            ),
          ),
        ),*/

        Image.asset("assets/images/loufengdetails.png"),

        /// 整体填充
        Container(
          padding: EdgeInsets.symmetric(horizontal: Dimens.pt16),
          child: Column(
            children: [
              /// 联系方式
              Container(
                margin: EdgeInsets.only(top: Dimens.pt16),
                child: LineTitle(
                  text: Lang.CONTACT_DETAILS,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.pt6),
                  color: AppColors.primaryColor,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.pt13,
                  vertical: Dimens.pt6,
                ),
                margin: EdgeInsets.only(top: Dimens.pt8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text.rich(
                        (item.isBought || item.isBooked ?? false)
                            ? TextSpan(children: [
                                TextSpan(text: '${item.contact}\n'),
                                TextSpan(
                                    text: '${Lang.CONTACT_MSG}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: Dimens.pt9,
                                      height: 1.6,
                                    )),
                              ])
                            : TextSpan(
                                text: '***********',
                                style: TextStyle(
                                  color: Color.fromRGBO(245, 68, 4, 1),
                                ),
                              ),
                        style: TextStyle(
                          fontSize: Dimens.pt11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !(item?.isBought ?? false),
                      child: Text(
                        '${Lang.YUE_PAO_MSG5}${item?.contactPrice ?? 0}${Lang.YUE_PAO_MSG6}',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimens.pt11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Visibility(
                visible: productItemBean != null,
                child: AspectRatio(
                  aspectRatio: 328 / 94,
                  child: GestureDetector(
                    onTap: goVip,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppPaddings.appMargin, vertical: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AssetsImages.LOUFENG_CARD),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    productItemBean?.productName ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppFontSize.fontSize16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    (productItemBean?.loufengCard?.isBrought ??
                                            false)
                                        ? (!(productItemBean
                                                    ?.loufengCard?.isReceived ??
                                                false)
                                            ? '「您有免费楼凤福利未领取」'
                                            : '「您本周的免费福利已领取」')
                                        : '【${(productItemBean?.duration ?? 0)}天】',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppFontSize.fontSize12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              assetsImg(AssetsImages.LOUFENG_CARD_ICON,
                                  width: Dimens.pt25),
                            ],
                          ),
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xFFFFFFFF),
                                Color(0x00FFFFFF),
                              ]), //背景渐变
                              //圆角
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    productItemBean?.desc ?? '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: AppFontSize.fontSize12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                (productItemBean?.loufengCard?.isBrought ??
                                        false)
                                    ? Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Dimens.pt10,
                                            vertical: Dimens.pt2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              !(productItemBean?.loufengCard
                                                          ?.isReceived ??
                                                      false)
                                                  ? '去领取'
                                                  : '去看看',
                                              style: TextStyle(
                                                color: Color(0xFF9527D7),
                                                fontSize: Dimens.pt14,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: Dimens.pt2),
                                              child: svgAssets(
                                                AssetsSvg.IC_LEFT,
                                                width: Dimens.pt7,
                                                color: Color(0xFF9527D7),
                                              ),
                                            ),
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimens.pt15),
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Text(
                                          "￥${(productItemBean?.discountedPrice ?? 0) ~/ 10}",
                                          style: TextStyle(
                                              height: 1,
                                              fontSize: Dimens.pt24,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              /// 基本信息
              Container(
                margin: EdgeInsets.only(top: Dimens.pt16),
                child: LineTitle(
                  text: Lang.BASIC_MSG,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.pt6),
                  color: AppColors.primaryColor,
                ),
                padding: EdgeInsets.all(Dimens.pt10),
                margin: EdgeInsets.only(top: Dimens.pt8),
                child: Column(
                  children: [
                    // 排行
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: Dimens.pt9),
                              width: Dimens.pt12,
                              height: Dimens.pt12,
                              child: svgAssets(
                                AssetsSvg.IC_RANKING,
                                color: Color.fromRGBO(245, 68, 4, 1),
                              ),
                            ),
                            Text(
                              '${Lang.NUMBER_OF_SISTERS}：',
                              style: TextStyle(
                                fontSize: Dimens.pt12,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Text(
                            '${item?.quantity ?? 1}',
                            style: TextStyle(
                              fontSize: Dimens.pt12,
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                        )
                      ],
                    ),

                    // 年龄
                    Container(
                      margin: EdgeInsets.only(top: Dimens.pt6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: Dimens.pt9),
                                width: Dimens.pt12,
                                height: Dimens.pt12,
                                child: svgAssets(
                                  AssetsSvg.IC_AGE,
                                  color: Color.fromRGBO(245, 68, 4, 1),
                                ),
                              ),
                              Text(
                                '${Lang.SISTERS_AGE}：',
                                style: TextStyle(
                                  fontSize: Dimens.pt12,
                                  color: Colors.white,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              '${item?.age ?? 0}',
                              style: TextStyle(
                                fontSize: Dimens.pt12,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    // 价格
                    Container(
                      margin: EdgeInsets.only(top: Dimens.pt6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: Dimens.pt9),
                                width: Dimens.pt12,
                                height: Dimens.pt12,
                                child: svgAssets(
                                  AssetsSvg.IC_PRICE,
                                  color: Color.fromRGBO(245, 68, 4, 1),
                                ),
                              ),
                              Text(
                                '${Lang.PRICE_LIST}：',
                                style: TextStyle(
                                  fontSize: Dimens.pt12,
                                  color: Colors.white,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              '${item?.price ?? 0}',
                              style: TextStyle(
                                fontSize: Dimens.pt12,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    // 营业时间
                    Container(
                      margin: EdgeInsets.only(top: Dimens.pt6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: Dimens.pt9),
                                width: Dimens.pt12,
                                height: Dimens.pt12,
                                child: svgAssets(
                                  AssetsSvg.IC_TIME,
                                  color: Color.fromRGBO(245, 68, 4, 1),
                                ),
                              ),
                              Text(
                                '${Lang.BUSINESS_HOURS}：',
                                style: TextStyle(
                                  fontSize: Dimens.pt12,
                                  color: Colors.white,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              '${item?.businessHours ?? 0}',
                              style: TextStyle(
                                fontSize: Dimens.pt12,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    // 所属地区
                    Container(
                      margin: EdgeInsets.only(top: Dimens.pt6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: Dimens.pt9),
                                width: Dimens.pt12,
                                height: Dimens.pt12,
                                child: svgAssets(
                                  AssetsSvg.IC_AREA,
                                  color: Color.fromRGBO(245, 68, 4, 1),
                                ),
                              ),
                              Text(
                                '${Lang.AREA2}：',
                                style: TextStyle(
                                  fontSize: Dimens.pt12,
                                  color: Colors.white,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              TextUtil.isEmpty(item?.district)
                                  ? (item?.city ?? "")
                                  : item?.district ?? '',
                              style: TextStyle(
                                fontSize: Dimens.pt12,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    // 服务项目
                    Container(
                      margin: EdgeInsets.only(top: Dimens.pt6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: Dimens.pt9),
                                width: Dimens.pt12,
                                height: Dimens.pt12,
                                child: svgAssets(
                                  AssetsSvg.IC_PROJECT,
                                  color: Color.fromRGBO(245, 68, 4, 1),
                                ),
                              ),
                              Text(
                                '${Lang.SERVICE_ITEMS}：',
                                style: TextStyle(
                                  height: 1.4,
                                  fontSize: Dimens.pt12,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              item?.serviceItems ?? '',
                              style: TextStyle(
                                height: 1.4,
                                fontSize: Dimens.pt12,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    Visibility(
                      visible: item.details == null ? false : true,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                            top: Dimens.pt10,
                            bottom: Dimens.pt10,
                            left: Dimens.pt10,
                            right: Dimens.pt10),
                        margin: EdgeInsets.only(top: Dimens.pt10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Text(
                          item.details ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: Dimens.pt12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// 综合评分
              Container(
                margin: EdgeInsets.only(top: Dimens.pt16),
                child: LineTitle(
                  text: Lang.RATING,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.pt6),
                  color: AppColors.primaryColor,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.pt19,
                  vertical: Dimens.pt10,
                ),
                margin: EdgeInsets.only(top: Dimens.pt8),
                child: Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${getAllScore(getStarNum((item?.prettyStar ?? 0), (item?.serviceStar ?? 0), (item?.envStar ?? 0)))}\n',
                            style: TextStyle(
                              color: Color(0xffFF8D61),
                              fontSize: Dimens.pt44,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: '${Lang.RATING}(${Lang.MINUTE}100)',
                            style: TextStyle(
                              fontSize: Dimens.pt10,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: Dimens.pt50),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${Lang.FACE_VALUE}：',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimens.pt10,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimens.pt7),
                                  child: StarCom(
                                    topStarNum: (item?.prettyStar ?? 0) /
                                        1, //int转double
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${Lang.SERVICE_STAR}：',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimens.pt10,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimens.pt7),
                                  child: StarCom(
                                    topStarNum: (item?.serviceStar ?? 0) / 1,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${Lang.EQUIPMENT}：',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Dimens.pt10,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimens.pt7),
                                  child: StarCom(
                                    topStarNum: (item?.envStar ?? 0) / 1,
                                  ),
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

              /// 体验详情
              Visibility(
                visible: isShow,
                child: Container(
                  margin: EdgeInsets.only(top: Dimens.pt16),
                  child: LineTitle(
                    text: Lang.EXPERIENCE_DETAILS,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
