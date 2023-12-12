import 'package:fish_redux/fish_redux.dart';

import 'common_post_detail_effect.dart';
import 'common_post_detail_reducer.dart';
import 'common_post_detail_state.dart';
import 'common_post_detail_view.dart';

class CommonPostDetailPage extends Page<CommonPostDetailState, Map<String, dynamic>> {
  CommonPostDetailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<CommonPostDetailState>(
                adapter: null,
                slots: <String, Dependent<CommonPostDetailState>>{
                }),
            middleware: <Middleware<CommonPostDetailState>>[
            ],);

}
