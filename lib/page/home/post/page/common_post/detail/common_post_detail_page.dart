import 'package:fish_redux/fish_redux.dart';

import 'common_post_detail_effect.dart';
import 'common_post_detail_reducer.dart';
import 'common_post_detail_state.dart';
import 'common_post_detail_view.dart';

class common_post_detailPage extends Page<common_post_detailState, Map<String, dynamic>> {
  common_post_detailPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<common_post_detailState>(
                adapter: null,
                slots: <String, Dependent<common_post_detailState>>{
                }),
            middleware: <Middleware<common_post_detailState>>[
            ],);

}
