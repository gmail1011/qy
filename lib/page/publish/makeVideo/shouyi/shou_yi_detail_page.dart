import 'package:fish_redux/fish_redux.dart';

import 'shou_yi_detail_effect.dart';
import 'shou_yi_detail_reducer.dart';
import 'shou_yi_detail_state.dart';
import 'shou_yi_detail_view.dart';

///收益详情列表
class ShouYiDetailPage extends Page<ShouYiDetailState, Map<String, dynamic>> {
  ShouYiDetailPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<ShouYiDetailState>(
              adapter: null, slots: <String, Dependent<ShouYiDetailState>>{}),
          middleware: <Middleware<ShouYiDetailState>>[],
        );
}
