import 'package:fish_redux/fish_redux.dart';

import 'state.dart';
import 'view.dart';

class NoNetPage extends Page<NoNetState, Map<String, dynamic>> {
  NoNetPage()
      : super(
          initState: initState,
          view: buildView,
          dependencies: Dependencies<NoNetState>(
              adapter: null, slots: <String, Dependent<NoNetState>>{}),
          middleware: <Middleware<NoNetState>>[],
        );
}
