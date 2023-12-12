import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///影视-长视频
class HjllCommunityPage
    extends Page<HjllCommunityHomeState, Map<String, dynamic>> {
  HjllCommunityPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<HjllCommunityHomeState>(
              adapter: null, slots: <String, Dependent<HjllCommunityHomeState>>{}),
          middleware: <Middleware<HjllCommunityHomeState>>[],
        );
}
