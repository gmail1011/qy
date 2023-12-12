import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_buy/adapter/adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class UserBuyPostPage extends Page<UserBuyPostState, Map<String, dynamic>> {
  UserBuyPostPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<UserBuyPostState>(
              adapter: NoneConn<UserBuyPostState>() + UserBuyAdapter(), slots: <String, Dependent<UserBuyPostState>>{}),
          middleware: <Middleware<UserBuyPostState>>[],
        );
}
