import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class GamePromotionPage extends Page<GamePromotionState, Map<String, dynamic>> {
  GamePromotionPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<GamePromotionState>(
                adapter: null,
                slots: <String, Dependent<GamePromotionState>>{
                }),
            middleware: <Middleware<GamePromotionState>>[
            ],);

}
