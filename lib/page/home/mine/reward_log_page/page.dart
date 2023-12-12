import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

/// 打赏列表
class RewardLogPage extends Page<RewardLogState, Map<String, dynamic>> {
  RewardLogPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<RewardLogState>(
                adapter: null,
                slots: <String, Dependent<RewardLogState>>{
                }),
            middleware: <Middleware<RewardLogState>>[
            ],);

}
