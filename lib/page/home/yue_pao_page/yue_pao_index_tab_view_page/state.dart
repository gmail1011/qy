import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';

class YuePaoIndexTabViewState implements Cloneable<YuePaoIndexTabViewState> {

  PullRefreshController pullController = PullRefreshController();
  List<LouFengItem> louFengList = [];
  /// 楼凤一级tab（0/精品楼凤/1认证专区）
  int pageTitle;
  /// 楼凤二级tab (0最新/1最热)
  int pageType;
  /// city
  String city = '';
  /// 是否需要广告
  bool hasAD = false;
  int pageNumber = 1;
  int pageSize = 10;


  @override
  YuePaoIndexTabViewState clone() {
    return YuePaoIndexTabViewState()
    ..louFengList = louFengList
    ..pageSize = pageSize
    ..pageNumber = pageNumber
    ..city = city
    ..pageType = pageType
    ..pageTitle = pageTitle
    ..hasAD = hasAD
    ..pullController = pullController;
  }
}

YuePaoIndexTabViewState initState(Map<String, dynamic> args) {
  var map = args??{};
  return YuePaoIndexTabViewState()
  ..pageTitle = map['pageTitle']??0
  ..pageType = map['pageType']??0;
}
