import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_base/eagle/umeng_util.dart';
import 'package:flutter_base/utils/navigator_util.dart';
import 'package:package_info/package_info.dart';
import 'action.dart';
import 'state.dart';

Effect<UploadRuleState> buildEffect() {
  return combineEffects(<Object, Effect<UploadRuleState>>{
    UploadRuleAction.backAction: _backAction,
    Lifecycle.initState: _initState,
  });
}

void _backAction(Action action, Context<UploadRuleState> ctx) {
  safePopPage();
}

Future<void> _initState(Action action, Context<UploadRuleState> ctx) async {
  PackageInfo _packageInfo = await PackageInfo.fromPlatform();
  ctx.state.packageInfo = _packageInfo;
  ctx.dispatch(UploadRuleActionCreator.initSuccessAction());
  Future.delayed(Duration(milliseconds: 200),(){
    //eaglePage(ctx.state.selfId(),
          //sourceId: ctx.state.eagleId(ctx.context));
  });
  
}
