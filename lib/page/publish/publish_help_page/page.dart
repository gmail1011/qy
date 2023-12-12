import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class PublishHelpPage extends Page<PublishHelpState, Map<String, dynamic>> {
  PublishHelpPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PublishHelpState>(
                adapter: null,
                slots: <String, Dependent<PublishHelpState>>{
                }),
            middleware: <Middleware<PublishHelpState>>[
            ],);

}
