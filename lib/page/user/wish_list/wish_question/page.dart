import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///愿望工单-问题
class WishQuestionPage extends Page<WishQuestionState, Map<String, dynamic>> {
  WishQuestionPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<WishQuestionState>(
                adapter: null,
                slots: <String, Dependent<WishQuestionState>>{
                }),
            middleware: <Middleware<WishQuestionState>>[
            ],);

}
