import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///我的购买
class MyPurchasesPage extends Page<MyPurchasesState, Map<String, dynamic>> {
  MyPurchasesPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MyPurchasesState>(
              adapter: null, slots: <String, Dependent<MyPurchasesState>>{}),
          middleware: <Middleware<MyPurchasesState>>[],
        );
}
