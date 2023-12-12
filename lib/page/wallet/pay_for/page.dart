import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PayForPage extends Page<PayForState, PayForArgs> {
  PayForPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PayForState>(
                adapter: null,
                slots: <String, Dependent<PayForState>>{
                }),
            middleware: <Middleware<PayForState>>[
            ],);

}
