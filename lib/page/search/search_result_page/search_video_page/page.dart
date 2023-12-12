import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SearchVideoPage extends Page<SearchVideoState, Map<String, dynamic>> {
  SearchVideoPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<SearchVideoState>(
              adapter: null, slots: <String, Dependent<SearchVideoState>>{}),
          middleware: <Middleware<SearchVideoState>>[],
        );
}
