import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/app_colors.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/common/image/custom_network_image.dart';
import 'package:flutter_app/common/manager/cs_manager.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/global_store/store.dart';
import 'package:flutter_app/model/user/integral_product_item.dart';
import 'package:flutter_app/model/user/new_product_list_model.dart';
import 'package:flutter_app/model/user/product_item.dart';
import 'package:flutter_app/model/user_info_model.dart';
import 'package:flutter_app/model/wallet_model_entity.dart';
import 'package:flutter_app/new_page/recharge/recharge_record_page.dart';
import 'package:flutter_app/page/wallet/pay_for/state.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/header_widget.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///充值会员
class RechargeVipPage extends StatefulWidget {
  final String specifyVipCardId;

  RechargeVipPage(this.specifyVipCardId);

  @override
  State<StatefulWidget> createState() {
    return _RechargeVipPageState();
  }
}

class _RechargeVipPageState extends State<RechargeVipPage> {
  NewProductList vipListModel;
  TabVipItem defaultTabVipItem;
  TabVipItem curTabVipItem;

  ProductItemBean selectVipItem;
  bool paying = false;
  int tabIndex = 0;
  int jumpPostion = 0;
  UserInfoModel meInfo;
  WalletModelEntity wallet;
  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();
  ScrollController scrollController = new ScrollController();
  ScrollController scrollControllerListView = ScrollController();

  @override
  void initState() {
    super.initState();
    meInfo = GlobalStore.getMe();
    wallet = GlobalStore.getWallet();
    _getNewVipList();
  }

