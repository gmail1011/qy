import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/app_padding.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/page/wallet/pay_for_nake_chat/NakeChatBillDetailPage.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/model/recharge_type_list_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_app/utils/svg_util.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    WalletState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
        /*appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(Lang.WALLET),
          //文字title居中
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                dispatch(WalletActionCreator.onBack());
              }),
          actions: <Widget>[
            FlatButton(
              child: Text(
                Lang.COMMON_QA,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              onPressed: () {
                JRouter().handleAdsInfo(Address.commonQuestion);
              },
            )
          ],
        ),*/

        appBar: getCommonAppBar("我的钱包", actions: <Widget>[
          FlatButton(
            child: Text(
              Lang.COMMON_QA,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            onPressed: () {
              JRouter().handleAdsInfo(Address.commonQuestion);
            },
          ),
        ]),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TabBar(
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: Dimens.pt14,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: Dimens.pt14,
              ),
              onTap: (index) {
                /* if (index == state.oldTabIndex) {
                  return;
                }
                var item = state.vipListModel.list[index];
                var vipitem = item.vips.first;
                dispatch(MemberCentreActionCreator.onChangeOldTabIndex(
                    index));
                dispatch(
                    MemberCentreActionCreator.onChangeItem(vipitem));*/
              },
              controller: state.tabBarController,
              unselectedLabelColor: Colors.white.withOpacity(0.4),
              labelColor: Colors.white,
              tabs: [Tab(text: "金币钱包"), Tab(text: "果币钱包")],
            ),
            Container(
              width: double.infinity,
              height: 0.5,
              color: AppColors.divideColor,
            ),
            Container(
              height: 16,
            ),
            Expanded(
              child: TabBarView(
                controller: state.tabBarController,
                children: [
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Text(
                            Lang.WALLET_BALANCE,
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
                                        setBalanceValue(state.wallet),
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
                                Row(
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
                                SizedBox(
                                  height: 27.0,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppPaddings.appMargin),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      getLinearGradientBtn(
                                        Lang.WITHDRAW,
                                        horizontal: false,
                                        enableColors: [Color.fromRGBO(201, 115, 255, 1),Color.fromRGBO(246, 168, 225, 1),],
                                        onTap: () {
                                          dispatch(
                                              WalletActionCreator.onWithdraw());
                                        },
                                      ),
                                      getLinearGradientBtn(
                                        Lang.BILL,
                                        horizontal: false,
                                        enableColors: [Color.fromRGBO(201, 115, 255, 1),Color.fromRGBO(246, 168, 225, 1),],
                                        onTap: () {
                                          //账单
                                          JRouter().go(PAGE_MY_BILL);
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ImageLoader.withP(ImageType.IMAGE_ASSETS,
                                    address: AssetsImages.LINE,
                                    width: screen.screenWidth)
                                .load(),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: BaseRequestView(
                            controller: state.baseRequestController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //充值
                                Text(Lang.RECHARGE_HINT,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                                Container(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(
                                      top: 10,
                                      left: 10,
                                      right: 10,
                                      bottom: 10,
                                    ),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 37,
                                      childAspectRatio: 1.2,
                                    ),
                                    itemCount: state.rechargeType?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      var item = state.rechargeType[index];
                                      return _rechargeItem(item, () {
                                        dispatch(WalletActionCreator.selctItem(
                                            index));
                                      }, index == state.selectIndex);
                                    },
                                  ),
                                ),

                                viewService.buildComponent("PayForComponent"),
                                SizedBox(
                                  height: 60,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: AppPaddings.appMargin),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Text(
                            "果币餘額",
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
                                        setNakeChatBalanceValue(state.wallet),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 34,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: Dimens.pt20,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: AppPaddings.appMargin),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      getLinearGradientBtn(
                                        Lang.BILL,
                                        horizontal: false,
                                        enableColors: [Color.fromRGBO(201, 115, 255, 1),Color.fromRGBO(246, 168, 225, 1),],
                                        onTap: () {
                                          //账单
                                          Navigator.push(viewService.context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return NakeChatBillDetailPage();
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ImageLoader.withP(ImageType.IMAGE_ASSETS,
                                    address: AssetsImages.LINE,
                                    width: screen.screenWidth)
                                .load(),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: BaseRequestView(
                            controller: state.baseRequestController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //充值
                                Text(Lang.RECHARGE_HINT,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                                Container(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(
                                      top: 10,
                                      left: 10,
                                      right: 10,
                                      bottom: 10,
                                    ),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 37,
                                      childAspectRatio: 1.2,
                                    ),
                                    itemCount:
                                        state.nakeChatRechargeType?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      var item =
                                          state.nakeChatRechargeType[index];
                                      return _rechargeItem(item, () {
                                        dispatch(WalletActionCreator
                                            .selctNakeChatItem(index));
                                      }, index == state.selectNakeChatIndex);
                                    },
                                  ),
                                ),

                                viewService
                                    .buildComponent("PayForNakeChatComponent"),
                                SizedBox(
                                  height: 60,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
  );
}

Widget _rechargeItem(
    RechargeTypeModel item, VoidCallback onTop, bool isSelect) {
  return InkWell(
      onTap: onTop,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: LinearGradient(
              colors: isSelect
                  ? [Color(0xFF2A72E3), Color(0xFF0057BB)]
                  : [Color(0xFF303150), Color(0xFF303150)],
            )),
        alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                svgAssets(
                  AssetsSvg.IC_GOLD,
                  width: Dimens.pt13,
                  height: Dimens.pt13,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '${item.amount}',
                  style: TextStyle(
                    fontSize: Dimens.pt12,
                    color: Color(0xFFFEF08C),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "${(item.money) ~/ 100}${Lang.YUAN}",
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimens.pt12,
              ),
            ),
            Visibility(
              visible: item.couponDesc == null || item.couponDesc == ""
                  ? false
                  : true,
              child: Spacer(),
            ),
            Visibility(
              visible: item.couponDesc == null || item.couponDesc == ""
                  ? false
                  : true,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(3),
                      bottomRight: Radius.circular(3)),
                  //color: isSelect ? Color(0xFF303150) : Color.fromRGBO(31,117,225,0.4),
                  gradient: LinearGradient(
                    colors: isSelect || item.couponDesc == null
                        ? [Color(0xFF303150), Color(0xFF303150)]
                        : [Color(0xFF2A72E3), Color(0xFF0057BB)],
                  ),
                ),
                child: Text(
                  item.couponDesc ?? " ",
                  maxLines: 1,
                  style: TextStyle(
                    color: Color(0xFFFEF08C),
                    fontSize: Dimens.pt10,
                  ),
                ),
              ),
            )
          ],
        ),
      ));
}

String setBalanceValue(WalletModelEntity model) {
  if (model == null) {
    return "";
  }
  int balance = (model.amount ?? 0) + (model.income ?? 0);
  return balance.toString();
}

String setNakeChatBalanceValue(WalletModelEntity model) {
  if (model == null) {
    return "";
  }
  int balance = model.fruitCoin;
  return balance.toString();
}
