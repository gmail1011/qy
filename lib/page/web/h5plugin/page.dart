import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class H5PluginPage extends Page<H5PluginState, Map<String, dynamic>> {
  H5PluginPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<H5PluginState>(
                adapter: null,
                slots: <String, Dependent<H5PluginState>>{
                }),
            middleware: <Middleware<H5PluginState>>[
            ],);

}
