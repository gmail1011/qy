import 'package:fish_redux/fish_redux.dart';
import 'state.dart';

Effect<PayPostState> buildEffect() {
  return combineEffects(<Object, Effect<PayPostState>>{
    Lifecycle.initState: _initState,
  });
}

void _initState(Action action, Context<PayPostState> ctx) {}
