import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/wallet/pay_for/pay_for_component/component.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///VIP
class VIPPage extends Page<VIPState, Map<String, dynamic>> {
  VIPPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<VIPState>(
              adapter: null,
              slots: <String, Dependent<VIPState>>{
                'PayForVipComponent': PayForVipConnector() + PayForComponent(),
              }),
          middleware: <Middleware<VIPState>>[],
        );
}
