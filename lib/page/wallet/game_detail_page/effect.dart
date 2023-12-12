import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'action.dart';
import 'state.dart';

Effect<DetailState> buildEffect() {
  return combineEffects(<Object, Effect<DetailState>>{
    DetailAction.action: _onAction,
    Lifecycle.initState: _init,
  });
}

void _init(Action action, Context<DetailState> ctx){
  
  Future.delayed(Duration(milliseconds: 200),(){
    //eaglePage(ctx.state.selfId(),
         // sourceId: ctx.state.eagleId(ctx.context));
  });
}

void _onAction(Action action, Context<DetailState> ctx) {
}
