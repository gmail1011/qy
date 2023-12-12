import 'package:fish_redux/fish_redux.dart';

import 'bang_dan_effect.dart';
import 'bang_dan_reducer.dart';
import 'bang_dan_state.dart';
import 'bang_dan_view.dart';

class BangDanPage extends Page<BangDanState, Map<String, dynamic>> {
  BangDanPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<BangDanState>(
                adapter: null,
                slots: <String, Dependent<BangDanState>>{
                }),
            middleware: <Middleware<BangDanState>>[
            ],);

}
