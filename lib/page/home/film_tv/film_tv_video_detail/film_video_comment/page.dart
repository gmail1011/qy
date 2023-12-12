import 'package:fish_redux/fish_redux.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///长视频详情-评论列表
class FilmVideoCommentPage
    extends Page<FilmVideoCommentState, Map<String, dynamic>> {
  FilmVideoCommentPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<FilmVideoCommentState>(
              adapter: null,
              slots: <String, Dependent<FilmVideoCommentState>>{}),
          middleware: <Middleware<FilmVideoCommentState>>[],
        );
}
