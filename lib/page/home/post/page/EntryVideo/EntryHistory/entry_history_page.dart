import 'package:fish_redux/fish_redux.dart';

import 'entry_history_effect.dart';
import 'entry_history_reducer.dart';
import 'entry_history_state.dart';
import 'entry_history_view.dart';

class EntryHistoryPage extends Page<EntryHistoryState, Map<String, dynamic>> {
  EntryHistoryPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<EntryHistoryState>(
                adapter: null,
                slots: <String, Dependent<EntryHistoryState>>{
                }),
            middleware: <Middleware<EntryHistoryState>>[
            ],);

}
