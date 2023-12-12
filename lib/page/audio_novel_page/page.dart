import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

/// 有声小说播放页面
class AudioNovelPage extends Page<AudioNovelState, Map<String, dynamic>> {
  AudioNovelPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AudioNovelState>(
                adapter: null,
                slots: <String, Dependent<AudioNovelState>>{
                }),
            middleware: <Middleware<AudioNovelState>>[
            ],);

}
