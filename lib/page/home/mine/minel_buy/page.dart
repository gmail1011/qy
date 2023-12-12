import 'package:fish_redux/fish_redux.dart';

import 'adapter/adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MineBuyPostPage extends Page<MineBuyPostState, Map<String, dynamic>> {
  MineBuyPostPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MineBuyPostState>(
              adapter: NoneConn<MineBuyPostState>() + MineBuyAdapter(), slots: <String, Dependent<MineBuyPostState>>{}),
          middleware: <Middleware<MineBuyPostState>>[],
        );
}
