import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///消息界面
class MsgPage extends Page<MsgState, Map<String, dynamic>> {
  MsgPage()
      : super(
    initState: initState,
    effect: buildEffect(),
    reducer: buildReducer(),
    view: buildView,
    dependencies: Dependencies<MsgState>(adapter: null, slots: <String, Dependent<MsgState>>{}),
    middleware: <Middleware<MsgState>>[],
  );
}
