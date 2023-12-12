import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

/// 约炮详情页面
class YuePaoDetailsPage extends Page<YuePaoDetailsState, Map<String, dynamic>> {
  YuePaoDetailsPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<YuePaoDetailsState>(
                adapter: null,
                slots: <String, Dependent<YuePaoDetailsState>>{
                }),
            middleware: <Middleware<YuePaoDetailsState>>[
            ],);

}
