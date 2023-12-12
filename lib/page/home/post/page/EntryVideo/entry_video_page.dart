import 'package:fish_redux/fish_redux.dart';

import 'entry_video_effect.dart';
import 'entry_video_reducer.dart';
import 'entry_video_state.dart';
import 'entry_video_view.dart';

class EntryVideoPage extends Page<EntryVideoState, Map<String, dynamic>> {
  EntryVideoPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<EntryVideoState>(
                adapter: null,
                slots: <String, Dependent<EntryVideoState>>{
                }),
            middleware: <Middleware<EntryVideoState>>[
            ],);

}
