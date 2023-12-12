import 'package:fish_redux/fish_redux.dart';

import 'community_recommend_effect.dart';
import 'community_recommend_reducer.dart';
import 'community_recommend_state.dart';
import 'community_recommend_view.dart';

class CommunityRecommendPage extends Page<CommunityRecommendState, Map<String, dynamic>> {
  CommunityRecommendPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            wrapper: keepAliveClientWrapper,
            dependencies: Dependencies<CommunityRecommendState>(
                adapter: null,
                slots: <String, Dependent<CommunityRecommendState>>{
                }),
            middleware: <Middleware<CommunityRecommendState>>[
            ],);

}
