import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class loufengPage extends Page<loufengState, Map<String, dynamic>> {
  loufengPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<loufengState>(
                adapter: null,
                slots: <String, Dependent<loufengState>>{
                }),
            middleware: <Middleware<loufengState>>[
            ],);

}
