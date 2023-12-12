import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class VideoUserCenterPage extends Page<VideoUserCenterState, Map<String, dynamic>> {
  VideoUserCenterPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<VideoUserCenterState>(
                adapter: null,
                slots: <String, Dependent<VideoUserCenterState>>{
                }),
            middleware: <Middleware<VideoUserCenterState>>[
            ],);

}
