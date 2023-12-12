import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///愿望工单-发布
class WishPublishPage extends Page<WishPublishState, Map<String, dynamic>> {
  WishPublishPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<WishPublishState>(
              adapter: null, slots: <String, Dependent<WishPublishState>>{}),
          middleware: <Middleware<WishPublishState>>[],
        );
}
