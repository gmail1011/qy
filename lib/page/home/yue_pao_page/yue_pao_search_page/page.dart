import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

/// 约炮搜索页面
class YuePaoSearchPage extends Page<YuePaoSearchState, Map<String, dynamic>> {
  YuePaoSearchPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<YuePaoSearchState>(
                adapter: null,
                slots: <String, Dependent<YuePaoSearchState>>{
                }),
            middleware: <Middleware<YuePaoSearchState>>[
            ],);

}
