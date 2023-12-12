import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PayForPage extends Page<PayForNakeChatState, PayForNakeArgs> {
  PayForPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PayForNakeChatState>(
                adapter: null,
                slots: <String, Dependent<PayForNakeChatState>>{
                }),
            middleware: <Middleware<PayForNakeChatState>>[
            ],);

}
