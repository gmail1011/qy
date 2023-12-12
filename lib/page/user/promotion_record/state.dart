import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user/promotion_record.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PromotionRecordState
    with EagleHelper
    implements Cloneable<PromotionRecordState> {
  List<Promotion> promotionList;
  var total = 0;
  var pageSize = 10;
  var pageNumber = 1;
  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();

  @override
  PromotionRecordState clone() {
    return PromotionRecordState()
      ..promotionList = promotionList
      ..pageSize = pageSize
      ..pageNumber = pageNumber
      ..total = total
      ..requestController = requestController
      ..refreshController = refreshController;
  }
}

PromotionRecordState initState(Map<String, dynamic> args) {
  return PromotionRecordState();
}
