import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class VideoIncomePage extends Page<VideoIncomeState, Map<String, dynamic>> {
  VideoIncomePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<VideoIncomeState>(
              adapter: null, slots: <String, Dependent<VideoIncomeState>>{}),
          middleware: <Middleware<VideoIncomeState>>[],
        );
}
