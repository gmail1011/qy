import 'dart:convert' as convert;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/alipay_bank_list_model.dart';
import 'package:flutter_app/model/bank_card_model.dart';
import 'package:flutter_app/model/bankcard_info.dart';
import 'package:flutter_app/new_page/recharge/bank_card_add_page.dart';
import 'package:flutter_app/widget/appbar/custom_appbar.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_app/widget/common_widget/ys_pull_refresh.dart';
import 'package:flutter_app/widget/dashed_decoration.dart';
import 'package:flutter_app/widget/dialog/confirm_dialog.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/light_model.dart';
import 'package:flutter_base/utils/log.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart' as Gets;
import 'package:pull_to_refresh/pull_to_refresh.dart';

///银行卡管理
class BankCardHomePage extends StatefulWidget {
  final bool isSelect;

  BankCardHomePage(this.isSelect);

  @override
  State<StatefulWidget> createState() {
    return _BankCardHomePageState();
  }
}

class _BankCardHomePageState extends State<BankCardHomePage> {
  bool isEdit = false;

  List<AccountInfoModel> aliList = [];

  AccountInfoModel selectItem;

  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();

  @override
  void initState() {
    super.initState();
    _getAliListData();
  }

  void _onDeleteAccount(int index) async {
    var isDelete =
        await showConfirm(context, content: "是否确认删除账号\n${aliList[index].act}", showCancelBtn: true);
    if (isDelete == null || !isDelete) {
      return;
    }
    String result;
    try {
      result = await netManager.client.bankCardDelete(aliList[index].id);
    } catch (e) {
      l.e("ali_list", "_onDeleteAccount()...error:$e");
    }
    if (null != result) {
      var result = await lightKV.getString(Config.LAST_A_ACCOUNT);
      if (result != null) {
        AccountInfoModel listBean = AccountInfoModel.fromMap(convert.jsonDecode(result));
        if (aliList[index].id == listBean.id) {
          lightKV.setString(Config.LAST_A_ACCOUNT, "");
        }
      }
      showToast(msg: "删除成功", gravity: ToastGravity.CENTER);
      aliList.removeAt(index);
      setState(() {});
    }
  }

  void _getAliListData() async {
    try {
      ApBankListModel model = await netManager.client.getBankCardList();
      aliList.clear();
      aliList.addAll(model.list);
      requestController.requestSuccess();
      refreshController.refreshCompleted();
      if (aliList.isNotEmpty) selectItem = aliList.first;
      setState(() {});
    } catch (e) {
      l.e('getAliPayList', e.toString());
      showToast(msg: e.toString());
      requestController.requestFail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FullBg(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppbar(
          title: "银行卡账号",
          actions: [
            InkWell(
              onTap: () {
                if (widget.isSelect) {
                  safePopPage(selectItem);
                } else {
                  setState(() {
                    isEdit = !isEdit;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Center(
                  child: Text(
                      widget.isSelect
                          ? "确认"
                          : isEdit
                              ? "完成"
                              : "编辑",
                      style: const TextStyle(
                          color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 12.0),
                      textAlign: TextAlign.center),
                ),
              ),
            )
          ],
        ),
        body: BaseRequestView(
          controller: requestController,
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: pullYsRefresh(
                refreshController: refreshController,
                enablePullUp: false,
                onRefresh: () async {
                  Future.delayed(Duration(milliseconds: 1000), () {
                    _getAliListData();
                  });
                },
                child: ListView.builder(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    shrinkWrap: true,
                    itemCount: (aliList.length ?? 0) + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= aliList.length) return _buildCardAddView();
                      return _buildCardView(index, aliList[index]);
                    })),
          ),
        ),
      ),
    );
  }

  Widget _buildCardView(int index, AccountInfoModel item) {
    return InkWell(
      onTap: () {
        if (isEdit)
          _onDeleteAccount(index);
        else
          setState(() {
            selectItem = item;
          });
      },
      child: Container(
        height: 77,
        margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(4)), color: const Color(0xff202733)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        getBankName(item.bankCode ?? ""),
                        style: const TextStyle(
                            color: const Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: 16.0),
                      ),
                      SizedBox(width: 5),
                      Text(
                        item.actName ?? "",
                        style: const TextStyle(
                            color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 10.0),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("储蓄卡:${item.act}",
                      style: const TextStyle(
                          color: const Color(0xffffffff), fontWeight: FontWeight.w400, fontSize: 12.0))
                ],
              ),
            ),
            Image.asset(
              isEdit
                  ? "assets/images/hj_withdrawal_icon_del.png"
                  : selectItem != null && selectItem.id == item.id
                      ? "assets/images/hj_withdrawal_icon_select.png"
                      : "assets/images/hj_withdrawal_icon_unselect.png",
              width: 12,
              height: 12,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCardAddView() {
    return InkWell(
      onTap: () async {
        await Gets.Get.to(() => BankCardAddPage(), opaque: false).then((value) => _getAliListData());
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: 77,
        decoration: DashedDecoration(
          dashedColor: Color(0xff9a9a9a),
          gap: 3,
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        ),
        child: Center(
          child: Text("+ 添加银行卡",
              style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.w500, fontSize: 16.0)),
        ),
      ),
    );
  }


  ///获取银行名称
  String getBankName(String bankCode) {
    if (bankCode.isEmpty) {
      return "";
    }
    BankCardModel model = BankcardInfo().getBankInfoMap(bankCode);
    if (model == null) {
      return BankcardInfo().getBankName(bankCode);
    }
    return model.bankName;
  }

  // ///获取银行logo
  // String _getBankLogo(String bankCode) {
  //   if (bankCode.isEmpty) {
  //     return "";
  //   }
  //   BankCardModel model = BankcardInfo().getBankInfoMap(bankCode);
  //   if (model == null) {
  //     return "assets/images/bank_card_logo/default_bank.png";
  //   }
  //   return model.bankLogoId;
  // }

}
