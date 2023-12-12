import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AccountQrCodePage extends Page<AccountQrCodeState, Map<String, dynamic>> {
  AccountQrCodePage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AccountQrCodeState>(
                adapter: null,
                slots: <String, Dependent<AccountQrCodeState>>{
                }),
            middleware: <Middleware<AccountQrCodeState>>[
            ],);

}
