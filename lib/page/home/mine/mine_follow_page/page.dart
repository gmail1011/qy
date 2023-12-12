import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

/// 我关注的人
class MineFollowPage extends Page<MineFollowState, Map<String, dynamic>> {
  MineFollowPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MineFollowState>(
              adapter: null, slots: <String, Dependent<MineFollowState>>{}),
          middleware: <Middleware<MineFollowState>>[],
        );
}
