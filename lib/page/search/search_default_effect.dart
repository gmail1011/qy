import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/common/net2/net_manager.dart';
import 'package:flutter_app/model/search_default_entity.dart';

import 'search_default_action.dart';
import 'search_default_state.dart';

Effect<SearchDefaultState> buildEffect() {
  return combineEffects(<Object, Effect<SearchDefaultState>>{
    SearchDefaultAction.action: _onAction,
    Lifecycle.initState: _onInitData,
  });
}

void _onAction(Action action, Context<SearchDefaultState> ctx) {

}

void _onInitData(Action action, Context<SearchDefaultState> ctx) async{

  dynamic model = await netManager.client.getSearchDefault();

  SearchDefaultData searchDefaultData = SearchDefaultData().fromJson(model);

  ctx.dispatch(SearchDefaultActionCreator.onInitData(searchDefaultData));

}
