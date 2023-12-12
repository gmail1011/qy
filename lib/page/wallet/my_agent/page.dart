import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

/// 我的代理
class MyAgentPage extends Page<MyAgentState, Map<String, dynamic>> {
  MyAgentPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MyAgentState>(
              adapter: null, slots: <String, Dependent<MyAgentState>>{}),
          middleware: <Middleware<MyAgentState>>[],
        );
}
