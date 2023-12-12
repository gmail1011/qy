import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///绑定手机号码
class InitialBindPhonePage extends Page<InitialBindPhoneState, Map<String, dynamic>> {
  InitialBindPhonePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<InitialBindPhoneState>(adapter: null, slots: <String, Dependent<InitialBindPhoneState>>{}),
          middleware: <Middleware<InitialBindPhoneState>>[],
        );
}
