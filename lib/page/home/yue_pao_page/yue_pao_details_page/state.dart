import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/lou_feng_model.dart';
import 'package:flutter_app/model/user/product_item.dart';
import 'package:flutter_app/model/verifyreport_model.dart';
import 'package:flutter_app/page/home/yue_pao_page/com/public.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';
import 'package:flutter_base/flutter_base.dart';

class YuePaoDetailsState
    with EagleHelper
    implements Cloneable<YuePaoDetailsState> {
  /// 楼凤id
  String id = '';
  /// 当前楼凤
  LouFengItem louFengItem;

  ProductItemBean productItemBean;

  PullRefreshController pullController = PullRefreshController();

  /// 验证报告列表
  List<VerifyReport> list = [];
  int pageNumber = 1;
  int pageSize = 10;

  int pageTitle;

  List<YuePaoResources> get resources {
    var list = <YuePaoResources>[];
    if ((louFengItem?.cover?.length ?? 0) > 0) {
      var list1 = louFengItem.cover
          .map((e) => YuePaoResources(type: 2, path: e))
          .toList();
      list.addAll(list1);
    }
    return list;
  }

  @override
  YuePaoDetailsState clone() {
    return YuePaoDetailsState()
      ..id = id
      ..pullController = pullController
      ..productItemBean = productItemBean
      ..list = list
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..pageTitle = pageTitle
      ..louFengItem = louFengItem;
  }
}

YuePaoDetailsState initState(Map<String, dynamic> args) {
  var map = args ?? {};
  return YuePaoDetailsState()
    ..id = map['id']
    ..pageTitle = map["pageTitle"]
  ;
}
