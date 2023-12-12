import 'package:fish_redux/fish_redux.dart';

import 'select_tags_effect.dart';
import 'select_tags_reducer.dart';
import 'select_tags_state.dart';
import 'select_tags_view.dart';

class SelectTagsPage extends Page<SelectTagsState, Map<String, dynamic>> {
  SelectTagsPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<SelectTagsState>(
                adapter: null,
                slots: <String, Dependent<SelectTagsState>>{
                }),
            middleware: <Middleware<SelectTagsState>>[
            ],);

}
