import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/local_store/local_ads_info_store.dart';
import 'package:flutter_app/model/ads_model.dart';

import 'action.dart';
import 'state.dart';

Effect<HjllCommunityHomeState> buildEffect() {
  return combineEffects(<Object, Effect<HjllCommunityHomeState>>{
    HjllCommunityHomeAction.action: _onAction,
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
  });
}

void _onAction(Action action, Context<HjllCommunityHomeState> ctx) {}

void _initState(Action action, Context<HjllCommunityHomeState> ctx) async {

}

void _dispose(Action action, Context<HjllCommunityHomeState> ctx) {
  ctx.state.tabController?.dispose();
}
