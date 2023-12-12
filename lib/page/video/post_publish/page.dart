import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PostPublishPage extends Page<PostPublishState, Map<String, dynamic>> {
  PostPublishPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PostPublishState>(
                adapter: null,
                slots: <String, Dependent<PostPublishState>>{
                }),
            middleware: <Middleware<PostPublishState>>[
            ],);

}
