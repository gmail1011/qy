import 'package:fish_redux/fish_redux.dart';

import 'community_detail_effect.dart';
import 'community_detail_reducer.dart';
import 'community_detail_state.dart';
import 'community_detail_view.dart';

class CommunityDetailPage extends Page<CommunityDetailState, Map<String, dynamic>> {
  CommunityDetailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CommunityDetailState>(
                adapter: null,
                slots: <String, Dependent<CommunityDetailState>>{
                }),
            middleware: <Middleware<CommunityDetailState>>[
            ],);

}
