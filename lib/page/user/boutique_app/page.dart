import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///精品应用
class BoutiqueAppPage extends Page<BoutiqueAppState, Map<String, dynamic>> {
  BoutiqueAppPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<BoutiqueAppState>(
                adapter: null,
                slots: <String, Dependent<BoutiqueAppState>>{
                }),
            middleware: <Middleware<BoutiqueAppState>>[
            ],);

}
