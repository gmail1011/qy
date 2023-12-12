import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class WithdrawIncomePage extends Page<WithdrawIncomeState, Map<String, dynamic>> {
  WithdrawIncomePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<WithdrawIncomeState>(
                adapter: null,
                slots: <String, Dependent<WithdrawIncomeState>>{
                }),
            middleware: <Middleware<WithdrawIncomeState>>[
            ],);

}
