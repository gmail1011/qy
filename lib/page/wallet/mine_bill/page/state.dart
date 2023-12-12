import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/wallet/mine_bill/item_component/state.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class MineBillState extends MutableSource with EagleHelper implements Cloneable<MineBillState> {
  int pageNumber = 0;
  int pageSize = 10;
  bool hasNext;

  List<dynamic> billList = [];

  EasyRefreshController refreshController;
  Header header;
  Footer footer;

  bool requestComplete = false;
  bool dataIsNormal = true;
  String errorMsg = "暂无数据";
  int maxCount = 8; //一页最多显示的数据

  bool isLoading = false;

  @override
  MineBillState clone() {
    return MineBillState()
      ..billList = billList
      ..refreshController = refreshController
      ..header = header
      ..footer = footer
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..hasNext = hasNext
      ..requestComplete = requestComplete
      ..dataIsNormal = dataIsNormal
      ..isLoading = isLoading
      ..maxCount = maxCount;
  }

  @override
  Object getItemData(int index) {
    return billList[index];
  }

  @override
  String getItemType(int index) {
    return billList[index] is MineBillItemState ? 'bill_item' : 'bill_section';
  }

  @override
  int get itemCount => billList.length;

  @override
  void setItemData(int index, Object data) {
    billList[index] = data;
  }
}

MineBillState initState(Map<String, dynamic> args) {
  MineBillState newState = MineBillState();
  newState.refreshController = EasyRefreshController();
  return newState;
}
