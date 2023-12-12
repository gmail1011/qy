import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///修改用户信息
class EditUserInfoPage extends Page<EditUserInfoState, Map<String, dynamic>> {
  EditUserInfoPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<EditUserInfoState>(adapter: null, slots: <String, Dependent<EditUserInfoState>>{}),
          middleware: <Middleware<EditUserInfoState>>[],
        );
}
