import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///长视频详情
class FilmTvVideoDetailPage
    extends Page<FilmTvVideoDetailState, Map<String, dynamic>> {
  FilmTvVideoDetailPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<FilmTvVideoDetailState>(
              adapter: null,
              slots: <String, Dependent<FilmTvVideoDetailState>>{}),
          middleware: <Middleware<FilmTvVideoDetailState>>[],
        );
}