  ///获取vip充值列表
  _getNewVipList() async {
    try {
      var model = await netManager.client.getNewVipTypeList();

      vipListModel = model;
      defaultTabVipItem = model.list?.first;
      List<ProductItemBean> vipList = model.list?.first?.vips;

      if (widget.specifyVipCardId != "") {
        for (int i = 0; i < model.list.first.vips.length; i++) {
          if (defaultTabVipItem.vips[i].productID == widget.specifyVipCardId) {
            // List<ProductItemBean> lastVipList = vipList.sublist(0, i);
            // List<ProductItemBean> firstVipList = vipList.sublist(i);
            // defaultTabVipItem.vips = [...firstVipList, ...lastVipList];
            // selectVipItem = model?.list?.first?.vips?.first;
            selectVipItem = defaultTabVipItem.vips[i];
            jumpPostion = i;
          }
        }
      } else {
        selectVipItem = defaultTabVipItem.vips?.first;
      }

      ///空处理
      if (defaultTabVipItem.vips == null) defaultTabVipItem.vips = [];
      defaultTabVipItem.vips.forEach((element) {
        if (element.newPrivilege == null) element.newPrivilege = [];
      });

      if ((model?.list?.length ?? 0) == 0) {
        requestController.requestDataEmpty();
      } else {
        requestController.requestSuccess();
      }
      refreshController.refreshCompleted();

      setState(() {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (jumpPostion > 0) {
            double pixelOffset = jumpPostion * 120.0;
            //将项滚动到中心位置
            scrollControllerListView.animateTo(pixelOffset, duration: Duration(milliseconds: 500), curve: Curves.ease);
          }
        });
      });
    } catch (e) {
      print("error");
      print(e);
      requestController.requestFail();
      refreshController.refreshFailed();
    }
  }

  void _exchangeIntegral(IntegralProductItem item) async {
    try {
      await netManager.client.exchangeIntegral(item.id);
      showToast(msg: "操作成功！");
      setState(() {
        wallet.integral -= item.price;
      });
    } catch (e) {
      l.e("_exchangeIntegral", e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        appBar: CustomAppbar(
          title: "会员中心",
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return RechargeRecordPage();
                }));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  "充值记录",
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                ),
              ),
            )
          ],
        ),
        backgroundColor: AppColors.primaryColor,
        body: Column(children: [
          Container(
            height: 50,
            margin: EdgeInsets.only(left: 16, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///用户名称-VIP时间
                HeaderWidget(
                  headPath: meInfo?.portrait ?? "",
                  level: (meInfo?.superUser ?? false) ? 1 : 0,
                  headWidth: 53,
                  headHeight: 53,
                  tabCallback: () {
                    if (TextUtil.isNotEmpty(meInfo?.portrait ?? false)) {
                      showPictureSwipe(context, [meInfo.portrait], 0);
                    }
                  },
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            meInfo == null ? Lang.UN_KNOWN : meInfo.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text(
                        "开通VIP全场畅看 "
                        "剩余可下载次数${wallet?.downloadCount ?? 0}",
                        style: TextStyle(
                            fontSize: 12,
                            color: GlobalStore.isVIP()
                                ? Color(0xfff5e5bf) // Color.fromRGBO(246, 197, 89, 1)
                                : Colors.white.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: BaseRequestView(
                controller: requestController,
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: pullYsRefresh(
                    enablePullUp: false,
                    refreshController: refreshController,
                    onRefresh: () async {
                      Future.delayed(Duration(milliseconds: 1000), () {
                        _getNewVipList();
                      });
                    },
                    child: CustomScrollView(controller: scrollController, slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          height: 30,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("开通VIP享受会员特权",
                                  style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 14.0),
                                  textAlign: TextAlign.left),
                              Text("",
                                  style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 14.0),
                                  textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          height: 170,
                          child: ListView.builder(
                              controller: scrollControllerListView,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: defaultTabVipItem == null ? 0 : defaultTabVipItem.vips.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildVipProductItemView(index, defaultTabVipItem.vips[index]);
                              }),
                        ),
                      ),
                      Visibility(
                        visible: selectVipItem != null && selectVipItem.newPrivilege != null,
                        child: SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          sliver: SliverGrid(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 70 / 116),
                            delegate: SliverChildBuilderDelegate((context, index) => _buildProductPrivilegeItemView(index),
                                childCount: selectVipItem == null
                                    ? 0
                                    : selectVipItem.newPrivilege == null
                                        ? 0
                                        : selectVipItem.newPrivilege.length ?? 0),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          height: 30,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("积分兑换VIP",
                                  style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 14.0),
                                  textAlign: TextAlign.left),
                              Text("当前积分:${wallet.integral}",
                                  style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 14.0),
                                  textAlign: TextAlign.left),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          height: 210,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: vipListModel == null
                                  ? 0
                                  : vipListModel.integralList == null
                                      ? 0
                                      : vipListModel.integralList.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildExchangeProductItemView(vipListModel.integralList[index]);
                              }),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 120,
            decoration:
                BoxDecoration(border: Border(top: BorderSide(color: Color(0xff4f4f4f), width: 0)), color: Color.fromRGBO(19, 19, 19, 1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (curTabVipItem == null && vipListModel == null) {
                      return;
                    }
                    var args =
                        PayForArgs(dcModel: vipListModel?.daichong, isDialog: false, vipitem: selectVipItem, curTabVipItem: curTabVipItem);
                    showPayListDialog(context, args);
                  },
                  child: Container(
                    height: 47,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(90)),
                      gradient: LinearGradient(colors: [
                        AppColors.primaryTextColor,
                        AppColors.primaryTextColor,
                      ]),
                    ),
                    child: Center(
                      child: Text(
                        "￥${(selectVipItem == null ? 0 : selectVipItem.discountedPrice ?? 0) ~/ 10} /立即支付",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () => csManager.openServices(context),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        style: TextStyle(
                          color: Color.fromRGBO(191, 191, 193, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                        ),
                        text: "支付问题反馈，点击联系  "),
                    TextSpan(
                        style: TextStyle(
                          color: AppColors.primaryTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                        ),
                        text: "在线客服"),
                  ])),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  ///VIP产品Item
  Widget _buildVipProductItemView(int index, ProductItemBean item) {
    var textColor = Colors.white;
    if (item.productID == selectVipItem.productID) {
      textColor = Colors.black;
    }
    return InkWell(
      onTap: () {
        setState(() {
          selectVipItem = item;
        });
      },
      child: Container(
        width: 110,
        height: 146,
        margin: EdgeInsets.symmetric(horizontal: 3),
        child: Stack(children: [
          Positioned(
            left: 0,
            top: 9,
            child: Container(
              width: 110,
              height: 146,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: selectVipItem != null && item.productID == selectVipItem.productID
                        ? [
                            Color.fromRGBO(255, 238, 220, 1),
                            Color.fromRGBO(250, 221, 193, 1),
                            Color.fromRGBO(238, 199, 178, 1),
                          ]
                        : [
                            Color.fromRGBO(32, 32, 32, 1),
                            Color.fromRGBO(32, 32, 32, 1),
                          ]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "${item.productName}",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        "¥",
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w200,
                          fontSize: 18,
                        ),
                      ), //
                      SizedBox(width: 2), // 300
                      Text(
                        "${item.discountedPriceAnd ~/ 10}",
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 32.0,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "￥${item.originalPrice ~/ 10}",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.lineThrough,
                      decorationColor:
                          selectVipItem != null && item.productID == selectVipItem.productID ? textColor : Color.fromRGBO(153, 153, 153, 1),
                      fontSize: 12,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 3),
                    child: Text(
                      item.vipCardDesc ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (item.actionDesc != null && item.actionDesc != "")
            Positioned(
              left: 1,
              top: 0,
              child: Container(
                width: 83,
                height: 20,
                padding: EdgeInsets.only(left: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(234, 191, 160, 1),
                      Color.fromRGBO(242, 211, 185, 1),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    "${item.actionDesc}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0xff131010),
                      fontSize: 10.0,
                    ),
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }

  ///兑换产品Item
  Widget _buildExchangeProductItemView(IntegralProductItem item) {
    return Column(
      children: [
        Container(
          width: 111,
          height: 100,
          margin: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(width: 1),
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [
              Color.fromRGBO(255, 238, 220, 1),
              Color.fromRGBO(250, 221, 193, 1),
              Color.fromRGBO(238, 199, 178, 1),
            ]),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "${item.name}",
              style: TextStyle(
                color: Color.fromRGBO(66, 26, 17, 1),
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "${item.price}积分",
              style: TextStyle(
                color: Color.fromRGBO(118, 62, 45, 1),
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ]),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            _exchangeIntegral(item);
          },
          child: Container(
            width: 72,
            margin: EdgeInsets.only(right: 0),
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(36)),
              color: Color(0xff202020),
            ),
            child: Center(
              child: // 兑换
                  Text(
                "兑换",
                style: TextStyle(
                  color: Color(0xffffffff),
                  fontWeight: FontWeight.w600,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  ///产品权益Item
  Widget _buildProductPrivilegeItemView(int index) {
    if (selectVipItem == null || selectVipItem.newPrivilege == null) return Container();
    var item = selectVipItem.newPrivilege[index];
    return Column(
      children: [
        Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ClipOval(
              child: CustomNetworkImage(
                imageUrl: item.img,
                height: 60,
                width: 60,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "${item.privilegeName}",
              style: TextStyle(
                color: Color(0xffffffff),
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 3),
            Text(
              "${item.privilegeDesc.split(" ").length > 1 ? item.privilegeDesc.split(" ")[0].trim() : item.privilegeDesc.split("\n")[0]}",
              maxLines: 1,
              style: TextStyle(
                color: Color(0xffffffff).withOpacity(0.5),
                fontWeight: FontWeight.w400,
                fontSize: 12.0,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "${item.privilegeDesc.split(" ").length > 1 ? item.privilegeDesc.split(" ")[1].trim() : item.privilegeDesc.split("\n").length > 1 ? item.privilegeDesc.split("\n")[1] : ""}",
              maxLines: 1,
              style: TextStyle(
                color: Color(0xffffffff).withOpacity(0.5),
                fontWeight: FontWeight.w400,
                fontSize: 12.0,
              ),
              textAlign: TextAlign.center,
            ),
          ]),
        ),
      ],
    );
  }
}
