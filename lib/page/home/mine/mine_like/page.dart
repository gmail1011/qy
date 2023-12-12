import 'package:fish_redux/fish_redux.dart';
import 'adapter/adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MineLikePostPage extends Page<MineLikePostState, Map<String, dynamic>> {
  MineLikePostPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MineLikePostState>(
              adapter: NoneConn<MineLikePostState>() + MineLikeAdapter(),
              slots: <String, Dependent<MineLikePostState>>{}),
          middleware: <Middleware<MineLikePostState>>[],
        );
}
