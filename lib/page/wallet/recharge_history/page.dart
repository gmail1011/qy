import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class RechargeHistoryPage extends Page<RechargeHistoryState, Map<String, dynamic>> {
  RechargeHistoryPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies:
              Dependencies<RechargeHistoryState>(adapter: null, slots: <String, Dependent<RechargeHistoryState>>{}),
          middleware: <Middleware<RechargeHistoryState>>[],
        );
}
