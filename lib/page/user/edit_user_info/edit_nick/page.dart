import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///编辑昵称
class EditNickNamePage extends Page<EditNickNameState, Map<String, dynamic>> {
  EditNickNamePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<EditNickNameState>(
              adapter: null, slots: <String, Dependent<EditNickNameState>>{}),
          middleware: <Middleware<EditNickNameState>>[],
        );
}
