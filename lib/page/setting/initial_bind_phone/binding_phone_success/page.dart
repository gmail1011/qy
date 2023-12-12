import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///绑定手机号成功UI
class BindingPhoneSuccessPage
    extends Page<BindingPhoneSuccessState, Map<String, dynamic>> {
  BindingPhoneSuccessPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<BindingPhoneSuccessState>(
              adapter: null,
              slots: <String, Dependent<BindingPhoneSuccessState>>{}),
          middleware: <Middleware<BindingPhoneSuccessState>>[],
        );
}
