import 'package:fish_redux/fish_redux.dart';

import 'topic_detail_effect.dart';
import 'topic_detail_reducer.dart';
import 'topic_detail_state.dart';
import 'topic_detail_view.dart';

class TopicDetailPage extends Page<TopicDetailState, Map<String, dynamic>> {
  TopicDetailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<TopicDetailState>(
                adapter: null,
                slots: <String, Dependent<TopicDetailState>>{
                }),
            middleware: <Middleware<TopicDetailState>>[
            ],);

}
