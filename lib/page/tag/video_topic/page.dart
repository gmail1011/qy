import 'package:fish_redux/fish_redux.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///专题页面
class VideoTopicPage extends Page<VideoTopicState, Map<String, dynamic>> {
  VideoTopicPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<VideoTopicState>(
            adapter: null,
            slots: <String, Dependent<VideoTopicState>>{},
          ),
          middleware: <Middleware<VideoTopicState>>[],
        );
}
