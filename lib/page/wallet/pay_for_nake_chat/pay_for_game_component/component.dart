import 'package:fish_redux/fish_redux.dart';

import '../effect.dart';
import '../reducer.dart';
import '../state.dart';
import 'view.dart';
import 'package:flutter_app/page/wallet/pay_for/state.dart';

class PayForGameComponent extends Component<PayForNakeChatState> {
  PayForGameComponent()
      : super(
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<PayForNakeChatState>(
              adapter: null, slots: <String, Dependent<PayForNakeChatState>>{}),
        );
}
