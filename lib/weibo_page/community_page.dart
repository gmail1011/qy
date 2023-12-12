import 'package:fish_redux/fish_redux.dart';

import 'community_effect.dart';
import 'community_reducer.dart';
import 'community_state.dart';
import 'community_view.dart';

class CommunityPage extends Page<CommunityState, Map<String, dynamic>> {
  CommunityPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CommunityState>(
                adapter: null,
                slots: <String, Dependent<CommunityState>>{
                }),
            middleware: <Middleware<CommunityState>>[
            ],);

}
