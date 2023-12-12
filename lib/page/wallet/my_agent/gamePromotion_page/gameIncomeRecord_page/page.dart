import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class GameIncomeRecordPage extends Page<GameIncomeRecordState, Map<String, dynamic>> {
  GameIncomeRecordPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<GameIncomeRecordState>(
                adapter: null,
                slots: <String, Dependent<GameIncomeRecordState>>{
                }),
            middleware: <Middleware<GameIncomeRecordState>>[
            ],);

}
