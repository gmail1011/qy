import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/widget/keep_alive_widget.dart';

import 'community_follow_effect.dart';
import 'community_follow_reducer.dart';
import 'community_follow_state.dart';
import 'community_follow_view.dart';

class CommunityFollowPage extends Page<CommunityFollowState, Map<String, dynamic>> {
  CommunityFollowPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            wrapper: keepAliveWrapper,
            dependencies: Dependencies<CommunityFollowState>(
                adapter: null,
                slots: <String, Dependent<CommunityFollowState>>{
                }),
            middleware: <Middleware<CommunityFollowState>>[
            ],);

}
