import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class DiscoveryTabPage extends Page<DiscoveryTabState, Map<String, dynamic>> {
  DiscoveryTabPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<DiscoveryTabState>(
                adapter: null,
                slots: <String, Dependent<DiscoveryTabState>>{
                }),
            middleware: <Middleware<DiscoveryTabState>>[
            ],);

}
