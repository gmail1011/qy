import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PayForGamePage extends Page<PayForGameState, PayGameForArgs> {
  PayForGamePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<PayForGameState>(
              adapter: null, slots: <String, Dependent<PayForGameState>>{}),
          middleware: <Middleware<PayForGameState>>[],
        );
}
