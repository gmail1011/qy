import 'package:auto_orientation/auto_orientation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/page/home/post/ads_banner_widget.dart';
import 'package:flutter_app/page/wallet/game_bill_detail/GameBillDetailPage.dart';
import 'package:flutter_app/page/wallet/pay_for/pay_for_game_page/state.dart';
import 'package:flutter_app/utils/EventBusUtils.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    WalletState state, Dispatch dispatch, ViewService viewService) {
  AutoOrientation.portraitAutoMode();

  if (Config.webView != null) {
    Config.webView.android.pause();
  }

  return FullBg(
    child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(Lang.GAMEWALLET),
          //文字title居中
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                dispatch(WalletActionCreator.onBack());
              }),
          // actions: <Widget>[
          //   FlatButton(
          //     child: Text(
          //       Lang.COMMON_QA,
          //       style: TextStyle(color: Colors.white, fontSize: 14),
          //     ),
          //     onPressed: () {
          //       JRouter().handleAdsInfo(Address.commonQuestion);
          //     },
          //   )
          // ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Text(
                  Lang.GAME_WALLET_BALANCE,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(width: 15.0),
                          svgAssets(
                            AssetsSvg.IC_GOLD,
                            width: 27.5,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15.0),
                            child: Text(
                              Config.gameBalanceEntity == null ||
                                      Config.gameBalanceEntity.wlTransferable ==
                                          null
                                  ? "0"
                                  : Config.gameBalanceEntity.wlTransferable
                                      .toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Visibility(
                        visible: false,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 40.0,
                            ),
                            Text(
                              Lang.sprint(Lang.WALLET_ALL_GLOD, args: [
                                state.wallet?.amount ?? "0",
                                state.wallet?.income ?? "0",
                              ]),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Dimens.pt12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 27.0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: AppPaddings.appMargin),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            getLinearGradientBtn(
                              Lang.WITHDRAW,
                              horizontal: false,
                              enableColors: [
                                Color(0xFFF1DCB9),
                                Color(0xFFFFCC6E),
                              ],
                              textColor: Colors.black,
                              width: Dimens.pt90,
                              onTap: () {
                                dispatch(WalletActionCreator.onWithdraw());
                              },
                            ),
                            /*getLinearGradientBtn(
                              Lang.TRANSFER,
                              width: Dimens.pt90,
                              onTap: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: viewService.context,
                                    builder: (ctx) => Dialog(
                                          backgroundColor: Colors.white,
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          child: Container(
                                            height: 220,
                                            width: 50,
                                            color: Colors.transparent,
                                            child: TransferDialog(
                                              title: "余额划拨",
                                              content: "APP余额需要划转到游戏余额才可进行游戏！",
                                              negativeText: "取消",
                                              postiveText: "确定",
                                              gameBalanceEntity:
                                                  Config.gameBalanceEntity,
                                              negtiveMethod: () {
                                                Navigator.of(
                                                        viewService.context)
                                                    .pop();
                                              },
                                              postiveMethod: () {},
                                            ),
                                          ),
                                        )).then((value) async {
                                  await netManager.client.getBalance();
                                  dispatch(WalletActionCreator.refreshAmount(
                                      Config.gameBalanceEntity.wlTransferable));
                                });
                              },
                            ),*/
                            getLinearGradientBtn(
                              Lang.BILL,
                              horizontal: false,
                              enableColors: [
                                Color(0xFFF1DCB9),
                                Color(0xFFFFCC6E),
                              ],
                              width: Dimens.pt90,
                              textColor: Colors.black,
                              onTap: () {
                                //账单
                                Navigator.push(viewService.context,
                                    MaterialPageRoute(builder: (context) {
                                  return GameBillDetailPage();
                                }));
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Offstage(
                  offstage: state.resultList.length == 0 ? false : true,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ImageLoader.withP(ImageType.IMAGE_ASSETS,
                            address: AssetsImages.LINE,
                            width: screen.screenWidth)
                        .load(),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Offstage(
                  offstage: state.resultList.length == 0 ? true : false,
                  child: Container(
                    width: Dimens.pt360,
                    height: Dimens.pt100,
                    margin: EdgeInsets.only(
                      bottom: Dimens.pt16,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      child: Container(
                        height: Dimens.pt100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: Container(
                          width: screen.screenWidth,
                          height: Dimens.pt100,
                          child: Stack(
                            children: <Widget>[
                              CarouselSlider(
                                options: CarouselOptions(
                                    height: Dimens.pt100,
                                    enableInfiniteScroll:
                                        state.resultList.length == 1
                                            ? false
                                            : true,
                                    autoPlay: state.resultList.length == 1
                                        ? false
                                        : true,
                                    viewportFraction: 1,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    onPageChanged: (int index,
                                        CarouselPageChangedReason reason) {
                                      dispatch(
                                          WalletActionCreator.selctBannerItem(
                                              index));
                                    }),
                                items: state.resultList.map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return GestureDetector(
                                        onTap: () {
                                          var ad = i;
                                          if (ad.href.contains("game_page")) {
                                            Navigator.of(FlutterBase.appContext)
                                                .pop();
                                            bus.emit(EventBusUtils.gamePage);
                                          } else {
                                            JRouter().handleAdsInfo(ad.href,
                                                id: ad.id);
                                          }
                                        },
                                        child: Container(
                                          width: screen.screenWidth,
                                          child: AspectRatio(
                                            aspectRatio: (Dimens.pt360 ?? 360) /
                                                (Dimens.pt100 ?? 250),
                                            child: CustomNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl: i.cover,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              Positioned(
                                bottom: Dimens.pt10,
                                right: Dimens.pt10,
                                child: CIndicator(
                                  itemCount: state.resultList.length ?? 0,
                                  selectIndex: state.selectBannerIndex,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: BaseRequestView(
                  controller: state.baseRequestController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //充值
                      Text(Lang.RECHARGE_GAME_HINT,
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Container(
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                            top: 10,
                            // left: 16,
                            // right: 16,
                            bottom: 10,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 9,
                            childAspectRatio: 115 / 70,
                          ),
                          itemCount: state.rechargeType?.length ?? 0,
                          itemBuilder: (context, index) {
                            var item = state.rechargeType[index];
                            bool isSelect = index == state.selectIndex;
                            return isSelect
                                ? _rechargeSelectItem(item, () {
                                    dispatch(
                                        WalletActionCreator.selctItem(index));
                                  })
                                : _rechargeItem(item, () {
                                    dispatch(
                                        WalletActionCreator.selctItem(index));
                                  });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        alignment: Alignment.center,
                        child: commonSubmitButton("立即充值", onTap: () {
                          if (state.rechargeType == null &&
                              state.dcModel == null) {
                            return;
                          }
                          var arg = PayGameForArgs();
                          arg.dcModel = state.dcModel;
                          arg.rechargeModel =
                              state.rechargeType[state.selectIndex];
                          showGamePayListDialog(viewService.context, arg);
                        }),
                      ),
                      GestureDetector(
                        onTap: () =>
                            csManager.openServices(viewService.context),
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
                                        color: AppColors.userPayTextColor
                                            .withAlpha(59),
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
                      // const SizedBox(height: 8),

                      // viewService.buildComponent("PayForComponent"),
                      SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
  );
}

// Widget _rechargeItem(
//     RechargeTypeModel item, VoidCallback onTop, bool isSelect) {
//   return InkWell(
//       onTap: onTop,
//       child: Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(3),
//             gradient: LinearGradient(
//               colors: isSelect
//                   ? [Color(0xFF2A72E3), Color(0xFF0057BB)]
//                   : [Color(0xFF303150), Color(0xFF303150)],
//             )),
//         alignment: Alignment.center,
//         padding: EdgeInsets.only(top: 10),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 svgAssets(
//                   AssetsSvg.IC_GOLD,
//                   width: Dimens.pt13,
//                   height: Dimens.pt13,
//                 ),
//                 SizedBox(
//                   width: 5,
//                 ),
//                 Text(
//                   '${(item.money) ~/ 100}',
//                   style: TextStyle(
//                     fontSize: Dimens.pt12,
//                     color: Color(0xFFFEF08C),
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Text(
//               "${(item.money) ~/ 100}${Lang.YUAN}",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: Dimens.pt12,
//               ),
//             ),
//             Visibility(
//               visible: item.couponDesc == null || item.couponDesc == ""
//                   ? false
//                   : true,
//               child: Spacer(),
//             ),
//             Visibility(
//               visible: item.couponDesc == null || item.couponDesc == ""
//                   ? false
//                   : true,
//               child: Container(
//                 alignment: Alignment.center,
//                 padding: EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(3),
//                       bottomRight: Radius.circular(3)),
//                   //color: isSelect ? Color(0xFF303150) : Color.fromRGBO(31,117,225,0.4),
//                   gradient: LinearGradient(
//                     colors: isSelect || item.couponDesc == null
//                         ? [Color(0xFF303150), Color(0xFF303150)]
//                         : [Color(0xFF2A72E3), Color(0xFF0057BB)],
//                   ),
//                 ),
//                 child: Text(
//                   item.couponDesc ?? " ",
//                   maxLines: 1,
//                   style: TextStyle(
//                     color: Color(0xFFFEF08C),
//                     fontSize: Dimens.pt10,
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ));
// }

String setBalanceValue(WalletModelEntity model) {
  if (model == null) {
    return "";
  }
  int balance = (model.amount ?? 0) + (model.income ?? 0);
  return balance.toString();
}

///选中钱包金额item
Widget _rechargeSelectItem(RechargeTypeModel item, VoidCallback onTop) {
  bool hasSendAmountUI = (item?.couponDesc ?? "") != ""; //是否有赠送UI

  return InkWell(
    onTap: onTop,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.pt4)),
        gradient: LinearGradient(colors: [
          Color(0xfff4d88a),
          Color(0xffd6be7e).withOpacity(0.37),
          Color(0xffc3ae76).withOpacity(0.30)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      alignment: Alignment.center,
      child: Stack(
        children: [
          ///背景图
          Container(
            margin: const EdgeInsets.all(1),
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

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: hasSendAmountUI ? 7 : 0),
                child: Text(
                  "¥${(item.money) ~/ 100}",
                  style: TextStyle(
                    fontSize: hasSendAmountUI ? Dimens.pt11 : Dimens.pt12,
                    color: Color(0xff958658),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  svgAssets(AssetsSvg.NEW_GOLD_COIN,
                      width: Dimens.pt14, height: Dimens.pt14),
                  const SizedBox(width: 2),
                  Text(
                    '${item.amount}',
                    style: TextStyle(
                      color: Color(0xfff1d589),
                      fontWeight: FontWeight.bold,
                      fontSize: hasSendAmountUI ? Dimens.pt16 : Dimens.pt18,
                    ),
                  ),
                ],
              ),

              ///首充送金币
              if (hasSendAmountUI) Spacer(),
              if (hasSendAmountUI)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  height: Dimens.pt19,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff494231),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Dimens.pt4),
                      bottomRight: Radius.circular(Dimens.pt4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${item.couponDesc}",
                    style: TextStyle(
                      fontSize: Dimens.pt10,
                      color: Color(0xfff1d589),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

///选中钱包金额item
Widget _rechargeItem(RechargeTypeModel item, VoidCallback onTop) {
  bool hasSendAmountUI = (item?.couponDesc ?? "") != ""; //是否有赠送UI

  return InkWell(
    onTap: onTop,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(Dimens.pt4)),
        gradient: LinearGradient(colors: [
          Color(0xff5c5c5c).withOpacity(0.24),
          Color(0xff5c5c5c).withOpacity(0.24),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      alignment: Alignment.center,
      child: Stack(
        children: [
          ///背景图
          Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Color(0xff1f1f1f),
              borderRadius: BorderRadius.all(Radius.circular(Dimens.pt4)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: hasSendAmountUI ? 7 : 0),
                child: Text(
                  "¥${(item.money) ~/ 100}",
                  style: TextStyle(
                    fontSize: hasSendAmountUI ? Dimens.pt11 : Dimens.pt12,
                    color: Color(0xff848484),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  svgAssets(AssetsSvg.NEW_GOLD_COIN,
                      width: Dimens.pt14, height: Dimens.pt14),
                  const SizedBox(width: 2),
                  Text(
                    '${item.amount}',
                    style: TextStyle(
                      color: Color(0xff848484),
                      fontWeight: FontWeight.bold,
                      fontSize: hasSendAmountUI ? Dimens.pt16 : Dimens.pt18,
                    ),
                  ),
                ],
              ),

              ///首充送金币
              if (hasSendAmountUI) Spacer(),
              if (hasSendAmountUI)
                Container(
                  height: Dimens.pt19,
                  width: double.infinity,
                  // margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: Color(0xff3c3c3c),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Dimens.pt4),
                      bottomRight: Radius.circular(Dimens.pt4),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${item.couponDesc}",
                    style: TextStyle(
                      fontSize: Dimens.pt10,
                      color: Color(0xff787878),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
