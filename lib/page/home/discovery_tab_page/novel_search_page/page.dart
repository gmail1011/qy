import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class NovelSearchPage extends Page<NovelSearchState, Map<String, dynamic>> {
  NovelSearchPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<NovelSearchState>(
                adapter: null,
                slots: <String, Dependent<NovelSearchState>>{
                }),
            middleware: <Middleware<NovelSearchState>>[
            ],);

}
