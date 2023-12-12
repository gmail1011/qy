import 'package:fish_redux/fish_redux.dart';

import 'search_default_effect.dart';
import 'search_default_reducer.dart';
import 'search_default_state.dart';
import 'search_default_view.dart';

class SearchDefaultPage extends Page<SearchDefaultState, Map<String, dynamic>> {
  SearchDefaultPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SearchDefaultState>(
                adapter: null,
                slots: <String, Dependent<SearchDefaultState>>{
                }),
            middleware: <Middleware<SearchDefaultState>>[
            ],);

}
