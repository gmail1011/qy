import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/tag/tag_home/adapter.dart';

import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';
///标签页面
class TagPage extends Page<TagState, Map<String, dynamic>> {
  TagPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          dependencies: Dependencies<TagState>(
              adapter: NoneConn<TagState>() + TagDetailAdapter(),
              slots: <String, Dependent<TagState>>{}),
          middleware: <Middleware<TagState>>[],
        );
}
