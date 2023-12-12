import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///长视频公用页面
class LongVideoPage extends Page<LongVideoState, Map<String, dynamic>> {
  LongVideoPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<LongVideoState>(
              adapter: null, slots: <String, Dependent<LongVideoState>>{}),
          middleware: <Middleware<LongVideoState>>[],
        );
}
