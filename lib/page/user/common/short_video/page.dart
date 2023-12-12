import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///短视频视频公用页面
class ShortVideoPage extends Page<ShortVideoState, Map<String, dynamic>> {
  ShortVideoPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ShortVideoState>(
              adapter: null, slots: <String, Dependent<ShortVideoState>>{}),
          middleware: <Middleware<ShortVideoState>>[],
        );
}
