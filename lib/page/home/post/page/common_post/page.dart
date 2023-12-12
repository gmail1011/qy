import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/post/common_post_adapter/adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CommonPostPage extends Page<CommonPostState, Map<String, dynamic>> {
  CommonPostPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<CommonPostState>(
              adapter: NoneConn<CommonPostState>() + CommonPostAdapter(),
              slots: <String, Dependent<CommonPostState>>{}),
          middleware: <Middleware<CommonPostState>>[],
        );
}
