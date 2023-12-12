import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

/// 约炮页面
class YuePaoPage extends Page<YuePaoState, Map<String, dynamic>> {
  YuePaoPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<YuePaoState>(
              adapter: null, slots: <String, Dependent<YuePaoState>>{}),
          middleware: <Middleware<YuePaoState>>[],
        );
}
