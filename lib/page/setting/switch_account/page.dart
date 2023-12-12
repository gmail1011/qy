import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class SwitchAccountPage extends Page<SwitchAccountState, Map<String, dynamic>> {
  SwitchAccountPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SwitchAccountState>(
                adapter: null,
                slots: <String, Dependent<SwitchAccountState>>{
                }),
            middleware: <Middleware<SwitchAccountState>>[
            ],);

}
