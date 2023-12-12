import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/wallet/mine_bill/adapter/adapter.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MineBillPage extends Page<MineBillState, Map<String, dynamic>> {
  MineBillPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MineBillState>(
                adapter: NoneConn<MineBillState>() + MineBillAdapter(),
                slots: <String, Dependent<MineBillState>>{
                }),
            middleware: <Middleware<MineBillState>>[
            ],);

}
