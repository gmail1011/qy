import 'package:fish_redux/fish_redux.dart';
import 'effect.dart';
import 'mine_work_adapter/adapter.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MineWorkPage extends Page<MineWorkState, MineWorkPageType> {
  MineWorkPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MineWorkState>(
              adapter: NoneConn<MineWorkState>() + MineWorkAdapter(),
              slots: <String, Dependent<MineWorkState>>{}),
          middleware: <Middleware<MineWorkState>>[],
        );
}
