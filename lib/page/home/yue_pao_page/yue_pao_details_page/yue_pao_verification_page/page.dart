import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class YuePaoVerificationPage extends Page<YuePaoVerificationState, Map<String, dynamic>> {
  YuePaoVerificationPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<YuePaoVerificationState>(
                adapter: null,
                slots: <String, Dependent<YuePaoVerificationState>>{
                }),
            middleware: <Middleware<YuePaoVerificationState>>[
            ],);

}
