import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///离线缓存UI
class OfflineCachePage extends Page<OfflineCacheState, Map<String, dynamic>> {
  OfflineCachePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<OfflineCacheState>(
              adapter: null, slots: <String, Dependent<OfflineCacheState>>{}),
          middleware: <Middleware<OfflineCacheState>>[],
        );
}
