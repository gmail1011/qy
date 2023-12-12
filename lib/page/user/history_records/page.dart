import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///历史记录
class HistoryRecordsPage
    extends Page<HistoryRecordsState, Map<String, dynamic>> {
  HistoryRecordsPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<HistoryRecordsState>(
              adapter: null, slots: <String, Dependent<HistoryRecordsState>>{}),
          middleware: <Middleware<HistoryRecordsState>>[],
        );
}
