import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/wallet/mine_bill/model/bill_item_model.dart';

class MineBillItemState implements Cloneable<MineBillItemState> {

  String uniqueId;

  BillItemModel billModel;

  MineBillItemState({this.billModel}) {
    uniqueId ??= DateTime.now().toIso8601String();
  }

  @override
  MineBillItemState clone() {
    return MineBillItemState();
  }
}

MineBillItemState initState(Map<String, dynamic> args) {
  return MineBillItemState();
}
