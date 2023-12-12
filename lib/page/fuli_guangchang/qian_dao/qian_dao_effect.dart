import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_app/page/fuli_guangchang/bean/day_mark_entity.dart';
import 'package:flutter_app/widget/dialog/dialog_entry.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'qian_dao_action.dart';
import 'qian_dao_state.dart';

Effect<qian_daoState> buildEffect() {
  return combineEffects(<Object, Effect<qian_daoState>>{
    qian_daoAction.action: _onAction,
    qian_daoAction.postDayMark: postDayMark,
    Lifecycle.initState: _initData,
  });
}

void _onAction(Action action, Context<qian_daoState> ctx) {
}

void _initData(Action action, Context<qian_daoState> ctx) async {
  Future.delayed(Duration(milliseconds: 100), () async {
    try {
      await getAds(ctx);
      await getDayMark(ctx);
    } catch (e) {
      //showToast(msg: e.toString());
      return;
    }
  });
}

getAds(Context<qian_daoState> ctx) async{
  //var list = await getAdsByType(AdsType.dayMark);

 // ctx.dispatch(qian_daoActionCreator.getAds(list));
}

///获取某一个广告数据
Future<List<AdsInfoBean>> getAdsByType(AdsType adsType) async {
  if (null == adsType) return null;
  List<AdsInfoBean> resultList = await LocalAdsStore().getAllAds();
  if (ArrayUtil.isEmpty(resultList)) return <AdsInfoBean>[];

  List<AdsInfoBean> adsList = resultList?.where((it) => it.position == adsType.index)?.toList();

  return adsList;
}

Future<dynamic> getDayMark(Context<qian_daoState> ctx) async{
  dynamic result = await netManager.client.getDayMark();
  bool isSign = true;
  DayMarkData dayMarkData = DayMarkData().fromJson(result);
  dayMarkData.xList.forEach((element) {
       if(element.status == 2){
          isSign = false;
       }
  });
  ctx.dispatch(qian_daoActionCreator.dayMark(dayMarkData));
  ctx.dispatch(qian_daoActionCreator.isSign(isSign));
}

Future<dynamic> postDayMark(Action action,Context<qian_daoState> ctx) async{
  dynamic result = await netManager.client.postDayMark(action.payload);
  await getDayMark(ctx);
  showDayMarkDialog(ctx.context,ctx.state.dayMarkData);
}

