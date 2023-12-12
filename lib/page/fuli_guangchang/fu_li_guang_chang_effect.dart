import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/ads_model.dart';
import 'package:flutter_base/utils/array_util.dart';
import 'package:flutter_base/utils/toast_util.dart';

import 'fu_li_guang_chang_action.dart';
import 'fu_li_guang_chang_state.dart';

Effect<FuLiGuangChangState> buildEffect() {
  return combineEffects(<Object, Effect<FuLiGuangChangState>>{
    FuLiGuangChangAction.action: _onAction,
    //Lifecycle.initState: _initData,
  });
}

void _onAction(Action action, Context<FuLiGuangChangState> ctx) {
}


