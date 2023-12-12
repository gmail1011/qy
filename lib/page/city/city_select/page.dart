import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///城市选择界面
class CitySelectPage extends Page<CitySelectState, Map<String, dynamic>> {
  CitySelectPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<CitySelectState>(adapter: null, slots: <String, Dependent<CitySelectState>>{}),
          middleware: <Middleware<CitySelectState>>[],
        );
}
