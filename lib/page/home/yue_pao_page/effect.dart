import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_router/jump_router.dart';
import 'package:flutter_app/common/local_router/route_map.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/page/home/yue_pao_page/com/public.dart';
import 'package:flutter_app/page/home/yue_pao_page/yue_pao_index_tab_view_page/action.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/flutter_base.dart';
import 'action.dart';
import 'state.dart';

Effect<YuePaoState> buildEffect() {
  return combineEffects(<Object, Effect<YuePaoState>>{
    YuePaoAction.selectCity: _onSelectCity,
    Lifecycle.initState: _initData,
  });
}

void _onSelectCity(Action action, Context<YuePaoState> ctx) async {
  String city = await JRouter().go(YUE_PAO_SELECT_CITY_PAGE);
  if (city != null && city != ctx.state.city) {
    /*eagleClick(ctx.state.selfId(),
        sourceId: ctx.state.eagleId(ctx.context), label: "城市$city");*/
    ctx.dispatch(YuePaoActionCreator.onChangeCity(city));
    ctx.broadcast(YuePaoIndexTabViewActionCreator.onSelectCity(city));
  }
}

void _initData(Action action, Context<YuePaoState> ctx) async{

  /*var list = await getAdsByType(AdsType.hotType);
  ctx.dispatch(YuePaoActionCreator.getAdsSuccess(list ?? []));*/

  Future.delayed(Duration(milliseconds: 500), () async {

    String city = await getCity('lou_feng_city');
    if (!TextUtil.isEmpty(city)) {
      /// 刷新当前ui
      ctx.dispatch(YuePaoActionCreator.onChangeCity(city));
    }
    if (!await ctx.state.hasEntered()) {
      ctx.state.intro.start(ctx.context);
      ctx.state.setEntered(true);
    }
  });
}


