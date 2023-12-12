import 'package:fish_redux/fish_redux.dart';

import 'view.dart';
import 'package:flutter_app/page/wallet/pay_for/state.dart';
import 'package:flutter_app/page/wallet/pay_for/effect.dart';
import 'package:flutter_app/page/wallet/pay_for/reducer.dart';

class PayForGameComponent extends Component<PayForState> {
  PayForGameComponent()
      : super(
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<PayForState>(
              adapter: null, slots: <String, Dependent<PayForState>>{}),
        );
}
