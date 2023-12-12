import 'package:fish_redux/fish_redux.dart';

import 'publish_effect.dart';
import 'publish_reducer.dart';
import 'publish_state.dart';
import 'publish_view.dart';

class PublishPage extends Page<PublishState, Map<String, dynamic>> {
  PublishPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<PublishState>(
                adapter: null,
                slots: <String, Dependent<PublishState>>{
                }),
            middleware: <Middleware<PublishState>>[
            ],);

}
