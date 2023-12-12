import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/novel_model.dart';
import 'package:flutter_app/page/home/discovery_tab_page/com/public_widget.dart';
import 'package:flutter_app/widget/common_widget/pull_refresh_view.dart';
import 'package:flutter_base/flutter_base.dart';

class PassionNovelViewState with EagleHelper implements Cloneable<PassionNovelViewState> {
  PullRefreshController pullController = PullRefreshController();
  /// 页面入口
  NOVEL_ENTRANCE target;
  /// 数据列表
  List<NoveItem> list = [];
  /// 小说分类(主页面参数)
  String fictionType;
  /// 搜索页面参数
  String keyword;
  int pageSize = 10;
  int pageNumber = 1;
  @override
  PassionNovelViewState clone() {
    return PassionNovelViewState()
    ..fictionType = fictionType
    ..pageNumber = pageNumber
    ..pageSize = pageSize
    ..list = list
    ..target = target
    ..keyword = keyword
    ..pullController = pullController;
  }
}

PassionNovelViewState initState(Map<String, dynamic> args) {
  var map = args??{};
  return PassionNovelViewState()
  ..target = map['target'] ?? NOVEL_ENTRANCE.MAIN
  ..keyword = map['keyword']??''
  ..fictionType = map['fictionType']??'';
}
