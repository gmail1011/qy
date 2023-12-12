import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///账号找回
class RecoverAccountPage
    extends Page<RecoverAccountState, Map<String, dynamic>> {
  RecoverAccountPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<RecoverAccountState>(
              adapter: null, slots: <String, Dependent<RecoverAccountState>>{}),
          middleware: <Middleware<RecoverAccountState>>[],
        );
}
