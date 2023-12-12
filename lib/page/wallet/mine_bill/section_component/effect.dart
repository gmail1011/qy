import 'package:fish_redux/fish_redux.dart';
import 'state.dart';

Effect<SectionState> buildEffect() {
  return combineEffects(
      <Object, Effect<SectionState>>{Lifecycle.initState: _initState});
}

void _initState(Action action, Context<SectionState> ctx) {}
