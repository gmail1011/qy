import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///同城界面
class NearbyPage extends Page<NearbyState, Map<String, dynamic>>{
  NearbyPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<NearbyState>(adapter: null, slots: <String, Dependent<NearbyState>>{}),
          middleware: <Middleware<NearbyState>>[],
        );
}
