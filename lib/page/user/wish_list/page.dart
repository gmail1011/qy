import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///心愿工单
class WishlistPage extends Page<WishlistState, Map<String, dynamic>> {
  WishlistPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<WishlistState>(
              adapter: null, slots: <String, Dependent<WishlistState>>{}),
          middleware: <Middleware<WishlistState>>[],
        );
}
