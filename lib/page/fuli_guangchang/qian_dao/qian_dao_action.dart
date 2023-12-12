import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/day_mark_entity.dart';

import '../fu_li_guang_chang_action.dart';

//TODO replace with your own action
enum qian_daoAction { action , adsLists , dayMark, postDayMark , isSign}

class qian_daoActionCreator {
  static Action onAction() {
    return const Action(qian_daoAction.action);
  }

  static Action getAds(List<AdsInfoBean> resultList) {
    return  Action(qian_daoAction.adsLists,payload: resultList);
  }

  static Action dayMark(DayMarkData dayMarkData) {
    return  Action(qian_daoAction.dayMark,payload: dayMarkData);
  }

  static Action postDayMark(String id) {
    return  Action(qian_daoAction.postDayMark,payload: id);
  }

  static Action isSign(bool isSign) {
    return  Action(qian_daoAction.isSign,payload: isSign);
  }
}
