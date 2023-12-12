import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AgentRecordPage extends Page<AgentRecordState, Map<String, dynamic>> {
  AgentRecordPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AgentRecordState>(
                adapter: null,
                slots: <String, Dependent<AgentRecordState>>{
                }),
            middleware: <Middleware<AgentRecordState>>[
            ],);

}
