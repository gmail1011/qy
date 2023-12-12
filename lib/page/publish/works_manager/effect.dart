import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_base/utils/log.dart';

import 'action.dart';
import 'state.dart';

Effect<WorksManagerState> buildEffect() {
  return combineEffects(<Object, Effect<WorksManagerState>>{
    Lifecycle.initState: _initState,
    Lifecycle.dispose: _dispose,
  });
}

void _initState(Action action, Context<WorksManagerState> ctx) {
  // ctx.state.tabBarController?.addListener(() {
  //   int index = ctx.state.tabBarController?.index;
  //   l.e("tabBarController.index", "$index");
  //   ctx.dispatch(WorksManagerActionCreator.changeEditModel(index == 2));
  // });
}

void _dispose(Action action, Context<WorksManagerState> ctx) {
  ctx.state.tabBarController?.dispose();
}
