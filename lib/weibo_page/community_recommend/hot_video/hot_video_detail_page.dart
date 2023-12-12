import 'package:fish_redux/fish_redux.dart';

import 'hot_video_detail_effect.dart';
import 'hot_video_detail_reducer.dart';
import 'hot_video_detail_state.dart';
import 'hot_video_detail_view.dart';

class HotVideoDetailPage extends Page<HotVideoDetailState, Map<String, dynamic>> {
  HotVideoDetailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<HotVideoDetailState>(
                adapter: null,
                slots: <String, Dependent<HotVideoDetailState>>{
                }),
            middleware: <Middleware<HotVideoDetailState>>[
            ],);

}
