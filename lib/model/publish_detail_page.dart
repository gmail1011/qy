import 'package:fish_redux/fish_redux.dart';

import 'publish_detail_effect.dart';
import 'publish_detail_reducer.dart';
import 'publish_detail_state.dart';
import 'publish_detail_view.dart';

class PublishDetailPage extends Page<PublishDetailState, Map<String, dynamic>> {
  PublishDetailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PublishDetailState>(
                adapter: null,
                slots: <String, Dependent<PublishDetailState>>{
                }),
            middleware: <Middleware<PublishDetailState>>[
            ],);

}
