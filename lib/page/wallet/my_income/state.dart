import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/history_income_model.dart';
import 'package:flutter_base/eagle/eagle_helper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class MyIncomeState with EagleHelper implements Cloneable<MyIncomeState> {
  HistoryIncomeModel model; //历史收益存放数据
  var income = "";
  var from;
  var pageSize = 15;
  var pageNumber = 1;
  EasyRefreshController controller = EasyRefreshController();

  @override
  MyIncomeState clone() {
    return MyIncomeState()
      ..model = model
      ..income = income
      ..from = from
      ..pageNumber = pageNumber
      ..pageSize = pageSize
      ..controller = controller; //clone 规则
  }
}

MyIncomeState initState(Map<String, dynamic> args) {
  return MyIncomeState()
    ..income = args['income']
    ..from = args['from'];
}
