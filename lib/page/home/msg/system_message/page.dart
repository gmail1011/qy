import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///系统消息界面
class SystemMessagePage extends Page<SystemMessageState, Map<String, dynamic>> {
  SystemMessagePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SystemMessageState>(
                adapter: null,
                slots: <String, Dependent<SystemMessageState>>{
                }),
            middleware: <Middleware<SystemMessageState>>[
            ],);

}
