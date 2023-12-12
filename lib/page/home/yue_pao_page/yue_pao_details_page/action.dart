import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/model/user/product_item.dart';
import 'package:flutter_app/model/verifyreport_model.dart';

import '../LouFengDisCountBuy.dart';

//TODO replace with your own action
enum YuePaoDetailsAction {
  onCollect,
  changeItem,
  onBuy,
  onBuyWithDiscountCard,
  onChangeCountBrowse,
  onClickReport,
  loadMoreData,
  onChangeList,
  onChangePageNumber,
  onVerification,
  onNextLouFeng,
  onReplaceLouFengItem,
  initPageNumber,
  productItemBean,
  goVip,
  renZhengZhuanQuYuYue,
}

class YuePaoDetailsActionCreator {
  static Action goVip() {
    return const Action(YuePaoDetailsAction.goVip);
  }

  static Action initPageNumber() {
    return const Action(YuePaoDetailsAction.initPageNumber);
  }

  static Action productItemBean(ProductItemBean item) {
    return Action(YuePaoDetailsAction.productItemBean, payload: item);
  }

  static Action onReplaceLouFengItem(LouFengItem item) {
    return Action(YuePaoDetailsAction.onReplaceLouFengItem, payload: item);
  }

  static Action onNextLouFeng() {
    return const Action(YuePaoDetailsAction.onNextLouFeng);
  }

  static Action onVerification() {
    return const Action(YuePaoDetailsAction.onVerification);
  }

  static Action onChangePageNumber() {
    return const Action(YuePaoDetailsAction.onChangePageNumber);
  }

  static Action onChangeList(List<VerifyReport> list) {
    return Action(YuePaoDetailsAction.onChangeList, payload: list ?? []);
  }

  static Action onClickReport() {
    return Action(YuePaoDetailsAction.onClickReport);
  }

  static Action onChangeCountBrowse() {
    return Action(YuePaoDetailsAction.onChangeCountBrowse);
  }

  static Action onCollect(bool collect) {
    return Action(YuePaoDetailsAction.onCollect, payload: collect);
  }

  static Action onChangeItem(bool collect) {
    return Action(YuePaoDetailsAction.changeItem, payload: collect);
  }

  static Action onBuy() {
    return Action(YuePaoDetailsAction.onBuy);
  }

  static Action onBuyWithDiscountCard(LouFengDisCountBuy louFengDisCountBuy) {
    return Action(YuePaoDetailsAction.onBuyWithDiscountCard,payload: louFengDisCountBuy);
  }

  static Action loadMoreData() {
    return Action(YuePaoDetailsAction.loadMoreData);
  }

  static Action renZhengZhuanQuYuYue() {
    return Action(YuePaoDetailsAction.renZhengZhuanQuYuYue);
  }
}
