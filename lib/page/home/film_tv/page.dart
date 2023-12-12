import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///影视-长视频
class FilmTelevisionPage
    extends Page<FilmTelevisionState, Map<String, dynamic>> {
  FilmTelevisionPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<FilmTelevisionState>(
              adapter: null, slots: <String, Dependent<FilmTelevisionState>>{}),
          middleware: <Middleware<FilmTelevisionState>>[],
        );
}
