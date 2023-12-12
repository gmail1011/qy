import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/app_fontsize.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/common/image/image_loader.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/page/wallet/pay_for/model/pay_type.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_base/utils/toast_util.dart';

import '../action.dart';
import '../state.dart';

Widget buildView(
    PayForNakeChatState state, Dispatch dispatch, ViewService viewService) {
  return Container(
    child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  csManager.openServices(viewService.context);
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: Lang.PAY_TYPE,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppFontSize.fontSize16,
                                  ),
                                ),
                                TextSpan(
                                  text: '（如有问题，请点击',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppFontSize.fontSize10,
                                  ),
                                ),
                                TextSpan(
                                  text: '联系客服',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: AppFontSize.fontSize10,
                                  ),
                                ),
                                TextSpan(
                                  text: '）',
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
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: state.vipItem != null && state.vipItem.isAmountPay,
                child: GestureDetector(
                  onTap: () {
                    dispatch(PayForActionCreator.glodBuyVip());
                  },
                  child: Column(
                    children: [
                      Container(
                        color: Color.fromRGBO(0, 0, 0, 0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: Dimens.pt20,
                                height: Dimens.pt20,
                                child: svgAssets(AssetsSvg.IC_GOLD,
                                    width: Dimens.pt20, height: Dimens.pt20),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: Dimens.pt10),
                                  child: Text(
                                    Lang.PAY_FOR_TIP6,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Dimens.pt12),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.navigate_next,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ImageLoader.withP(ImageType.IMAGE_ASSETS,
                              address: AssetsImages.LINE,
                              width: screen.screenWidth)
                          .load(),
                    ],
                  ),
                ),
              ),
              ListView.separated(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (BuildContext context, int index) {
                  return ImageLoader.withP(ImageType.IMAGE_ASSETS,
                          address: AssetsImages.LINE, width: screen.screenWidth)
                      .load();
                },
                itemBuilder: (BuildContext context, int index) {
                  PayType payType = state.payList[index];
                  String giftStr = '';
                  if (payType.increaseAmount != null &&
                      payType.increaseAmount != '0') {
                    giftStr = "赠送${payType.increaseAmount}${Lang.GOLD_COIN}";
                  } else if (payType.incTax != null && payType.incTax != '0') {
                    giftStr = "赠送${payType.increaseAmount}%";
                  }
                  return GestureDetector(
                    onTap: () {
                      if (!state.isPayLoading) {
                        dispatch(PayForActionCreator.onConventional(index));
                      } else {
                        showToast(msg: Lang.PAYING_TIP);
                      }
                    },
                    child: Container(
                      color: Color.fromRGBO(0, 0, 0, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: Dimens.pt20,
                              height: Dimens.pt20,
                              child: svgAssets(payType.localImgPath,
                                  width: Dimens.pt20, height: Dimens.pt20),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: Dimens.pt10),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      payType.typeName,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Dimens.pt12),
                                    ),
                                    Visibility(
                                      visible: payType.isOfficial,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: Dimens.pt5),
                                        child: Text(
                                          '(官方推荐)',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Dimens.pt12),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: giftStr.isNotEmpty,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: Dimens.pt3,
                                    horizontal: Dimens.pt5),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 248, 215, 215),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimens.pt15)),
                                ),
                                child: Text(
                                  giftStr,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 248, 0, 0),
                                      fontSize: Dimens.pt10),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: state.payList.length,
              ),
            ],
          ),
        ),
        Visibility(
          visible: state.isPayLoading,
          child: LoadingWidget(),
        ),
      ],
    ),
  );
}
