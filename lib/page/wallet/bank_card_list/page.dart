import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class BankCardListPage extends Page<BankCardListState, Map<String, dynamic>> {
  BankCardListPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<BankCardListState>(adapter: null, slots: <String, Dependent<BankCardListState>>{}),
          middleware: <Middleware<BankCardListState>>[],
        );
}
