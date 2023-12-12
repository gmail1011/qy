import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class YuePaoIndexTabViewPage extends Page<YuePaoIndexTabViewState, Map<String, dynamic>> {
  YuePaoIndexTabViewPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            wrapper: keepAliveClientWrapper,
            dependencies: Dependencies<YuePaoIndexTabViewState>(
                adapter: null,
                slots: <String, Dependent<YuePaoIndexTabViewState>>{
                }),
            middleware: <Middleware<YuePaoIndexTabViewState>>[
            ],);

}
