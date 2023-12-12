import 'package:fish_redux/fish_redux.dart' hide ListAdapter;

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

class MemberCentrePage extends Page<MemberCentreState, Map<String, dynamic>> {
  MemberCentrePage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<MemberCentreState>(
              slots: <String, Dependent<MemberCentreState>>{}),
          middleware: <Middleware<MemberCentreState>>[],
        );
}
