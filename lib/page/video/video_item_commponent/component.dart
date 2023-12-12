import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class VideoItemComponent extends Component<VideoItemState>
    with WidgetsBindingObserverMixin<VideoItemState> {
  VideoItemComponent()
      : super(
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies:
              Dependencies<VideoItemState>(adapter: null, slots: <String, Dependent<VideoItemState>>{}),
        );
}
