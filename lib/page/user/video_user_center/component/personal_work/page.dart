import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/user/video_user_center/component/personal_work/adapter/adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class UserWorkPostPage extends Page<UserWorkPostState, Map<String, dynamic>>{
  UserWorkPostPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            wrapper:keepAliveClientWrapper,
            dependencies: Dependencies<UserWorkPostState>(
                adapter: NoneConn<UserWorkPostState>() + UserWorkAdapter(),
                slots: <String, Dependent<UserWorkPostState>>{
                }),
            middleware: <Middleware<UserWorkPostState>>[
            ],);

}
