import 'package:fish_redux/fish_redux.dart';
import 'package:flutter_app/page/tag/tag_home/adapter.dart';

import 'adapter.dart';
import 'effect.dart';
import 'reducer.dart';
import 'state.dart';
import 'view.dart';

///标签页面
class LiaoBaTagDetailPage extends Page<TagState, Map<String, dynamic>> {
  LiaoBaTagDetailPage()
      : super(
          initState: initState,
          effect: buildEffect(),
          reducer: buildReducer(),
          view: buildView,
          wrapper: keepAliveClientWrapper,
          dependencies: Dependencies<TagState>(
              adapter: NoneConn<TagState>() + LiaoBaTagDetailAdapter(),
              slots: <String, Dependent<TagState>>{}),
          middleware: <Middleware<TagState>>[],
        );
}
