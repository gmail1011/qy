import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

/// 约炮城市选择页
class YuePaoSelectCityPage extends Page<YuePaoSelectCityState, Map<String, dynamic>> {
  YuePaoSelectCityPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<YuePaoSelectCityState>(
                adapter: null,
                slots: <String, Dependent<YuePaoSelectCityState>>{
                }),
            middleware: <Middleware<YuePaoSelectCityState>>[
            ],);

}
