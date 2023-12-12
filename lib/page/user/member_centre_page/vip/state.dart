import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/global_store/state.dart';
import 'package:flutter_app/model/user/new_product_list_model.dart';
import 'package:flutter_app/model/user/product_item.dart';
import 'package:flutter_app/page/wallet/pay_for/state.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class VIPState extends GlobalBaseState implements Cloneable<VIPState> {
  BaseRequestController requestController = BaseRequestController();
  SwiperController swiperController = SwiperController();

  NewProductList vipListModel;
  TabVipItem defaultTabVipItem;
  TabVipItem curTabVipItem;
  ProductItemBean selectVipItem;
  bool paying = false;
  int tabIndex = 0;
  String specifyVipCardId;

  @override
  VIPState clone() {
    return VIPState()
      ..requestController = requestController
      ..swiperController = swiperController
      ..vipListModel = vipListModel
      ..defaultTabVipItem = defaultTabVipItem
      ..curTabVipItem = curTabVipItem
      ..selectVipItem = selectVipItem
      ..paying = paying
      ..tabIndex = tabIndex
      ..specifyVipCardId = specifyVipCardId;
  }
}

VIPState initState(Map<String, dynamic> args) {
  final VIPState state = VIPState();
  state.specifyVipCardId =
      (args != null && args.containsKey("specifyVipCardId"))
          ? args['specifyVipCardId']
          : "";
  return state;
}

class PayForVipConnector extends ConnOp<VIPState, PayForState> {
  @override
  PayForState get(VIPState state) {
    if (state.selectVipItem != null && state.vipListModel?.daichong != null) {
      var args = PayForArgs(
          dcModel: state.vipListModel.daichong,
          isDialog: false,
          vipitem: state.selectVipItem,
          curTabVipItem: state.curTabVipItem);
      return PayForState(args: args)..isPayLoading = state.paying;
    }
    return PayForState();
  }

  @override
  void set(VIPState state, PayForState subState) {
    state.paying = subState.isPayLoading;
  }
}
