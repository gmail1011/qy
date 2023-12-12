import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<YuePaoBannerState> buildEffect() {
  return combineEffects(<Object, Effect<YuePaoBannerState>>{
    YuePaoBannerAction.action: _onAction,
  });
}

void _onAction(Action action, Context<YuePaoBannerState> ctx) {
}
