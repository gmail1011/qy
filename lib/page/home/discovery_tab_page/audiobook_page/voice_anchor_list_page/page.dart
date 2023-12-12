import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class VoiceAnchorListPage
    extends Page<VoiceAnchorListState, Map<String, dynamic>> {
  VoiceAnchorListPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<VoiceAnchorListState>(
              adapter: null,
              slots: <String, Dependent<VoiceAnchorListState>>{}),
          middleware: <Middleware<VoiceAnchorListState>>[],
        );
}
