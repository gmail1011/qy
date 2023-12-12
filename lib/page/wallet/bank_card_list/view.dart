import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/assets/svg.dart';
import 'package:flutter_app/assets/lang.dart';
import 'package:flutter_app/model/bank_card_model.dart';
import 'package:flutter_app/model/bankcard_info.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';
import 'package:flutter_base/utils/screen.dart';
import 'package:flutter_app/utils/svg_util.dart';
import 'package:flutter_base/utils/toast_util.dart';
import 'package:flutter_app/widget/common_widget/loading_widget.dart';
import 'package:masked_text_input_formatter/masked_text_input_formatter.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    BankCardListState state, Dispatch dispatch, ViewService viewService) {
  return FullBg(
    child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          Lang.BANKCARD_ACCOUNT,
          style: TextStyle(fontSize: Dimens.pt20, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            dispatch(BankCardListActionCreator.onBack());
          },
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    (state.model?.list?.length ?? 0) > 0
                        ? Divider(
                            height: 1.0, indent: 0.0, color: Color(0x805a4f59))
                        : Container(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.model?.list?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        return _itemBank(state, dispatch, index);
                      },
                    ),
                    addBanView(state, dispatch, viewService),
                  ],
                ),
                //加载动画
                Visibility(
                  visible: state.isLoading,
                  child: Center(
                    child: LoadingWidget(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _itemBank(BankCardListState state, Dispatch dispatch, int index) {
  return InkWell(
    onTap: () async {
      dispatch(BankCardListActionCreator.onItemBankClicked(index));
    },
    child: Container(
      decoration: BoxDecoration(
          color: Color(_getBankBackground(index)),
          borderRadius: BorderRadius.circular(Dimens.pt4)),
      margin: EdgeInsets.only(
        left: Dimens.pt16,
        top: Dimens.pt20,
        right: Dimens.pt16,
      ),
      height: Dimens.pt73,
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                left: Dimens.pt7, top: Dimens.pt7, bottom: Dimens.pt5),
            child: Text(
              getBankName(state.model.list[index].bankCode),
              style: TextStyle(fontSize: Dimens.pt14, color: Colors.white),
            ),
          ),
          Positioned(
            left: Dimens.pt7,
            top: Dimens.pt24,
            child: Text(
              _getBankCardType(state.model.list[index].cardType),
              style: TextStyle(fontSize: Dimens.pt10, color: Colors.white),
            ),
          ),
          Positioned(
            left: Dimens.pt78,
            top: Dimens.pt28,
            child: Text(
              '**** **** **** ${state.model.list[index].act.substring(state.model.list[index].act.length - 4)}',
              style: TextStyle(fontSize: Dimens.pt18, color: Colors.white),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Image(
              image: AssetImage(_getBankLogo(state.model.list[index].bankCode)),
              width: Dimens.pt73,
              height: Dimens.pt73,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: InkWell(
              onTap: () {
                dispatch(BankCardListActionCreator.onDeleteBankCard(index));
              },
              child: Container(
                padding: EdgeInsets.all(Dimens.pt10),
                child: svgAssets(AssetsSvg.ACCOUNT_DELETE,
                    width: Dimens.pt16, height: Dimens.pt16),
              ),
            ),
          ),
          (state.lastAccountName ?? '') == state.model.list[index].act
              ? Positioned(
                  right: Dimens.pt12,
                  bottom: Dimens.pt3,
                  child: Text(
                    Lang.RECENT_USE,
                    style: TextStyle(
                        fontSize: Dimens.pt8, color: Color(0xffFF0000)),
                  ),
                )
              : Container()
        ],
      ),
    ),
  );
}

Widget addBanView(
    BankCardListState state, Dispatch dispatch, ViewService viewService) {
  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      FocusScope.of(viewService.context).requestFocus(FocusNode());
      if (state.actController.text.isNotEmpty) {
        dispatch(BankCardListActionCreator.validatedBankCard());
      }
    },
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //top分割线
          Visibility(
            visible: (state.model?.list?.length ?? 0) > 0,
            child: Container(
                margin: EdgeInsets.only(top: Dimens.pt20, bottom: Dimens.pt12),
                width: screen.screenWidth,
                height: Dimens.pt6,
                color: Colors.white10),
          ),
          Visibility(
            //占位间距
            visible: (state.model?.list?.length ?? 0) <= 0,
            child: Container(
              margin: EdgeInsets.only(
                top: Dimens.pt20,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: Dimens.pt16)),
              Container(
                width: Dimens.pt4,
                height: Dimens.pt18,
                color: Color(0xffFF0000),
              ),
              Padding(padding: EdgeInsets.only(left: Dimens.pt4)),
              Text(
                Lang.ADD_BANKCARD,
                style: TextStyle(fontSize: Dimens.pt15, color: Colors.white),
              )
            ],
          ),
          //持卡人
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
                left: Dimens.pt24, top: Dimens.pt19, bottom: Dimens.pt5),
            child: Text(
              Lang.CARD_HOLDER,
              style: TextStyle(
                fontSize: Dimens.pt12,
                color: Colors.white,
              ),
            ),
          ),
          //输入框
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: Dimens.pt24),
                child: Text(
                  '*',
                  style: TextStyle(
                      fontSize: Dimens.pt20, color: Color(0xffbbbcbb)),
                ),
              ),
              Expanded(
                child: Container(
                  margin:
                      EdgeInsets.only(left: Dimens.pt10, right: Dimens.pt30),
                  child: TextField(
                    controller: state.actNameController,
                    maxLines: 1,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        fontSize: Dimens.pt15,
                        color: Colors.white,
                        textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.white70, fontSize: Dimens.pt15),
                      hintText: Lang.NAME,
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
            padding: EdgeInsets.only(
                left: Dimens.pt24,
                top: Dimens.pt19,
                bottom: Dimens.pt5,
                right: Dimens.pt24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  Lang.CARD_NUMBER,
                  style: TextStyle(
                    fontSize: Dimens.pt12,
                    color: Colors.white,
                  ),
                ),
                Visibility(
                    visible: state.validatedBankName != null,
                    child: Text(
                      state.validatedBankName ?? "",
                      style: TextStyle(
                        fontSize: Dimens.pt12,
                        color: Color(0xffDA242B),
                      ),
                    ))
              ],
            ),
          ),
          //账号输入框
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: Dimens.pt24),
                child: Text(
                  '#',
                  style: TextStyle(
                      fontSize: Dimens.pt15, color: Color(0xffbbbcbb)),
                ),
              ),
              Expanded(
                child: Container(
                  margin:
                      EdgeInsets.only(left: Dimens.pt10, right: Dimens.pt30),
                  child: TextField(
                    inputFormatters: [
                      MaskedTextInputFormatter(
                        mask: 'xxxx-xxxx-xxxx-xxxx-xxxx',
                        separator: "-",
                      ),
                    ],
                    controller: state.actController,
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      if (state.validatedBankName.isNotEmpty) {
                        state.validatedBankName = null;
                        dispatch(BankCardListActionCreator.updateUI());
                      }
                    },
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: Dimens.pt15,
                        color: Colors.white,
                        textBaseline: TextBaseline.alphabetic),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.white70, fontSize: Dimens.pt15),
                      hintText: Lang.BANKCARD_NUMBER,
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
              height: 1,
              indent: 0.0,
              color: Colors.white30,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: Dimens.pt51)),
          InkWell(
            onTap: () {
              FocusScope.of(viewService.context).requestFocus(FocusNode());
              if (state.actNameController.text.isNotEmpty) {
                if (state.actController.text.isNotEmpty) {
                  if (state.actController.text.length >= 15) {
                    //用户名和账号不为空添加
                    dispatch(BankCardListActionCreator.onAddBankCard());
                  } else {
                    showToast(msg: Lang.ACCOUNT_IS_INCORRECT);
                  }
                } else {
                  showToast(msg: Lang.ACCOUNT_CAN_NOT_EMPTY);
                }
              } else {
                showToast(msg: Lang.USER_CAN_NOT_EMPTY);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.pt20),
                  gradient: LinearGradient(
                      colors: [Color(0xffE9252F), Color(0xffC00A18)])),
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: Dimens.pt26, right: Dimens.pt26),
              child: Text(
                Lang.SURE_ADD,
                style: TextStyle(fontSize: Dimens.pt14, color: Colors.white),
              ),
              width: double.infinity,
              height: Dimens.pt40,
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.only(bottom: Dimens.pt40 + screen.paddingBottom)),
        ],
      ),
    ),
  );
}

///展示银行卡类型
String _getBankCardType(String type) {
  switch (type) {
    case "DC":
      //储蓄卡
      return Lang.BANK_CARD_TYPE_1;
    case "CC":
      //信用卡
      return Lang.BANK_CARD_TYPE_2;
    case "SCC":
      //准贷记卡
      return Lang.BANK_CARD_TYPE_3;
    case "PC":
      //预付费卡
      return Lang.BANK_CARD_TYPE_4;
    default:
      return '';
  }
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

///获取银行logo
String _getBankLogo(String bankCode) {
  if (bankCode.isEmpty) {
    return "";
  }
  BankCardModel model = BankcardInfo().getBankInfoMap(bankCode);
  if (model == null) {
    return "assets/images/bank_card_logo/default_bank.png";
  }
  return model.bankLogoId;
}
