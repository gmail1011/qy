import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///账号找回-绑定手机号找回
class RecoverMobilePage extends Page<RecoverMobileState, Map<String, dynamic>> {
  RecoverMobilePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<RecoverMobileState>(
              adapter: null, slots: <String, Dependent<RecoverMobileState>>{}),
          middleware: <Middleware<RecoverMobileState>>[],
        );
}
