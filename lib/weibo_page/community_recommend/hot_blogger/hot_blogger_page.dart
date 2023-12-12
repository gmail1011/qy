import 'package:fish_redux/fish_redux.dart';

import 'hot_blogger_effect.dart';
import 'hot_blogger_reducer.dart';
import 'hot_blogger_state.dart';
import 'hot_blogger_view.dart';

class HotBloggerPage extends Page<HotBloggerState, Map<String, dynamic>> {
  HotBloggerPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<HotBloggerState>(
                adapter: null,
                slots: <String, Dependent<HotBloggerState>>{
                }),
            middleware: <Middleware<HotBloggerState>>[
            ],);

}
