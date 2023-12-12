import 'package:fish_redux/fish_redux.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PayPostPage extends Page<PayPostState, Map<String, dynamic>> {
  PayPostPage()
      : super(
    initState: initState,
    effect: buildEffect(),
    reducer: buildReducer(),
    view: buildView,
    dependencies: Dependencies<PayPostState>(
        adapter: null,
        slots: <String, Dependent<PayPostState>>{
        }),
    middleware: <Middleware<PayPostState>>[
    ],);

}
