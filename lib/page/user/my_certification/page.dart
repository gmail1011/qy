import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///我的认证
class MyCertificationPage extends Page<MyCertificationState, Map<String, dynamic>> {
  MyCertificationPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MyCertificationState>(
                adapter: null,
                slots: <String, Dependent<MyCertificationState>>{
                }),
            middleware: <Middleware<MyCertificationState>>[
            ],);

}
