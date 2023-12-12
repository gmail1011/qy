import 'package:fish_redux/fish_redux.dart';

import 'a_v_commentary_effect.dart';
import 'a_v_commentary_reducer.dart';
import 'a_v_commentary_state.dart';
import 'a_v_commentary_view.dart';

class AVCommentaryPage extends Page<AVCommentaryState, Map<String, dynamic>> {
  AVCommentaryPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<AVCommentaryState>(
                adapter: null,
                slots: <String, Dependent<AVCommentaryState>>{
                }),
            middleware: <Middleware<AVCommentaryState>>[
            ],);

}
