import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PassionNovelViewPage extends Page<PassionNovelViewState, Map<String, dynamic>> {
  PassionNovelViewPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            wrapper: keepAliveClientWrapper,
            view: buildView,
            dependencies: Dependencies<PassionNovelViewState>(
                adapter: null,
                slots: <String, Dependent<PassionNovelViewState>>{
                }),
            middleware: <Middleware<PassionNovelViewState>>[
            ],);

}
