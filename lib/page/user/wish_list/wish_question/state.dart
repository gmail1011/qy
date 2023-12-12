import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/user/wish_list_entity.dart';
import 'package:flutter_app/widget/common_widget/base_request_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WishQuestionState implements Cloneable<WishQuestionState> {
  RefreshController refreshController = RefreshController();
  BaseRequestController requestController = BaseRequestController();

  int questionType = 0; //0 全部 1 我的
  int pageNumber = 1;
  int pageSize = 10;
  bool hasNext = true;

  List<WishListDataList> wishList = [];

  @override
  WishQuestionState clone() {
    return WishQuestionState()
      ..refreshController = refreshController
      ..requestController = requestController
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..wishList = wishList
      ..hasNext = hasNext
      ..questionType = questionType;
  }
}

WishQuestionState initState(Map<String, dynamic> args) {
  return WishQuestionState()..questionType = args["questionType"] ?? 0;
}
