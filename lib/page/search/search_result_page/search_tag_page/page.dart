import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SearchTagPage extends Page<SearchTagState, Map<String, dynamic>> {
  SearchTagPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<SearchTagState>(
              adapter: null, slots: <String, Dependent<SearchTagState>>{}),
          middleware: <Middleware<SearchTagState>>[],
        );
}
