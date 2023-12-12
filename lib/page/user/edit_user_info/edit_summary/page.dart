import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///修改简介
class EditSummaryPage extends Page<EditSummaryState, Map<String, dynamic>> {
  EditSummaryPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<EditSummaryState>(
              adapter: null, slots: <String, Dependent<EditSummaryState>>{}),
          middleware: <Middleware<EditSummaryState>>[],
        );
}
