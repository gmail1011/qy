import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AudiobookPage extends Page<AudiobookState, Map<String, dynamic>> {
  AudiobookPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            wrapper: keepAliveClientWrapper,
            dependencies: Dependencies<AudiobookState>(
                adapter: null,
                slots: <String, Dependent<AudiobookState>>{
                }),
            middleware: <Middleware<AudiobookState>>[
            ],);

}
