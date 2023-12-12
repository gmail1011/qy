import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/post/common_post_adapter/adapter.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class UserDynamicPostPage
    extends Page<UserDynamicPostState, Map<String, dynamic>> {
  UserDynamicPostPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<UserDynamicPostState>(
              adapter: NoneConn<UserDynamicPostState>() +
                  CommonPostAdapter<UserDynamicPostState>(),
              slots: <String, Dependent<UserDynamicPostState>>{}),
          middleware: <Middleware<UserDynamicPostState>>[],
        );
}
