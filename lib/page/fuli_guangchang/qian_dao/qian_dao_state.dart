import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/day_mark_entity.dart';

class qian_daoState implements Cloneable<qian_daoState> {
  List<AdsInfoBean> resultList = [];

  DayMarkData dayMarkData;

  bool isSign;

  @override
  qian_daoState clone() {
    return qian_daoState()
      ..resultList = resultList
      ..dayMarkData = dayMarkData
      ..isSign = isSign;
  }
}

qian_daoState initState(Map<String, dynamic> args) {
  return qian_daoState();
}
