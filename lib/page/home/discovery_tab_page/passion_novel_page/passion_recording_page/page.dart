import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PassionRecordingPage extends Page<PassionRecordingState, Map<String, dynamic>> {
  PassionRecordingPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PassionRecordingState>(
                adapter: null,
                slots: <String, Dependent<PassionRecordingState>>{
                }),
            middleware: <Middleware<PassionRecordingState>>[
            ],);

}
