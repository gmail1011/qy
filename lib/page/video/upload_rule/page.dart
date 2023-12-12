import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class UploadRulePage extends Page<UploadRuleState, Map<String, dynamic>> {
  UploadRulePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<UploadRuleState>(
                adapter: null,
                slots: <String, Dependent<UploadRuleState>>{
                }),
            middleware: <Middleware<UploadRuleState>>[
            ],);

}
