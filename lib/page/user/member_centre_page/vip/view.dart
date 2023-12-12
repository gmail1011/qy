import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/common/provider/countdown_update_model.dart';
import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/model/user/product_item.dart';
import 'package:flutter_app/page/user/member_centre_page/vip/vip_countdown_widget.dart';
import 'package:flutter_app/page/wallet/pay_for/state.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

import 'action.dart';
import 'state.dart';

///VIP UI
Widget buildView(VIPState state, Dispatch dispatch, ViewService viewService) {
  return BaseRequestView(
    controller: state.requestController,
    child: ((state.defaultTabVipItem?.vips?.length ?? 0) > 0)
        ? _buildVipUI(state, dispatch, viewService)
        : Container(),
  );
}

///build VIP UI
Column _buildVipUI(VIPState state, Dispatch dispatch, ViewService viewService) {
  return Column(
    children: [
      Expanded(
        flex: 1,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //     child: svgAssets(AssetsSvg.ICON_USER_VIP_MENU,
              //         height: Dimens.pt22),
              //     margin: const EdgeInsets.only(top: 16, bottom: 18)),

              Container(
                height: Dimens.pt156,
                margin: EdgeInsets.only(
                  left: Dimens.pt4,
                  right: Dimens.pt4,
                  top: Dimens.pt16,
                ),
                // padding: EdgeInsets.only(top: 20),
                child: Swiper(
                  controller: state.swiperController,
                  itemBuilder: (BuildContext context, int index) {
                    var item = state.defaultTabVipItem?.vips[index];
                    bool _isCurrentVip = state.selectVipItem == item;
                    return _isCurrentVip
                        ? (item?.productType == 5

                            ///选中新人倒计时 UI
                            ? _selectCutDownVipItemView(item, dispatch)

                            ///选中会员卡 UI
                            : _selectVipItemView(item, dispatch))

                        ///默认会员卡UI
                        : _defaultVipItemView(item, dispatch);
                  },
                  // index: 0,
                  itemCount: state.defaultTabVipItem?.vips?.length ?? 0,
                  viewportFraction: 0.325,
                  scale: 1,
                  onIndexChanged: (index) {
                    var item = state.defaultTabVipItem?.vips[index];
                    dispatch(VIPActionCreator.changeItem(index, item));
                  },
                  onTap: (index) {
                    int startIndex = state.tabIndex;
                    int targetIndex = index;
                    if (startIndex == targetIndex) {
                      return;
                    }
                    l.d("swiperController-start", "$startIndex");
                    l.d("swiperController-target", "$targetIndex");

                    ///特殊处理-第一个和最后一个
                    int vipTotalCount =
                        state.defaultTabVipItem?.vips?.length ?? 0;
                    if ((startIndex == vipTotalCount - 1) && targetIndex == 0) {
                      //6->0
                      state.swiperController?.next(animation: true);
                      l.d("swiperController-next", "special-下一步");
                    } else if ((targetIndex == vipTotalCount - 1) &&
                        startIndex == 0) {
                      //0->6
                      state.swiperController?.previous(animation: true);
                      l.d("swiperController-previous", "special-上一步");
                    } else {
                      ///普通滑动
                      if (startIndex < targetIndex) {
                        state.swiperController?.next(animation: true);
                        l.d("swiperController-next", "普通滑动-下一步");
                      } else if (startIndex > targetIndex) {
                        state.swiperController?.previous(animation: true);
                        l.d("swiperController-previous", "普通滑动-上一步");
                      }
                    }
                  },
                ),
              ),

              ///新手卡之前的逻辑，现在要改成所有的会员卡都提示新用户注册24小时内有折扣.
              const SizedBox(height: 10),

              ///设置VIP特权 logo
              Visibility(
                visible: (state.selectVipItem?.newPrivilege?.length ?? 0) > 0,
                child: ImageLoader.withP(ImageType.IMAGE_SVG,
                        address: AssetsSvg.ICON_USER_VIP_PRIVILEGE,
                        width: Dimens.pt130)
                    .load(),
              ),

              ///配置VIP 权限网格列表
              Visibility(
                visible: (state.selectVipItem?.newPrivilege?.length ?? 0) > 0,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                      Dimens.pt32,
                      AppPaddings.appMargin,
                      Dimens.pt32,
                      AppPaddings.appMargin),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: state.selectVipItem?.newPrivilege?.length ?? 0,
                  itemBuilder: (context, index) {
                    Privilege privilege = state.selectVipItem?.newPrivilege[index];
                    return Container(
                      child: Column(
                        children: [
                          ClipOval(
                            child: CustomNetworkImage(
                              imageUrl: privilege?.img ?? "",
                              width: Dimens.pt48,
                              height: Dimens.pt48,
                              fit: BoxFit.cover,
                              type: ImgType.avatar,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            privilege?.privilegeName ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(0xFF686869),
                                fontSize: AppFontSize.fontSize12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      _buildSubmitPayUI(state, viewService),
      const SizedBox(height: 8),
    ],
  );
}

///倒计时控件
Container _buildCutDownUI() {
  return Container(
    margin: EdgeInsets.only(top: 2),
    padding: EdgeInsets.only(left: 8, right: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: Color.fromRGBO(56, 56, 56, 1),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "限时：",
          style: TextStyle(
              color: Color(0xffffe495), fontSize: AppFontSize.fontSize10),
        ),
        Consumer<CountdwonUpdate>(
          builder: (context, value, Widget child) {
            Countdown countdown = value.countdown;
            return VIPCountDownWidget(
              seconds: countdown.countdownSec ?? 0,
              countdownEnd: () {},
            );
          },
        ),
      ],
    ),
  );
}

///创建支付按钮UI
Widget _buildSubmitPayUI(VIPState state, ViewService viewService) {
  return Column(
    children: [
      commonSubmitButton("立即充值", onTap: () {
        if (state.curTabVipItem == null && state.vipListModel == null) {
          return;
        }
        var args = PayForArgs(
            dcModel: state.vipListModel?.daichong,
            isDialog: false,
            vipitem: state.selectVipItem,
            curTabVipItem: state.curTabVipItem);
        showPayListDialog(viewService.context, args);
      }),
      GestureDetector(
        onTap: () => csManager.openServices(viewService.context),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "支付中如有问题，请在线联系 ",
                      style: TextStyle(
                        color: AppColors.userPayTextColor.withAlpha(59),
                        fontSize: AppFontSize.fontSize10,
                      ),
                    ),
                    TextSpan(
                      text: '联系客服',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSize.fontSize10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

/// select item card
Widget _selectCutDownVipItemView(ProductItemBean item, Dispatch dispatch,
    {VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Stack(
      children: [
        Container(
          height: Dimens.pt142,
          width: Dimens.pt105,
          margin: EdgeInsets.only(top: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(Dimens.pt4)),
            gradient: LinearGradient(colors: [
              Color(0xfff4d88a),
              Color(0xffd6be7e).withOpacity(0.37),
              Color(0xffc3ae76).withOpacity(0.30)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              ///背景图
              Container(
                margin: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff3b341f),
                      Color(0xff2b2b2b),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(Dimens.pt4)),
                ),
              ),

              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 5),
                        Container(
                          margin: EdgeInsets.only(
                              left: Dimens.pt5, right: Dimens.pt5),
                          padding: EdgeInsets.only(
                              top: Dimens.pt3, bottom: Dimens.pt3),
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(Dimens.pt8),
                                bottomRight: Radius.circular(Dimens.pt8)),
                            // gradient: LinearGradient(
                            //     colors: [
                            //       Color(0xffe8ce84),
                            //       Color(0xffab9866).withOpacity(0.58)
                            //     ],
                            //     begin: Alignment.topCenter,
                            //     end: Alignment.bottomCenter),
                          ),
                          child: Text(
                            (item.productName ?? "").isEmpty
                                ? ""
                                : (item.productName.length > 6
                                    ? item.productName.substring(0, 6)
                                    : item.productName),
                            style: TextStyle(
                                fontSize: Dimens.pt13,
                                color: Color(0xffddc57e),
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                          ),
                        ),
                        // SizedBox(height: Dimens.pt7),
                        Container(
                          padding: EdgeInsets.only(bottom: 2),
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text: "￥",
                                  style: TextStyle(
                                      fontSize: Dimens.pt15,
                                      color: Color(0xffddc57e),
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: "${(item.discountedPrice ?? 0) ~/ 10}",
                                style: TextStyle(
                                    fontSize: Dimens.pt27,
                                    color: Color(0xffddc57e),
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ),
                        ),
                        Text(
                          "${Lang.WORD_ORIGINAL_PRICE}:￥${(item.originalPrice ?? 0) ~/ 10}",
                          style: TextStyle(
                            fontSize: Dimens.pt10,
                            color: Color(0xff968659),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: Dimens.pt7),
                        Container(
                          height: 0.8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xff2b2b2b).withOpacity(0.56),
                                  Color(0xffab9866),
                                  Color(0xff2b2b2b).withOpacity(0.56)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight),
                          ),
                        ),
                        SizedBox(height: Dimens.pt4),
                        Text(
                          (item.actionDesc ?? "").isEmpty
                              ? ""
                              : item.actionDesc,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: Dimens.pt10,
                            color: Color(0xff968659),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: Dimens.pt2),
                        Text(
                          (item.desc ?? "").isEmpty ? "" : item.desc,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: Dimens.pt9,
                            color: Color(0xff968659),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        _buildCutDownUI(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        (item?.tag ?? "") != ""
            ? Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.only(
                      left: Dimens.pt10,
                      right: Dimens.pt10,
                      top: Dimens.pt3,
                      bottom: Dimens.pt10),
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      // color: Color.fromRGBO(0, 0, 0, 0),
                      image: DecorationImage(
                    image: AssetImage(AssetsImages.VIP_LABEL_BG),
                    fit: BoxFit.fill,
                  )),
                  child: Text(
                    item?.tag ?? "",
                    style:
                        TextStyle(color: Colors.white, fontSize: Dimens.pt12),
                  ),
                ),
              )
            : Container(),
      ],
    ),
  );
}

/// select item card
Widget _selectVipItemView(ProductItemBean item, Dispatch dispatch,
    {VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Stack(
      children: [
        Container(
          height: Dimens.pt142,
          width: Dimens.pt105,
          margin: EdgeInsets.only(top: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(Dimens.pt4)),
            gradient: LinearGradient(colors: [
              Color(0xfff4d88a),
              Color(0xffd6be7e).withOpacity(0.37),
              Color(0xffc3ae76).withOpacity(0.30)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Stack(
            // alignment: AlignmentDirectional.center,
            clipBehavior: Clip.none,
            // fit: StackFit.loose,
            // overflow: Overflow.visible,
            children: <Widget>[
              ///背景图
              Container(
                margin: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff3b341f),
                      Color(0xff2b2b2b),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(Dimens.pt4)),
                ),
              ),

              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 11),
                        Container(
                          margin: EdgeInsets.only(
                              left: Dimens.pt5, right: Dimens.pt5),
                          padding: EdgeInsets.only(
                              top: Dimens.pt3, bottom: Dimens.pt3),
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(Dimens.pt8),
                                bottomRight: Radius.circular(Dimens.pt8)),
                            // gradient: LinearGradient(
                            //     colors: [
                            //       Color(0xffe8ce84),
                            //       Color(0xffab9866).withOpacity(0.58)
                            //     ],
                            //     begin: Alignment.topCenter,
                            //     end: Alignment.bottomCenter),
                          ),
                          child: Text(
                            (item.productName ?? "").isEmpty
                                ? ""
                                : (item.productName.length > 6
                                    ? item.productName.substring(0, 6)
                                    : item.productName),
                            style: TextStyle(
                                fontSize: Dimens.pt13,
                                color: Color(0xffddc57e),
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                          ),
                        ),
                        // SizedBox(height: 11),
                        Container(
                          padding: EdgeInsets.only(bottom: 3),
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text: "￥",
                                  style: TextStyle(
                                      fontSize: Dimens.pt17,
                                      color: Color(0xffddc57e),
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: "${(item.discountedPrice ?? 0) ~/ 10}",
                                style: TextStyle(
                                    fontSize: Dimens.pt30,
                                    color: Color(0xffddc57e),
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ),
                        ),
                        Text(
                          "${Lang.WORD_ORIGINAL_PRICE}:￥${(item.originalPrice ?? 0) ~/ 10}",
                          style: TextStyle(
                            fontSize: Dimens.pt11,
                            color: Color(0xff968659),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: Dimens.pt10),
                        Container(
                          height: 0.8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xff2b2b2b).withOpacity(0.56),
                                  Color(0xffab9866),
                                  Color(0xff2b2b2b).withOpacity(0.56)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight),
                          ),
                        ),
                        SizedBox(height: Dimens.pt6),
                        Text(
                          (item.actionDesc ?? "").isEmpty
                              ? ""
                              : item.actionDesc,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: Dimens.pt12,
                            color: Color(0xff968659),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: Dimens.pt3),
                        Text(
                          (item.desc ?? "").isEmpty ? "" : item.desc,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: Dimens.pt10,
                            color: Color(0xff968659),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              ///标签
            ],
          ),
        ),
        (item?.tag ?? "") != ""
            ? Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.only(
                      left: Dimens.pt10,
                      right: Dimens.pt10,
                      top: Dimens.pt3,
                      bottom: Dimens.pt10),
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      // color: Color.fromRGBO(0, 0, 0, 0),
                      image: DecorationImage(
                    image: AssetImage(AssetsImages.VIP_LABEL_BG),
                    fit: BoxFit.fill,
                  )),
                  child: Text(
                    item?.tag ?? "",
                    style:
                        TextStyle(color: Colors.white, fontSize: Dimens.pt12),
                  ),
                ),
              )
            : Container(),
      ],
    ),
  );
}

