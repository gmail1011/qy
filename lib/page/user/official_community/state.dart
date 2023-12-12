import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/office_item_entity.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';

class OfficialCommunityState implements Cloneable<OfficialCommunityState> {
  BaseRequestController requestController = BaseRequestController();
  List<OfficeItemData> dataList = [];

  @override
  OfficialCommunityState clone() {
    return OfficialCommunityState()
      ..dataList = dataList
      ..requestController = requestController;
  }
}

OfficialCommunityState initState(Map<String, dynamic> args) {
  return OfficialCommunityState();
}
