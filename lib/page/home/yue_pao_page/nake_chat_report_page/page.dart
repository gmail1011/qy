import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

/// 约炮举报页面
class NakeChatReportPage extends Page<NakeChatReportState, Map<String, dynamic>> {
  NakeChatReportPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<NakeChatReportState>(
                adapter: null,
                slots: <String, Dependent<NakeChatReportState>>{
                }),
            middleware: <Middleware<NakeChatReportState>>[
            ],);

}
