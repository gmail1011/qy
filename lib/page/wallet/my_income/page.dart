import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MyIncomePage extends Page<MyIncomeState, Map<String, dynamic>> {
  MyIncomePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MyIncomeState>(adapter: null, slots: <String, Dependent<MyIncomeState>>{}),
          middleware: <Middleware<MyIncomeState>>[],
        );
}
