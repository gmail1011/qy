import 'package:fish_redux/fish_redux.dart';

import 'make_video_effect.dart';
import 'make_video_reducer.dart';
import 'make_video_state.dart';
import 'make_video_view.dart';

class MakeVideoPage extends Page<MakeVideoState, Map<String, dynamic>> {
  MakeVideoPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<MakeVideoState>(
                adapter: null,
                slots: <String, Dependent<MakeVideoState>>{
                }),
            middleware: <Middleware<MakeVideoState>>[
            ],);

}
