import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class KeyBoardComponent extends Component<KeyBoardState> {
  KeyBoardComponent()
      : super(
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          shouldUpdate: _shouldUpdate,
          dependencies: Dependencies<KeyBoardState>(
              adapter: null, slots: <String, Dependent<KeyBoardState>>{}),
        );
}

bool _shouldUpdate(KeyBoardState oldState, KeyBoardState newState) {
  return (oldState.editController != newState.editController ||
      oldState.freezePlayer != newState.freezePlayer ||
      (oldState.isVoice != newState.isVoice &&
          newState.isHideRecord == true));
}
