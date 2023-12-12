import 'package:fish_redux/fish_redux.dart';

import 'game_page_effect.dart';
import 'game_page_reducer.dart';
import 'game_page_state.dart';
import 'game_page_view.dart';

class GamePagePage extends Page<GamePageState, Map<String, dynamic>> {
  GamePagePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<GamePageState>(
                adapter: null,
                slots: <String, Dependent<GamePageState>>{
                }),
            middleware: <Middleware<GamePageState>>[
            ],);

}
