import 'package:fish_redux/fish_redux.dart';

import 'add_effect.dart';
import 'add_reducer.dart';
import 'add_state.dart';
import 'add_view.dart';

class AddPage extends Page<AddState, Map<String, dynamic>> {
  AddPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AddState>(
                adapter: null,
                slots: <String, Dependent<AddState>>{
                }),
            middleware: <Middleware<AddState>>[
            ],);

}
