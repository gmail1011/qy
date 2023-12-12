import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///绑定手机号码
class RebindPhonePage extends Page<RebindPhoneState, Map<String, dynamic>> {
  RebindPhonePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<RebindPhoneState>(adapter: null, slots: <String, Dependent<RebindPhoneState>>{}),
          middleware: <Middleware<RebindPhoneState>>[],
        );
}
