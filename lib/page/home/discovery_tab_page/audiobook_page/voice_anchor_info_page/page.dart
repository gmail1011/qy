import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class VoiceAnchorInfoPage
    extends Page<VoiceAnchorInfoState, Map<String, dynamic>> {
  VoiceAnchorInfoPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<VoiceAnchorInfoState>(
              adapter: null,
              slots: <String, Dependent<VoiceAnchorInfoState>>{}),
          middleware: <Middleware<VoiceAnchorInfoState>>[],
        );
}
