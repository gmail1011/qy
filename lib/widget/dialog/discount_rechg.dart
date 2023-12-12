import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/coupon_entity.dart';
import 'package:flutter_app/model/user/product_item.dart';
import 'package:flutter_app/widget/coupon_widget.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_svg/svg.dart';

Future openDiscountBottomSheet({
  @required BuildContext context,
  @required ProductItemBean vipItem,
}) async {
  await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.pt26),
              topRight: Radius.circular(Dimens.pt26))),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CouponWidget(vipItem);
      });
}
