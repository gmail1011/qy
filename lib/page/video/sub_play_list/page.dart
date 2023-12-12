import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/video/video_list_adapter/adapter.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SubPlayListPage extends Page<SubPlayListState, Map<String, dynamic>> {
  SubPlayListPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<SubPlayListState>(
              adapter: NoneConn<SubPlayListState>() +
                  VideoListAdapter<SubPlayListState>(),
              slots: <String, Dependent<SubPlayListState>>{}),
          middleware: <Middleware<SubPlayListState>>[],
        );
}
