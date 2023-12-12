import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///图文公用页面
class PictureWordPage extends Page<PictureWordState, Map<String, dynamic>> {
  PictureWordPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PictureWordState>(
                adapter: null,
                slots: <String, Dependent<PictureWordState>>{
                }),
            middleware: <Middleware<PictureWordState>>[
            ],);

}
