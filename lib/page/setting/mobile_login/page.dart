import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///绑定手机号码
class MobileLoginPage extends Page<MobileLoginState, Map<String, dynamic>> {
  MobileLoginPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MobileLoginState>(adapter: null, slots: <String, Dependent<MobileLoginState>>{}),
          middleware: <Middleware<MobileLoginState>>[],
        );
}
