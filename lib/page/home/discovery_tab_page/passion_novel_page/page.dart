import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PassionNovelPage extends Page<PassionNovelState, Map<String, dynamic>> {
  PassionNovelPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            wrapper: keepAliveClientWrapper,
            dependencies: Dependencies<PassionNovelState>(
                adapter: null,
                slots: <String, Dependent<PassionNovelState>>{
                }),
            middleware: <Middleware<PassionNovelState>>[
            ],);

}
