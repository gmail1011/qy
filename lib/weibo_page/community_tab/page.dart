import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class CommunityTabPage extends Page<CommunityTabState, Map<String, dynamic>> {
  CommunityTabPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CommunityTabState>(
                adapter: null,
                slots: <String, Dependent<CommunityTabState>>{
                }),
            middleware: <Middleware<CommunityTabState>>[
            ],);

}
