import 'package:fish_redux/fish_redux.dart';

import 'history_effect.dart';
import 'history_reducer.dart';
import 'history_state.dart';
import 'history_view.dart';

class HistoryPage extends Page<HistoryState, Map<String, dynamic>> {
  HistoryPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<HistoryState>(
                adapter: null,
                slots: <String, Dependent<HistoryState>>{
                }),
            middleware: <Middleware<HistoryState>>[
            ],);

}
