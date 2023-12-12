import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///关于app
class AboutAppPage extends Page<AboutAppState, Map<String, dynamic>> {
  AboutAppPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<AboutAppState>(
              adapter: null, slots: <String, Dependent<AboutAppState>>{}),
          middleware: <Middleware<AboutAppState>>[],
        );
}
