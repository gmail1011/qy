import 'package:fish_redux/fish_redux.dart';

import 'extension_setting_effect.dart';
import 'extension_setting_reducer.dart';
import 'extension_setting_state.dart';
import 'extension_setting_view.dart';

class ExtensionSettingPage extends Page<ExtensionSettingState, Map<String, dynamic>> {
  ExtensionSettingPage()
      : super(
            initState: initState,
            effect: buildEffect(),
            reducer: buildReducer(),
            view: buildView,
            dependencies: Dependencies<ExtensionSettingState>(
                adapter: null,
                slots: <String, Dependent<ExtensionSettingState>>{
                }),
            middleware: <Middleware<ExtensionSettingState>>[
            ],);

}
