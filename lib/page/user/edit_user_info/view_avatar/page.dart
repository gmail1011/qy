import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class ViewAvatarPage extends Page<ViewAvatarState, Map<String, dynamic>> {
  ViewAvatarPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ViewAvatarState>(
                adapter: null,
                slots: <String, Dependent<ViewAvatarState>>{
                }),
            middleware: <Middleware<ViewAvatarState>>[
            ],);

}
