import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class YuePaoTabPage extends Page<YuePaoTabState, Map<String, dynamic>> {
  YuePaoTabPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            wrapper: keepAliveClientWrapper,
            dependencies: Dependencies<YuePaoTabState>(
                adapter: null,
                slots: <String, Dependent<YuePaoTabState>>{
                }),
            middleware: <Middleware<YuePaoTabState>>[
            ],);

}
