import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/coupon_entity.dart';
import 'package:flutter_app/model/user/product_item.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_svg/svg.dart';

import 'common_widget/loading_widget.dart';
import 'dialog/payfor_confirm_dialog.dart';

class CouponWidget extends StatefulWidget {
  ProductItemBean vipItem;
  CouponWidget(this.vipItem, {Key key}) : super(key: key);

  @override
  _CouponWidgetState createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  bool isCouponUse = false; //是否使用优惠券
  List isCouponUseList = []; //选择框数组
  CouponData couponData; //当前会员卡优惠数据
  int curCheckboxIndex; //当前选择框选择的索引
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getCoupon(widget.vipItem.productType, widget.vipItem.productID);
  }

//获取优惠券
  Future getCoupon(int productType, String productID) async {
    try {
      setState(() {
        isLoading = true;
      });
      var result = await netManager.client.getCoupon(
        productType,
        productID,
      );
      isLoading = false;
      couponData = CouponData().fromJson(result);
      List<CouponDataCouponList> list = couponData.couponList ?? [];
      for (int i = 0; i < list.length; i++) {
        isCouponUseList.add(false);
      }
      setState(() {});
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

//确认支付
  paying() async {
    int productType = widget.vipItem.productType;
    String productID = widget.vipItem.productID;
    String productName = widget.vipItem.productName;
    int discountedPrice = widget.vipItem.discountedPrice;
    String couponId;
    if (curCheckboxIndex != null &&
        isCouponUseList[curCheckboxIndex] &&
        curCheckboxIndex < couponData.couponList.length) {
      couponId = couponData.couponList[curCheckboxIndex].id;
      discountedPrice = couponData.couponList[curCheckboxIndex].discountedPrice;
    }
    try {
      setState(() {
        isLoading = true;
      });
      var result = await netManager.client.buyVipProduct(
          productType, productID, productName, discountedPrice,
          couponId: couponId);
      isLoading = false;
      if (null == result) {
        showToast(msg: "购买vip失败");
        return;
      }
      Navigator.of(context).pop();
      showToast(
          msg: Lang.sprint(Lang.SUCCESSFUL_PURCHASE,
              args: [widget.vipItem.productName]));

      setState(() {});
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

//优惠券组件
  Widget coupon() {
    List<CouponDataCouponList> couponList = couponData.couponList ?? [];
    return couponList.length > 0
        ? ListView.separated(
        itemCount: couponList.length,
        separatorBuilder: (BuildContext context, int index) {
          return line();
        },
        itemBuilder: (context, index) {
          String name = couponList[index].name ?? "";
          int count = couponList[index].count ?? 0;
          return Padding(
            padding: EdgeInsets.all(Dimens.pt16),
            child: Row(
              children: [
                Container(
                  width: Dimens.pt140,
                  padding: EdgeInsets.only(right: Dimens.pt20),
                  child: Text(
                    "$name",
                    style: TextStyle(
                        color: Color.fromRGBO(219, 10, 10, 0.5),
                        fontSize: Dimens.pt12,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("剩余：$count",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.5),
                            fontSize: Dimens.pt12,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                Spacer(),
                count > 0
                    ? Container(
                  height: Dimens.pt20,
                  child: Checkbox(
                    value: isCouponUseList[index],
                    activeColor: Colors.red, //选中时的颜色
                    onChanged: (value) {
                      setState(() {
                        isCouponUseList.clear();
                        for (int i = 0;
                        i < couponData.couponList.length;
                        i++) {
                          isCouponUseList.add(false);
                        }
                        isCouponUseList[index] = value;
                        curCheckboxIndex = index;
                      });
                    },
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    JRouter().go(Address.activityUrl);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("去抽奖",
                          style: TextStyle(
                              color: Color.fromRGBO(255, 0, 0, 0.5),
                              fontSize: Dimens.pt12,
                              fontWeight: FontWeight.w500)),
                      Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: Dimens.pt12,
                        color: Color.fromRGBO(255, 0, 0, 0.5),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        })
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    bool isCouponData = couponData != null && couponData.couponList.length > 0;
    return Container(
      height: isCouponData ? null : Dimens.pt300,
      child: isLoading
          ? Container(
        height: Dimens.pt300,
        child: Center(
          child: LoadingWidget(),
        ),
      )
          : Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          header(
              couponData, isCouponUse, isCouponUseList, curCheckboxIndex),
          // Spacer(),
          Expanded(child: coupon()),
          exchgButton("确认兑换", () {
            paying();
          }),
          SizedBox(
            height: Dimens.pt57,
          ),
        ],
      ),
    );
  }
}

//线
Widget line() {
  return Container(
    height: Dimens.pt1,
    margin: EdgeInsets.only(left: Dimens.pt16, right: Dimens.pt16),
    color: Color.fromRGBO(0, 0, 0, 0.1),
  );
}

//header
Widget header(CouponData couponData, bool isCouponUse, List isCouponUseList,
    int curCheckboxIndex) {
  int discountedPrice = couponData.discountedPrice ?? 0;
  int originalPrice = couponData.originalPrice ?? 0;
  String name = "";
  if (curCheckboxIndex != null && isCouponUseList[curCheckboxIndex]) {
    name = couponData.couponList[curCheckboxIndex].name;
    discountedPrice = couponData.couponList[curCheckboxIndex].discountedPrice;
  }
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.only(top: Dimens.pt22, bottom: Dimens.pt10),
        child: name != null && name != ""
            ? Center(
          child: Text("您使用$name",
              style: TextStyle(
                  fontSize: Dimens.pt12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff333333))),
        )
            : Container(),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg/icon_gold_coin.svg",
            width: Dimens.pt38,
            height: Dimens.pt38,
          ),
          Text(
            "$discountedPrice",
            style: TextStyle(
              fontSize: Dimens.pt40,
              color: Color(0xFFDE252B),
            ),
          )
        ],
      ),
      Row(
        children: [
          Spacer(),
          Text(
            "原价：",
            style: TextStyle(
                color: Color(0xff333333), fontWeight: FontWeight.w400),
          ),
          Text(
            "$originalPrice金币",
            style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Color(0xff333333),
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            width: Dimens.pt40,
          )
        ],
      ),
      SizedBox(
        height: Dimens.pt20,
      ),
      line(),
    ],
  );
}

//兑换按钮
Widget exchgButton(String title, Function onTap) {
  return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: Dimens.pt290,
        height: Dimens.pt38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(Dimens.pt20)),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(245, 22, 78, 1),
            Color.fromRGBO(255, 101, 56, 1),
            Color.fromRGBO(245, 68, 4, 1),
          ], begin: Alignment.centerLeft, end: Alignment.centerRight),
          boxShadow: [
            BoxShadow(
//阴影
              color: Color.fromRGBO(248, 44, 44, 0.4),
              offset: Offset(0.0, 1.0),
              blurRadius: 8.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        margin: EdgeInsets.only(
            left: Dimens.pt36, right: Dimens.pt36, top: Dimens.pt20),
        child: Text(
          "$title",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: Dimens.pt16),
        ),
      ));
}
