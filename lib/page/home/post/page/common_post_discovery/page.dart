import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/home/post/common_post_adapter/adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CommonPostDiscoveryPage extends Page<CommonPostState, Map<String, dynamic>> {
  CommonPostDiscoveryPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<CommonPostState>(
              adapter: NoneConn<CommonPostState>() + CommonPostAdapter(),
              slots: <String, Dependent<CommonPostState>>{}),
          middleware: <Middleware<CommonPostState>>[],
        );
}
