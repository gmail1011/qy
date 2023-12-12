import 'package:fish_redux/fish_redux.dart';

import 'fu_li_guang_chang_effect.dart';
import 'fu_li_guang_chang_reducer.dart';
import 'fu_li_guang_chang_state.dart';
import 'fu_li_guang_chang_view.dart';

class FuLiGuangChangPage extends Page<FuLiGuangChangState, Map<String, dynamic>> {
  FuLiGuangChangPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<FuLiGuangChangState>(
                adapter: null,
                slots: <String, Dependent<FuLiGuangChangState>>{
                }),
            middleware: <Middleware<FuLiGuangChangState>>[
            ],);

}
