import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class VoiceAnchorDataListPage
    extends Page<VoiceAnchorDataListState, Map<String, dynamic>> {
  VoiceAnchorDataListPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          wrapper: keepAliveClientWrapper,
          view: buildView,
          dependencies: Dependencies<VoiceAnchorDataListState>(
              adapter: null,
              slots: <String, Dependent<VoiceAnchorDataListState>>{}),
          middleware: <Middleware<VoiceAnchorDataListState>>[],
        );
}
