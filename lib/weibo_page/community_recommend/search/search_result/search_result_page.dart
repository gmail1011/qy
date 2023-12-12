import 'package:fish_redux/fish_redux.dart';

import 'search_result_effect.dart';
import 'search_result_reducer.dart';
import 'search_result_state.dart';
import 'search_result_view.dart';

class SearchResultPage extends Page<SearchResultState, Map<String, dynamic>> {
  SearchResultPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SearchResultState>(
                adapter: null,
                slots: <String, Dependent<SearchResultState>>{
                }),
            middleware: <Middleware<SearchResultState>>[
            ],);

}
