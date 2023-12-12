import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class NovelPlayerPage extends Page<NovelPlayerState, Map<String, dynamic>> {
  NovelPlayerPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<NovelPlayerState>(
                adapter: null,
                slots: <String, Dependent<NovelPlayerState>>{
                }),
            middleware: <Middleware<NovelPlayerState>>[
            ],);

}
