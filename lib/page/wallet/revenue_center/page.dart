import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///收益中心
class RevenueCenterPage extends Page<RevenueCenterState, Map<String, dynamic>> {
  RevenueCenterPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<RevenueCenterState>(
              adapter: null, slots: <String, Dependent<RevenueCenterState>>{}),
          middleware: <Middleware<RevenueCenterState>>[],
        );
}
