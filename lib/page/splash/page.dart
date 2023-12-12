import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///启动页
class SplashPage extends Page<SplashState, Map<String, dynamic>> {
  SplashPage()
      : super(
          view: buildView,
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          dependencies: Dependencies<SplashState>(adapter: null, slots: <String, Dependent<SplashState>>{}),
          middleware: <Middleware<SplashState>>[],
        );
}
