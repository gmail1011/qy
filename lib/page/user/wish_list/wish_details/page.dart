import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///愿望工单-问题详情
class WishDetailsPage extends Page<WishDetailsState, Map<String, dynamic>> {
  WishDetailsPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<WishDetailsState>(
              adapter: null, slots: <String, Dependent<WishDetailsState>>{}),
          middleware: <Middleware<WishDetailsState>>[],
        );
}
