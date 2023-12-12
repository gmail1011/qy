import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///个人名片
class PersonalCardPage extends Page<PersonalCardState, Map<String, dynamic>> {
  PersonalCardPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<PersonalCardState>(adapter: null, slots: <String, Dependent<PersonalCardState>>{}),
          middleware: <Middleware<PersonalCardState>>[],
        );
}
