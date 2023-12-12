import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///影视长视频列表
class HjllCommunityChild
    extends Page<HjllCommunityChildState, Map<String, dynamic>> {
  HjllCommunityChild()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<HjllCommunityChildState>(
              adapter: null,
              slots: <String, Dependent<HjllCommunityChildState>>{}),
          middleware: <Middleware<HjllCommunityChildState>>[],
        );
}
