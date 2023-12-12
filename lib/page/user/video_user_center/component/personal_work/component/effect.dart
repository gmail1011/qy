import 'package:fish_redux/fish_redux.dart';
import 'state.dart';

Effect<WorkItemState> buildEffect() {
  return combineEffects(<Object, Effect<WorkItemState>>{});
}
