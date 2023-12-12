import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/text_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_app/widget/custom_edge_insets.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    AliListState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Lang.ALIPAY_WITHDRAW,
          style: TextStyle(fontSize: Dimens.pt16, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            dispatch(AliListActionCreator.onBack());
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return _getAliItem(state, dispatch, index);
                  },
                  childCount: state.aliList.length,
                ),
              ),
              SliverToBoxAdapter(
                child: _getBottomWidget(state, dispatch),
              ),
            ],
          ),
          Visibility(
            visible: state.isLoading,
            child: Center(
              child: LoadingWidget(),
            ),
          )
        ],
      ),
    ),
  );
}

Widget _getAliItem(AliListState state, Dispatch dispatch, index) {
  return InkWell(
    onTap: () {
      dispatch(AliListActionCreator.onUseAccount(index));
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.pt5),
        color: Color(_getBankBackground(index)),
      ),
      margin: CustomEdgeInsets.only(left: 24, top: 7.5, right: 24, bottom: 7.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                top: Dimens.pt10,
                bottom: Dimens.pt10,
                left: Dimens.pt12,
                right: Dimens.pt12),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    "${Lang.ACCOUNT_TYPE_A}(${state.aliList[index].actName})",
                    style:
                        TextStyle(fontSize: Dimens.pt12, color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    dispatch(AliListActionCreator.onDeleteAccount(index));
                  },
                  child: Container(
                    padding: EdgeInsets.all(Dimens.pt5),
                    child: svgAssets(AssetsSvg.ACCOUNT_DELETE,
                        width: Dimens.pt16, height: Dimens.pt16),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: CustomEdgeInsets.only(left: 12.5, right: 20.5, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                svgAssets(
                  AssetsSvg.IC_AP,
                  width: Dimens.pt32,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      hideAccountInfo(state.aliList[index].act),
                      style:
                          TextStyle(fontSize: Dimens.pt20, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            visible: (state.lastAccountName ?? '') == state.aliList[index].act,
            child: Container(
              margin: CustomEdgeInsets.only(left: 12.5, right: 20.5, bottom: 5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Text(
                    Lang.RECENT_USE,
                    style: TextStyle(fontSize: Dimens.pt12, color: Colors.red),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _getBottomWidget(AliListState state, Dispatch dispatch) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Visibility(
        visible: (state.aliList?.length ?? 0) > 0,
        child: Container(
          margin: EdgeInsets.only(top: Dimens.pt20),
          width: Dimens.pt360,
          height: Dimens.pt6,
          color: Colors.white10,
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(
            left: Dimens.pt30, top: Dimens.pt24, bottom: Dimens.pt5),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: Dimens.pt2),
              width: Dimens.pt4,
              height: Dimens.pt18,
              color: Colors.red,
            ),
            Text(
              Lang.ADD_ALI_PAY,
              style: TextStyle(
                fontSize: Dimens.pt14,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      //持卡人
      Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(
            left: Dimens.pt34, top: Dimens.pt24, bottom: Dimens.pt5),
        child: Text(
          Lang.NAME,
          style: TextStyle(
            fontSize: Dimens.pt12,
            color: Colors.white,
          ),
        ),
      ),
      //支付宝账号输入框
      Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: Dimens.pt34),
            child: Text(
              '*',
              style: TextStyle(fontSize: Dimens.pt20, color: Color(0xffbbbcbb)),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: Dimens.pt10, right: Dimens.pt30),
              child: TextField(
                controller: state.actNameController,
                maxLines: 1,
                autocorrect: true,
                autofocus: false,
                style: TextStyle(
                    fontSize: Dimens.pt16,
                    color: Colors.white,
                    textBaseline: TextBaseline.alphabetic),
                decoration: InputDecoration(
                  hintStyle:
                      TextStyle(color: Colors.white30, fontSize: Dimens.pt14),
                  hintText: Lang.USER_NAME,
                  border: InputBorder.none,
                ),
              ),
            ),
          )
        ],
      ),
      Container(
        margin: EdgeInsets.only(left: Dimens.pt30, right: Dimens.pt20),
        child: Divider(
          color: Colors.white30,
        ),
      ),
      //卡号
      Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(
            left: Dimens.pt34, top: Dimens.pt10, bottom: Dimens.pt5),
        child: Text(
          Lang.ALI_PAY_ACCOUNT,
          style: TextStyle(
            fontSize: Dimens.pt12,
            color: Colors.white,
          ),
        ),
      ),
      //账号输入框
      Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: Dimens.pt34),
            child: Text(
              '#',
              style: TextStyle(fontSize: Dimens.pt20, color: Color(0xffbbbcbb)),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: Dimens.pt10, right: Dimens.pt30),
              child: TextField(
                controller: state.actController,
                maxLines: 1,
                autocorrect: true,
                autofocus: false,
                style: TextStyle(
                    fontSize: Dimens.pt16,
                    color: Colors.white,
                    textBaseline: TextBaseline.alphabetic),
                decoration: InputDecoration(
                  hintStyle:
                      TextStyle(color: Colors.white30, fontSize: Dimens.pt14),
                  hintText: Lang.ACCOUNT1,
                  border: InputBorder.none,
                ),
              ),
            ),
          )
        ],
      ),
      Container(
        margin: EdgeInsets.only(left: Dimens.pt30, right: Dimens.pt20),
        child: Divider(
          color: Colors.white30,
        ),
      ),
      Container(
        margin: EdgeInsets.only(
            left: Dimens.pt24, top: Dimens.pt30, right: Dimens.pt24),
        child: MaterialButton(
          onPressed: () {
            if (TextUtil.isPhone(state.actController.text) ||
                TextUtil.isEmail(state.actController.text)) {
              dispatch(AliListActionCreator.onAddAliAccount());
            } else {
              showToast(
                  msg: Lang.ACCOUNT_CAN_NOT_EMPTY,
                  gravity: ToastGravity.CENTER);
            }
          },
          color: Color(0xfffc3066),
          child: Text(Lang.SURE,
              style: TextStyle(fontSize: Dimens.pt14, color: Colors.white)),
          padding: EdgeInsets.only(top: Dimens.pt10, bottom: Dimens.pt10),
          minWidth: double.infinity,
          height: Dimens.pt40,
        ),
      )
    ],
  );
}

String hideAccountInfo(String account) {
  if (TextUtil.isEmpty(account)) {
    return account;
  }
  try {
    if (TextUtil.isPhone(account)) {
      //手机号码
      return account.replaceFirst(RegExp(r'\d{4}'), '****', 3);
    } else if (TextUtil.isEmail(account)) {
      //邮箱
      List<String> list = account.split("@");
      String result = list[0];
      StringBuffer buffer = StringBuffer();
      int count = 4;
      for (int i = 0; i < result.length; i++) {
        if (i == 0) {
          buffer.write(result.substring(0, 1));
        } else if (i == result.length - 1) {
          buffer.write(result.substring(result.length - 1));
        } else {
          if (count > 0) {
            buffer.write("*");
          }
          count--;
        }
      }
      buffer.write("@");
      buffer.write(list[1]);
      return buffer.toString();
    }
  } catch (e) {}
  return account;
}

///银行卡背景色
int _getBankBackground(int index) {
  int color;
  switch (index % 4) {
    case 0:
      color = 0xff3f6087;
      break;
    case 1:
      color = 0xff009F8A;
      break;
    case 2:
      color = 0xff2057A2;
      break;
    case 3:
      color = 0xffD7442D;
      break;
  }
  return color;
}
