import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///作品列表
class WorksListPage extends Page<WorksListState, Map<String, dynamic>> {
  WorksListPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<WorksListState>(
              adapter: null, slots: <String, Dependent<WorksListState>>{}),
          middleware: <Middleware<WorksListState>>[],
        );
}
