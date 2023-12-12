import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class FansPage extends Page<FansState, Map<String, dynamic>> {
  FansPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<FansState>(
                adapter: null,
                slots: <String, Dependent<FansState>>{
                }),
            middleware: <Middleware<FansState>>[
            ],);

}
