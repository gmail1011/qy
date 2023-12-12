import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/wallet/pay_for/pay_for_component/component.dart';
import 'package:flutter_app/page/wallet/pay_for/pay_for_game_component/component.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///钱包主界面
class GameWalletPage extends Page<WalletState, Map<String, dynamic>> {
  GameWalletPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<WalletState>(
              adapter: null,
              slots: <String, Dependent<WalletState>>{
                'PayForComponent': PayForCOnnector() + PayForGameComponent(),
              }),
          middleware: <Middleware<WalletState>>[],
        );
}
