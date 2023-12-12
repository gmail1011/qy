import 'package:fish_redux/fish_redux.dart';

import 'ren_wu_effect.dart';
import 'ren_wu_reducer.dart';
import 'ren_wu_state.dart';
import 'ren_wu_view.dart';

class RenWuPage extends Page<RenWuState, Map<String, dynamic>> {
  RenWuPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<RenWuState>(
                adapter: null,
                slots: <String, Dependent<RenWuState>>{
                }),
            middleware: <Middleware<RenWuState>>[
            ],);

}
