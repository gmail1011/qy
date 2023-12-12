import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class GameRulesPage extends Page<GameRulesState, Map<String, dynamic>> {
  GameRulesPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<GameRulesState>(
                adapter: null,
                slots: <String, Dependent<GameRulesState>>{
                }),
            middleware: <Middleware<GameRulesState>>[
            ],);

}
