import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PostPage extends Page<PostState, Map<String, dynamic>>{
  PostPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PostState>(
                adapter: null,
                slots: <String, Dependent<PostState>>{

                }),
            middleware: <Middleware<PostState>>[
            ],);

}
