import 'package:fish_redux/fish_redux.dart';

import 'qian_dao_effect.dart';
import 'qian_dao_reducer.dart';
import 'qian_dao_state.dart';
import 'qian_dao_view.dart';

class qian_daoPage extends Page<qian_daoState, Map<String, dynamic>> {
  qian_daoPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<qian_daoState>(
                adapter: null,
                slots: <String, Dependent<qian_daoState>>{
                }),
            middleware: <Middleware<qian_daoState>>[
            ],);

}
