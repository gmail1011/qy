import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PurchaseDetailPage extends Page<PurchaseDetailState, Map<String, dynamic>> {
  PurchaseDetailPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies:
              Dependencies<PurchaseDetailState>(adapter: null, slots: <String, Dependent<PurchaseDetailState>>{}),
          middleware: <Middleware<PurchaseDetailState>>[],
        );
}
