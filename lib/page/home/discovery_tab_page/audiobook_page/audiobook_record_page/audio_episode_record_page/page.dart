import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AudioEpisodeRecordPage extends Page<AudioEpisodeRecordState, Map<String, dynamic>> {
  AudioEpisodeRecordPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AudioEpisodeRecordState>(
                adapter: null,
                slots: <String, Dependent<AudioEpisodeRecordState>>{
                }),
            middleware: <Middleware<AudioEpisodeRecordState>>[
            ],);

}
