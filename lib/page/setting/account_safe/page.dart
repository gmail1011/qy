import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///账号与安全
class AccountSafePage extends Page<AccountSafeState, Map<String, dynamic>> {
  AccountSafePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<AccountSafeState>(adapter: null, slots: <String, Dependent<AccountSafeState>>{}),
          middleware: <Middleware<AccountSafeState>>[],
        );
}
