import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

/// 个人记录页面
class RecordingPage extends Page<RecordingState, Map<String, dynamic>> {
  RecordingPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<RecordingState>(
                adapter: null,
                slots: <String, Dependent<RecordingState>>{
                }),
            middleware: <Middleware<RecordingState>>[
            ],);

}
