import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AudiobookDataListPage
    extends Page<AudiobookDataListState, Map<String, dynamic>> {
  AudiobookDataListPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<AudiobookDataListState>(
              adapter: null,
              slots: <String, Dependent<AudiobookDataListState>>{}),
          middleware: <Middleware<AudiobookDataListState>>[],
        );
}
