import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///稿件管理
class WorksManagerPage extends Page<WorksManagerState, Map<String, dynamic>> {
  WorksManagerPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<WorksManagerState>(
              adapter: null, slots: <String, Dependent<WorksManagerState>>{}),
          middleware: <Middleware<WorksManagerState>>[],
        );
}
