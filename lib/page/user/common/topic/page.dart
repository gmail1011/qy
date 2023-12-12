import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///话题公用页面
class TopicPage extends Page<TopicState, Map<String, dynamic>> {
  TopicPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<TopicState>(
              adapter: null, slots: <String, Dependent<TopicState>>{}),
          middleware: <Middleware<TopicState>>[],
        );
}
