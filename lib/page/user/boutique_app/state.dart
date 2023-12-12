import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/office_item_entity.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';

class BoutiqueAppState implements Cloneable<BoutiqueAppState> {
  BaseRequestController requestController = BaseRequestController();
  List<OfficeItemData> dataList = [];

  @override
  BoutiqueAppState clone() {
    return BoutiqueAppState()
      ..dataList = dataList
      ..requestController = requestController;
  }
}

BoutiqueAppState initState(Map<String, dynamic> args) {
  return BoutiqueAppState();
}
