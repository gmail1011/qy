import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///官方社群
class OfficialCommunityPage
    extends Page<OfficialCommunityState, Map<String, dynamic>> {
  OfficialCommunityPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<OfficialCommunityState>(
              adapter: null,
              slots: <String, Dependent<OfficialCommunityState>>{}),
          middleware: <Middleware<OfficialCommunityState>>[],
        );
}
