import 'package:fish_redux/fish_redux.dart';

import '../effect.dart';
import '../reducer.dart';
import '../state.dart';
import 'view.dart';

class PayForNakeChatComponent extends Component<PayForNakeChatState> {
  PayForNakeChatComponent()
      : super(
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<PayForNakeChatState>(
              adapter: null, slots: <String, Dependent<PayForNakeChatState>>{}),
        );
}
