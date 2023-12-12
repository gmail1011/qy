import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class LaudPage extends Page<LaudState, Map<String, dynamic>> {
  LaudPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<LaudState>(
                adapter: null,
                slots: <String, Dependent<LaudState>>{
                }),
            middleware: <Middleware<LaudState>>[
            ],);

}
