import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///长视频详情-简介
class FilmVideoIntroductionPage
    extends Page<FilmVideoIntroductionState, Map<String, dynamic>> {
  FilmVideoIntroductionPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<FilmVideoIntroductionState>(
              adapter: null,
              slots: <String, Dependent<FilmVideoIntroductionState>>{}),
          middleware: <Middleware<FilmVideoIntroductionState>>[],
        );
}
