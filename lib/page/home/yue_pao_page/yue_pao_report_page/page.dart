import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

/// 约炮举报页面
class YuePaoReportPage extends Page<YuePaoReportState, Map<String, dynamic>> {
  YuePaoReportPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<YuePaoReportState>(
                adapter: null,
                slots: <String, Dependent<YuePaoReportState>>{
                }),
            middleware: <Middleware<YuePaoReportState>>[
            ],);

}
