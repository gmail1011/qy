import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class WithdrawDetailsPage extends Page<WithdrawDetailsState, Map<String, dynamic>> with KeepAliveMixin{
  WithdrawDetailsPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper:keepAliveClientWrapper,
          dependencies:
              Dependencies<WithdrawDetailsState>(adapter: null, slots: <String, Dependent<WithdrawDetailsState>>{}),
          middleware: <Middleware<WithdrawDetailsState>>[],
        );
}
