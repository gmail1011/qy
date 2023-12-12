import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_like/adapter/adapter.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class UserLikePostPage extends Page<UserLikePostState, Map<String, dynamic>> {
  UserLikePostPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<UserLikePostState>(
              adapter: NoneConn<UserLikePostState>() + UserLikeAdapter(),
              slots: <String, Dependent<UserLikePostState>>{}),
          middleware: <Middleware<UserLikePostState>>[],
        );
}
