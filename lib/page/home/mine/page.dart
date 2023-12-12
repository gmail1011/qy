import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///我的界面
class MinePage extends Page<MineState, Map<String, dynamic>> {
  MinePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<MineState>(adapter: null, slots: <String, Dependent<MineState>>{}),
          middleware: <Middleware<MineState>>[],
        );
}
