import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class DoorPage extends Page<DoorState, Map<String, dynamic>> {
  DoorPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<DoorState>(
                adapter: null,
                slots: <String, Dependent<DoorState>>{
                }),
            middleware: <Middleware<DoorState>>[
            ],);

}
