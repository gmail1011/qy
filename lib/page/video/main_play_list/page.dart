import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/video/video_list_adapter/adapter.dart';


import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MainPlayerListPage extends Page<MainPlayerListState, Map<String, dynamic>>{
  MainPlayerListPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper:keepAliveClientWrapper,
          dependencies: Dependencies<MainPlayerListState>(
              adapter: NoneConn<MainPlayerListState>() + VideoListAdapter<MainPlayerListState>(),
              slots: <String, Dependent<MainPlayerListState>>{}),
          middleware: <Middleware<MainPlayerListState>>[],
        );
}
