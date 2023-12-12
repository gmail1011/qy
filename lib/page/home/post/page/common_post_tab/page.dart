import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/post/common_post_adapter/adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CommonPostTabPage extends Page<CommonPostTagsState, Map<String, dynamic>> {
  CommonPostTabPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<CommonPostTagsState>(
              adapter: NoneConn<CommonPostTagsState>() + CommonPostAdapter(),
              slots: <String, Dependent<CommonPostTagsState>>{}),
          middleware: <Middleware<CommonPostTagsState>>[],
        );
}
