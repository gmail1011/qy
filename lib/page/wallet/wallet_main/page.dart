import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/wallet/pay_for/pay_for_component/component.dart';
import 'package:flutter_app/page/wallet/pay_for_nake_chat/pay_for_component/component.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///钱包主界面
class WalletPage extends Page<WalletState, Map<String, dynamic>> {
  WalletPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<WalletState>(
              adapter: null,
              slots: <String, Dependent<WalletState>>{
                'PayForComponent': PayForCOnnector() + PayForComponent(),
                'PayForNakeChatComponent': PayForNakeChatCOnnector() + PayForNakeChatComponent(),
              }),
          middleware: <Middleware<WalletState>>[],
        );
}
