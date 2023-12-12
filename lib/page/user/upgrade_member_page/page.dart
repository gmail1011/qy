import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

/// 会员升级
class UpgradeMemberPage extends Page<UpgradeMemberState, Map<String, dynamic>> {
  UpgradeMemberPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<UpgradeMemberState>(
                adapter: null,
                slots: <String, Dependent<UpgradeMemberState>>{
                }),
            middleware: <Middleware<UpgradeMemberState>>[
            ],);

}
