import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SearchUserPage extends Page<SearchUserState, Map<String, dynamic>> {
  SearchUserPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<SearchUserState>(
              adapter: null, slots: <String, Dependent<SearchUserState>>{}),
          middleware: <Middleware<SearchUserState>>[],
        );
}
