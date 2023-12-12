import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class NovelSearchResultPage extends Page<NovelSearchResultState, Map<String, dynamic>> {
  NovelSearchResultPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<NovelSearchResultState>(
                adapter: null,
                slots: <String, Dependent<NovelSearchResultState>>{
                }),
            middleware: <Middleware<NovelSearchResultState>>[
            ],);

}
