import 'package:fish_redux/fish_redux.dart';

import 'zuo_pin_effect.dart';
import 'zuo_pin_reducer.dart';
import 'zuo_pin_state.dart';
import 'zuo_pin_view.dart';

class ZuoPinPage extends Page<ZuoPinState, Map<String, dynamic>> {
  ZuoPinPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ZuoPinState>(
                adapter: null,
                slots: <String, Dependent<ZuoPinState>>{
                }),
            middleware: <Middleware<ZuoPinState>>[
            ],);

}
