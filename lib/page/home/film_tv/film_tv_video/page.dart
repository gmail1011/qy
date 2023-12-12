import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///影视长视频列表
class FilmTelevisionVideoPage
    extends Page<FilmTelevisionVideoState, Map<String, dynamic>> {
  FilmTelevisionVideoPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<FilmTelevisionVideoState>(
              adapter: null,
              slots: <String, Dependent<FilmTelevisionVideoState>>{}),
          middleware: <Middleware<FilmTelevisionVideoState>>[],
        );
}
