import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AliListPage extends Page<AliListState, Map<String, dynamic>> {
  AliListPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<AliListState>(adapter: null, slots: <String, Dependent<AliListState>>{}),
          middleware: <Middleware<AliListState>>[],
        );
}
