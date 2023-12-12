import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CommentPage extends Page<CommentState, Map<String, dynamic>> {
  CommentPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CommentState>(
                adapter: null,
                slots: <String, Dependent<CommentState>>{
                }),
            middleware: <Middleware<CommentState>>[
            ],);

}
