import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PromoteIncomePage extends Page<PromoteIncomeState, Map<String, dynamic>> {
  PromoteIncomePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          wrapper: keepAliveClientWrapper,
          view: buildView,
          dependencies: Dependencies<PromoteIncomeState>(
              adapter: null, slots: <String, Dependent<PromoteIncomeState>>{}),
          middleware: <Middleware<PromoteIncomeState>>[],
        );
}