/// default item card
Widget _defaultVipItemView(ProductItemBean item, Dispatch dispatch,
    {VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          width: Dimens.pt102,
          height: Dimens.pt130,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(Dimens.pt4)),
            color: Color(0xff5c5c5c).withOpacity(0.24),
          ),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              ///背景图
              Container(
                margin: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.pt4),
                  color: Color(0xff1f1f1f),
                ),
              ),

              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 5, right: 5, top: 11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          (item.productName ?? "").isEmpty
                              ? ""
                              : (item.productName.length > 6
                                  ? item.productName.substring(0, 6)
                                  : item.productName),
                          style: TextStyle(
                              fontSize: Dimens.pt12,
                              color: Color(0xffc7c7c7).withOpacity(0.5),
                              fontWeight: FontWeight.w500),
                          maxLines: 1,
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.only(bottom: 3),
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                  text: "￥",
                                  style: TextStyle(
                                      fontSize: Dimens.pt17,
                                      color: Color(0xffc7c7c7).withOpacity(0.6),
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                text: "${(item.discountedPrice ?? 0) ~/ 10}",
                                style: TextStyle(
                                    fontSize: Dimens.pt22,
                                    color: Color(0xffc7c7c7).withOpacity(0.6),
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ),
                        ),
                        Text(
                          "${Lang.WORD_ORIGINAL_PRICE}:￥${(item.originalPrice ?? 0) ~/ 10}",
                          style: TextStyle(
                            fontSize: Dimens.pt11,
                            color: Colors.white.withOpacity(0.4),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(height: Dimens.pt6),
                        Container(
                          height: 0.8,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xff2b2b2b).withOpacity(0.26),
                                  Colors.white12,
                                  Color(0xff2b2b2b).withOpacity(0.26)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight),
                          ),
                        ),
                        SizedBox(height: Dimens.pt5),
                        Text(
                          (item.actionDesc ?? "").isEmpty
                              ? ""
                              : item.actionDesc,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: Dimens.pt11,
                            color: Color(0xff8f8f8f),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: Dimens.pt3),
                        Text(
                          (item.desc ?? "").isEmpty ? "" : item.desc,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: Dimens.pt9,
                            color: Color(0xff8f8f8f),
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
