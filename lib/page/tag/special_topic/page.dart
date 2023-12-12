import 'package:fish_redux/fish_redux.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///专题页面
class SpecialTopicPage extends Page<SpecialTopicState, Map<String, dynamic>> {
  SpecialTopicPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<SpecialTopicState>(
            adapter: null,
            slots: <String, Dependent<SpecialTopicState>>{},
          ),
          middleware: <Middleware<SpecialTopicState>>[],
        );
}
