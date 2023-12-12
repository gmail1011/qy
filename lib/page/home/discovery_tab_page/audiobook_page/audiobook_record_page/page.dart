import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class AudiobookRecordPage extends Page<AudiobookRecordState, Map<String, dynamic>> {
  AudiobookRecordPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AudiobookRecordState>(
                adapter: null,
                slots: <String, Dependent<AudiobookRecordState>>{
                }),
            middleware: <Middleware<AudiobookRecordState>>[
            ],);

}
